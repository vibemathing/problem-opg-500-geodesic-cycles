"""Different-core generator-side audit of the frozen C15 finite certificate.
Edge-subset enumeration, coefficient-kernel rank, Bellman-Ford/Fraction.
No historical producer/replayer imported. Not a trusted verifier.
"""
from __future__ import annotations
import argparse, copy, hashlib, json, time
from collections import Counter
from fractions import Fraction as Q
from itertools import combinations
from pathlib import Path

B=tuple(range(4))
E=tuple((u,v) for u,v in combinations(range(8),2)
        if v<4 or u<4<=v and u!=7-v)
EI={e:i for i,e in enumerate(E)}
CORE=tuple(combinations(B,2)); LIMIT=1<<len(E); START=time.monotonic()
COLUMNS=['edge_mask','core_mask','N0','N1','N2','N3','components','beta',
         'triangle_count','triangle_rank','dual','outside_cycle']

def need(ok,message):
    if not ok:raise ValueError(message)

def guard():
    if time.monotonic()-START>38:raise TimeoutError('bounded audit time cap')

def bits(m):
    while m:
        z=m&-m;yield z.bit_length()-1;m-=z

def cc(m,vertices=tuple(range(8))):
    vs=set(vertices);par={v:v for v in vs}
    def root(x):
        while par[x]!=x:x=par[x]
        return x
    for j in bits(m):
        u,v=E[j]
        if u in vs and v in vs:par[root(u)]=root(v)
    return len({root(v) for v in vs})

def objects():
    cycles={};paths={p:[] for p in combinations(range(8),2)}
    # ALL edge subsets are considered. Degree and connectedness characterize
    # simple cycles/paths without a DFS or permutation enumeration core.
    for m in range(1,LIMIT):
        if not m%8192:guard()
        if m.bit_count()>8:continue
        adj=[[] for _ in range(8)]
        for j in bits(m):
            u,v=E[j];adj[u].append(v);adj[v].append(u)
        deg=list(map(len,adj));vs=[i for i,d in enumerate(deg) if d]
        if max(deg)>2:continue
        ends=[i for i,d in enumerate(deg) if d==1]
        if len(ends) not in (0,2) or cc(m,vs)!=1:continue
        s=min(vs) if not ends else min(ends);seq=[s];prev=None;u=s
        while True:
            opts=[v for v in adj[u] if v!=prev]
            if not opts:break
            v=min(opts)
            if v==s:break
            seq.append(v);prev,u=u,v
        need(len(seq)==len(vs),'lost vertices in degree-subgraph traversal')
        if ends:paths[tuple(sorted(ends))].append(m)
        else:cycles[m]=tuple(seq)
    return cycles,paths

def peripheral(m,seq):
    vs=set(seq)
    induced=all(not(u in vs and v in vs) or m>>j&1 for j,(u,v) in enumerate(E))
    return induced and cc(LIMIT-1,set(range(8))-vs)<=1

def core_data():
    data={}
    for f in range(1<<len(CORE)):
        es={e for j,e in enumerate(CORE) if f>>j&1}
        triangles=[t for t in combinations(B,3) if set(combinations(t,2))<=es]
        links=[]
        for i in B:
            allowed=[]
            for n in range(16):
                if n>>i&1:continue
                if all(n>>j&1 or any(n>>k&1 and tuple(sorted((j,k))) in es
                         for k in B if k!=j) for j in B if j!=i):allowed.append(n)
            links.append(allowed)
        data[f]=(triangles,links)
    return data

def mask_pattern(m,data):
    f=sum(1<<j for j,e in enumerate(CORE) if m>>EI[e]&1)
    if data[f][0]:return None
    ns=[sum(1<<j for j in B if j!=i and m>>EI[tuple(sorted((j,7-i)))]&1) for i in B]
    return (f,ns) if all(n in data[f][1][i] for i,n in enumerate(ns)) else None

def kernel(vectors):
    # Retain COEFFICIENT identities of relations; rank of each subfamily is
    # its cardinality minus kernel dimension. Not a Gaussian/image-size core.
    sums=[0];relations=[0]
    for v in vectors:
        old=len(sums)
        for x in range(old):
            z=sums[x]^v;sums.append(z)
            if not z:relations.append(old+x)
    return relations

def rank(selected,relations):
    n=sum(r&~selected==0 for r in relations)
    need(n>0 and n&(n-1)==0,'non-power-of-two relation count')
    return selected.bit_count()-(n.bit_length()-1)

