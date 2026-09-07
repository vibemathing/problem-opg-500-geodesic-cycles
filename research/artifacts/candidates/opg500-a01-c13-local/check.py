"""C13 exact finite-path characterization tests; candidate generation only.
Run: python -I -S check.py
No network, floats, solver, proof assistant or third-party dependencies.
"""
from __future__ import annotations
from fractions import Fraction as Q
from itertools import combinations, permutations
from pathlib import Path
import hashlib
import json
import sys
import time

START = time.monotonic()
MAX_N, MAX_PATHS, MAX_ATOMS = 6, 50000, 100000

def require(ok, message):
    if not ok:
        raise ValueError(message)

def guard():
    require(time.monotonic() - START < 25, 'bounded checker timeout')

def edge(u, v):
    return min(u, v), max(u, v)

def edges_of(path):
    return [edge(u, v) for u, v in zip(path, path[1:])]

def graph(n, rows):
    require(type(n) is int and 3 <= n <= MAX_N, 'vertex cap/domain')
    weights = {}
    for u, v, value in rows:
        require(type(u) is int and type(v) is int and 0 <= u < v < n, 'simple edge')
        require((u, v) not in weights, 'duplicate edge')
        require(type(value) in (str, int), 'exact input required; floats rejected')
        q = Q(value)
        require(q > 0, 'strictly positive lengths required')
        weights[u, v] = q
    es = tuple(sorted(weights))
    adj = tuple(tuple(v for v in range(n) if edge(u, v) in weights) for u in range(n))
    return es, adj, weights

def paths_dfs(adj, x, y):
    if x == y:
        return [(x,)]
    out = []
    def visit(p):
        guard()
        if p[-1] == y:
            out.append(p)
            require(len(out) <= MAX_PATHS, 'path cap; never truncate silently')
            return
        for v in adj[p[-1]]:
            if v not in p:
                visit(p + (v,))
    visit((x,))
    return sorted(out)

def paths_permutations(es, n, x, y):
    if x == y:
        return [(x,)]
    inside = tuple(v for v in range(n) if v not in (x, y))
    return sorted((x,) + p + (y,) for r in range(len(inside)+1)
                  for p in permutations(inside, r)
                  if set(edges_of((x,) + p + (y,))) <= set(es))

def cycles(es, n):
    # Canonical minimum vertex and reversal only; never increasing-label paths.
    out = []
    for k in range(3, n+1):
        for vs in combinations(range(n), k):
            for tail in permutations(vs[1:]):
                c = (vs[0],) + tail
                if tail[0] < tail[-1] and set(edges_of(c + (c[0],))) <= set(es):
                    out.append(c)
    return out

def arcs(c, x, y):
    require(x != y and x in c and y in c, 'arcs require distinct cycle vertices')
    out = []
    for step in (1, -1):
        j, p = c.index(x), [x]
        while p[-1] != y:
            j = (j + step) % len(c)
            p.append(c[j])
        out.append(tuple(p))
    return out

def cost(p, w):
    return sum((w[e] for e in edges_of(p)), Q(0))

def floyd(n, es, w):
    d = [[Q(0) if i == j else None for j in range(n)] for i in range(n)]
    for u, v in es:
        d[u][v] = d[v][u] = w[u, v]
    for k in range(n):
        for i in range(n):
            for j in range(n):
                if d[i][k] is not None and d[k][j] is not None:
                    via = d[i][k] + d[k][j]
                    if d[i][j] is None or via < d[i][j]:
                        d[i][j] = via
    return d

def row(a, p, es):
    aa, pp = set(edges_of(a)), set(edges_of(p))
    return [int(e in aa) - int(e in pp) for e in es]

def compile_cycle(c, es, table, mutation=None):
    require(len(c) >= 3 and len(set(c)) == len(c), 'simple cycle required')
    require(set(edges_of(c + (c[0],))) <= set(es), 'cycle closing edge missing')
    pairs, atoms = [], 0
    for x, y in combinations(sorted(c), 2):
        choices = []
        for a in arcs(c, x, y):
            terms = []
            for p in table[x, y]:
                if mutation == 'omit_02' and (x, y, p) == (0, 2, (0, 2)):
                    continue
                if mutation == 'strict_without_self' and set(edges_of(a)) == set(edges_of(p)):
                    continue
                r = row(a, p, es)
                if mutation == 'sign_flip':
                    r = [-z for z in r]
                relation = '<' if mutation in ('strict', 'strict_without_self') else '<='
                terms.append({'row': r, 'relation': relation, 'rhs': 0})
                atoms += 1
            choices.append({'and': terms})
        pairs.append({('and' if mutation == 'both_arcs' else 'or'): choices})
    require(atoms <= MAX_ATOMS, 'atom cap; never truncate silently')
    return {'and': pairs}, atoms

def evaluate(ast, vector):
    if 'and' in ast:
        return all(evaluate(v, vector) for v in ast['and'])
    if 'or' in ast:
        return any(evaluate(v, vector) for v in ast['or'])
    require(len(ast['row']) == len(vector), 'shared edge vector dimension')
    val = sum((Q(a)*b for a, b in zip(ast['row'], vector)), Q(0))
    if ast['relation'] == '<=':
        return val <= ast['rhs']
    if ast['relation'] == '<':
        return val < ast['rhs']
    raise ValueError('unknown relation')

