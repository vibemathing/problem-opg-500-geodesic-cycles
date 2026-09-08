import Definitions.Def_opg500_weighted_cycle_models

open Set
open scoped Sym2

namespace OPG500Counterexample

abbrev Vertex := Fin 8

def coreVertices : Finset Vertex := {0, 1, 2, 3}

def apexVertices : Finset Vertex := {4, 5, 6, 7}

/-- The frozen list of the eighteen undirected edges of the candidate graph. -/
def eightVertexEdges : Finset (Sym2 Vertex) :=
  {s(0, 1), s(0, 2), s(0, 3), s(0, 4), s(0, 5), s(0, 6),
   s(1, 2), s(1, 3), s(1, 4), s(1, 5), s(1, 7),
   s(2, 3), s(2, 4), s(2, 6), s(2, 7),
   s(3, 5), s(3, 6), s(3, 7)}

/-- The fixed eight-vertex graph proposed as a universal obstruction. -/
def H : SimpleGraph Vertex :=
  SimpleGraph.fromEdgeSet (eightVertexEdges : Set (Sym2 Vertex))

/-- The twelve vertex triples proposed to be exactly the peripheral cycles of `H`. -/
def peripheralTriples : Finset (Finset Vertex) :=
  [[0, 1, 4], [0, 1, 5], [0, 2, 4], [0, 2, 6],
   [0, 3, 5], [0, 3, 6], [1, 2, 4], [1, 2, 7],
   [1, 3, 5], [1, 3, 7], [2, 3, 6], [2, 3, 7]].map List.toFinset |>.toFinset

end OPG500Counterexample