def context():
    cycles,paths=objects();per=[m for m,s in cycles.items() if peripheral(m,s)]
    need(all(len(cycles[t])==3 for t in per),'peripheral classification')
    tris=[m for m,s in cycles.items() if len(s)==3]
    data=core_data();necessary={}
    for m in range(LIMIT):
        if not m%8192:guard()
        p=mask_pattern(m,data)
        if p is not None:necessary[m]=p
    return cycles,paths,per,tris,kernel(per),data,necessary

def check_row(row,ctx):
    cycles,paths,per,tris,rels,data,necessary=ctx
    need(len(row)==12 and all(type(x)is int for x in row),'integer row contract')
    m=row[0];need(m in necessary,'ineligible edge mask')
    f,ns=necessary[m];need(row[1:6]==[f,*ns],'core/neighbor mismatch')
    parts=cc(m)
    stars=[sum(1<<j for j,e in enumerate(E) if m>>j&1 and v in e) for v in range(8)]
    irank=rank(255,kernel(stars));need(irank==8-parts,'incidence rank/cc mismatch')
    beta=m.bit_count()-irank
    ts=[t for t in tris if t&~m==0]
    need(set(ts)<=set(per),'core triangle in necessary mask')
    chosen=sum(1<<j for j,t in enumerate(per) if t&~m==0)
    trank=rank(chosen,rels)
    need(row[6:10]==[parts,beta,len(ts),trank],'component/beta/triangle-rank mismatch')
    q,c=row[10:]
    need(0<=q<LIMIT and c in cycles and c&~m==0,'dual/cycle membership')
    need(all((q&t).bit_count()%2==0 for t in ts),'dual not zero on triangle')
    need((q&c).bit_count()%2==1,'outside-cycle parity not odd')
    need(beta>trank,'nonpositive actual rank gap')
    return beta-trank

def validate(cert,ctx):
    cycles,paths,per,tris,rels,data,necessary=ctx
    need(cert['edges']==list(map(list,E)) and cert['vertices']==list(range(8)),'fixed graph mismatch')
    need(cert['columns']==COLUMNS,'column mismatch')
    seen=set();hist=Counter()
    for r in cert['rows']:
        need(r[0] not in seen,'duplicate mask');seen.add(r[0]);hist[check_row(r,ctx)]+=1
    need(seen==set(necessary),'missing mask coverage')
    cs=cert['core_cases'];need(len(cs)==len(data),'core-case length')
    need({r['core_mask'] for r in cs}==set(data),'core-case coverage')
    for r in cs:
        t,n=data[r['core_mask']]
        if t:need(r.get('excluded_triangle') in list(map(list,t)),'wrong excluded triangle')
        else:need(r.get('neighbor_options')==n,'incomplete dominating-neighbor options')
    return dict(sorted(hist.items()))

def distances(w):
    result=[]
    for s in range(8):
        d=[None]*8;d[s]=Q(0)
        for _ in range(7):
            old=list(d)
            for j,(u,v) in enumerate(E):
                if old[u] is not None:
                    z=old[u]+w[j]
                    if d[v] is None or z<d[v]:d[v]=z
                if old[v] is not None:
                    z=old[v]+w[j]
                    if d[u] is None or z<d[u]:d[u]=z
        need(all(x is not None for x in d),'disconnected fixed graph');result.append(d)
    return result

def cycle_ok(seq,w,d):
    total=sum(w[EI[tuple(sorted((seq[j],seq[(j+1)%len(seq)])))]] for j in range(len(seq)))
    for i,j in combinations(range(len(seq)),2):
        a=sum(w[EI[tuple(sorted((seq[k],seq[k+1])))]] for k in range(i,j))
        if min(a,total-a)!=d[seq[i]][seq[j]]:return False
    return True

