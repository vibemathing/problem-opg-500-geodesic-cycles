"""OPG-500 candidate computation. Exact integers/Fractions; no trusted receipt.
Canonical cycles retain chords. DFS paths may decrease in vertex labels.
The output is candidate data and does not admit any repository obligation.
"""
from __future__ import annotations
import argparse, hashlib, itertools, json, math, random, sys, time
from collections import Counter
from fractions import Fraction
from pathlib import Path
from typing import Iterable

VERSION = 'opg500-c08-root-search-1'


def canonical_bytes(obj):
    return json.dumps(obj,sort_keys=True,separators=(',',':'),ensure_ascii=False).encode()

def digest(obj): return hashlib.sha256(canonical_bytes(obj)).hexdigest()

class CapExceeded(RuntimeError): pass

class Graph:
    def __init__(self,n:int,edges:Iterable[tuple[int,int]],deadline=None):
        if type(n) is not int or n<1: raise ValueError('invalid vertex count')
        raw=list(edges)
        if any(len(e)!=2 or any(type(v) is not int or not 0<=v<n for v in e) or e[0]==e[1] for e in raw):
            raise ValueError('invalid edge')
        self.n=n; self.edges=sorted(tuple(sorted(e)) for e in raw)
        if len(set(self.edges))!=len(raw): raise ValueError('duplicate undirected edge')
        self.m=len(raw); self.idx={e:i for i,e in enumerate(self.edges)}
        self.adj=[[] for _ in range(n)]
        for a,b in self.edges: self.adj[a].append(b);self.adj[b].append(a)
        self.adj=[sorted(a) for a in self.adj]
        self.deadline=deadline; self.steps=0
    def tick(self):
        self.steps+=1
        if self.steps%4096==0 and self.deadline is not None and time.monotonic()>self.deadline:
            raise CapExceeded('wall-clock budget exceeded; no completeness claim')
    def eids(self,p):
        return [self.idx[tuple(sorted((a,b)))] for a,b in zip(p,p[1:])]
    def components(self,deleted=()):
        remaining=set(range(self.n))-set(deleted); ans=[]
        while remaining:
            start=min(remaining); remaining.remove(start); todo=[start]; comp=[]
            while todo:
                u=todo.pop();comp.append(u)
                for v in self.adj[u]:
                    if v in remaining: remaining.remove(v);todo.append(v)
            ans.append(sorted(comp))
        return ans
    def connectivity_audit(self):
        rows=[]
        for size in range(3):
            for cut in itertools.combinations(range(self.n),size):
                comps=self.components(cut)
                rows.append({'deleted':list(cut),'components':comps})
        return {'is_3_connected':self.n>=4 and all(len(r['components'])==1 for r in rows),'deletion_tests':rows}
    def cycles(self,limit=200000):
        ans=[]
        def visit(s,p,used):
            self.tick()
            for v in self.adj[p[-1]]:
                if v==s:
                    if len(p)>=3 and p[1]<p[-1]:
                        ans.append(tuple(p))
                        if len(ans)>limit: raise CapExceeded('cycle cap exceeded')
                elif v>s and v not in used:
                    visit(s,p+[v],used|{v})
        for s in range(self.n): visit(s,[s],{s})
        return sorted(ans,key=lambda c:(len(c),c))
    def paths(self,x,y,limit=200000):
        ans=[]
        def visit(p,used):
            self.tick()
            if p[-1]==y:
                ans.append(tuple(p))
                if len(ans)>limit: raise CapExceeded('path cap exceeded')
                return
            for v in self.adj[p[-1]]:
                if v not in used: visit(p+[v],used|{v})
        visit([x],{x})
        return sorted(ans)
    def classify(self,c):
        ce={tuple(sorted((a,b))) for a,b in zip(c,c[1:]+c[:1])}; vs=set(c)
        chords=[e for e in self.edges if set(e)<=vs and e not in ce]
        comps=self.components(vs)
        return {'induced':not chords,'chords':[list(e) for e in chords],
                'remaining_components':comps,'peripheral':not chords and len(comps)<=1}
    def distances(self,w):
        if len(w)!=self.m or any(x<=0 for x in w): raise ValueError('positive length vector required')
        # None, rather than a finite sentinel, represents infinity.
        d=[[None]*self.n for _ in range(self.n)]; route=[[None]*self.n for _ in range(self.n)]
        for u in range(self.n):d[u][u]=0;route[u][u]=(u,)
        for (u,v),value in zip(self.edges,w):d[u][v]=d[v][u]=value;route[u][v]=(u,v);route[v][u]=(v,u)
        for k in range(self.n):
            for u in range(self.n):
                if d[u][k] is None:continue
                for v in range(self.n):
                    if d[k][v] is None:continue
                    z=d[u][k]+d[k][v]
                    if d[u][v] is None or z<d[u][v]:
                        d[u][v]=z;route[u][v]=route[u][k]+route[k][v][1:]
        return d,route
    def evaluate(self,cycles,w,full=False):
        d,routes=self.distances(w); records=[]; bad=[]; geos=[]
        for c in cycles:
            ids=self.eids(c+c[:1]); pref=[0]
            for j in ids:pref.append(pref[-1]+w[j])
            failure=None; pairs=[]
            for i in range(len(c)):
                for j in range(i+1,len(c)):
                    a=pref[j]-pref[i];b=pref[-1]-a;dist=d[c[i]][c[j]]
                    assert dist is not None and dist<=min(a,b)
                    if full:pairs.append([c[i],c[j],str(a),str(b),str(dist)])
                    if failure is None and dist<min(a,b):
                        p=routes[c[i]][c[j]]
                        assert len(p)==len(set(p))
                        failure={'endpoints':[c[i],c[j]],'path':list(p),
                                 'arc_lengths':[str(a),str(b)],'path_length':str(dist)}
            klass=self.classify(c)
            if failure is None:
                geos.append(c)
                if not klass['peripheral']:bad.append(c)
            if full:
                records.append({'cycle':list(c),**klass,'geodesic':failure is None,'shortcut':failure,
                                'pair_audit_u_v_forward_backward_distance':pairs})
        return {'bad':bad,'geodesic':geos,'cycle_audit':records}
    def compile(self,cycles,all_paths):
        # C07 atom convention: integer coefficients dot w < 0.
        # All cycle clauses point into one shared edge vector.
        clauses=[]
        for c in cycles:
            if self.classify(c)['peripheral']:continue
            ids=self.eids(c+c[:1]); branches=[]
            for i,j in itertools.combinations(range(len(c)),2):
                x,y=c[i],c[j];a=ids[i:j];b=ids[j:]+ids[:i]
                lo,hi=sorted((x,y))
                for path_index,p in enumerate(all_paths[(lo,hi)]):
                    pi=self.eids(p);cv=[0]*self.m
                    for e in pi:cv[e]+=1
                    ca=cv.copy();cb=cv.copy()
                    for e in a:ca[e]-=1
                    for e in b:cb[e]-=1
                    # A path entirely no shorter than one arc under any w>0
                    # could be pruned, but the baseline table deliberately keeps it.
                    branches.append({'pair':[lo,hi],'path_index':path_index,'lt_zero':[ca,cb]})
            clauses.append({'cycle':list(c),'or_path_branches':branches})
        return {'variables':[f'w{j}' for j in range(self.m)],'positive_edge_indices':list(range(self.m)),
                'and_nonperipheral_cycles':clauses}
    def evaluate_formula(self,formula,all_paths,w):
        if len(w)!=self.m or any(v<=0 for v in w):return False
        for clause in formula['and_nonperipheral_cycles']:
            if not any(all(sum(a*x for a,x in zip(row,w))<0 for row in branch['lt_zero'])
                       for branch in clause['or_path_branches']):return False
        return True


