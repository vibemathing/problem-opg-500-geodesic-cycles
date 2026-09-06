"""Candidate-only cross-check by edge-subset exhaustion; exact integer arithmetic."""
from __future__ import annotations
import itertools,json,time,hashlib,sys,resource
from pathlib import Path
from root_search import Graph,named_graphs,digest,canonical_bytes,CapExceeded


def edge_subsets(g:Graph):
    paths={(u,v):[] for u in range(g.n) for v in range(u+1,g.n)};cycles=[]
    for mask in range(1,1<<g.m):
        g.tick();adj={};bad=False
        for j,(u,v) in enumerate(g.edges):
            if mask>>j&1:
                adj.setdefault(u,[]).append(v);adj.setdefault(v,[]).append(u)
                if len(adj[u])>2 or len(adj[v])>2:bad=True;break
        if bad:continue
        ends=sorted(u for u in adj if len(adj[u])==1)
        if len(ends) not in (0,2):continue
        s=ends[0] if ends else min(adj);seq=[s];prev=None;cur=s
        while True:
            nxt=[v for v in adj[cur] if v!=prev]
            if not nxt:break
            v=min(nxt)
            if v==s:break
            if v in seq:raise AssertionError('unexpected repeated vertex')
            seq.append(v);prev,cur=cur,v
        if len(seq)!=len(adj):continue # excludes disjoint cycles or extra components
        if ends:
            assert seq[-1]==ends[1]
            paths[tuple(ends)].append(tuple(seq))
        elif len(seq)>=3:
            if seq[1]>seq[-1]:seq=seq[:1]+seq[:0:-1]
            cycles.append(tuple(seq))
    return {k:sorted(v) for k,v in paths.items()},sorted(cycles,key=lambda c:(len(c),c))


def small_box(g,cycles,max_value):
    for i,w in enumerate(itertools.product(range(1,max_value+1),repeat=g.m)):
        if not g.evaluate(cycles,w)['bad']:
            return {'max_value':max_value,'trials':i+1,'w':list(w),'search_order':'lexicographic full integer box until first witness'}
    return {'max_value':max_value,'trials':max_value**g.m,'w':None,'search_order':'complete bounded integer box; not universal UNSAT'}


def external_witness(g,c,paths,w):
    vs=set(c);ids=g.eids(c+c[:1]);ce=set(ids)
    for i,j in itertools.combinations(range(len(c)),2):
        u,v=sorted((c[i],c[j]));a=ids[i:j];b=ids[j:]+ids[:i]
        for index,p in enumerate(paths[(u,v)]):
            if set(p[1:-1])&vs:continue
            pe=g.eids(p)
            if len(pe)==1 and pe[0] in ce:continue
            ca=[0]*g.m;cb=[0]*g.m
            for e in a:ca[e]+=1
            for e in b:cb[e]+=1
            for e in pe:ca[e]-=1;cb[e]-=1
            slack=[sum(z*x for z,x in zip(r,w)) for r in (ca,cb)]
            if min(slack)>0:
                return {'endpoints':[u,v],'path_index':index,'path':list(p),'arc_edge_indices':[a,b],
                        'gt_zero_rows':[ca,cb],'integer_slacks':slack}
    return None


