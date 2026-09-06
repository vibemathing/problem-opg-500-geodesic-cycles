"""C10 all-ties tight-subgraph certificate and exact witness extractor.
Candidate-generation checks only. No network, third-party package, or
trusted verifier/admission action. Run with python -S check.py.
"""
from __future__ import annotations
from collections import Counter
from fractions import Fraction as Q
from itertools import combinations, product
from pathlib import Path
import hashlib
import heapq
import json
import random
import sys
import time

B=tuple(range(4))
E=tuple(sorted(tuple(combinations(B,2))+tuple((v,7-i) for i in B for v in B if v!=i)))
EI={e:j for j,e in enumerate(E)}
CORE=tuple(combinations(B,2))
START=time.monotonic()

def guard():
    if time.monotonic()-START>30:
        raise TimeoutError('C10 candidate-generation time cap')

def edge(u,v):
    return (min(u,v),max(u,v))

def comps(vertices,es):
    remaining=set(vertices);out=[]
    while remaining:
        seen={min(remaining)};todo=list(seen)
        while todo:
            u=todo.pop()
            for a,b in es:
                if a==u:v=b
                elif b==u:v=a
                else:continue
                if v in remaining and v not in seen:
                    seen.add(v);todo.append(v)
        remaining-=seen;out.append(sorted(seen))
    return sorted(out)

def adjacency(es):
    a=[[] for _ in range(8)]
    for u,v in es:a[u].append(v);a[v].append(u)
    return [sorted(z) for z in a]

def cycles(es):
    adj=adjacency(es);out=[]
    def go(s,p):
        for v in adj[p[-1]]:
            if v==s and len(p)>=3 and p[1]<p[-1]:out.append(p)
            elif v>s and v not in p:go(s,p+(v,))
    for s in range(8):go(s,(s,))
    return sorted(out,key=lambda p:(len(p),p))

def path_edges(p):
    return [edge(a,b) for a,b in zip(p,p[1:])]

def cycle_edges(c):
    return path_edges(c+(c[0],))

def cycle_vector(c):
    return sum(1<<EI[e] for e in cycle_edges(c))

def canonical(c):
    j=c.index(min(c));z=c[j:]+c[:j]
    return min(z,(z[0],)+z[:0:-1])

def basis(vs):
    piv={}
    for v in vs:
        while v:
            j=v.bit_length()-1
            if j not in piv:piv[j]=v;break
            v^=piv[j]
    return piv

def outside(v,piv):
    while v:
        j=v.bit_length()-1
        if j not in piv:return True
        v^=piv[j]
    return False

def peripheral(c):
    ce=set(cycle_edges(c))
    return not any(set(e)<=set(c) and e not in ce for e in E) and len(comps(set(range(8))-set(c),E))<=1

def geodesic(c,w,d):
    total=sum(w[e] for e in cycle_edges(c))
    return all(min(sum(w[e] for e in path_edges(c[i:j+1])),total-sum(w[e] for e in path_edges(c[i:j+1])))==d[c[i]][c[j]] for i in range(len(c)) for j in range(i+1,len(c)))

def all_distances(w):
    """Distances are validated below by edge bounds AND path attainment."""
    adj=adjacency(E);ds=[];ps=[]
    for s in range(8):
        d=[None]*8;p=[None]*8;d[s]=Q(0);p[s]=(s,);heap=[(Q(0),s)]
        while heap:
            a,u=heapq.heappop(heap)
            if a!=d[u]:continue
            for v in adj[u]:
                z=a+w[edge(u,v)]
                if d[v] is None or z<d[v]:
                    d[v]=z;p[v]=p[u]+(v,);heapq.heappush(heap,(z,v))
        if d[s]!=0:raise ArithmeticError('Missing anchor')
        for u,v in E:
            if abs(d[u]-d[v])>w[(u,v)]:raise ArithmeticError('Invalid distance lower bound')
        for v in range(8):
            if len(p[v])!=len(set(p[v])):raise ArithmeticError('Nonsimple attaining path')
            if sum(w[e] for e in path_edges(p[v]))!=d[v]:raise ArithmeticError('No path attainment')
        ds.append(d);ps.append(p)
    return ds,ps