def metric_replay(samples,cert,ctx):
    cycles,paths,per,tris,rels,data,necessary=ctx;rows={r[0]:r for r in cert['rows']}
    counts=Counter();witnesses=[]
    for sample in samples:
        guard()
        need(all(type(x) in (str,int) for x in sample['lengths']),'exact rational syntax required')
        w=list(map(Q,sample['lengths']))
        need(len(w)==len(E) and all(a>0 for a in w),'positive rational vector')
        cost=lambda m:sum((w[j] for j in bits(m)),Q(0))
        d=distances(w);T=sum(1<<j for j,(u,v) in enumerate(E) if w[j]==d[u][v])
        need(cc(T)==1,'tight subgraph disconnected')
        for (u,v),ps in paths.items():
            pmin=min(map(cost,ps));need(pmin==d[u][v],'path minimum/Bellman-Ford mismatch')
            mins=[p for p in ps if cost(p)==pmin]
            counts['tied_pairs']+=len(mins)>1
            for p in mins:need(p&~T==0,'shortest path has nontight edge')
            e=EI.get((u,v))
            if e is not None and not T>>e&1:
                for p in mins:
                    c=p|(1<<e)
                    need(c in cycles and cycle_ok(cycles[c],w,d),'nontight complementary cycle failure')
                    counts['nontight_cycles']+=1
        if T in rows:
            q=rows[T][10];choices=[c for c in cycles if c&~T==0 and (q&c).bit_count()%2]
            need(bool(choices),'empty odd-cycle family');c=min(choices,key=lambda x:(cost(x),x))
            need(c not in per and cycle_ok(cycles[c],w,d),'minimum odd cycle failure')
            counts['minimum_odd_cases']+=1
        else:
            choices=[c for c in cycles if c not in per and cycle_ok(cycles[c],w,d)]
            need(bool(choices),'positive metric defeated root candidate');c=choices[0]
        witnesses.append({'name':sample['name'],'lengths':sample['lengths'],'cycle_mask':c,'cycle':list(cycles[c])})
    return dict(counts),witnesses

def mutations(cert,ctx):
    results=[]
    row=cert['rows'][0]
    changes={'beta':(7,row[7]+1),'rank':(9,row[9]+1),'dual_zero':(10,0),
             'dual_range':(10,LIMIT),'not_a_cycle':(11,1),'wrong_link':(2,row[2]^1),
             'wrong_core':(1,row[1]^1),'wrong_components':(6,row[6]+1)}
    for name,(i,value) in changes.items():
        r=list(row);r[i]=value
        try:check_row(r,ctx)
        except ValueError as e:results.append({'name':name,'rejected':True,'reason':str(e)})
        else:raise ValueError('row mutation survived: '+name)
    for name,modify in [('missing_mask',lambda c:c['rows'].pop()),
                         ('duplicate_mask',lambda c:c['rows'].append(c['rows'][0])),
                         ('omitted_core_case',lambda c:c['core_cases'].pop()),
                         ('changed_graph',lambda c:c['edges'].pop())]:
        broken=copy.deepcopy(cert);modify(broken)
        try:validate(broken,ctx)
        except ValueError as e:results.append({'name':name,'rejected':True,'reason':str(e)})
        else:raise ValueError('coverage mutation survived: '+name)
    return results

def main():
    p=argparse.ArgumentParser();p.add_argument('input_directory',type=Path);a=p.parse_args()
    cp=a.input_directory/'rank-certificate.json';mp=a.input_directory/'metric-report.json'
    cert=json.loads(cp.read_text());samples=json.loads(mp.read_text())['samples'];ctx=context()
    hist=validate(cert,ctx);ms=mutations(cert,ctx);metrics,ws=metric_replay(samples,cert,ctx)
    cycles,paths,per,tris,rels,data,necessary=ctx
    bad_inputs=[]
    for name,value in [('zero',0),('negative',-1),('float',0.5),('boolean',True)]:
        changed=copy.deepcopy(samples[0]);changed['lengths'][0]=value
        try:metric_replay([changed],cert,ctx)
        except ValueError as exc:bad_inputs.append({'name':name,'rejected':True,'reason':str(exc)})
        else:raise ValueError('invalid metric input accepted')
    report={'verdict':'candidate_only','execution_role':'generator_different_core_check',
      'methods':['connected edge subsets','coefficient-kernel rank-nullity','Bellman-Ford exact rational'],
      'cycles':len(cycles),'paths':sum(map(len,paths.values())),'peripheral':len(per),
      'core_patterns':len(data),'triangle_free_core_patterns':sum(not x[0] for x in data.values()),
      'necessary_patterns':len(necessary),'actual_rank_gap_histogram':hist,
      'H_peripheral_generator_count':len(per),'H_peripheral_actual_rank':rank((1<<len(per))-1,rels),
      'H_coefficient_kernel_masks':rels,'mutations':ms,'metric_samples':len(samples),
      'metric_counts':metrics,'invalid_metric_inputs':bad_inputs,'witnesses':ws,'input_sha256':hashlib.sha256(cp.read_bytes()).hexdigest(),
      'metric_input_sha256':hashlib.sha256(mp.read_bytes()).hexdigest(),
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'trusted_verifier_receipt':None,'scope':'finite certificate and listed rational metrics only'}
    raw=(json.dumps(report,sort_keys=True,separators=(',',':'))+'\n').encode()
    need(len(raw)<=1048576,'output cap');Path('recheck.json').write_bytes(raw)
    print(json.dumps({k:v for k,v in report.items() if k not in ('witnesses','mutations')},sort_keys=True))
if __name__=='__main__':main()