def audit(out:Path):
    start=time.monotonic();deadline=start+90
    allsum=[]
    for name,(n,edges) in named_graphs().items():
        g=Graph(n,edges,deadline);cycles=g.cycles();paths={(u,v):g.paths(u,v) for u in range(n) for v in range(u+1,n)}
        altpaths,altcycles=edge_subsets(g)
        assert cycles==altcycles,(name,'cycle crosscheck')
        assert paths==altpaths,(name,'path crosscheck')
        old=json.loads((out/f'{name}.json').read_text());w=old['search']['w']
        if name=='cube':
            small=small_box(g,cycles,2);assert small['w'];w=small['w'];old['small_box_search']=small
        elif name=='triangular_bipyramid':
            small=small_box(g,cycles,2);old['small_box_search']=small
            if not small['w']:
                small=small_box(g,cycles,3);old['small_box_search_max3']=small
            if small['w']:w=small['w']
        formula=g.compile(cycles,paths)
        assert g.evaluate_formula(formula,paths,w)
        full=g.evaluate(cycles,w,full=True);assert not full['bad']
        for rec in full['cycle_audit']:
            c=tuple(rec['cycle']);ids=g.eids(c+c[:1]);pref=[0]
            for e in ids:pref.append(pref[-1]+w[e])
            tablegeo=True
            for i,j in itertools.combinations(range(len(c)),2):
                u,v=sorted((c[i],c[j]));a=pref[j]-pref[i];b=pref[-1]-a
                costs=[sum(w[e] for e in g.eids(p)) for p in paths[(u,v)]]
                if min(costs)<min(a,b):tablegeo=False
            assert tablegeo==rec['geodesic'],(name,c,'table vs Floyd')
            if not rec['peripheral']:
                witness=external_witness(g,c,paths,w);assert witness
                rec['root_branch_witness']=witness
        # actual Boolean AST evaluation on the first witness and the unit vector
        # plus its exact agreement with independently evaluated all-pairs distances.
        checks=[]
        for probe in ([1]*g.m,w,[10+(3*j)%5 for j in range(g.m)]):
            dd,_=g.distances(probe)
            for (u,v),ps in paths.items():
                assert min(sum(probe[e] for e in g.eids(p)) for p in ps)==dd[u][v]
            actual=g.evaluate_formula(formula,paths,probe)
            expected=not g.evaluate(cycles,probe)['bad']
            assert actual==expected
            checks.append({'w':probe,'root_formula':actual,'distance_test':expected})
        serialized_paths=[{'endpoints':list(pair),'paths':[list(p) for p in ps]} for pair,ps in paths.items()]
        old.update(full);old.update({'length_vector':w,'path_count':sum(len(ps) for ps in paths.values()),
             'path_table_sha256':digest(serialized_paths),'root_formula_sha256':digest(formula),
             'root_branch_count_sum':sum(len(c['or_path_branches']) for c in formula['and_nonperipheral_cycles']),
             'exhaustive_edge_subsets_checked':(1<<g.m)-1,'dfs_vs_edge_subset_cycles_equal':True,
             'dfs_vs_edge_subset_paths_equal':True,'path_table_vs_floyd_geodesicity_equal':True,
             'root_formula_probes':checks})
        (out/f'{name}.json').write_text(json.dumps(old,sort_keys=True,indent=2)+'\n')
        (out/f'{name}.paths.json').write_bytes(canonical_bytes(serialized_paths)+b'\n')
        # The full AST is regenerated and hashed above; no branch is truncated.
        row={'graph':name,'cycle_count':len(cycles),'peripheral_count':old['peripheral_count'],
             'path_count':old['path_count'],'geodesic_count':len(full['geodesic']),'w':w,
             'root_branches':old['root_branch_count_sum'],'cycle_table_sha256':old['cycle_table_sha256'],
             'path_table_sha256':old['path_table_sha256'],'root_formula_sha256':old['root_formula_sha256']}
        allsum.append(row);print(json.dumps(row),flush=True)
    source_hashes={f:hashlib.sha256((Path(__file__).parent/f).read_bytes()).hexdigest() for f in ['root_search.py','exact_audit.py']}
    report={'verdict':'candidate_only','graphs':allsum,'source_sha256':source_hashes,'seconds_elapsed':time.monotonic()-start,
            'execution':'actual local candidate-generation sandbox; no registered verifier invoked','arithmetic':'integer exact; no floating solver'}
    (out/'exact-summary.json').write_text(json.dumps(report,sort_keys=True,indent=2)+'\n')
    print('elapsed_seconds',round(report['seconds_elapsed'],3))

if __name__=='__main__':
    resource.setrlimit(resource.RLIMIT_AS,(768*1024*1024,768*1024*1024))
    try:audit(Path(sys.argv[1]))
    except CapExceeded as exc:print('INCOMPLETE:',str(exc),file=sys.stderr);sys.exit(2)