def extract(vector):
    if len(vector)!=18 or any(a<=0 for a in vector):raise ValueError('Positive 18-vector required')
    w=dict(zip(E,map(Q,vector)));d,ps=all_distances(w)
    T=tuple(e for e in E if w[e]==d[e[0]][e[1]])
    if len(comps(range(8),T))!=1:raise ArithmeticError('Tight graph disconnected')
    for row in ps:
        if any(e not in T for p in row for e in path_edges(p)):raise ArithmeticError('Shortest path not tight')
    F=tuple(e for e in CORE if e in T)
    Ns=[tuple(j for j in B if j!=i and edge(j,7-i) in T) for i in B]
    reason=None;chosen=None;meta={}
    for tri in combinations(B,3):
        if all(e in F for e in combinations(tri,2)):
            reason='tight_core_triangle';chosen=tri;break
    if chosen is None:
        for i in B:
            for j in B:
                if j==i or j in Ns[i] or any(edge(j,k) in F for k in Ns[i]):continue
                p=ps[7-i][j]
                if w[edge(7-i,j)]<=d[7-i][j] or len(p)<4:raise ArithmeticError('Invalid nondomination witness')
                chosen=canonical(p);reason='nontight_edge_cycle'
                meta={'missing_domination':[i,j],'shortest_path':list(p)};break
            if chosen is not None:break
    if chosen is None:
        tc=cycles(T);tris=[c for c in tc if len(c)==3]
        piv=basis(map(cycle_vector,tris));beta=len(T)-7
        ci=[len(comps(N,F)) for N in Ns]
        gap=len(F)+sum(ci)-7
        if gap!=beta-len(tris) or gap<1:raise ArithmeticError('Rank bound failure')
        candidates=[c for c in tc if outside(cycle_vector(c),piv)]
        if not candidates:raise ArithmeticError('No cycle outside triangle span')
        chosen=min(candidates,key=lambda c:(sum(w[e] for e in cycle_edges(c)),len(c),c))
        reason='minimum_outside_triangle_span'
        meta={'core_edges':[list(e) for e in F],'tight_apex_neighbors':list(map(list,Ns)),
              'link_component_counts':ci,'cycle_rank':beta,'triangle_count':len(tris),
              'triangle_span_rank':len(piv),'rank_gap':gap,
              'outside_span_cycle_count':len(candidates)}
    if peripheral(chosen) or not geodesic(chosen,w,d):raise ArithmeticError('Extractor failed')
    total=sum(w[e] for e in cycle_edges(chosen));pairs=[]
    for i,j in combinations(range(len(chosen)),2):
        a=sum(w[e] for e in path_edges(chosen[i:j+1]));b=total-a
        pairs.append({'vertices':[chosen[i],chosen[j]],'arc_lengths':[str(a),str(b)],
                      'distance':str(d[chosen[i]][chosen[j]])})
    return {'length_vector':list(map(str,vector)),'case':reason,'cycle':list(chosen),
            'chords':[list(e) for e in E if set(e)<=set(chosen) and e not in cycle_edges(chosen)],
            'complement_components':comps(set(range(8))-set(chosen),E),
            'pair_audit':pairs,'distance_matrix':[list(map(str,row)) for row in d],
            'attaining_paths':[[list(p) for p in row] for row in ps],
            'tight_edges':[list(e) for e in T],'case_data':meta}

