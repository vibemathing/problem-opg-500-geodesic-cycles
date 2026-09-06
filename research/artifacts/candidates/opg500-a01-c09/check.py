"""C09 exact graph audit and replayable Boolean UNSAT tree. Candidate only.
Python standard library only. Use --build once, then --verify on frozen files.
No mathematical kernel/admission receipt is produced. No network is used.
"""
from __future__ import annotations
import argparse
import hashlib
import itertools as it
import json
from pathlib import Path
import time

N=8
BLACK=tuple(range(4))
EDGES=tuple(sorted(tuple(it.combinations(BLACK,2))+tuple((b,7-i) for i in BLACK for b in BLACK if b!=i)))
ADJ=tuple(frozenset(v for e in EDGES if u in e for v in e if v!=u) for u in range(N))

def encode(x):
    return (json.dumps(x,sort_keys=True,separators=(',',':'))+'\n').encode()

def digest(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def components(vertices,edges=EDGES):
    remaining=set(vertices); out=[]
    while remaining:
        seen={min(remaining)}; stack=list(seen)
        while stack:
            u=stack.pop()
            for e in edges:
                if u in e:
                    v=e[0] if e[1]==u else e[1]
                    if v in remaining and v not in seen:
                        seen.add(v); stack.append(v)
        remaining-=seen;out.append(sorted(seen))
    return out

def canonical(seq):
    s=tuple(seq);k=s.index(min(s));s=s[k:]+s[:k]
    return min(s,(s[0],)+s[:0:-1])

def cycles_dfs():
    out=set()
    def go(start,path):
        for v in sorted(ADJ[path[-1]]):
            if v==start and len(path)>=3:
                out.add(canonical(path))
            elif v>start and v not in path:
                go(start,path+(v,))
    for s in range(N):go(s,(s,))
    return sorted(out,key=lambda z:(len(z),z))

def cycles_by_subsets():
    """Second exhaustive method: connected 2-regular edge subsets."""
    incident=[sum(1<<j for j,e in enumerate(EDGES) if v in e) for v in range(N)]
    out=set()
    for mask in range(1<<len(EDGES)):
        if not 3<=mask.bit_count()<=N:continue
        deg=[(mask&inc).bit_count() for inc in incident]
        if any(d not in (0,2) for d in deg):continue
        active=[v for v,d in enumerate(deg) if d]
        es=[e for j,e in enumerate(EDGES) if mask>>j&1]
        if len(components(active,es))!=1:continue
        start=min(active); prev=None;u=start;seq=[]
        while True:
            seq.append(u)
            neighbours=sorted(v for e in es if u in e for v in e if v!=u)
            v=next(v for v in neighbours if v!=prev)
            prev,u=u,v
            if u==start:break
            assert len(seq)<N
        out.add(canonical(seq))
    return out

def gf2rank(vectors):
    basis={}
    for x in vectors:
        while x:
            k=x.bit_length()-1
            if k not in basis:basis[k]=x;break
            x^=basis[k]
    return len(basis)

def graph_audit():
    cs=cycles_dfs();assert set(cs)==cycles_by_subsets()
    table=[]; vectors=[]
    for c in cs:
        ce={tuple(sorted((c[j],c[(j+1)%len(c)]))) for j in range(len(c))}
        chords=[list(e) for e in EDGES if set(e)<=set(c) and e not in ce]
        comps=components(set(range(N))-set(c))
        peripheral=not chords and len(comps)<=1
        table.append([list(c),chords,comps,peripheral])
        vectors.append(sum(1<<j for j,e in enumerate(EDGES) if e in ce))
    faces=[r[0] for r in table if r[3]]
    bad_triangles=[r[0] for r in table if len(r[0])==3 and not r[3]]
    black_edges=[list(e) for e in it.combinations(BLACK,2)]
    incidence=[[i for i,f in enumerate(faces) if set(e)<=set(f)] for e in black_edges]
    assert len(cs)==239 and len(faces)==12 and gf2rank(vectors)==11
    assert bad_triangles==[list(t) for t in it.combinations(BLACK,3)]
    assert all(len(i)==2 for i in incidence)
    assert all(sum(set(e)<=set(f) for e in black_edges)==1 for f in faces)
    deletion=[]
    for k in range(3):
        for d in it.combinations(range(N),k):
            comps=components(set(range(N))-set(d));assert len(comps)==1
            deletion.append([list(d),comps])
    # 13 missing-face cases. A missing face has one black edge ab;
    # choose the black triangle omitting a, so all its edges are forced tight.
    cover=[]
    for missing in [None]+list(range(12)):
        forced=[j for j,ff in enumerate(incidence) if all(f!=missing for f in ff)]
        valid=[t for t in bad_triangles if all(j in forced for j,e in enumerate(black_edges) if set(e)<=set(t))]
        assert valid
        cover.append([missing,forced,valid[0]])
    return {'verdict':'candidate_only','n':N,'edges':[list(e) for e in EDGES],
            'cycle_rows_format':['vertices','chords','components_after_vertex_deletion','peripheral'],
            'cycle_rows':table,'black_edges':black_edges,'peripheral_triangles':faces,
            'nonperipheral_triangles':bad_triangles,'black_edge_face_incidence':incidence,
            'cycle_rank':gf2rank(vectors),'deletion_rows':deletion,'missing_face_cover':cover}

def compile_cnf(g):
    # 1..12 = peripheral face geodesic; 13..18 = black edge tight.
    rows=[[i+1,j+1] for i,j in it.combinations(range(12),2)]
    for j,(f,h) in enumerate(g['black_edge_face_incidence']):rows.append([-f-1,-h-1,13+j])
    for t in g['nonperipheral_triangles']:
        rows.append([-(13+j) for j,e in enumerate(g['black_edges']) if set(e)<=set(t)])
    assert len(rows)==76
    return rows

def evaluate(clause,assignment):
    if any(abs(q) in assignment and assignment[abs(q)]==(q>0) for q in clause):return True,[]
    return False,[q for q in clause if abs(q) not in assignment]

def generate_tree(rows,assignment):
    a=dict(assignment);units=[]
    while True:
        changed=False
        for i,c in enumerate(rows):
            sat,free=evaluate(c,a)
            if sat:continue
            if not free:return {'units':units,'conflict':i}
            if len(free)==1:
                q=free[0];a[abs(q)]=q>0;units.append([i,q]);changed=True;break
        if not changed:break
    if len(a)==18:raise ValueError('SAT assignment: '+repr(a))
    v=next(v for v in range(1,19) if v not in a)
    return {'units':units,'split':v,
            'false':generate_tree(rows,a|{v:False}),
            'true':generate_tree(rows,a|{v:True})}

def replay(rows,node,assignment):
    a=dict(assignment);counts=[1,0,0]
    for i,q in node['units']:
        assert 0<=i<len(rows)
        sat,free=evaluate(rows[i],a)
        assert not sat and free==[q]
        a[abs(q)]=q>0;counts[1]+=1
    if 'conflict' in node:
        assert 0<=node['conflict']<len(rows)
        sat,free=evaluate(rows[node['conflict']],a)
        assert not sat and not free
        counts[2]=1;return counts
    v=node['split'];assert 1<=v<=18 and v not in a
    for value,key in [(False,'false'),(True,'true')]:
        child=replay(rows,node[key],a|{v:value})
        counts=[x+y for x,y in zip(counts,child)]
    return counts

def exhaustive(rows):
    eligible=0;tested=0;survivors=0
    for g in it.product([False,True],repeat=12):
        if sum(g)<11:continue
        eligible+=1
        for t in it.product([False,True],repeat=6):
            tested+=1;a=dict(enumerate(g+t,1))
            survivors+=all(evaluate(c,a)[0] for c in rows)
    assert (eligible,tested,survivors)==(13,832,0)
    return [eligible,tested,survivors]

def mutation(g):
    """All black edges length 3, all white spokes length 1."""
    es=g['edges'];w=[3 if v<4 else 1 for u,v in es];idx={tuple(e):j for j,e in enumerate(es)}
    def length(s):return sum(w[idx[tuple(sorted((u,v)))]] for u,v in zip(s,s[1:]))
    d=[[0 if i==j else 1000000 for j in range(N)] for i in range(N)]
    for (u,v),a in zip(es,w):d[u][v]=d[v][u]=a
    for k in range(N):
        for i in range(N):
            for j in range(N):d[i][j]=min(d[i][j],d[i][k]+d[k][j])
    geo=[];bad=[]
    for c,chords,comps,peripheral in g['cycle_rows']:
        total=length(c+[c[0]])
        ok=all(min(length(c[i:j+1]),total-length(c[i:j+1]))==d[c[i]][c[j]] for i in range(len(c)) for j in range(i+1,len(c)))
        if ok:
            geo.append(c)
            if not peripheral:bad.append(c)
    assert len(geo)==22 and len(bad)==10
    assert sorted(map(len,bad))==[4]*6+[6]*4
    assert all(t not in geo for t in g['nonperipheral_triangles'])
    return {'weights':w,'geodesic_cycles':geo,'nonperipheral_geodesic_cycles':bad,
            'warning':'Avoiding just the four black triangles is a weaker SAT condition; the root must exclude every bad cycle.'}

def main():
    p=argparse.ArgumentParser(description=__doc__)
    mode=p.add_mutually_exclusive_group(required=True);mode.add_argument('--build',action='store_true');mode.add_argument('--verify',action='store_true')
    p.add_argument('--directory',default='.')
    p.add_argument('--write-audit',action='store_true',help='Save graph and mutation audits, never overwrite the frozen UNSAT tree in verify mode.')
    a=p.parse_args();out=Path(a.directory);start=time.monotonic()
    g=graph_audit();rows=compile_cnf(g)
    if a.build:
        out.mkdir(parents=True,exist_ok=True)
        for name,obj in [('graph-audit.json',g),('unsat-tree.json',{'verdict':'candidate_only','variables':18,'clauses':rows,'tree':generate_tree(rows,{})}),('mutation.json',mutation(g))]:
            (out/name).write_bytes(encode(obj))
    if a.write_audit:
        (out/'graph-audit.json').write_bytes(encode(g))
        (out/'mutation.json').write_bytes(encode(mutation(g)))
    if (out/'graph-audit.json').exists():
        assert json.loads((out/'graph-audit.json').read_text())==g
    cert=json.loads((out/'unsat-tree.json').read_text());assert cert['clauses']==rows and cert['variables']==18
    counts=replay(rows,cert['tree'],{})
    if (out/'mutation.json').exists():
        assert json.loads((out/'mutation.json').read_text())==mutation(g)
    ex=exhaustive(rows)
    print(json.dumps({'verdict':'candidate_only','mode':'build_and_replay' if a.build else 'frozen_replay',
                      'n':N,'m':len(EDGES),'cycles':len(g['cycle_rows']),'peripheral':len(g['peripheral_triangles']),
                      'cycle_rank':g['cycle_rank'],'vertex_deletions_checked':len(g['deletion_rows']),
                      'edge_subsets_checked':1<<len(EDGES),'cnf_clauses':len(rows),'dpll_nodes':counts[0],
                      'unit_steps':counts[1],'conflict_leaves':counts[2],
                      'eligible_face_assignments':ex[0],'tightness_assignments':ex[1],'survivors':ex[2],
                      'source_sha256':digest(__file__),'artifact_sha256':{'graph-audit.json':hashlib.sha256(encode(g)).hexdigest(),'unsat-tree.json':digest(out/'unsat-tree.json'),'mutation.json':hashlib.sha256(encode(mutation(g))).hexdigest()},
                      'elapsed_seconds':time.monotonic()-start,
                      'scope':'Finite graph/CNF checks only; the universal metric bridge is a separate candidate proof.'},sort_keys=True))
if __name__=='__main__':main()
