/- Standalone proof of the frozen OPG500 eight-vertex counterexample.
   Local assembly and metric helpers are inlined; prior Proved theorem
   imports are retained and attributed in the accompanying explanation. -/

import Definitions.Def_opg500_eight_vertex_graph
import Mathlib.Tactic
import Theorems.Thm_OPG500Counterexample_tight_edge_metric_bridge
import Definitions.Def_opg500_weighted_cycle_models
import Theorems.Thm_OPG500Counterexample_eight_vertex_graph_structure
import Mathlib.Combinatorics.SimpleGraph.Acyclic
import Theorems.Thm_OPG500Counterexample_core_link_rank_gap
import Mathlib.LinearAlgebra.Dimension.Finrank
import Theorems.Thm_OPG500Counterexample_finite_geodesic_cycles_generate
import Mathlib.LinearAlgebra.Dimension.Constructions

set_option autoImplicit false


section Solutions_OPG500MetricTools

-- Inlined from Solutions.OPG500MetricTools.
/- Helper proofs from carlok, accepted submission 023791eb-2d6a-4431-94a5-eb20f83ade53.
   Renamed to preserve provenance while avoiding assumptions about exported helper names. -/
open Set
open scoped Sym2

universe u

namespace OPG500MetricTools
open OPG500Counterexample
open scoped Classical

variable {V : Type u} {G : SimpleGraph V} (ℓ : EdgeWeight G)

/-- The edge weight extended by zero to all of `Sym2 V`. -/
noncomputable def w (e : Sym2 V) : ℝ := if h : e ∈ G.edgeSet then ℓ ⟨e, h⟩ else 0

lemma w_nonneg (hpos : IsPositive ℓ) (e : Sym2 V) : 0 ≤ w ℓ e := by
  unfold w
  split
  · exact (hpos _).le
  · exact le_rfl

lemma w_apply {e : Sym2 V} (he : e ∈ G.edgeSet) : w ℓ e = ℓ ⟨e, he⟩ := by
  simp [w, he]