def finite_certificate():
    cases=[];patterns=[];hist=Counter();excluded=[]
    for fm in range(64):
        guard();F=tuple(e for j,e in enumerate(CORE) if fm>>j&1)
        tri=next((t for t in combinations(B,3) if all(e in F for e in combinations(t,2))),None)
        if tri is not None:
            excluded.append([fm,list(tri)]);continue
        options=[]
        for i in B:
            V=set(B)-{i};oi=[]
            for nm in range(1,16):
                N={j for j in B if nm>>j&1}
                if not N<=V:continue
                if not all(v in N or any(edge(v,k) in F for k in N) for v in V):continue
                c=len(comps(N,F));ei=sum(set(e)<=N for e in F)
                if len(N)-ei!=c:raise ArithmeticError('Link not a forest')
                oi.append((nm,c))
            options.append(oi)
        local=Counter()
        for selected in product(*options):
            gap=len(F)+sum(c for nm,c in selected)-7
            if gap<=0:raise ArithmeticError('Surviving necessary pattern')
            hist[gap]+=1;local[gap]+=1
            patterns.append([fm]+[nm for nm,c in selected]+[gap])
        cases.append({'core_mask':fm,'edges':[list(e) for e in F],
                      'apex_options':options,'patterns':sum(local.values()),'gap_histogram':dict(local)})
    if len(cases)!=41 or len(patterns)!=5913 or len(excluded)!=23:raise ArithmeticError('Incomplete case coverage')
    if dict(hist)!={1:768,2:2752,3:2019,4:366,5:8}:raise ArithmeticError('Changed histogram')
    return {'verdict':'candidate_only','edge_order':list(map(list,E)),
            'core_edge_bit_order':list(map(list,CORE)),'excluded_core_triangles':excluded,
            'cases':cases,'pattern_columns':['core_mask','N0_mask','N1_mask','N2_mask','N3_mask','rank_gap'],
            'patterns':patterns,'gap_histogram':dict(sorted(hist.items()))}

def encoded(x):return (json.dumps(x,sort_keys=True,separators=(',',':'))+'\n').encode()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,data):
    raw=encoded(data)
    if len(raw)>1048576:raise RuntimeError('Candidate file cap')
    p.write_bytes(raw)

def main():
    out=Path(__file__).resolve().parent;cs=cycles(E)
    if len(cs)!=239 or sum(map(peripheral,cs))!=12:raise ArithmeticError('Graph identity')
    cert=finite_certificate();write(out/'patterns.json',cert)
    r=random.Random(20260906)
    tests=[('unit',[Q(1)]*18),('core3_spokes1',[Q(3 if e[1]<4 else 1) for e in E]),
           ('binary_powers',[Q(2**j) for j in range(18)])]
    for j in range(32):tests.append((f'integer_{j}',[Q(r.randrange(1,31)) for e in E]))
    for j in range(16):tests.append((f'rational_{j}',[Q(r.randrange(1,21),r.randrange(1,8)) for e in E]))
    tests.append(('uniform_scaled',[Q(7,13)]*18))
    witnesses=[]
    for label,v in tests:
        guard();a=extract(v);a['input_label']=label;witnesses.append(a)
    write(out/'witness-audits.json',{'verdict':'candidate_only','edge_order':list(map(list,E)),
                                   'seed':20260906,'samples':witnesses})
    report={'verdict':'candidate_only','execution_role':'candidate_generation_sandbox',
            'python_version':sys.version.split()[0],'source_sha256':sha(Path(__file__)),
            'core_patterns':64,'triangle_free_patterns':41,'dominating_spoke_patterns':5913,
            'gap_histogram':cert['gap_histogram'],'exact_weight_samples':len(witnesses),
            'extractor_cases':dict(Counter(a['case'] for a in witnesses)),
            'all_sample_witnesses_nonperipheral_geodesic':True,
            'patterns_sha256':sha(out/'patterns.json'),'witness_audits_sha256':sha(out/'witness-audits.json'),
            'elapsed_seconds':time.monotonic()-START,'trusted_verifier_receipt':None,
            'scope':'Finite combinatorial certificate and rational sample extraction only; all-real proof remains a separate candidate.'}
    write(out/'replay-report.json',report);print(json.dumps(report,sort_keys=True))

if __name__=='__main__':main()