def named_graphs():
    out={}
    out['K4']=(4,list(itertools.combinations(range(4),2)))
    for rim in [4,5,6]:
        out[f'wheel_rim{rim}']=(rim+1,[(0,i) for i in range(1,rim+1)]+[(i,1+i%rim) for i in range(1,rim+1)])
    out['triangular_prism']=(6,[(0,1),(1,2),(0,2),(3,4),(4,5),(3,5),(0,3),(1,4),(2,5)])
    out['K33']=(6,[(a,b) for a in range(3) for b in range(3,6)])
    out['cube']=(8,[(v,v^(1<<bit)) for v in range(8) for bit in range(3) if v<(v^(1<<bit))])
    out['Petersen']=(10,[(i,(i+1)%5) for i in range(5)]+[(i,i+5) for i in range(5)]+[(5+i,5+(i+2)%5) for i in range(5)])
    out['triangular_bipyramid']=(5,[e for e in itertools.combinations(range(5),2) if e!=(3,4)])
    return out

def search(g,cycles,tries=4000,seed=500):
    rnd=random.Random(seed); best=None
    for index in range(tries):
        g.tick()
        if index==0:w=[1]*g.m
        elif index<1000:w=[10+rnd.randrange(5) for _ in range(g.m)]
        elif index<2000:w=[1+rnd.randrange(8) for _ in range(g.m)]
        else:
            w=best['w'].copy()
            for _ in range(1+rnd.randrange(3)):
                j=rnd.randrange(g.m);w[j]=max(1,w[j]+rnd.choice([-3,-2,-1,1,2,3]))
        ev=g.evaluate(cycles,w)
        score=len(ev['bad'])
        if best is None or score<best['bad_count'] or (score==best['bad_count'] and rnd.randrange(7)==0):
            best={'w':w,'bad_count':score,'bad':ev['bad']}
        if score==0:return {'found':True,'trials':index+1,'w':w}
    return {'found':False,'trials':tries,'best':best}