lemma weightedLength_eq {x y : V} (p : G.Walk x y) :
    Walk.weightedLength ℓ p = (p.edges.map (w ℓ)).sum := by
  unfold Walk.weightedLength Walk.edgeList
  rw [List.map_map]
  rw [List.map_congr_left
    (g := fun e : {e // e ∈ p.edges} => w ℓ e.1)
    (fun e _ => by simp [w, p.edges_subset_edgeSet e.2])]
  exact congrArg List.sum (List.attach_map_val (f := w ℓ))

end OPG500MetricTools

namespace OPG500MetricTools
open OPG500Counterexample
open scoped Classical

variable {V : Type u} {G : SimpleGraph V} (ℓ : EdgeWeight G)

lemma list_sum_le_of_sublist {l₁ l₂ : List ℝ} (h : l₁.Sublist l₂) :
    (∀ a ∈ l₂, 0 ≤ a) → l₁.sum ≤ l₂.sum := by
  induction h with
  | slnil => intro _; simp
  | cons a hh ih =>
      intro hnn
      have h1 := ih (fun b hb => hnn b (List.mem_cons_of_mem _ hb))
      have h2 := hnn a List.mem_cons_self
      simp only [List.sum_cons]
      exact h1.trans (le_add_of_nonneg_left h2)
  | cons_cons a hh ih =>
      intro hnn
      have h1 := ih (fun b hb => hnn b (List.mem_cons_of_mem _ hb))
      simp only [List.sum_cons]
      exact add_le_add le_rfl h1

lemma sum_le_of_nodup_subset (hpos : IsPositive ℓ) {l₁ l₂ : List (Sym2 V)}
    (h1 : l₁.Nodup) (h2 : l₁ ⊆ l₂) :
    (l₁.map (w ℓ)).sum ≤ (l₂.map (w ℓ)).sum := by
  obtain ⟨l, hperm, hsub⟩ := List.subperm_of_subset h1 h2
  have h3 : (l.map (w ℓ)).sum = (l₁.map (w ℓ)).sum := (hperm.map (w ℓ)).sum_eq
  rw [← h3]
  refine list_sum_le_of_sublist (hsub.map (w ℓ)) ?_
  intro a ha
  obtain ⟨b, _, rfl⟩ := List.mem_map.mp ha
  exact w_nonneg ℓ hpos b

lemma wl_append {x y z : V} (p : G.Walk x y) (q : G.Walk y z) :
    Walk.weightedLength ℓ (p.append q)
      = Walk.weightedLength ℓ p + Walk.weightedLength ℓ q := by
  simp [weightedLength_eq, SimpleGraph.Walk.edges_append]

lemma wl_reverse {x y : V} (p : G.Walk x y) :
    Walk.weightedLength ℓ p.reverse = Walk.weightedLength ℓ p := by
  simp [weightedLength_eq, SimpleGraph.Walk.edges_reverse, List.map_reverse]

lemma wl_bypass (hpos : IsPositive ℓ) {x y : V} (p : G.Walk x y) :
    Walk.weightedLength ℓ p.bypass ≤ Walk.weightedLength ℓ p := by
  rw [weightedLength_eq, weightedLength_eq]
  exact sum_le_of_nodup_subset ℓ hpos
    (p.bypass_isPath.isTrail.edges_nodup) (p.edges_bypass_subset_edges)

lemma IsShortest.reverse (hpos : IsPositive ℓ) {x y : V} {p : G.Walk x y}
    (hp : Walk.IsShortest ℓ p) : Walk.IsShortest ℓ p.reverse := by
  refine ⟨hp.1.reverse, ?_⟩
  intro q hq
  rw [wl_reverse]
  have := hp.2 q.reverse hq.reverse
  rwa [wl_reverse] at this

end OPG500MetricTools

namespace OPG500MetricTools
open OPG500Counterexample
open scoped Classical

variable {V : Type u} {G : SimpleGraph V} (ℓ : EdgeWeight G)

/-- A middle segment of a shortest path is itself shortest. -/
lemma splice (hpos : IsPositive ℓ) {x y u v : V} {p : G.Walk x y}
    (hp : Walk.IsShortest ℓ p)
    (A : G.Walk x u) (m : G.Walk u v) (B : G.Walk v y)
    (hdec : p = A.append (m.append B)) (hm : m.IsPath) :
    Walk.IsShortest ℓ m := by
  refine ⟨hm, ?_⟩
  intro q hq
  by_contra hlt
  rw [not_le] at hlt
  have h1 : Walk.weightedLength ℓ p
      ≤ Walk.weightedLength ℓ (A.append (q.append B)).bypass :=
    hp.2 _ (SimpleGraph.Walk.bypass_isPath _)
  have h2 : Walk.weightedLength ℓ (A.append (q.append B)).bypass
      ≤ Walk.weightedLength ℓ (A.append (q.append B)) := wl_bypass ℓ hpos _
  have h3 : Walk.weightedLength ℓ (A.append (q.append B))
      = Walk.weightedLength ℓ A
        + (Walk.weightedLength ℓ q + Walk.weightedLength ℓ B) := by
    rw [wl_append, wl_append]
  have h4 : Walk.weightedLength ℓ p
      = Walk.weightedLength ℓ A
        + (Walk.weightedLength ℓ m + Walk.weightedLength ℓ B) := by
    rw [hdec, wl_append, wl_append]
  have h5 := h4 ▸ (h1.trans (h2.trans_eq h3))
  have h6 := (add_le_add_iff_left (Walk.weightedLength ℓ A)).mp h5
  have h7 := (add_le_add_iff_right (Walk.weightedLength ℓ B)).mp h6
  exact absurd h7 (not_le.mpr hlt)

/-- Every edge of a walk splits it into a prefix, that edge, and a suffix. -/
lemma split_edge {x y : V} (p : G.Walk x y) :
    ∀ {e : Sym2 V}, e ∈ p.edges →
      ∃ (c d : V) (hcd : G.Adj c d) (p1 : G.Walk x c) (p2 : G.Walk d y),
        s(c, d) = e ∧ p = p1.append (SimpleGraph.Walk.cons hcd p2) := by
  induction p with
  | nil => intro e he; simp at he
  | cons h p' ih =>
      intro e he
      rw [SimpleGraph.Walk.edges_cons, List.mem_cons] at he
      rcases he with rfl | he
      · exact ⟨_, _, h, SimpleGraph.Walk.nil, p', rfl, by simp⟩
      · obtain ⟨c, d, hcd, p1, p2, hce, hdec⟩ := ih he
        exact ⟨c, d, hcd, SimpleGraph.Walk.cons h p1, p2, hce, by rw [hdec]; simp⟩

end OPG500MetricTools

namespace OPG500MetricTools
open OPG500Counterexample
open scoped Classical

variable {V : Type u} {G : SimpleGraph V} (ℓ : EdgeWeight G)

/-- Every edge on a shortest path is tight. -/
lemma tight_of_mem_edges (hpos : IsPositive ℓ) {x y : V} {p : G.Walk x y}
    (hp : Walk.IsShortest ℓ p) {e : Sym2 V} (he : e ∈ p.edges) :
    Edge.IsTight ℓ ⟨e, p.edges_subset_edgeSet he⟩ := by
  obtain ⟨c, d, hcd, p1, p2, hce, hdec⟩ := split_edge p he
  have hdec' : p = p1.append (hcd.toWalk.append p2) := by
    rw [hdec]; rfl
  exact ⟨c, d, hcd, hce.symm, splice ℓ hpos hp p1 _ p2 hdec' hcd.isPath_toWalk⟩

/-- In a finite connected graph a shortest path exists between any two vertices. -/
lemma exists_shortest [Fintype V] [DecidableEq V] (hconn : G.Connected) (x y : V) :
    ∃ p : G.Walk x y, Walk.IsShortest ℓ p := by
  classical
  have hne : (Finset.univ : Finset (G.Path x y)).Nonempty := by
    obtain ⟨q⟩ := hconn x y
    exact ⟨⟨q.bypass, q.bypass_isPath⟩, Finset.mem_univ _⟩
  obtain ⟨P, -, hP⟩ :=
    Finset.exists_min_image (Finset.univ : Finset (G.Path x y))
      (fun P => Walk.weightedLength ℓ P.1) hne
  exact ⟨P.1, P.2, fun q hq => hP ⟨q, hq⟩ (Finset.mem_univ _)⟩

end OPG500MetricTools

namespace OPG500MetricTools
open OPG500Counterexample
open scoped Classical

variable {V : Type u} {G : SimpleGraph V} (ℓ : EdgeWeight G)

/-- Between any two vertices of a shortest path there is a shortest path
whose edges all lie on the given one. -/
lemma exists_shortest_sub (hpos : IsPositive ℓ) {x y : V} {p : G.Walk x y}
    (hp : Walk.IsShortest ℓ p) {u v : V} (hu : u ∈ p.support) (hv : v ∈ p.support) :
    ∃ r : G.Walk u v, Walk.IsShortest ℓ r ∧ r.edges ⊆ p.edges := by
  classical
  by_cases hvD : v ∈ (p.dropUntil u hu).support
  · refine ⟨(p.dropUntil u hu).takeUntil v hvD, ?_, ?_⟩
    · refine splice ℓ hpos hp (p.takeUntil u hu) _
        ((p.dropUntil u hu).dropUntil v hvD) ?_ ((hp.1.dropUntil hu).takeUntil hvD)
      rw [(p.dropUntil u hu).take_spec hvD, p.take_spec hu]
    · intro e he
      have h1 := (p.dropUntil u hu).edges_takeUntil_subset_edges hvD he
      have h2 := p.edges_dropUntil_subset_edges hu h1
      exact h2
  · have hvA : v ∈ (p.takeUntil u hu).support := by
      have h := hv
      rw [← p.take_spec hu, SimpleGraph.Walk.support_append, List.mem_append] at h
      rcases h with h | h
      · exact h
      · exact absurd (List.mem_of_mem_tail h) hvD
    have hs : Walk.IsShortest ℓ ((p.takeUntil u hu).dropUntil v hvA) := by
      refine splice ℓ hpos hp ((p.takeUntil u hu).takeUntil v hvA) _
        (p.dropUntil u hu) ?_ ((hp.1.takeUntil hu).dropUntil hvA)
      rw [SimpleGraph.Walk.append_assoc, (p.takeUntil u hu).take_spec hvA, p.take_spec hu]
    refine ⟨((p.takeUntil u hu).dropUntil v hvA).reverse,
      IsShortest.reverse ℓ hpos hs, ?_⟩
    intro e he
    rw [SimpleGraph.Walk.edges_reverse, List.mem_reverse] at he
    exact p.edges_takeUntil_subset_edges hu
      ((p.takeUntil u hu).edges_dropUntil_subset_edges hvA he)

end OPG500MetricTools

end Solutions_OPG500MetricTools


section Solutions_OPG500TightGraph

-- Inlined from Solutions.OPG500TightGraph.
open Set
open scoped Sym2
open OPG500Counterexample

namespace OPG500Assembly

universe u
variable {V : Type u} {G : SimpleGraph V}

theorem shortest_nil (ℓ : EdgeWeight G) (x : V) :
    Walk.IsShortest ℓ (SimpleGraph.Walk.nil : G.Walk x x) := by
  refine ⟨.nil, ?_⟩
  intro p hp
  have hn := SimpleGraph.Walk.isPath_iff_nil.mp hp
  cases hn
  exact le_rfl

theorem tight_iff_shortest_toWalk (ℓ : EdgeWeight G) (hpos : IsPositive ℓ)
    {x y : V} (h : G.Adj x y) :
    Edge.IsTight ℓ ⟨s(x,y), h⟩ ↔ Walk.IsShortest ℓ h.toWalk := by
  constructor
  · rintro ⟨a, b, hab, he, hp⟩
    rcases Sym2.eq_iff.mp he with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    · exact hp
    · exact OPG500MetricTools.IsShortest.reverse ℓ hpos hp
  · exact fun hp => ⟨x, y, h, rfl, hp⟩

/-- The spanning graph retaining precisely the edges that attain the metric. -/
def tightGraph (G : SimpleGraph V) (ℓ : EdgeWeight G) : SimpleGraph V where
  Adj x y := ∃ h : G.Adj x y, Edge.IsTight ℓ ⟨s(x,y), h⟩
  symm.symm x y := by
    rintro ⟨h, ht⟩
    refine ⟨h.symm, ?_⟩
    simpa only [Sym2.eq_swap] using ht
  loopless.irrefl x := fun ⟨h, _⟩ => h.ne rfl

theorem tightGraph_le (G : SimpleGraph V) (ℓ : EdgeWeight G) :
    tightGraph G ℓ ≤ G := fun _ _ h => h.1

@[simp] theorem tightGraph_adj (G : SimpleGraph V) (ℓ : EdgeWeight G) (x y : V) :
    (tightGraph G ℓ).Adj x y ↔ ∃ h : G.Adj x y, Edge.IsTight ℓ ⟨s(x,y), h⟩ := Iff.rfl

def tightWeight (G : SimpleGraph V) (ℓ : EdgeWeight G) : EdgeWeight (tightGraph G ℓ) :=
  fun e => ℓ ⟨e.1, SimpleGraph.edgeSet_mono (tightGraph_le G ℓ) e.2⟩

theorem tightWeight_positive (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) :
    IsPositive (tightWeight G ℓ) := fun _e => hpos _

theorem mem_tightGraph_edgeSet (ℓ : EdgeWeight G) (e : Edge G) :
    e.1 ∈ (tightGraph G ℓ).edgeSet ↔ Edge.IsTight ℓ e := by
  obtain ⟨e, he⟩ := e
  induction e using Sym2.ind with
  | _ x y => exact ⟨fun h => h.2, fun h => ⟨he, h⟩⟩

theorem weightedLength_mapTightWalk (ℓ : EdgeWeight G) {x y : V}
    (p : (tightGraph G ℓ).Walk x y) :
    Walk.weightedLength ℓ (p.mapLe (tightGraph_le G ℓ)) =
      Walk.weightedLength (tightWeight G ℓ) p := by
  classical
  rw [OPG500MetricTools.weightedLength_eq, OPG500MetricTools.weightedLength_eq,
    SimpleGraph.Walk.edges_mapLe_eq_edges]
  apply congrArg List.sum
  apply List.map_congr_left
  intro e he
  rw [OPG500MetricTools.w_apply ℓ
    (SimpleGraph.edgeSet_mono (tightGraph_le G ℓ) (p.edges_subset_edgeSet he)),
    OPG500MetricTools.w_apply (tightWeight G ℓ) (p.edges_subset_edgeSet he)]
  rfl

def liftTightWalk (ℓ : EdgeWeight G) {x y : V} (p : G.Walk x y)
    (hp : ∀ e (he : e ∈ p.edges), Edge.IsTight ℓ ⟨e, p.edges_subset_edgeSet he⟩) :
    (tightGraph G ℓ).Walk x y :=
  p.transfer (tightGraph G ℓ) fun e he =>
    (mem_tightGraph_edgeSet ℓ ⟨e, p.edges_subset_edgeSet he⟩).mpr (hp e he)

@[simp] theorem map_liftTightWalk (ℓ : EdgeWeight G) {x y : V} (p : G.Walk x y)
    (hp : ∀ e (he : e ∈ p.edges), Edge.IsTight ℓ ⟨e, p.edges_subset_edgeSet he⟩) :
    (liftTightWalk ℓ p hp).mapLe (tightGraph_le G ℓ) = p := by
  induction p with
  | nil => rfl
  | cons h p ih =>
    let htail := fun e (he : e ∈ p.edges) => hp e (by simp [he])
    change SimpleGraph.Walk.cons h ((liftTightWalk ℓ p htail).mapLe _) = _
    congr 1
    exact ih _

theorem weightedLength_liftTightWalk (ℓ : EdgeWeight G) {x y : V} (p : G.Walk x y)
    (hp : ∀ e (he : e ∈ p.edges), Edge.IsTight ℓ ⟨e, p.edges_subset_edgeSet he⟩) :
    Walk.weightedLength (tightWeight G ℓ) (liftTightWalk ℓ p hp) =
      Walk.weightedLength ℓ p := by
  rw [← weightedLength_mapTightWalk, map_liftTightWalk]

theorem tightGraph_connected [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) (hconn : G.Connected) (ℓ : EdgeWeight G)
    (hpos : IsPositive ℓ) : (tightGraph G ℓ).Connected where
  preconnected x y := by
    obtain ⟨p, _, hp⟩ := (tight_edge_metric_bridge G hconn ℓ hpos).1 x y
    exact (liftTightWalk ℓ p hp).reachable
  nonempty := hconn.nonempty

theorem shortest_mapTightWalk [Fintype V] [DecidableEq V]
    (hconn : G.Connected) (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) {x y : V}
    (p : (tightGraph G ℓ).Walk x y) (hp : Walk.IsShortest (tightWeight G ℓ) p) :
    Walk.IsShortest ℓ (p.mapLe (tightGraph_le G ℓ)) := by
  refine ⟨hp.1.mapLe _, ?_⟩
  intro q hq
  obtain ⟨r, hr, hrt⟩ := (tight_edge_metric_bridge G hconn ℓ hpos).1 x y
  have hlift : (liftTightWalk ℓ r hrt).IsPath := hr.1.transfer _
  calc
    Walk.weightedLength ℓ (p.mapLe (tightGraph_le G ℓ)) =
        Walk.weightedLength (tightWeight G ℓ) p := weightedLength_mapTightWalk ℓ p
    _ ≤ Walk.weightedLength (tightWeight G ℓ) (liftTightWalk ℓ r hrt) := hp.2 _ hlift
    _ = Walk.weightedLength ℓ r := weightedLength_liftTightWalk ℓ r hrt
    _ ≤ Walk.weightedLength ℓ q := hr.2 q hq

def mapTightCycle (ℓ : EdgeWeight G) (C : Cycle (tightGraph G ℓ)) : Cycle G where
  base := C.base
  walk := C.walk.mapLe (tightGraph_le G ℓ)
  isCycle := C.isCycle.mapLe _

@[simp] theorem mapTightCycle_vertexSet (ℓ : EdgeWeight G) (C : Cycle (tightGraph G ℓ)) :
    (mapTightCycle ℓ C).vertexSet = C.vertexSet := by
  simp [mapTightCycle, Cycle.vertexSet]

@[simp] theorem mapTightCycle_edgeSet (ℓ : EdgeWeight G) (C : Cycle (tightGraph G ℓ)) :
    (mapTightCycle ℓ C).edgeSet = C.edgeSet := by
  simp [mapTightCycle, Cycle.edgeSet]

@[simp] theorem mapTightCycle_edgeVector [DecidableEq V] (ℓ : EdgeWeight G)
    (C : Cycle (tightGraph G ℓ)) : (mapTightCycle ℓ C).edgeVector = C.edgeVector := by
  funext e
  simp [mapTightCycle, Cycle.edgeVector]

theorem mapTightCycle_isGeodesic [Fintype V] [DecidableEq V]
    (hconn : G.Connected) (ℓ : EdgeWeight G) (hpos : IsPositive ℓ)
    (C : Cycle (tightGraph G ℓ)) (hC : C.IsGeodesic (tightWeight G ℓ)) :
    (mapTightCycle ℓ C).IsGeodesic ℓ := by
  intro x y hx hy
  rw [mapTightCycle_vertexSet] at hx hy
  obtain ⟨p, hp, hpC⟩ := hC hx hy
  refine ⟨p.mapLe (tightGraph_le G ℓ), shortest_mapTightWalk hconn ℓ hpos p hp, ?_⟩
  simpa only [SimpleGraph.Walk.edgeSet_mapLe_eq_edgeSet, mapTightCycle_edgeSet] using hpC

end OPG500Assembly

end Solutions_OPG500TightGraph


section Solutions_OPG500CoreModels

-- Inlined from Solutions.OPG500CoreModels.
open OPG500Counterexample SimpleGraph
open scoped Sym2
namespace OPG500Assembly

instance decidableHAdj : DecidableRel H.Adj :=
  inferInstanceAs (DecidableRel (SimpleGraph.fromEdgeSet
    (eightVertexEdges : Set (Sym2 Vertex))).Adj)

def coreVertex (i : Fin 4) : Vertex := ⟨i.val, by omega⟩
def apexVertex (i : Fin 4) : Vertex := ⟨7 - i.val, by omega⟩

def tightCore (ℓ : EdgeWeight H) : SimpleGraph (Fin 4) :=
  (tightGraph H ℓ).comap coreVertex

noncomputable def tightLinks (ℓ : EdgeWeight H) (i : Fin 4) : Finset (Fin 4) := by
  classical
  exact Finset.univ.filter (fun j => (tightGraph H ℓ).Adj (apexVertex i) (coreVertex j))

@[simp] theorem mem_tightLinks (ℓ : EdgeWeight H) (i j : Fin 4) :
    j ∈ tightLinks ℓ i ↔ (tightGraph H ℓ).Adj (apexVertex i) (coreVertex j) := by
  classical
  simp [tightLinks]

lemma coreVertex_injective : Function.Injective coreVertex := by
  intro a b h
  apply Fin.ext
  exact congrArg (fun v : Vertex => v.val) h

lemma apex_core_adj (i j : Fin 4) : H.Adj (apexVertex i) (coreVertex j) ↔ j ≠ i := by
  revert i j
  decide +kernel


lemma apex_neighbor_core (i : Fin 4) (v : Vertex) (h : H.Adj (apexVertex i) v) :
    ∃ j : Fin 4, coreVertex j = v ∧ j ≠ i := by
  revert i v h
  decide +kernel

lemma H_connected : H.Connected := by
  have hhub : ∀ v : Vertex, v = 0 ∨ H.Adj 0 v ∨ ∃ w : Vertex, H.Adj 0 w ∧ H.Adj w v := by
    decide +kernel
  apply (SimpleGraph.connected_iff_exists_forall_reachable H).mpr
  refine ⟨0, ?_⟩
  intro v
  rcases hhub v with rfl | h | ⟨w,hw,hv⟩
  · exact SimpleGraph.Reachable.rfl
  · exact h.reachable
  · exact hw.reachable.trans hv.reachable

end OPG500Assembly

end Solutions_OPG500CoreModels


section Solutions_OPG500TwoStep

-- Inlined from Solutions.OPG500TwoStep.
open OPG500Counterexample SimpleGraph
open scoped Sym2

namespace OPG500Assembly

private theorem peripheralTriple_card (s : Finset Vertex) (hs : s ∈ peripheralTriples) :
    s.card = 3 := by
  revert s hs
  decide +kernel

/-- If all geodesic cycles are peripheral, every nontight edge has a replacement
consisting of exactly two tight edges. This includes tied shortest-path metrics. -/
theorem nontight_twoStep (ℓ : EdgeWeight H) (hpos : IsPositive ℓ)
    (hall : ∀ C : Cycle H, C.IsGeodesic ℓ → C.IsPeripheral)
    {x y : Vertex} (hxy : H.Adj x y)
    (hnt : ¬ Edge.IsTight ℓ ⟨s(x,y), hxy⟩) :
    ∃ z, (tightGraph H ℓ).Adj x z ∧ (tightGraph H ℓ).Adj z y := by
  classical
  obtain ⟨p, hp⟩ := OPG500MetricTools.exists_shortest ℓ H_connected x y
  have hnotmem : s(x,y) ∉ p.edges := by
    intro he
    exact hnt (OPG500MetricTools.tight_of_mem_edges ℓ hpos hp he)
  have hcyc : (SimpleGraph.Walk.cons hxy p.reverse).IsCycle := by
    rw [SimpleGraph.Walk.cons_isCycle_iff]
    refine ⟨hp.1.reverse, ?_⟩
    simpa only [SimpleGraph.Walk.edges_reverse, List.mem_reverse] using hnotmem
  let C : Cycle H := ⟨x, SimpleGraph.Walk.cons hxy p.reverse, hcyc⟩
  have hmem : ∀ c : Vertex, c ∈ C.vertexSet ↔ c ∈ p.support := by
    intro c
    change c ∈ (SimpleGraph.Walk.cons hxy p.reverse).support ↔ c ∈ p.support
    rw [SimpleGraph.Walk.support_cons, List.mem_cons,
      SimpleGraph.Walk.support_reverse, List.mem_reverse]
    exact ⟨fun h => h.elim (fun h => h ▸ p.start_mem_support) id, Or.inr⟩
  have hgeod : C.IsGeodesic ℓ := by
    intro a b ha hb
    obtain ⟨r, hr, hrsub⟩ := OPG500MetricTools.exists_shortest_sub ℓ hpos hp
      ((hmem a).mp ha) ((hmem b).mp hb)
    refine ⟨r, hr, ?_⟩
    intro e he
    have her : e ∈ p.edges := hrsub he
    change e ∈ (SimpleGraph.Walk.cons hxy p.reverse).edgeSet
    simp only [SimpleGraph.Walk.edgeSet, Set.mem_ofPred_eq,
      SimpleGraph.Walk.edges_cons, List.mem_cons, SimpleGraph.Walk.edges_reverse,
      List.mem_reverse]
    exact Or.inr her
  have hcard := peripheralTriple_card C.walk.support.toFinset
    ((eight_vertex_graph_structure.2 C).mp (hall C hgeod))
  have hsupport : C.walk.support.toFinset = p.support.toFinset := by
    ext c
    simpa only [List.mem_toFinset, Cycle.vertexSet, Set.mem_ofPred_eq] using hmem c
  rw [hsupport, List.toFinset_card_of_nodup hp.1.support_nodup, p.length_support] at hcard
  have hlen : p.length = 2 := by omega
  let tp := liftTightWalk ℓ p
    (fun e he => OPG500MetricTools.tight_of_mem_edges ℓ hpos hp he)
  have htlen : tp.length = 2 := by simpa [tp, liftTightWalk] using hlen
  refine ⟨tp.getVert 1, ?_, ?_⟩
  · simpa using tp.adj_getVert_succ (i := 0) (by omega)
  · have hlast : tp.getVert 2 = y := by rw [← htlen, SimpleGraph.Walk.getVert_length]
    simpa only [show 1 + 1 = (2 : ℕ) by rfl, hlast] using
      tp.adj_getVert_succ (i := 1) (by omega)

end OPG500Assembly

end Solutions_OPG500TwoStep


section Solutions_OPG500CoreStructure

-- Inlined from Solutions.OPG500CoreStructure.
open OPG500Counterexample SimpleGraph
open scoped Sym2

namespace OPG500Assembly

universe u

noncomputable def triangleCycle {V : Type u} {G : SimpleGraph V}
    {a b c : V} (hab : G.Adj a b) (hbc : G.Adj b c) (hca : G.Adj c a) : Cycle G where
  base := a
  walk := .cons hab (.cons hbc (.cons hca .nil))
  isCycle := by
    apply SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length.mpr
    constructor
    · simp [SimpleGraph.Walk.isPath_def, hab.ne, hbc.ne, hca.ne, Ne.symm hab.ne,
        Ne.symm hbc.ne, Ne.symm hca.ne]
    · simp

lemma triangleCycle_support {V : Type u} [DecidableEq V] {G : SimpleGraph V}
    {a b c : V} (hab : G.Adj a b) (hbc : G.Adj b c) (hca : G.Adj c a) :
    (triangleCycle hab hbc hca).walk.support.toFinset = {a, b, c} := by
  ext x
  simp [triangleCycle]
  tauto

lemma triangleCycle_edges {V : Type u} {G : SimpleGraph V}
    {a b c : V} (hab : G.Adj a b) (hbc : G.Adj b c) (hca : G.Adj c a) :
    (triangleCycle hab hbc hca).edgeSet = {s(a,b),s(b,c),s(c,a)} := by
  simp [Cycle.edgeSet, triangleCycle, SimpleGraph.Walk.edgeSet_cons]

lemma triangleCycle_isGeodesic {V : Type u} {G : SimpleGraph V}
    (ℓ : EdgeWeight G) (hpos : IsPositive ℓ)
    {a b c : V} (hab : G.Adj a b) (hbc : G.Adj b c) (hca : G.Adj c a)
    (habT : Edge.IsTight ℓ ⟨s(a,b),hab⟩)
    (hbcT : Edge.IsTight ℓ ⟨s(b,c),hbc⟩)
    (hcaT : Edge.IsTight ℓ ⟨s(c,a),hca⟩) :
    (triangleCycle hab hbc hca).IsGeodesic ℓ := by
  have habS := (tight_iff_shortest_toWalk ℓ hpos hab).mp habT
  have hbcS := (tight_iff_shortest_toWalk ℓ hpos hbc).mp hbcT
  have hcaS := (tight_iff_shortest_toWalk ℓ hpos hca).mp hcaT
  have hbaS := OPG500MetricTools.IsShortest.reverse ℓ hpos habS
  have hcbS := OPG500MetricTools.IsShortest.reverse ℓ hpos hbcS
  have hacS := OPG500MetricTools.IsShortest.reverse ℓ hpos hcaS
  intro x y hx hy
  by_cases hxy : x = y
  · subst y
    exact ⟨.nil, shortest_nil ℓ x, by simp⟩
  have hx' : x = a ∨ x = b ∨ x = c := by
    simpa [Cycle.vertexSet, triangleCycle, or_assoc, or_left_comm, or_comm] using hx
  have hy' : y = a ∨ y = b ∨ y = c := by
    simpa [Cycle.vertexSet, triangleCycle, or_assoc, or_left_comm, or_comm] using hy
  rcases hx' with rfl | rfl | rfl <;> rcases hy' with rfl | rfl | rfl
  all_goals first
    | exact (hxy rfl).elim
    | exact ⟨hab.toWalk, habS, by simp [triangleCycle_edges, SimpleGraph.Adj.toWalk]⟩
    | exact ⟨hbc.toWalk, hbcS, by simp [triangleCycle_edges, SimpleGraph.Adj.toWalk]⟩
    | exact ⟨hca.toWalk, hcaS, by simp [triangleCycle_edges, SimpleGraph.Adj.toWalk]⟩
    | exact ⟨hab.symm.toWalk, hbaS, by simp [triangleCycle_edges, SimpleGraph.Adj.toWalk, Sym2.eq_swap]⟩
    | exact ⟨hbc.symm.toWalk, hcbS, by simp [triangleCycle_edges, SimpleGraph.Adj.toWalk, Sym2.eq_swap]⟩
    | exact ⟨hca.symm.toWalk, hacS, by simp [triangleCycle_edges, SimpleGraph.Adj.toWalk, Sym2.eq_swap]⟩

lemma core_triple_not_peripheral (a b c : Fin 4) :
    ({coreVertex a, coreVertex b, coreVertex c} : Finset Vertex) ∉ peripheralTriples := by
  revert a b c
  decide +kernel

lemma tightLinks_avoids (ℓ : EdgeWeight H) (i j : Fin 4)
    (hj : j ∈ tightLinks ℓ i) : j ≠ i :=
  (apex_core_adj i j).mp ((mem_tightLinks ℓ i j).mp hj).1

lemma tightCore_triangleFree (ℓ : EdgeWeight H) (hpos : IsPositive ℓ)
    (hall : ∀ C : Cycle H, C.IsGeodesic ℓ → C.IsPeripheral)
    {a b c : Fin 4} (_hab : a ≠ b) (_hbc : b ≠ c) (_hac : a ≠ c) :
    ¬ ((tightCore ℓ).Adj a b ∧ (tightCore ℓ).Adj b c ∧ (tightCore ℓ).Adj c a) := by
  rintro ⟨⟨hab, habT⟩, ⟨hbc,hbcT⟩, ⟨hca,hcaT⟩⟩
  have hgeo := triangleCycle_isGeodesic ℓ hpos hab hbc hca habT hbcT hcaT
  have hper := (eight_vertex_graph_structure.2 _).mp (hall _ hgeo)
  rw [triangleCycle_support] at hper
  exact core_triple_not_peripheral a b c hper

lemma tightLinks_dominates (ℓ : EdgeWeight H) (hpos : IsPositive ℓ)
    (hall : ∀ C : Cycle H, C.IsGeodesic ℓ → C.IsPeripheral)
    (i j : Fin 4) (hji : j ≠ i) (hj : j ∉ tightLinks ℓ i) :
    ∃ k, k ∈ tightLinks ℓ i ∧ (tightCore ℓ).Adj j k := by
  have hadj := (apex_core_adj i j).mpr hji
  have hnt : ¬ Edge.IsTight ℓ ⟨s(apexVertex i, coreVertex j), hadj⟩ := by
    intro ht
    exact hj ((mem_tightLinks ℓ i j).mpr ⟨hadj, ht⟩)
  obtain ⟨z,haz,hzj⟩ := nontight_twoStep ℓ hpos hall hadj hnt
  obtain ⟨k,hk,_⟩ := apex_neighbor_core i z haz.1
  rw [← hk] at haz hzj
  exact ⟨k, (mem_tightLinks ℓ i k).mpr haz, hzj.symm⟩

end OPG500Assembly

end Solutions_OPG500CoreStructure


section Solutions_OPG500Counting

-- Inlined from Solutions.OPG500Counting.
open SimpleGraph Set Classical
open scoped Sym2 BigOperators

namespace OPG500Assembly

def fourPair : Fin 6 → Sym2 (Fin 4) :=
  ![s(0,1), s(0,2), s(0,3), s(1,2), s(1,3), s(2,3)]

def fourGraph (b : Fin 6 → Bool) : SimpleGraph (Fin 4) :=
  SimpleGraph.fromEdgeSet {e | ∃ i, b i = true ∧ fourPair i = e}

instance fourGraph_decidable (b : Fin 6 → Bool) : DecidableRel (fourGraph b).Adj := by
  unfold fourGraph
  infer_instance

def fourTriangleFree (F : SimpleGraph (Fin 4)) : Prop :=
  ∀ a b c, ¬(F.Adj a b ∧ F.Adj b c ∧ F.Adj c a)

instance fourTriangleFree_decidable (b : Fin 6 → Bool) :
    Decidable (fourTriangleFree (fourGraph b)) := by
  unfold fourTriangleFree
  infer_instance

set_option maxRecDepth 100000 in
set_option maxHeartbeats 10000000 in
theorem fourGraph_small_forest_count :
    ∀ (b : Fin 6 → Bool) (S : Finset (Fin 4)),
      S.card ≤ 3 → fourTriangleFree (fourGraph b) →
      ((fourGraph b).induce {v | v ∈ S}).edgeFinset.card +
        Fintype.card ((fourGraph b).induce {v | v ∈ S}).ConnectedComponent = S.card := by
  decide +kernel

theorem fourGraph_encode (F : SimpleGraph (Fin 4)) [DecidableRel F.Adj] :
    fourGraph (fun i => decide (fourPair i ∈ F.edgeSet)) = F := by
  ext x y
  fin_cases x <;> fin_cases y <;>
    simp [fourGraph, fourPair, Fin.exists_fin_succ, F.adj_comm] <;>
    exact ⟨fun h => h.symm, fun h => h.symm⟩

/-- A triangle-free induced link on at most three core vertices is a forest;
its edge count plus component count equals its vertex count. -/
theorem four_link_forest_count (F : SimpleGraph (Fin 4)) [DecidableRel F.Adj]
    (S : Finset (Fin 4)) (hS : S.card ≤ 3)
    (htri : ∀ ⦃a b c : Fin 4⦄, a ≠ b → b ≠ c → a ≠ c →
      ¬ (F.Adj a b ∧ F.Adj b c ∧ F.Adj c a)) :
    (F.induce {v | v ∈ S}).edgeFinset.card +
      Nat.card (F.induce {v | v ∈ S}).ConnectedComponent = S.card := by
  have ht : fourTriangleFree F := by
    intro a b c h
    exact htri h.1.ne h.2.1.ne h.2.2.ne.symm h
  have hx := fourGraph_small_forest_count
    (fun i => decide (fourPair i ∈ F.edgeSet)) S hS
  have hm : fourTriangleFree (fourGraph (fun i => decide (fourPair i ∈ F.edgeSet))) := by
    simpa only [fourGraph_encode] using ht
  have hx' : Nat.card ((fourGraph (fun i => decide (fourPair i ∈ F.edgeSet))).induce {v | v ∈ S}).edgeSet +
      Nat.card ((fourGraph (fun i => decide (fourPair i ∈ F.edgeSet))).induce {v | v ∈ S}).ConnectedComponent = S.card := by
    simpa only [Nat.card_eq_fintype_card, SimpleGraph.edgeFinset_card] using hx hm
  rw [fourGraph_encode] at hx'
  simpa only [Nat.card_eq_fintype_card, SimpleGraph.edgeFinset_card] using hx'

theorem edgeFinset_eq_filter_of_le {V : Type*} [Fintype V] [DecidableEq V]
    (G K : SimpleGraph V) [DecidableRel G.Adj] [DecidableRel K.Adj] (h : G ≤ K) :
    G.edgeFinset = K.edgeFinset.filter (fun e => e ∈ G.edgeSet) := by
  ext e
  simp only [Finset.mem_filter, SimpleGraph.mem_edgeFinset]
  exact ⟨fun he => ⟨SimpleGraph.edgeSet_mono h he, he⟩, fun he => he.2⟩

theorem H_edgeFinset : OPG500Counterexample.H.edgeFinset = OPG500Counterexample.eightVertexEdges := by
  decide +kernel

theorem four_top_edgeFinset : (⊤ : SimpleGraph (Fin 4)).edgeFinset =
    {s(0,1), s(0,2), s(0,3), s(1,2), s(1,3), s(2,3)} := by
  decide +kernel

theorem nat_card_filter_eq_sum {α : Type*} (s : Finset α) (p : α → Prop) [DecidablePred p] :
    (s.filter p).card = ∑ x ∈ s, if p x then (1 : ℕ) else 0 := by
  simpa using (Finset.sum_boole (R := ℕ) p s).symm

set_option maxRecDepth 10000 in
theorem card_edgeFinset_four (F : SimpleGraph (Fin 4)) [DecidableRel F.Adj] :
    F.edgeFinset.card = ∑ i : Fin 6, if fourPair i ∈ F.edgeSet then 1 else 0 := by
  rw [edgeFinset_eq_filter_of_le F ⊤ le_top, four_top_edgeFinset, nat_card_filter_eq_sum]
  simp [-Finset.sum_boole, fourPair, Fin.sum_univ_succ]

open OPG500Counterexample

set_option maxRecDepth 10000 in
set_option maxHeartbeats 4000000 in
theorem tight_graph_edge_count (ℓ : EdgeWeight H) :
    (tightGraph H ℓ).edgeFinset.card = (tightCore ℓ).edgeFinset.card +
      ∑ i, (tightLinks ℓ i).card := by
  classical
  have hlink (i : Fin 4) : (tightLinks ℓ i).card =
      ∑ j : Fin 4, if (tightGraph H ℓ).Adj (apexVertex i) (coreVertex j) then 1 else 0 := by
    simp [tightLinks]
  have hm (i : Fin 4) : ¬(tightGraph H ℓ).Adj (apexVertex i) (coreVertex i) := by
    intro h
    exact (apex_core_adj i i).mp ((tightGraph_le H ℓ) h) rfl
  have hm0 := hm 0
  have hm1 := hm 1
  have hm2 := hm 2
  have hm3 := hm 3
  simp only [apexVertex, coreVertex] at hm0 hm1 hm2 hm3
  have hn0 : ¬(tightGraph H ℓ).Adj 0 7 := fun h => hm0 h.symm
  have hn1 : ¬(tightGraph H ℓ).Adj 1 6 := fun h => hm1 h.symm
  have hn2 : ¬(tightGraph H ℓ).Adj 2 5 := fun h => hm2 h.symm
  have hn3 : ¬(tightGraph H ℓ).Adj 3 4 := fun h => hm3 h.symm
  have h10 : (tightGraph H ℓ).Adj 1 0 ↔ (tightGraph H ℓ).Adj 0 1 := (tightGraph H ℓ).adj_comm 1 0
  rw [edgeFinset_eq_filter_of_le _ H (tightGraph_le H ℓ), H_edgeFinset,
    nat_card_filter_eq_sum, card_edgeFinset_four]
  simp_rw [hlink]
  simp [-Finset.sum_boole, -tightGraph_adj, eightVertexEdges, fourPair, Fin.sum_univ_succ, tightCore,
    coreVertex, apexVertex, SimpleGraph.adj_comm]
  simp only [hn0, hn1, hn2, hn3, h10, if_false]
  <;> omega


end OPG500Assembly

end Solutions_OPG500Counting


section Solutions_OPG500RankGap

-- Inlined from Solutions.OPG500RankGap.
open OPG500Counterexample SimpleGraph
open scoped BigOperators
open Classical
namespace OPG500Assembly

lemma tightLinks_card_le_three (ℓ : EdgeWeight H) (i : Fin 4) :
    (tightLinks ℓ i).card ≤ 3 := by
  calc
    _ ≤ (Finset.univ.erase i).card := Finset.card_le_card (by
      intro j hj
      exact Finset.mem_erase.mpr ⟨tightLinks_avoids ℓ i j hj, Finset.mem_univ _⟩)
    _ = 3 := by simp

lemma tight_link_triangle_count_lt_cycle_rank (ℓ : EdgeWeight H) (hpos : IsPositive ℓ)
    (hall : ∀ C : Cycle H, C.IsGeodesic ℓ → C.IsPeripheral) :
    (∑ i : Fin 4, ((tightCore ℓ).induce {v | v ∈ tightLinks ℓ i}).edgeFinset.card) <
      (tightGraph H ℓ).edgeFinset.card + 1 - 8 := by
  have hgap := core_link_rank_gap (tightCore ℓ) (tightLinks ℓ)
    (fun {_ _ _} hab hbc hac => tightCore_triangleFree ℓ hpos hall hab hbc hac) (tightLinks_avoids ℓ)
    (tightLinks_dominates ℓ hpos hall)
  have hsum :
      (∑ i : Fin 4, ((tightCore ℓ).induce {v | v ∈ tightLinks ℓ i}).edgeFinset.card) +
      (∑ i : Fin 4, Nat.card ((tightCore ℓ).induce {v | v ∈ tightLinks ℓ i}).ConnectedComponent) =
      ∑ i : Fin 4, (tightLinks ℓ i).card := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun i _ => four_link_forest_count (tightCore ℓ)
      (tightLinks ℓ i) (tightLinks_card_le_three ℓ i) (fun {_ _ _} hab hbc hac => tightCore_triangleFree ℓ hpos hall hab hbc hac))
  have hcount := tight_graph_edge_count ℓ
  omega

end OPG500Assembly

end Solutions_OPG500RankGap


section Solutions_OPG500TriangleSpan

-- Inlined from Solutions.OPG500TriangleSpan.
open OPG500Counterexample SimpleGraph
open scoped Sym2

namespace OPG500Assembly

/-- One potential peripheral triangle for every edge inside an apex link. -/
abbrev triangleGeneratorIndex (ℓ : EdgeWeight H) :=
  Σ i : Fin 4, Edge ((tightCore ℓ).induce {v | v ∈ tightLinks ℓ i})

noncomputable instance triangleGeneratorIndexFintype (ℓ : EdgeWeight H) :
    Fintype (triangleGeneratorIndex ℓ) := Fintype.ofFinite _

noncomputable def inducedEdgeVector (s : Finset Vertex) (e : Sym2 Vertex) : ZMod 2 := by
  classical
  exact if e ∈ H.edgeSet ∧ ∀ v ∈ e, v ∈ s then 1 else 0

noncomputable def triangleGeneratorVertices (ℓ : EdgeWeight H)
    (t : triangleGeneratorIndex ℓ) : Finset Vertex :=
  insert (apexVertex t.1) ((t.2.1.map (fun v => coreVertex v.1)).toFinset)

noncomputable def triangleGeneratorVector (ℓ : EdgeWeight H)
    (t : triangleGeneratorIndex ℓ) : Sym2 Vertex → ZMod 2 :=
  inducedEdgeVector (triangleGeneratorVertices ℓ t)

noncomputable def triangleGenerators (ℓ : EdgeWeight H) : Finset (Sym2 Vertex → ZMod 2) := by
  classical
  exact Finset.univ.image (triangleGeneratorVector ℓ)

theorem triangleGenerators_card_le (ℓ : EdgeWeight H) :
    (triangleGenerators ℓ).card ≤
      ∑ i : Fin 4, Nat.card (Edge ((tightCore ℓ).induce {v | v ∈ tightLinks ℓ i})) := by
  classical
  calc
    _ ≤ Fintype.card (triangleGeneratorIndex ℓ) := Finset.card_image_le
    _ = _ := by rw [← Nat.card_eq_fintype_card]; exact Nat.card_sigma

open Classical in
theorem triangleGenerators_card_le_link_edges (ℓ : EdgeWeight H) :
    (triangleGenerators ℓ).card ≤
      ∑ i : Fin 4, ((tightCore ℓ).induce {v | v ∈ tightLinks ℓ i}).edgeFinset.card := by
  simpa only [SimpleGraph.edgeFinset_card, Nat.card_eq_fintype_card] using
    triangleGenerators_card_le ℓ

theorem chordless_edgeVector (C : Cycle H) (hC : C.walk.IsChordless) :
    C.edgeVector = inducedEdgeVector C.walk.support.toFinset := by
  classical
  funext e
  have hequiv : e ∈ C.walk.edges ↔
      e ∈ H.edgeSet ∧ ∀ v ∈ e, v ∈ C.walk.support.toFinset := by
    constructor
    · intro he
      exact ⟨C.walk.edges_subset_edgeSet he,
        fun v hv => List.mem_toFinset.mpr (SimpleGraph.Walk.mem_support_of_mem_edges he hv)⟩
    · induction e using Sym2.ind with
      | _ a b =>
        intro he
        exact hC.mem_edges
          (List.mem_toFinset.mp (he.2 a (Sym2.mem_mk_left a b)))
          (List.mem_toFinset.mp (he.2 b (Sym2.mem_mk_right a b))) he.1
  simp only [Cycle.edgeVector, inducedEdgeVector, hequiv]

private theorem peripheralTriple_representation (s : Finset Vertex)
    (hs : s ∈ peripheralTriples) :
    ∃ i a b : Fin 4,
      H.Adj (apexVertex i) (coreVertex a) ∧
      H.Adj (apexVertex i) (coreVertex b) ∧
      H.Adj (coreVertex a) (coreVertex b) ∧
      s = {apexVertex i, coreVertex a, coreVertex b} := by
  revert s hs
  decide +kernel

/-- A peripheral ambient image is one of the finite link-edge generators. -/
theorem peripheral_mapTightCycle_mem_generators (ℓ : EdgeWeight H)
    (C : Cycle (tightGraph H ℓ)) (hper : (mapTightCycle ℓ C).IsPeripheral) :
    C.edgeVector ∈ triangleGenerators ℓ := by
  classical
  let M := mapTightCycle ℓ C
  have hm : M.walk.support.toFinset ∈ peripheralTriples :=
    (eight_vertex_graph_structure.2 M).mp hper
  obtain ⟨i,a,b,hia,hib,hab,hs⟩ := peripheralTriple_representation _ hm
  have edge_in_tight {u v : Vertex} (hu : u ∈ M.walk.support.toFinset)
      (hv : v ∈ M.walk.support.toFinset) (huv : H.Adj u v) :
      (tightGraph H ℓ).Adj u v := by
    have he := hper.1.mem_edges (List.mem_toFinset.mp hu) (List.mem_toFinset.mp hv) huv
    have he' : s(u,v) ∈ C.walk.edges := by simpa [M, mapTightCycle] using he
    exact C.walk.edges_subset_edgeSet he'
  have hiaT : (tightGraph H ℓ).Adj (apexVertex i) (coreVertex a) :=
    edge_in_tight (by rw [hs]; simp) (by rw [hs]; simp) hia
  have hibT : (tightGraph H ℓ).Adj (apexVertex i) (coreVertex b) :=
    edge_in_tight (by rw [hs]; simp) (by rw [hs]; simp) hib
  have habT : (tightCore ℓ).Adj a b :=
    edge_in_tight (by rw [hs]; simp) (by rw [hs]; simp) hab
  have ha : a ∈ tightLinks ℓ i := (mem_tightLinks ℓ i a).mpr hiaT
  have hb : b ∈ tightLinks ℓ i := (mem_tightLinks ℓ i b).mpr hibT
  let t : triangleGeneratorIndex ℓ :=
    ⟨i, ⟨s((⟨a, ha⟩ : {v // v ∈ tightLinks ℓ i}), ⟨b, hb⟩), habT⟩⟩
  have hverts : triangleGeneratorVertices ℓ t = M.walk.support.toFinset := by
    rw [hs]
    simp [triangleGeneratorVertices, t, Sym2.toFinset_mk_eq]
  have hvec : C.edgeVector = triangleGeneratorVector ℓ t := by
    rw [← mapTightCycle_edgeVector ℓ C]
    change M.edgeVector = inducedEdgeVector (triangleGeneratorVertices ℓ t)
    rw [hverts]
    exact chordless_edgeVector M hper.1
  rw [hvec]
  exact Finset.mem_image.mpr ⟨t, Finset.mem_univ _, rfl⟩

theorem peripheral_mapTightCycle_mem_span (ℓ : EdgeWeight H)
    (C : Cycle (tightGraph H ℓ)) (hper : (mapTightCycle ℓ C).IsPeripheral) :
    C.edgeVector ∈ Submodule.span (ZMod 2)
      (triangleGenerators ℓ : Set (Sym2 Vertex → ZMod 2)) :=
  Submodule.subset_span (peripheral_mapTightCycle_mem_generators ℓ C hper)

end OPG500Assembly

end Solutions_OPG500TriangleSpan


section Solutions_OPG500CycleRank

-- Inlined from Solutions.OPG500CycleRank.
open SimpleGraph Set
open scoped Sym2 BigOperators
open OPG500Counterexample

namespace OPG500Assembly

universe u
variable {V : Type u} [DecidableEq V] {G T : SimpleGraph V}

/-- Every edge outside a connected spanning subgraph has a cycle whose only
edge outside that subgraph is the chosen edge. -/
theorem exists_pivot_cycle (hTG : T ≤ G) (hT : T.Connected)
    (e : Sym2 V) (heG : e ∈ G.edgeSet) (heT : e ∉ T.edgeSet) :
    ∃ C : Cycle G, e ∈ C.walk.edges ∧
      ∀ d ∈ C.walk.edges, d = e ∨ d ∈ T.edgeSet := by
  classical
  obtain ⟨x,y⟩ := e
  let J : SimpleGraph V := T ⊔ SimpleGraph.fromEdgeSet {s(x,y)}
  have hJG : J ≤ G := sup_le hTG (G.fromEdgeSet_le.mpr (by simpa using Or.inr (show G.Adj x y from heG)))
  have hTJ : T ≤ J := le_sup_left
  have heJ : J.Adj x y := Or.inr (by simp [SimpleGraph.fromEdgeSet_adj, (show G.Adj x y from heG).ne])
  have hdel : T ≤ J.deleteEdges {s(x,y)} := by
    intro a b hab
    exact ⟨hTJ hab, by
      intro h
      have habT : s(a,b) ∈ T.edgeSet := hab
      have heq : s(a,b) = s(x,y) := h.1
      apply heT
      change s(x,y) ∈ T.edgeSet
      rw [← heq]
      exact habT⟩
  obtain ⟨v,p,hp,hep⟩ :=
    (SimpleGraph.adj_and_reachable_delete_edges_iff_exists_cycle (G := J)).mp
      ⟨heJ, SimpleGraph.Reachable.mono hdel (hT.preconnected x y)⟩
  refine ⟨⟨v,p.mapLe hJG,hp.mapLe hJG⟩, ?_, ?_⟩
  · simpa using hep
  · intro d hd
    have hdJ : d ∈ J.edgeSet := p.edges_subset_edgeSet (by simpa using hd)
    have : d ∈ T.edgeSet ∨ d ∈ (SimpleGraph.fromEdgeSet {s(x,y)} : SimpleGraph V).edgeSet := by simpa only [J, SimpleGraph.edgeSet_sup, Set.mem_union] using hdJ
    rcases this with hdT | hdE
    · exact Or.inr hdT
    · have hdE' : d = s(x,y) ∧ ¬d.IsDiag := by simpa only [SimpleGraph.edgeSet_fromEdgeSet, Set.mem_sdiff, Set.mem_singleton_iff, Sym2.mem_diagSet] using hdE
      exact Or.inl hdE'.1

/-- Point evaluations giving an identity matrix certify linear independence. -/
theorem linearIndependent_of_pivots
    {I E : Type*} [Fintype I] [DecidableEq I]
    (v : I → (E → ZMod 2)) (p : I → E)
    (h : ∀ i j, v i (p j) = if i = j then 1 else 0) :
    LinearIndependent (ZMod 2) v := by
  rw [Fintype.linearIndependent_iff]
  intro a ha j
  have hj := congrFun ha (p j)
  simpa only [Finset.sum_apply, Pi.smul_apply, Pi.zero_apply, h,
    smul_eq_mul, mul_ite, mul_one, mul_zero, Finset.sum_ite_eq',
    Finset.mem_univ, if_true] using hj

noncomputable def cycleVectorSpan (G : SimpleGraph V) :
    Submodule (ZMod 2) (Sym2 V → ZMod 2) :=
  Submodule.span (ZMod 2) (Set.range (Cycle.edgeVector (G := G)))

/-- The fundamental cycles of a connected spanning subgraph have distinct
non-subgraph edges as evaluation pivots. -/
theorem edge_excess_le_cycleVectorSpan_finrank [Fintype V]
    [DecidableRel G.Adj] [DecidableRel T.Adj]
    (hTG : T ≤ G) (hT : T.Connected) :
    G.edgeFinset.card - T.edgeFinset.card ≤
      Module.finrank (ZMod 2) (cycleVectorSpan G) := by
  classical
  let S := G.edgeFinset \ T.edgeFinset
  have hC (e : S) : ∃ C : Cycle G, e.1 ∈ C.walk.edges ∧
      ∀ d ∈ C.walk.edges, d = e.1 ∨ d ∈ T.edgeSet := by
    apply exists_pivot_cycle hTG hT e.1
    · simpa using (Finset.mem_sdiff.mp e.2).1
    · simpa using (Finset.mem_sdiff.mp e.2).2
  choose C hC using hC
  have hpivot (e f : S) : (C e).edgeVector f.1 = if e = f then 1 else 0 := by
    by_cases hef : e = f
    · subst f
      simp [Cycle.edgeVector, (hC e).1]
    · have hnot : f.1 ∉ (C e).walk.edges := by
        intro hf
        rcases (hC e).2 f.1 hf with hfe | hfT
        · exact hef (Subtype.ext hfe.symm)
        · exact (Finset.mem_sdiff.mp f.2).2 (by simpa using hfT)
      simp [Cycle.edgeVector, hnot, hef]
  let c : S → cycleVectorSpan G := fun e =>
    ⟨(C e).edgeVector, Submodule.subset_span ⟨C e, rfl⟩⟩
  have hli : LinearIndependent (ZMod 2) c := by
    apply LinearIndependent.of_comp (cycleVectorSpan G).subtype
    exact linearIndependent_of_pivots (fun e => (C e).edgeVector) (fun e => e.1) hpivot
  have hcard := hli.fintype_card_le_finrank
  have hsub : T.edgeFinset ⊆ G.edgeFinset := SimpleGraph.edgeFinset_mono hTG
  have hcard' : S.card ≤ Module.finrank (ZMod 2) (cycleVectorSpan G) := by
    simpa only [Fintype.card_coe] using hcard
  change (G.edgeFinset \ T.edgeFinset).card ≤ _ at hcard'
  rwa [Finset.card_sdiff_of_subset hsub] at hcard'

/-- Only the lower bound is needed: a spanning tree provides the required
number of independent cycle vectors. -/
theorem connected_edge_excess_le_cycleVectorSpan_finrank [Fintype V]
    [DecidableRel G.Adj] (hG : G.Connected) :
    G.edgeFinset.card + 1 - Fintype.card V ≤
      Module.finrank (ZMod 2) (cycleVectorSpan G) := by
  classical
  obtain ⟨T, hTG, hT⟩ := hG.exists_isTree_le
  have hbound := edge_excess_le_cycleVectorSpan_finrank hTG hT.connected
  have hcard := hT.card_edgeFinset
  omega

/-- A subspace of insufficient dimension misses an actual graph cycle. -/
theorem exists_cycle_outside_subspace [Fintype V] [DecidableRel G.Adj]
    (hG : G.Connected) (W : Submodule (ZMod 2) (Sym2 V → ZMod 2))
    (hsmall : Module.finrank (ZMod 2) W <
      G.edgeFinset.card + 1 - Fintype.card V) :
    ∃ C : Cycle G, C.edgeVector ∉ W := by
  classical
  by_contra! h
  have hle : cycleVectorSpan G ≤ W :=
    Submodule.span_le.mpr (by rintro v ⟨C,rfl⟩; exact h C)
  have hrank := Submodule.finrank_mono hle
  have hbound := connected_edge_excess_le_cycleVectorSpan_finrank hG
  omega

/-- More independent cycles than a proposed finite family of generators force
an actual cycle outside their span. The generators need not be independent. -/
theorem exists_cycle_outside_finite_span [Fintype V] [DecidableRel G.Adj]
    (hG : G.Connected) (s : Finset (Sym2 V → ZMod 2))
    (hsmall : s.card < G.edgeFinset.card + 1 - Fintype.card V) :
    ∃ C : Cycle G, C.edgeVector ∉ Submodule.span (ZMod 2) (s : Set (Sym2 V → ZMod 2)) := by
  apply exists_cycle_outside_subspace hG
  exact lt_of_le_of_lt (finrank_span_finset_le_card (R := ZMod 2) s) hsmall


end OPG500Assembly

end Solutions_OPG500CycleRank


section Solutions_OPG500GeodesicOutside

-- Inlined from Solutions.OPG500GeodesicOutside.
open OPG500Counterexample
namespace OPG500Assembly
universe u
variable {V : Type u} [Fintype V] [DecidableEq V] {G : SimpleGraph V}

lemma cycleList_mem_submodule (W : Submodule (ZMod 2) (Sym2 V → ZMod 2))
    (cycles : List (Cycle G)) (h : ∀ C ∈ cycles, C.edgeVector ∈ W) :
    CycleList.edgeVectorSum cycles ∈ W := by
  induction cycles with
  | nil =>
    change (0 : Sym2 V → ZMod 2) ∈ W
    exact W.zero_mem
  | cons C cs ih =>
    change C.edgeVector + CycleList.edgeVectorSum cs ∈ W
    exact W.add_mem (h C (by simp)) (ih (fun D hD => h D (by simp [hD])))

/-- Geodesic generation carries any cycle-space obstruction to a geodesic cycle. -/
theorem exists_geodesic_outside_submodule (ℓ : EdgeWeight G) (hpos : IsPositive ℓ)
    (W : Submodule (ZMod 2) (Sym2 V → ZMod 2))
    (outside : ∃ C : Cycle G, C.edgeVector ∉ W) :
    ∃ C : Cycle G, C.IsGeodesic ℓ ∧ C.edgeVector ∉ W := by
  obtain ⟨C, hC⟩ := outside
  obtain ⟨cycles, hcycles, hsum⟩ := finite_geodesic_cycles_generate G ℓ hpos C
  by_contra! hall
  have hmem := cycleList_mem_submodule W cycles
    (fun D hD => hall D (hcycles D hD).1)
  rw [hsum] at hmem
  exact hC hmem

end OPG500Assembly

end Solutions_OPG500GeodesicOutside


section Solutions_OPG500Root

-- Inlined from Solutions.OPG500Root.
open OPG500Counterexample OPG500Assembly
open scoped BigOperators

theorem OPG500Counterexample.eight_vertex_counterexample :
    IsThreeConnected H ∧
      ∀ ℓ : EdgeWeight H, IsPositive ℓ →
        ∃ C : Cycle H, C.IsGeodesic ℓ ∧ ¬ C.IsPeripheral := by
  classical
  refine ⟨eight_vertex_graph_structure.1, ?_⟩
  intro ℓ hpos
  by_contra! hall
  have hcard : (triangleGenerators ℓ).card ≤
      ∑ i : Fin 4, ((tightCore ℓ).induce {v | v ∈ tightLinks ℓ i}).edgeFinset.card := by
    simpa only [Nat.card_eq_fintype_card, SimpleGraph.edgeFinset_card] using
      triangleGenerators_card_le ℓ
  have hsmall : (triangleGenerators ℓ).card <
      (tightGraph H ℓ).edgeFinset.card + 1 - Fintype.card Vertex := by
    simpa [Vertex] using lt_of_le_of_lt hcard
      (tight_link_triangle_count_lt_cycle_rank ℓ hpos hall)
  let W := Submodule.span (ZMod 2) (triangleGenerators ℓ : Set (Sym2 Vertex → ZMod 2))
  have houtside : ∃ C : Cycle (tightGraph H ℓ), C.edgeVector ∉ W :=
    exists_cycle_outside_finite_span (tightGraph_connected H H_connected ℓ hpos)
      (triangleGenerators ℓ) hsmall
  obtain ⟨C, hC, hout⟩ := exists_geodesic_outside_submodule
    (tightWeight H ℓ) (tightWeight_positive ℓ hpos) W houtside
  have hper := hall (mapTightCycle ℓ C) (mapTightCycle_isGeodesic H_connected ℓ hpos C hC)
  exact hout (peripheral_mapTightCycle_mem_span ℓ C hper)

end Solutions_OPG500Root

#print axioms OPG500Counterexample.eight_vertex_counterexample
