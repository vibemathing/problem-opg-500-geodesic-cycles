"""Expand frozen C09 unit/split certificate to tactic-free Lean proof terms.
This generator does NOT invoke Lean or claim a kernel check. Only Init is
imported in the emitted source. All input clauses and proof steps are
checked before emission; output elaboration remains an open obligation.
"""
from __future__ import annotations
from itertools import combinations
from pathlib import Path
import copy
import hashlib
import json
import sys

CERT_SHA='b7f6bb1aaa032313232be769f83f0a8e3862b852095e868f25ff82506b2d73be'

def expected_clauses():
    return ([list(p) for p in combinations(range(1,13),2)]
            +[[-(2*i+1),-(2*i+2),13+i] for i in range(6)]
            +[[-13,-14,-16],[-13,-15,-17],[-14,-15,-18],[-16,-17,-18]])

def lit_type(lit):return f'p{lit}' if lit>0 else f'(p{-lit} → False)'
def clause_type(lits):
    if not lits:return 'False'
    if len(lits)==1:return lit_type(lits[0])
    return f'({lit_type(lits[0])} ∨ {clause_type(lits[1:])})'

class Emitter:
    def __init__(self,clauses):
        if clauses!=expected_clauses():raise ValueError('Different frozen clauses')
        self.clauses=clauses;self.counter=0;self.nodes=0;self.units=0;self.leaves=0
    def fresh(self,prefix):
        self.counter+=1;return f'{prefix}{self.counter}'
    def derive(self,lits,h,target,env):
        if not lits:
            if target is None:return h
            return f'(False.elim {h})'
        def branch(lit,name):
            if lit==target:return name
            if -lit not in env:raise ValueError('Missing complementary literal')
            contra=f'({env[-lit]} {name})' if lit>0 else f'({name} {env[-lit]})'
            return contra if target is None else f'(False.elim {contra})'
        if len(lits)==1:return branch(lits[0],h)
        left=self.fresh('l');right=self.fresh('r')
        return (f'(Or.elim {h} (fun ({left} : {lit_type(lits[0])}) => '
                +branch(lits[0],left)+f') (fun {right} => '
                +self.derive(lits[1:],right,target,env)+'))')
    def node(self,node,incoming):
        if not isinstance(node,dict):raise ValueError('Non-object proof node')
        self.nodes+=1;env=dict(incoming);prefix=[]
        for clause_id,target in node.get('units',[]):
            if not 0<=clause_id<len(self.clauses):raise ValueError('Clause index')
            lits=self.clauses[clause_id]
            if any(lit in env for lit in lits):raise ValueError('Satisfied clause is not unit')
            residual=[lit for lit in lits if -lit not in env]
            if residual!=[target] or target in env or -target in env:raise ValueError('Invalid unit step')
            name=self.fresh('u');proof=self.derive(lits,f'h{clause_id}',target,env)
            prefix.append(f'let {name} : {lit_type(target)} := {proof};')
            env[target]=name;self.units+=1
        if 'conflict' in node:
            if 'split' in node:raise ValueError('Ambiguous leaf')
            cid=node['conflict']
            if not 0<=cid<len(self.clauses):raise ValueError('Conflict index')
            lits=self.clauses[cid]
            if not all(-lit in env for lit in lits):raise ValueError('Clause is not a conflict')
            tail=self.derive(lits,f'h{cid}',None,env);self.leaves+=1
        else:
            if not {'split','true','false'}<=node.keys():raise ValueError('Incomplete split coverage')
            v=node['split']
            if not 1<=v<=18 or v in env or -v in env:raise ValueError('Invalid split variable')
            yes=self.fresh('yes');no=self.fresh('no')
            ep=dict(env);en=dict(env);ep[v]=yes;en[-v]=no
            a=self.node(node['true'],ep);b=self.node(node['false'],en)
            tail=f'(Or.elim (Classical.em p{v})\n(fun ({yes} : p{v}) =>\n{a})\n(fun ({no} : p{v} → False) =>\n{b}))'
        return '\n'.join(prefix+[tail])
    def emit(self,tree):
        proof=self.node(tree,{})
        parameters=' '.join(f'p{i}' for i in range(1,19))
        hyps='\n'.join(f'    (h{i} : {clause_type(c)})' for i,c in enumerate(self.clauses))
        return ('-- Candidate only; generated proof term has NOT been elaborated.\n'
          '-- Input certificate SHA-256: '+CERT_SHA+'\n'
          'import Init\n\nnamespace OPG500C11\n\n'
          f'theorem noNecessaryPattern ({parameters} : Prop)\n{hyps} : False :=\n'
          +'\n'.join('  '+line for line in proof.splitlines())+'\n\nend OPG500C11\n\n#print axioms OPG500C11.noNecessaryPattern\n')

def audit_mutations(cert):
    results=[]
    for name in ['wrong_unit','false_conflict','missing_branch','changed_clause']:
        bad=copy.deepcopy(cert)
        if name=='wrong_unit':bad['tree']['false']['units'][0][1]=3
        elif name=='false_conflict':bad['tree']['false']['conflict']=0
        elif name=='missing_branch':del bad['tree']['true']
        else:bad['clauses'][0]=[1,3]
        try:Emitter(bad['clauses']).emit(bad['tree'])
        except ValueError as exc:results.append({'mutation':name,'rejected':True,'reason':str(exc)})
        else:raise ArithmeticError('Unsound mutation accepted')
    return results

def main():
    out=Path(__file__).resolve().parent;source=out.parent/'opg500-a01-c09'/'unsat-tree.json'
    raw=source.read_bytes()
    if hashlib.sha256(raw).hexdigest()!=CERT_SHA:raise ValueError('Input digest mismatch')
    cert=json.loads(raw)
    if cert.get('variables')!=18:raise ValueError('Variable count')
    e=Emitter(cert['clauses']);text=e.emit(cert['tree'])
    if (e.nodes,e.units,e.leaves)!=(15,89,8):raise ValueError('Proof coverage changed')
    if len(text.encode())>1048576:raise RuntimeError('Output size limit')
    (out/'NecessaryPattern.lean').write_text(text,encoding='utf-8')
    report={'verdict':'candidate_only','execution_role':'candidate_generation_sandbox',
      'python_version':sys.version.split()[0],'input_sha256':CERT_SHA,
      'generator_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'lean_source_sha256':hashlib.sha256(text.encode()).hexdigest(),
      'lean_source_bytes':len(text.encode()),'clauses':len(e.clauses),'proof_nodes':e.nodes,
      'unit_derivations':e.units,'conflict_leaves':e.leaves,'mutations':audit_mutations(cert),
      'lean_execution':'not_run','kernel_output':None,'trusted_verifier_receipt':None}
    (out/'generation.json').write_text(json.dumps(report,sort_keys=True,separators=(',',':'))+'\n')
    print(json.dumps(report,sort_keys=True))
if __name__=='__main__':main()