def validate_graph(n, rows):
    es, adj, w = graph(n, rows)
    d, table = floyd(n, es, w), {}
    for x in range(n):
        require(d[x][x] == 0 and paths_dfs(adj, x, x) == [(x,)], 'diagonal convention')
    for x, y in combinations(range(n), 2):
        table[x, y] = paths_dfs(adj, x, y)
        require(table[x, y] == paths_permutations(es, n, x, y), 'path coverage mismatch')
        direct = min((cost(p, w) for p in table[x, y]), default=None)
        require(direct == d[x][y], 'simple paths / Floyd mismatch')
    checked = []
    for c in cycles(es, n):
        ast, atoms = compile_cycle(c, es, table)
        got = evaluate(ast, [w[e] for e in es])
        exact = all(min(cost(a, w) for a in arcs(c, x, y)) == d[x][y]
                    for x, y in combinations(sorted(c), 2))
        require(got == exact, 'AST / graph-distance mismatch')
        checked.append({'cycle': list(c), 'geodesic': got, 'atoms': atoms})
    return es, w, table, d, checked

def main():
    here = Path(__file__).resolve().parent
    fixtures = json.loads((here / 'fixtures.json').read_text())
    reports, mutations = [], []
    all_cycles_checked, pair_tables = 0, 0
    for f in fixtures:
        guard()
        es, w, table, d, audit = validate_graph(f['n'], f['edges'])
        c = tuple(f['cycle'])
        ast, _ = compile_cycle(c, es, table)
        answer = evaluate(ast, [w[e] for e in es])
        require(answer == f['expected_geodesic'], 'fixture expectation mismatch')
        pairs = []
        for x, y in combinations(sorted(c), 2):
            aa = arcs(c, x, y)
            values = [cost(a, w) for a in aa]
            attaining = [i for i, v in enumerate(values) if v == d[x][y]]
            shortest = min(table[x, y], key=lambda p: (cost(p, w), p))
            pairs.append({'pair': [x, y], 'arcs': list(map(list, aa)),
                          'arc_lengths': list(map(str, values)),
                          'distance': str(d[x][y]), 'attaining_arcs': attaining,
                          'shortest_path': list(shortest), 'simple_paths': len(table[x, y])})
        reports.append({'fixture': f['id'], 'selected_cycle_pairs': pairs,
                        'all_cycles': audit})
        pair_tables += len(table)
        all_cycles_checked += len(audit)
        for mut in f.get('mutations', []):
            altered, _ = compile_cycle(c, es, table, mut)
            bad = evaluate(altered, [w[e] for e in es])
            require(answer != bad, 'mutation survived: '+mut)
            mutations.append({'fixture': f['id'], 'mutation': mut,
                              'correct': answer, 'mutated': bad,
                              'omitted_path': [0, 2] if mut == 'omit_02' else None})
    # Exhaust all 64 labelled four-vertex simple graphs, with two exact assignments.
    complete = list(combinations(range(4), 2))
    count4 = 0
    for mask in range(64):
        es = [e for i, e in enumerate(complete) if mask >> i & 1]
        for mode in (0, 1):
            rows = [[u, v, '1' if mode == 0 else str(Q(1+(u+2*v)%5, 1+(2*u+v)%3))]
                    for u, v in es]
            *_, audit = validate_graph(4, rows)
            count4 += len(audit)
    rejected = 0
    for value in ('0', '-1', 0.5):
        try:
            graph(3, [[0, 1, value], [0, 2, '1'], [1, 2, '1']])
        except ValueError:
            rejected += 1
    require(rejected == 3, 'invalid numeric input accepted')
    output = {'verdict': 'candidate_only', 'scope': 'finite implementation tests only',
              'fixtures': reports, 'mutation_witnesses': mutations,
              'summary': {'fixture_count': len(fixtures), 'fixture_cycles_checked': all_cycles_checked,
                          'fixture_pair_tables': pair_tables, 'four_vertex_graphs': 64,
                          'four_vertex_weighted_instances': 128, 'four_vertex_cycle_checks': count4,
                          'mutation_tests_rejected': len(mutations), 'invalid_inputs_rejected': rejected,
                          'all_exact_comparisons_agree': True},
              'source_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
              'fixtures_sha256': hashlib.sha256((here / 'fixtures.json').read_bytes()).hexdigest(),
              'trusted_verifier_receipt': None, 'lean_replay': 'not_performed'}
    raw = (json.dumps(output, sort_keys=True, separators=(',', ':'))+'\n').encode()
    require(len(raw) <= 1048576, 'output cap')
    (here / 'checks.json').write_bytes(raw)
    print(json.dumps({'verdict': 'candidate_only', **output['summary'],
                      'checks_sha256': hashlib.sha256(raw).hexdigest()}, sort_keys=True))

if __name__ == '__main__':
    main()
