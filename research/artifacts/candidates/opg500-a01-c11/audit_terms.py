"""Read the emitted Lean text with a small propositional proof checker.
Candidate-generation audit, not Lean elaboration or a trusted verifier.
Only the explicit noNecessaryPattern term is accepted. No eval or imports
of the exporter are used. Types: propositional variables, False, Or, arrow.
Rules: hypothesis, lambda/application, let, Or.elim, False.elim, Classical.em.
"""
from __future__ import annotations
from collections import Counter
from pathlib import Path
import hashlib
import json
import re
import sys

TOKEN = re.compile(r'\s*(?:(:=|=>|→|∨|[():;])|([A-Za-z_][A-Za-z_0-9.]*))')
FALSE = ('false',)

def tokenize(text):
    out=[];i=0
    while i<len(text):
        if not text[i:].strip():break
        m=TOKEN.match(text,i)
        if m is None:raise ValueError('Unexpected token near '+repr(text[i:i+24]))
        out.append(m.group(1) or m.group(2));i=m.end()
    return out

class Parser:
    def __init__(self,text):self.ts=tokenize(text);self.i=0
    def peek(self):return self.ts[self.i] if self.i<len(self.ts) else None
    def take(self,want=None):
        z=self.peek()
        if z is None or want is not None and z!=want:raise ValueError('Unexpected syntax')
        self.i+=1;return z
    def ty(self):
        if self.peek()=='(':
            self.take();lhs=self.ty();self.take(')')
        else:
            t=self.take();lhs=FALSE if t=='False' else ('var',t)
            if t!='False' and not re.fullmatch(r'p(?:[1-9]|1[0-8])',t):raise ValueError('Unknown proposition')
        if self.peek() in ('→','∨'):
            op=self.take();return ('arrow' if op=='→' else 'or',lhs,self.ty())
        return lhs
    def atom(self):
        if self.peek()=='(':
            self.take();z=self.expr();self.take(')');return z
        t=self.take()
        if not re.fullmatch(r'[A-Za-z_][A-Za-z_0-9.]*',t):raise ValueError('Expected name')
        return ('name',t)
    def expr(self):
        if self.peek()=='let':
            self.take();n=self.take();self.take(':');ty=self.ty();self.take(':=')
            val=self.expr();self.take(';');body=self.expr();return ('let',n,ty,val,body)
        if self.peek()=='fun':
            self.take();annotation=None
            if self.peek()=='(':
                self.take();n=self.take();self.take(':');annotation=self.ty();self.take(')')
            else:n=self.take()
            self.take('=>');return ('lambda',n,annotation,self.expr())
        z=self.atom()
        while self.peek() not in (None,')',';',':=','=>'):
            if self.peek() in ('let','fun'):raise ValueError('Unparenthesized binder application')
            z=('app',z,self.atom())
        return z

def flatten(t):
    args=[]
    while t[0]=='app':args.append(t[2]);t=t[1]
    return t,list(reversed(args))

class Checker:
    def __init__(self):self.rules=Counter()
    def infer(self,t,env):
        head,args=flatten(t)
        if head==('name','Classical.em'):
            if len(args)!=1 or args[0][0]!='name':raise ValueError('Excluded-middle argument')
            name=args[0][1]
            if name not in {f'p{i}' for i in range(1,19)}:raise ValueError('Undeclared proposition')
            self.rules['classical_em']+=1;p=('var',name);return ('or',p,('arrow',p,FALSE))
        if t[0]=='name':
            if t[1] not in env:raise ValueError('Unbound hypothesis: '+t[1])
            self.rules['hypothesis']+=1;return env[t[1]]
        if t[0]=='app':
            funty=self.infer(t[1],env)
            if funty[0]!='arrow':raise ValueError('Application of a non-function')
            self.check(t[2],funty[1],env);self.rules['application']+=1;return funty[2]
        raise ValueError('Cannot infer this term without an expected type')
    def check(self,t,expected,env):
        if t[0]=='let':
            _,name,ty,val,body=t
            if name in env:raise ValueError('Shadowing not admitted in this fragment')
            self.check(val,ty,env);self.rules['let']+=1
            self.check(body,expected,env|{name:ty});return
        if t[0]=='lambda':
            _,name,annotation,body=t
            if expected[0]!='arrow':raise ValueError('Lambda type')
            if annotation is not None and annotation!=expected[1]:raise ValueError('Binder annotation mismatch')
            if name in env:raise ValueError('Shadowed lambda binder')
            self.rules['lambda']+=1;self.check(body,expected[2],env|{name:expected[1]});return
        head,args=flatten(t)
        if head==('name','Or.elim'):
            if len(args)!=3:raise ValueError('Or.elim arity')
            disj=self.infer(args[0],env)
            if disj[0]!='or':raise ValueError('Or.elim premise')
            self.rules['or_elim']+=1
            self.check(args[1],('arrow',disj[1],expected),env)
            self.check(args[2],('arrow',disj[2],expected),env);return
        if head==('name','False.elim'):
            if len(args)!=1:raise ValueError('False.elim arity')
            self.rules['false_elim']+=1;self.check(args[0],FALSE,env);return
        if self.infer(t,env)!=expected:raise ValueError('Type mismatch')

