"""Separate generator-side C10 output replay; no trusted verification status.
No import of check.py. Rebuilds pattern coverage and checks exact distance
certificates (edge bounds + path attainment) for every extracted cycle.
"""
from collections import Counter
from fractions import Fraction as Q
from itertools import combinations, product
from pathlib import Path
import hashlib
import json
import sys

B=tuple(range(4));CORE=tuple(combinations(B,2))
E=tuple(sorted(CORE+tuple((j,7-i) for i in B for j in B if j!=i)))
ES=set(E)
def ed(a,b):return tuple(sorted((a,b)))
def components(V,edges):
    V=set(V);parts=[{v} for v in V]
    for a,b in edges:
        if a not in V or b not in V:continue
        x=next(p for p in parts if a in p);y=next(p for p in parts if b in p)
        if x is not y:x.update(y);parts.remove(y)
    return sorted(sorted(p) for p in parts)
def pe(p):return [ed(a,b) for a,b in zip(p,p[1:])]
def load(p):return json.loads(p.read_text())
def main():
    if not __debug__:raise RuntimeError('Assertions must be enabled')
    D=Path(__file__).resolve().parent
    a=load(D/'patterns.json');samples=load(D/'witness-audits.json')['samples']
    assert a['edge_order']==list(map(list,E))
    excluded={fm:tri for fm,tri in a['excluded_core_triangles']}
    expected=set();hist=Counter();core_cases=set()
    Noptions=[[s for s in range(1,16) if not (s>>i&1)] for i in B]
    for fm in range(64):
        F={e for j,e in enumerate(CORE) if fm>>j&1}
        triangles=[t for t in combinations(B,3) if set(combinations(t,2))<=F]
        if triangles:
            assert fm in excluded and tuple(excluded[fm]) in triangles
            continue
        assert fm not in excluded;core_cases.add(fm)
        for ns in product(*Noptions):
            Ns=[{j for j in B if nm>>j&1} for nm in ns]
            if not all(all(j in Ns[i] or any(ed(j,k) in F for k in Ns[i]) for j in B if j!=i) for i in B):continue
            edgesT=len(F)+sum(map(len,Ns))
            trianglesT=sum(sum(set(e)<=N for e in F) for N in Ns)
            gap=edgesT-7-trianglesT
            assert gap>=1
            expected.add((fm,)+ns+(gap,));hist[gap]+=1
    actual=list(map(tuple,a['patterns']))
    assert len(actual)==len(set(actual))==5913 and set(actual)==expected
    assert len(core_cases)==41 and len(excluded)==23
    assert hist==Counter({1:768,2:2752,3:2019,4:366,5:8})
    for s in samples:
        w=dict(zip(E,map(Q,s['length_vector'])));assert len(s['length_vector'])==18 and all(v>0 for v in w.values())
        d=[list(map(Q,row)) for row in s['distance_matrix']];assert len(d)==8 and all(len(r)==8 for r in d)
        for x in range(8):
            assert d[x][x]==0
            for u,v in E:assert abs(d[x][u]-d[x][v])<=w[u,v]
            for y in range(8):
                p=s['attaining_paths'][x][y]
                assert p[0]==x and p[-1]==y and len(p)==len(set(p)) and set(pe(p))<=ES
                assert sum(w[e] for e in pe(p))==d[x][y]
        T={e for e in E if w[e]==d[e[0]][e[1]]}
        assert T==set(map(tuple,s['tight_edges'])) and len(components(range(8),T))==1
        c=s['cycle'];assert 3<=len(c)<=8 and len(c)==len(set(c)) and set(c)<=set(range(8))
        ce=pe(c+[c[0]]);assert set(ce)<=ES
        chords=sorted(e for e in E if set(e)<=set(c) and e not in ce)
        cc=components(set(range(8))-set(c),E)
        assert chords or len(cc)>1
        assert s['chords']==list(map(list,chords)) and s['complement_components']==cc
        total=sum(w[e] for e in ce);pairs=[]
        for i,j in combinations(range(len(c)),2):
            arc=sum(w[e] for e in pe(c[i:j+1]));assert min(arc,total-arc)==d[c[i]][c[j]]
            pairs.append({'vertices':[c[i],c[j]],'arc_lengths':[str(arc),str(total-arc)],'distance':str(d[c[i]][c[j]])})
        assert pairs==s['pair_audit']
    report={'verdict':'candidate_only','execution_role':'candidate_generation_sandbox',
      'method':'Cartesian-mask coverage plus exact distance/path certificate replay; no producer import',
      'python_version':sys.version.split()[0],
      'checker_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'patterns_sha256':hashlib.sha256((D/'patterns.json').read_bytes()).hexdigest(),
      'witness_audits_sha256':hashlib.sha256((D/'witness-audits.json').read_bytes()).hexdigest(),
      'triangle_free_cases':len(core_cases),'patterns':len(expected),'exact_weight_samples':len(samples),
      'all_distance_and_bad_cycle_certificates_valid':True,'trusted_verifier_receipt':None}
    (D/'separate-report.json').write_text(json.dumps(report,sort_keys=True,separators=(',',':'))+'\n')
    print(json.dumps(report,sort_keys=True))
if __name__=='__main__':main()
