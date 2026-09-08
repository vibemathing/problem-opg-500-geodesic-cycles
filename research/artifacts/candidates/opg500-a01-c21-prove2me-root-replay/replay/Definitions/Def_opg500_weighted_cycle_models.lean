import Mathlib.Combinatorics.SimpleGraph.Connectivity.Finite
import Mathlib.Combinatorics.SimpleGraph.Walk.Chord
import Mathlib.Data.Real.Basic

open Set
open scoped Sym2

namespace OPG500Counterexample

universe u

abbrev Edge {V : Type u} (G : SimpleGraph V) := G.edgeSet

abbrev EdgeWeight {V : Type u} (G : SimpleGraph V) := Edge G → ℝ

def IsPositive {V : Type u} {G : SimpleGraph V} (ℓ : EdgeWeight G) : Prop :=
  ∀ e, 0 < ℓ e

structure Cycle {V : Type u} (G : SimpleGraph V) where
  base : V
  walk : G.Walk base base
  isCycle : walk.IsCycle

def Walk.edgeList {V : Type u} {G : SimpleGraph V} {u v : V}
    (p : G.Walk u v) : List (Edge G) :=
  p.edges.attach.map fun e => ⟨e.1, p.edges_subset_edgeSet e.2⟩

def Walk.weightedLength {V : Type u} {G : SimpleGraph V} {u v : V}
    (ℓ : EdgeWeight G) (p : G.Walk u v) : ℝ :=
  ((Walk.edgeList p).map ℓ).sum

def Walk.IsShortest {V : Type u} {G : SimpleGraph V} {u v : V}
    (ℓ : EdgeWeight G) (p : G.Walk u v) : Prop :=
  p.IsPath ∧ ∀ q : G.Walk u v, q.IsPath →
    Walk.weightedLength ℓ p ≤ Walk.weightedLength ℓ q

def Cycle.vertexSet {V : Type u} {G : SimpleGraph V} (C : Cycle G) : Set V :=
  {v | v ∈ C.walk.support}

def Cycle.edgeSet {V : Type u} {G : SimpleGraph V} (C : Cycle G) : Set (Sym2 V) :=
  C.walk.edgeSet

def Cycle.edgeVector {V : Type u} [DecidableEq V] {G : SimpleGraph V}
    (C : Cycle G) (e : Sym2 V) : ZMod 2 :=
  if e ∈ C.walk.edges then 1 else 0

def CycleList.edgeVectorSum {V : Type u} [DecidableEq V] {G : SimpleGraph V}
    (cycles : List (Cycle G)) (e : Sym2 V) : ZMod 2 :=
  (cycles.map fun C => C.edgeVector e).sum

/-- A graph edge is tight when its one-edge walk is a globally shortest path
between its endpoints. The existential endpoints make this definition independent
of an orientation chosen for the unordered edge. -/
def Edge.IsTight {V : Type u} {G : SimpleGraph V}
    (ℓ : EdgeWeight G) (e : Edge G) : Prop :=
  ∃ x y : V, ∃ h : G.Adj x y,
    e.1 = s(x, y) ∧ Walk.IsShortest ℓ h.toWalk

/-- A vertex-based weighted geodesic cycle: between any two of its vertices,
there is a globally shortest simple path using only edges of the cycle. -/
def Cycle.IsGeodesic {V : Type u} {G : SimpleGraph V}
    (ℓ : EdgeWeight G) (C : Cycle G) : Prop :=
  ∀ ⦃x y : V⦄, x ∈ C.vertexSet → y ∈ C.vertexSet →
    ∃ p : G.Walk x y, Walk.IsShortest ℓ p ∧ p.edgeSet ⊆ C.edgeSet

/-- An induced cycle whose vertex deletion leaves a connected graph or no vertices. -/
def Cycle.IsPeripheral {V : Type u} {G : SimpleGraph V} (C : Cycle G) : Prop :=
  C.walk.IsChordless ∧
    (IsEmpty {v : V // v ∉ C.vertexSet} ∨
      (G.induce {v | v ∉ C.vertexSet}).Connected)

/-- Vertex 3-connectivity for a finite simple graph: at least four vertices,
and deletion of any set of fewer than three vertices leaves a connected graph. -/
def IsThreeConnected {V : Type u} [Fintype V] (G : SimpleGraph V) : Prop :=
  4 ≤ Fintype.card V ∧
    ∀ s : Finset V, s.card < 3 → (G.induce {v | v ∉ s}).Connected

end OPG500Counterexample