def run(outdir:Path,seconds:int,tries:int):
    start=time.monotonic(); deadline=start+seconds;outdir.mkdir(parents=True,exist_ok=True)
    summary=[]
    for name,(n,edges) in named_graphs().items():
        g=Graph(n,edges,deadline);cycles=g.cycles();conn=g.connectivity_audit()
        assert conn['is_3_connected'], 'named graph outside root domain'
        result=search(g,cycles,tries)
        unit=g.evaluate(cycles,[1]*g.m)
        data={'kind':'candidate_computation','version':VERSION,'graph_name':name,'n':n,'edges':[list(e) for e in g.edges],
              'connectivity':conn,'cycle_count':len(cycles),'cycle_table_sha256':digest(cycles),
              'peripheral_count':sum(g.classify(c)['peripheral'] for c in cycles),
              'unit_bad_cycles':[list(c) for c in unit['bad']],'search':result}
        if result['found']:
            ev=g.evaluate(cycles,result['w'],full=True);data.update(ev);assert not ev['bad']
        (outdir/f'{name}.json').write_text(json.dumps(data,indent=2)+'\n')
        row={'graph':name,'n':n,'m':g.m,'cycles':len(cycles),'peripheral':data['peripheral_count'],
             'unit_bad':len(unit['bad']),'found':result['found'],'trials':result['trials'],
             'w':result.get('w'),'geodesic_count':len(data.get('geodesic',[]))}
        summary.append(row);print(json.dumps(row),flush=True)
    (outdir/'summary.json').write_text(json.dumps({'candidate_only':True,'graphs':summary},indent=2)+'\n')
    print('elapsed_seconds',round(time.monotonic()-start,3),flush=True)

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--out',type=Path,required=True);p.add_argument('--seconds',type=int,default=90);p.add_argument('--tries',type=int,default=4000)
    a=p.parse_args()
    try:run(a.out,a.seconds,a.tries)
    except CapExceeded as exc:
        print('INCOMPLETE:',str(exc),file=sys.stderr);sys.exit(2)