def audit(text):
    text='\n'.join(line for line in text.splitlines() if not line.lstrip().startswith('--'))
    expected_start='import Init\n\nnamespace OPG500C11\n\ntheorem noNecessaryPattern ('
    if not text.startswith(expected_start):raise ValueError('Unexpected theorem/import envelope')
    parameter_text,rest=text[len(expected_start):].split(' : Prop)',1)
    if parameter_text!=' '.join(f'p{i}' for i in range(1,19)):raise ValueError('Variable list mismatch')
    header,tail=rest.split(' : False :=\n',1)
    body,ending=tail.split('\n\nend OPG500C11',1)
    if ending.strip()!='#print axioms OPG500C11.noNecessaryPattern':raise ValueError('Extra declaration')
    hp=Parser(header);env={}
    while hp.peek() is not None:
        hp.take('(');name=hp.take();hp.take(':');ty=hp.ty();hp.take(')')
        if name in env:raise ValueError('Duplicate premise')
        env[name]=ty
    if list(env)!=[f'h{i}' for i in range(76)]:raise ValueError('Premise coverage')
    bp=Parser(body);proof=bp.expr()
    if bp.peek() is not None:raise ValueError('Trailing proof token')
    c=Checker();c.check(proof,FALSE,env)
    return dict(c.rules),env

def main():
    out=Path(__file__).resolve().parent;text=(out/'NecessaryPattern.lean').read_text()
    counts,env=audit(text)
    cert=json.loads((out.parent/'opg500-a01-c09'/'unsat-tree.json').read_text())
    # Reconstruct every premise from the frozen integer clauses, without emit.py.
    def literal(q):
        p=('var',f'p{abs(q)}');return p if q>0 else ('arrow',p,FALSE)
    def clause(row):
        if not row:return FALSE
        if len(row)==1:return literal(row[0])
        return ('or',literal(row[0]),clause(row[1:]))
    if any(env[f'h{i}']!=clause(row) for i,row in enumerate(cert['clauses'])):raise ValueError('Header-to-certificate mismatch')
    if counts.get('let')!=89 or counts.get('classical_em')!=7:raise ValueError('Unexpected proof rule counts')
    changes={
      'changed_premise':text.replace('(h0 : (p1 ∨ p2))','(h0 : (p1 ∨ p3))',1),
      'unbound_hypothesis':text.replace('Or.elim h66','Or.elim absent66',1),
      'wrong_negation':text.replace('(u5 l280)','(u5 u5)',1),
    }
    results=[]
    for name,broken in changes.items():
        if broken==text:
            # Select an actual parenthesized function application, not a guessed binder.
            candidates=re.findall(r'\((u\d+) (l\d+)\)',text)
            if not candidates:raise ValueError('No mutation site')
            f,a=candidates[0];broken=text.replace(f'({f} {a})',f'({a} {f})',1)
        try:audit(broken)
        except ValueError as exc:results.append({'mutation':name,'rejected':True,'reason':str(exc)})
        else:raise ArithmeticError('Corrupt proof term accepted')
    report={'verdict':'candidate_only','execution_role':'candidate_generation_sandbox',
      'method':'small-propositional-fragment-checker-reading-emitted-text',
      'python_version':sys.version.split()[0],'premises':len(env),'rules':counts,'mutations':results,
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'lean_text_sha256':hashlib.sha256(text.encode()).hexdigest(),
      'scope':'Checks only the explicit propositional fragment, not Lean parsing/elaboration, the graph metric bridges or root admission.',
      'lean_execution':'not_run','trusted_verifier_receipt':None}
    (out/'term-audit.json').write_text(json.dumps(report,sort_keys=True,separators=(',',':'))+'\n')
    print(json.dumps(report,sort_keys=True))
if __name__=='__main__':main()
