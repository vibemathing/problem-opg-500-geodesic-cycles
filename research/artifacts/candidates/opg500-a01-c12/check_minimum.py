"""Bounded exact candidate tests for finite restricted minimum and descent.
No Lean execution. Tests do not verify the universal Lean statements.
Standard library only; all compared costs are exact integers.
"""
from __future__ import annotations
from itertools import product
from pathlib import Path
from collections import Counter
import hashlib
import json
import sys
import time

START=time.monotonic()

def choose(table, costs, eligible):
    best=None
    for a in table:
        if not eligible[a]:
            continue
        if best is None or costs[a] < costs[best]:
            best=a
    return best

def model(objects, codes, inside, costs, good, splits, weak=False):
    # All codes lie in the four-element F2^2 group; combine is XOR.
    closure=all((a^b) in inside for a in inside for b in inside)
    complete=tuple(objects)
    smaller=lambda a,b:costs[a]<=costs[b] if weak else costs[a]<costs[b]
    compat=all(not(costs[a]<=costs[b] and smaller(b,a))
               for a in objects for b in objects)
    split_ok=all(c in good or
                 (c in splits and smaller(splits[c][0],c)
                  and smaller(splits[c][1],c)
                  and codes[c]==codes[splits[c][0]]^codes[splits[c][1]])
                 for c in objects)
    outside=[c for c in complete if codes[c] not in inside]
    conclusion=any(c in good for c in outside)
    return {'span_closed':closure,'strict_compatibility':compat,
            'split_hypothesis':split_ok,'complete_table':True,
            'outside_nonempty':bool(outside),'conclusion':conclusion}

def main():
    out=Path(__file__).resolve().parent
    tables=[t for n in range(5) for t in product(range(4),repeat=n)]
    count=Counter()
    for costs in product(range(4),repeat=4):
        for eligible in product((False,True),repeat=4):
            for table in tables:
                if count['table_cases']%4096==0 and time.monotonic()-START>12:
                    raise TimeoutError('Bounded minimum audit exceeded twelve seconds')
                best=choose(table,costs,eligible)
                relevant=[a for a in table if eligible[a]]
                if not relevant:
                    if best is not None:raise ArithmeticError('Invented eligible object')
                    count['empty_restriction']+=1
                else:
                    if best not in relevant:raise ArithmeticError('Unsound selected object')
                    if any(costs[a]<costs[best] for a in relevant):
                        raise ArithmeticError('Not a minimum')
                    count['nonempty_restriction']+=1
                    if sum(costs[a]==costs[best] for a in relevant)>1:
                        count['tie_or_duplicate_minimum']+=1
                count['table_cases']+=1
    if count['table_cases']!=1396736:raise ArithmeticError('Coverage changed')

    # Closure cannot be replaced by membership in a list of generators.
    # a=3=b XOR c with b=1,c=2; inside={0,1,2} is not a subspace.
    bad_closure=model((0,1,2),{0:3,1:1,2:2},{0,1,2},
                      {0:2,1:1,2:1},{1,2},{0:(1,2)})
    if bad_closure != {'span_closed':False,'strict_compatibility':True,
                       'split_hypothesis':True,'complete_table':True,
                       'outside_nonempty':True,'conclusion':False}:
        raise ArithmeticError('Closure mutation failed')

    # Weak self-replenishing descent is not strict descent: all costs tie.
    bad_weak=model((0,1,2),{0:1,1:2,2:3},{0},
                   {0:1,1:1,2:1},set(),{0:(1,2),1:(0,2),2:(0,1)},weak=True)
    if bad_weak != {'span_closed':True,'strict_compatibility':False,
                    'split_hypothesis':True,'complete_table':True,
                    'outside_nonempty':True,'conclusion':False}:
        raise ArithmeticError('Weak descent mutation failed')

    # A missing eligible object invalidates GLOBAL minimality of the selected row.
    costs=(2,1);eligible=(True,True);table=(0,)
    selected=choose(table,costs,eligible)
    if selected!=0 or not costs[1]<costs[selected]:raise ArithmeticError('Omission fixture')
    omission={'table':[0],'universe':[0,1],'costs':[2,1],
              'selected':0,'complete':False,'global_minimum':False}

    # Nonempty object table does not imply a nonempty outside-span restriction.
    no_outside=model((0,),{0:0},{0},{0:1},{0},{})
    if no_outside['outside_nonempty'] or no_outside['conclusion']:
        raise ArithmeticError('Empty outside fixture')
    text=(out/'FiniteDescent.lean').read_text()
    if 'hminimum' in text.split('theorem finiteGoodOutside',1)[1].split(':=',1)[0]:
        raise ArithmeticError('Old minimum premise retained')
    report={'verdict':'candidate_only','execution_role':'candidate_generation_sandbox',
      'python_version':sys.version.split()[0],
      'input_scope':{'objects':4,'cost_values':[0,1,2,3],
                    'all_lists_max_length':4,'all_predicates':True},
      'counts':dict(count),'mutations':{'missing_closure':bad_closure,
      'weak_descent':bad_weak,'incomplete_table':omission,
      'empty_outside':no_outside},
      'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
      'lean_source_sha256':hashlib.sha256(text.encode()).hexdigest(),
      'lean_execution':'not_run','trusted_verifier_receipt':None,
      'limits':'Exact finite semantic tests only, not Lean type checking or graph-metric verification.'}
    (out/'minimum-audit.json').write_text(json.dumps(report,sort_keys=True,separators=(',',':'))+'\n')
    print(json.dumps(report,sort_keys=True))
if __name__=='__main__':main()
