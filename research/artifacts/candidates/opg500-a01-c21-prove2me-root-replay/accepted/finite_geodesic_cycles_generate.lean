import Mathlib
import Definitions.Def_opg500_weighted_cycle_models

/-!
# Geodesic cycles generate the cycle space (Georgakopoulos–Sprüssel, Theorem 3.1)

Every cycle of a finite graph with positive edge weights is an `𝔽₂`-sum of vertex-geodesic
cycles, each no longer than the original cycle.

The proof is a well-founded induction on the weighted length of the cycle. If `C` is not
geodesic, choose a *bad* pair `(u, v)` of vertices of `C` (no shortest `u`–`v` path lies on `C`)
together with a shortest `u`–`v` path `P`, the whole triple minimising the length of `P`.
Minimality forces the interior of `P` to avoid `C`, and `P` is strictly shorter than both arcs
of `C` between `u` and `v`.  Gluing `P` to either arc gives two strictly shorter cycles whose
edge vectors add up (mod 2) to the edge vector of `C`, and the induction hypothesis applies.
-/

open SimpleGraph
open scoped Sym2

namespace OPG500Counterexample

universe u

variable {V : Type u} [Fintype V] [DecidableEq V] {G : SimpleGraph V}

/-! ### Weighted length as a sum over the edge list -/

open Classical in
/-- The weight extended to all of `Sym2 V` (zero off the edge set). -/
noncomputable def wt (ℓ : EdgeWeight G) (e : Sym2 V) : ℝ :=
  if h : e ∈ G.edgeSet then ℓ ⟨e, h⟩ else 0

lemma wt_of_mem (ℓ : EdgeWeight G) {e : Sym2 V} (h : e ∈ G.edgeSet) :
    wt ℓ e = ℓ ⟨e, h⟩ := by
  unfold wt
  exact dif_pos h

lemma wt_nonneg (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) (e : Sym2 V) : 0 ≤ wt ℓ e := by
  unfold wt
  split_ifs with h
  · exact (hpos ⟨e, h⟩).le
  · exact le_rfl

lemma wt_pos (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) {e : Sym2 V} (h : e ∈ G.edgeSet) :
    0 < wt ℓ e := by
  rw [wt_of_mem ℓ h]
  exact hpos _

lemma weightedLength_eq {u v : V} (ℓ : EdgeWeight G) (p : G.Walk u v) :
    Walk.weightedLength ℓ p = (p.edges.map (wt ℓ)).sum := by
  unfold Walk.weightedLength Walk.edgeList
  rw [List.map_map]
  congr 1
  conv_rhs => rw [← List.attach_map_subtype_val p.edges, List.map_map]
  apply List.map_congr_left
  intro e _
  simp [Function.comp, wt_of_mem ℓ (p.edges_subset_edgeSet e.2)]

lemma wl_append {u v w : V} (ℓ : EdgeWeight G) (p : G.Walk u v) (q : G.Walk v w) :
    Walk.weightedLength ℓ (p.append q) =
      Walk.weightedLength ℓ p + Walk.weightedLength ℓ q := by
  simp [weightedLength_eq, SimpleGraph.Walk.edges_append]

lemma wl_reverse {u v : V} (ℓ : EdgeWeight G) (p : G.Walk u v) :
    Walk.weightedLength ℓ p.reverse = Walk.weightedLength ℓ p := by
  simp [weightedLength_eq, SimpleGraph.Walk.edges_reverse]

lemma wl_nil {u : V} (ℓ : EdgeWeight G) :
    Walk.weightedLength ℓ (SimpleGraph.Walk.nil : G.Walk u u) = 0 := by
  simp [weightedLength_eq]

lemma wl_cons {u v w : V} (ℓ : EdgeWeight G) (h : G.Adj u v) (p : G.Walk v w) :
    Walk.weightedLength ℓ (SimpleGraph.Walk.cons h p) =
      wt ℓ s(u, v) + Walk.weightedLength ℓ p := by
  simp [weightedLength_eq, SimpleGraph.Walk.edges_cons]

lemma wl_nonneg {u v : V} (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) (p : G.Walk u v) :
    0 ≤ Walk.weightedLength ℓ p := by
  rw [weightedLength_eq]
  apply List.sum_nonneg
  intro x hx
  obtain ⟨e, -, rfl⟩ := List.mem_map.mp hx
  exact wt_nonneg ℓ hpos e

lemma wl_pos {u v : V} (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) (p : G.Walk u v)
    (hp : 0 < p.length) : 0 < Walk.weightedLength ℓ p := by
  cases p with
  | nil => simp at hp
  | cons h q =>
    rw [wl_cons]
    have := wt_pos ℓ hpos (G.mem_edgeSet.mpr h)
    linarith [wl_nonneg ℓ hpos q]

lemma wl_rotate {u w : V} (ℓ : EdgeWeight G) (c : G.Walk u u) (h : w ∈ c.support) :
    Walk.weightedLength ℓ (c.rotate w h) = Walk.weightedLength ℓ c := by
  rw [weightedLength_eq, weightedLength_eq]
  exact ((c.rotate_edges w h).perm.map (wt ℓ)).sum_eq

lemma wl_bypass_le {u v : V} (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) (p : G.Walk u v) :
    Walk.weightedLength ℓ p.bypass ≤ Walk.weightedLength ℓ p := by
  rw [weightedLength_eq, weightedLength_eq]
  apply List.Sublist.sum_le_sum ((p.edges_bypass_sublist_edges).map (wt ℓ))
  intro x hx
  obtain ⟨e, -, rfl⟩ := List.mem_map.mp hx
  exact wt_nonneg ℓ hpos e

/-- A single edge of a walk contributes at most the weighted length. -/
lemma wt_le_wl {u v : V} (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) (p : G.Walk u v)
    {e : Sym2 V} (he : e ∈ p.edges) : wt ℓ e ≤ Walk.weightedLength ℓ p := by
  rw [weightedLength_eq]
  apply List.single_le_sum
  · intro x hx
    obtain ⟨e', -, rfl⟩ := List.mem_map.mp hx
    exact wt_nonneg ℓ hpos e'
  · exact List.mem_map.mpr ⟨e, he, rfl⟩

/-! ### Shortest paths -/

lemma exists_shortest (ℓ : EdgeWeight G) {u v : V} (h : G.Reachable u v) :
    ∃ p : G.Walk u v, Walk.IsShortest ℓ p := by
  classical
  obtain ⟨w⟩ := h
  haveI : Nonempty (G.Path u v) := ⟨w.toPath⟩
  obtain ⟨P, -, hP⟩ := Finset.exists_min_image (Finset.univ : Finset (G.Path u v))
    (fun P => Walk.weightedLength ℓ (P : G.Walk u v)) Finset.univ_nonempty
  refine ⟨P, P.2, ?_⟩
  intro q hq
  exact hP ⟨q, hq⟩ (Finset.mem_univ _)

lemma isShortest_takeUntil (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) {u v w : V}
    {P : G.Walk u v} (hP : Walk.IsShortest ℓ P) (hw : w ∈ P.support) :
    Walk.IsShortest ℓ (P.takeUntil w hw) := by
  refine ⟨hP.1.takeUntil hw, ?_⟩
  intro q hq
  have h1 := hP.2 ((q.append (P.dropUntil w hw)).bypass) (SimpleGraph.Walk.bypass_isPath _)
  have h2 := wl_bypass_le ℓ hpos (q.append (P.dropUntil w hw))
  rw [wl_append] at h2
  have h3 : Walk.weightedLength ℓ P =
      Walk.weightedLength ℓ (P.takeUntil w hw) + Walk.weightedLength ℓ (P.dropUntil w hw) := by
    rw [← wl_append, SimpleGraph.Walk.take_spec]
  linarith

lemma isShortest_dropUntil (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) {u v w : V}
    {P : G.Walk u v} (hP : Walk.IsShortest ℓ P) (hw : w ∈ P.support) :
    Walk.IsShortest ℓ (P.dropUntil w hw) := by
  refine ⟨hP.1.dropUntil hw, ?_⟩
  intro q hq
  have h1 := hP.2 (((P.takeUntil w hw).append q).bypass) (SimpleGraph.Walk.bypass_isPath _)
  have h2 := wl_bypass_le ℓ hpos ((P.takeUntil w hw).append q)
  rw [wl_append] at h2
  have h3 : Walk.weightedLength ℓ P =
      Walk.weightedLength ℓ (P.takeUntil w hw) + Walk.weightedLength ℓ (P.dropUntil w hw) := by
    rw [← wl_append, SimpleGraph.Walk.take_spec]
  linarith

/-! ### Basic facts about cycles -/

lemma mem_vertexSet_iff {C : Cycle G} {x : V} : x ∈ C.vertexSet ↔ x ∈ C.walk.support :=
  Iff.rfl

lemma edgeSet_subset_iff {u v : V} {p : G.Walk u v} {C : Cycle G} :
    p.edgeSet ⊆ C.edgeSet ↔ ∀ e ∈ p.edges, e ∈ C.walk.edges :=
  Iff.rfl

lemma Cycle.reachable {C : Cycle G} {x y : V} (hx : x ∈ C.walk.support)
    (hy : y ∈ C.walk.support) : G.Reachable x y :=
  ⟨(C.walk.dropUntil x hx).append (C.walk.takeUntil y hy)⟩

/-- Vertices in the tail of the support of a path are in the support and differ from the
start vertex. -/
lemma mem_tail_support {u v : V} {p : G.Walk u v} (hp : p.IsPath) {x : V}
    (hx : x ∈ p.support.tail) : x ∈ p.support ∧ x ≠ u := by
  refine ⟨List.mem_of_mem_tail hx, ?_⟩
  rintro rfl
  have h := hp.support_nodup
  rw [← SimpleGraph.Walk.cons_tail_support] at h
  exact (List.nodup_cons.mp h).1 hx

lemma edges_of_length_one {u v : V} (p : G.Walk u v) (h : p.length = 1) :
    p.edges = [s(u, v)] := by
  cases p with
  | nil => simp at h
  | cons h' q =>
    cases q with
    | nil => simp
    | cons h'' r => simp at h

/-- `Cycle G` is finite: a cycle is determined by its base point and its walk, and cycle walks
have length at most `Fintype.card V`. -/
instance : Finite (Cycle G) := by
  classical
  let f : Cycle G → Σ u : V, {p : G.Walk u u // p.length < Fintype.card V + 1} :=
    fun C => ⟨C.base, ⟨C.walk, by
      have h1 := C.isCycle.support_nodup.length_le_card
      have h2 := C.walk.length_support
      have h3 : C.walk.support.tail.length = C.walk.support.length - 1 := List.length_tail
      omega⟩⟩
  refine Finite.of_injective f ?_
  rintro ⟨b, w, hw⟩ ⟨b', w', hw'⟩ h
  simp only [f, Sigma.mk.inj_iff] at h
  obtain ⟨rfl, h⟩ := h
  simp only [heq_eq_eq, Subtype.mk.injEq] at h
  subst h
  rfl

/-! ### Bad pairs -/

/-- A pair of vertices of `C` is *bad* when no shortest path between them lies on `C`. -/
def Bad (ℓ : EdgeWeight G) (C : Cycle G) (x y : V) : Prop :=
  x ∈ C.walk.support ∧ y ∈ C.walk.support ∧
    ∀ p : G.Walk x y, Walk.IsShortest ℓ p → ¬ (p.edgeSet ⊆ C.edgeSet)

lemma exists_bad_of_not_geodesic {ℓ : EdgeWeight G} {C : Cycle G}
    (h : ¬ C.IsGeodesic ℓ) : ∃ x y, Bad ℓ C x y := by
  unfold Cycle.IsGeodesic at h
  push Not at h
  obtain ⟨x, y, hx, hy, h⟩ := h
  exact ⟨x, y, hx, hy, h⟩

lemma not_bad_iff {ℓ : EdgeWeight G} {C : Cycle G} {x y : V} (hx : x ∈ C.walk.support)
    (hy : y ∈ C.walk.support) :
    ¬ Bad ℓ C x y ↔ ∃ p : G.Walk x y, Walk.IsShortest ℓ p ∧ p.edgeSet ⊆ C.edgeSet := by
  unfold Bad
  push Not
  constructor
  · intro h
    exact h hx hy
  · intro h _ _
    exact h

lemma Bad.ne {ℓ : EdgeWeight G} (hpos : IsPositive ℓ) {C : Cycle G} {x y : V}
    (h : Bad ℓ C x y) : x ≠ y := by
  rintro rfl
  apply h.2.2 SimpleGraph.Walk.nil
    ⟨SimpleGraph.Walk.IsPath.nil, fun q _ => by rw [wl_nil]; exact wl_nonneg ℓ hpos q⟩
  intro e he
  simp [SimpleGraph.Walk.edgeSet] at he

/-- For a bad pair `(u, v)` and a shortest `u`–`v` path whose interior avoids `C`, no edge of
the path lies on `C`. -/
lemma edges_not_mem {ℓ : EdgeWeight G} (hpos : IsPositive ℓ) {C : Cycle G} {u v : V}
    (hbad : Bad ℓ C u v) {P : G.Walk u v} (hP : Walk.IsShortest ℓ P)
    (hint : ∀ w ∈ P.support, w ≠ u → w ≠ v → w ∉ C.walk.support) :
    ∀ e ∈ P.edges, e ∉ C.walk.edges := by
  intro e
  revert e
  refine Sym2.ind ?_
  intro a b he heC
  have hadj : G.Adj a b := P.adj_of_mem_edges he
  have haP : a ∈ P.support := P.fst_mem_support_of_mem_edges he
  have hbP : b ∈ P.support := P.snd_mem_support_of_mem_edges he
  have haC : a ∈ C.walk.support := C.walk.fst_mem_support_of_mem_edges heC
  have hbC : b ∈ C.walk.support := C.walk.snd_mem_support_of_mem_edges heC
  by_cases ha : a ≠ u ∧ a ≠ v
  · exact hint a haP ha.1 ha.2 haC
  by_cases hb : b ≠ u ∧ b ≠ v
  · exact hint b hbP hb.1 hb.2 hbC
  push Not at ha hb
  have huv : u ≠ v := hbad.ne hpos
  -- the edge is `s(u, v)`
  have hab : s(a, b) = s(u, v) := by
    have hne : a ≠ b := hadj.ne
    by_cases hau : a = u
    · have hbv : b = v := hb (fun hbu => hne (hau.trans hbu.symm))
      rw [hau, hbv]
    · have hav : a = v := ha hau
      have hbu : b = u := by
        by_contra hbu
        have hbv : b = v := hb hbu
        exact hne (hav.trans hbv.symm)
      rw [hav, hbu, Sym2.eq_swap]
  rw [hab] at he heC
  have hadj' : G.Adj u v := C.walk.adj_of_mem_edges heC
  -- the single edge `u v` is a shortest path lying on `C`
  let q : G.Walk u v := SimpleGraph.Walk.cons hadj' SimpleGraph.Walk.nil
  have hqpath : q.IsPath := by
    rw [SimpleGraph.Walk.cons_isPath_iff]
    exact ⟨SimpleGraph.Walk.IsPath.nil, by simpa using huv⟩
  have hqshort : Walk.IsShortest ℓ q := by
    refine ⟨hqpath, ?_⟩
    intro r hr
    have h1 : Walk.weightedLength ℓ q = wt ℓ s(u, v) := by
      simp [q, wl_cons, wl_nil]
    have h2 := wt_le_wl ℓ hpos P he
    have h3 := hP.2 r hr
    linarith
  apply hbad.2.2 q hqshort
  intro e' he'
  have : e' ∈ q.edges := he'
  simp [q] at this
  subst this
  exact heC

/-! ### Splitting a cycle along a short path -/

/-- The two shorter cycles obtained by gluing a chord-like path `P` to the two arcs of `C`. -/
lemma exists_two_cycles (ℓ : EdgeWeight G) (hpos : IsPositive ℓ) (C : Cycle G) {u v : V}
    (hu : u ∈ C.walk.support) (hv : v ∈ C.walk.support) (huv : u ≠ v)
    (P : G.Walk u v) (hP : P.IsPath)
    (hshort : ∀ q : G.Walk u v, q.IsPath →
      Walk.weightedLength ℓ P ≤ Walk.weightedLength ℓ q)
    (hnotin : ∀ q : G.Walk u v, Walk.IsShortest ℓ q → ¬ (q.edgeSet ⊆ C.edgeSet))
    (hint : ∀ w ∈ P.support, w ≠ u → w ≠ v → w ∉ C.walk.support)
    (hedge : ∀ e ∈ P.edges, e ∉ C.walk.edges) :
    ∃ C1 C2 : Cycle G,
      Walk.weightedLength ℓ C1.walk < Walk.weightedLength ℓ C.walk ∧
      Walk.weightedLength ℓ C2.walk < Walk.weightedLength ℓ C.walk ∧
      ∀ e, C1.edgeVector e + C2.edgeVector e = C.edgeVector e := by
  -- rotate `C` to start at `u`, and split it at `v`
  set c' := C.walk.rotate u hu with hc'def
  have hc' : c'.IsCycle := C.isCycle.rotate hu
  have hv' : v ∈ c'.support := (SimpleGraph.Walk.mem_support_rotate_iff _ _ _).mpr hv
  set A := c'.takeUntil v hv' with hAdef
  set B := c'.dropUntil v hv' with hBdef
  have hAB : A.append B = c' := SimpleGraph.Walk.take_spec c' hv'
  have hA : A.IsPath := hc'.isPath_takeUntil hv'
  have hB : B.IsPath := by
    apply SimpleGraph.Walk.IsCycle.isPath_of_append_right (p := A)
      (SimpleGraph.Walk.not_nil_of_ne huv)
    rw [hAB]
    exact hc'
  -- edges of `C` are the edges of the two arcs
  have hedgesC : ∀ e, e ∈ C.walk.edges ↔ e ∈ A.edges ∨ e ∈ B.edges := by
    intro e
    have h1 : e ∈ C.walk.edges ↔ e ∈ c'.edges := (C.walk.rotate_edges u hu).perm.mem_iff.symm
    have h2 : c'.edges = A.edges ++ B.edges := by
      have := SimpleGraph.Walk.edges_append A B
      rw [hAB] at this
      exact this
    rw [h1, h2, List.mem_append]
  have hdisj : A.edges.Disjoint B.edges :=
    hc'.isCircuit.isTrail.disjoint_edges_takeUntil_dropUntil hv'
  -- supports of the arcs lie on `C`
  have hAsupp : ∀ x ∈ A.support, x ∈ C.walk.support := fun x hx =>
    (SimpleGraph.Walk.mem_support_rotate_iff _ _ _).mp
      (SimpleGraph.Walk.support_takeUntil_subset_support _ _ hx)
  have hBsupp : ∀ x ∈ B.support, x ∈ C.walk.support := fun x hx =>
    (SimpleGraph.Walk.mem_support_rotate_iff _ _ _).mp
      (SimpleGraph.Walk.support_dropUntil_subset_support _ _ hx)
  -- lengths
  have hlenC : Walk.weightedLength ℓ C.walk =
      Walk.weightedLength ℓ A + Walk.weightedLength ℓ B := by
    rw [← wl_append, hAB, hc'def, wl_rotate]
  have hPA : Walk.weightedLength ℓ P < Walk.weightedLength ℓ A := by
    refine lt_of_le_of_ne (hshort A hA) ?_
    intro heq
    apply hnotin A ⟨hA, fun q hq => heq ▸ hshort q hq⟩
    intro e (he : e ∈ A.edges)
    exact (hedgesC e).mpr (Or.inl he)
  have hPB : Walk.weightedLength ℓ P < Walk.weightedLength ℓ B := by
    have hBr : B.reverse.IsPath := hB.reverse
    have hle : Walk.weightedLength ℓ P ≤ Walk.weightedLength ℓ B := by
      have := hshort B.reverse hBr
      rwa [wl_reverse] at this
    refine lt_of_le_of_ne hle ?_
    intro heq
    apply hnotin B.reverse ⟨hBr, fun q hq => by rw [wl_reverse, ← heq]; exact hshort q hq⟩
    intro e (he : e ∈ B.reverse.edges)
    rw [SimpleGraph.Walk.edges_reverse, List.mem_reverse] at he
    exact (hedgesC e).mpr (Or.inr he)
  have hPlen : 0 < P.length :=
    SimpleGraph.Walk.not_nil_iff_lt_length.mp (SimpleGraph.Walk.not_nil_of_ne huv)
  have hAlen : 0 < A.length :=
    SimpleGraph.Walk.not_nil_iff_lt_length.mp (SimpleGraph.Walk.not_nil_of_ne huv)
  have hBlen : 0 < B.length :=
    SimpleGraph.Walk.not_nil_iff_lt_length.mp (SimpleGraph.Walk.not_nil_of_ne huv.symm)
  -- edges of `P` are not edges of the arcs
  have hPA' : ∀ e ∈ P.edges, e ∉ A.edges := fun e he ha =>
    hedge e he ((hedgesC e).mpr (Or.inl ha))
  have hPB' : ∀ e ∈ P.edges, e ∉ B.edges := fun e he hb =>
    hedge e he ((hedgesC e).mpr (Or.inr hb))
  -- first cycle: `P` followed by the arc `B`
  have hcyc1 : (P.append B).IsCycle := by
    apply hP.isCycle_append hB
    · intro x hx1 hx2
      obtain ⟨hxP, hxu⟩ := mem_tail_support hP hx1
      obtain ⟨hxB, hxv⟩ := mem_tail_support hB hx2
      exact hint x hxP hxu hxv (hBsupp x hxB)
    · by_contra hcon
      push Not at hcon
      have hP1 : P.length = 1 := by omega
      have hB1 : B.length = 1 := by omega
      have h1 := edges_of_length_one P hP1
      have h2 := edges_of_length_one B hB1
      apply hPB' s(u, v) (by rw [h1]; simp)
      rw [h2]
      simp [Sym2.eq_swap]
  -- second cycle: the arc `A` followed by `P` reversed
  have hcyc2 : (A.append P.reverse).IsCycle := by
    apply hA.isCycle_append hP.reverse
    · intro x hx1 hx2
      obtain ⟨hxA, hxu⟩ := mem_tail_support hA hx1
      obtain ⟨hxP, hxv⟩ := mem_tail_support hP.reverse hx2
      rw [SimpleGraph.Walk.support_reverse, List.mem_reverse] at hxP
      exact hint x hxP hxu hxv (hAsupp x hxA)
    · by_contra hcon
      push Not at hcon
      rw [SimpleGraph.Walk.length_reverse] at hcon
      have hP1 : P.length = 1 := by omega
      have hA1 : A.length = 1 := by omega
      have h1 := edges_of_length_one P hP1
      have h2 := edges_of_length_one A hA1
      apply hPA' s(u, v) (by rw [h1]; simp)
      rw [h2]
      simp
  refine ⟨⟨u, P.append B, hcyc1⟩, ⟨u, A.append P.reverse, hcyc2⟩, ?_, ?_, ?_⟩
  · show Walk.weightedLength ℓ (P.append B) < Walk.weightedLength ℓ C.walk
    rw [wl_append, hlenC]
    linarith
  · show Walk.weightedLength ℓ (A.append P.reverse) < Walk.weightedLength ℓ C.walk
    rw [wl_append, wl_reverse, hlenC]
    linarith
  · intro e
    simp only [Cycle.edgeVector, SimpleGraph.Walk.edges_append, SimpleGraph.Walk.edges_reverse,
      List.mem_append, List.mem_reverse, hedgesC e]
    by_cases hp : e ∈ P.edges
    · have ha : e ∉ A.edges := hPA' e hp
      have hb : e ∉ B.edges := hPB' e hp
      simp [hp, ha, hb]
      decide
    · by_cases ha : e ∈ A.edges
      · have hb : e ∉ B.edges := fun hb => hdisj ha hb
        simp [hp, ha, hb]
      · by_cases hb : e ∈ B.edges
        · simp [hp, ha, hb]
        · simp [hp, ha, hb]

/-! ### The main theorem -/

theorem finite_geodesic_cycles_generate_aux (ℓ : EdgeWeight G) (hpos : IsPositive ℓ)
    (C : Cycle G) :
    ∃ cycles : List (Cycle G),
      (∀ D, D ∈ cycles →
        D.IsGeodesic ℓ ∧ Walk.weightedLength ℓ D.walk ≤ Walk.weightedLength ℓ C.walk) ∧
      CycleList.edgeVectorSum cycles = C.edgeVector := by
  classical
  -- well-founded induction on the weighted length
  let r : Cycle G → Cycle G → Prop :=
    fun D E => Walk.weightedLength ℓ D.walk < Walk.weightedLength ℓ E.walk
  haveI : IsTrans (Cycle G) r := ⟨fun _ _ _ h1 h2 => lt_trans h1 h2⟩
  haveI : IsIrrefl (Cycle G) r := ⟨fun _ => lt_irrefl _⟩
  have hwf : WellFounded r := Finite.wellFounded_of_trans_of_irrefl r
  refine WellFounded.induction (C := fun C : Cycle G => ∃ cycles : List (Cycle G),
      (∀ D, D ∈ cycles →
        D.IsGeodesic ℓ ∧ Walk.weightedLength ℓ D.walk ≤ Walk.weightedLength ℓ C.walk) ∧
      CycleList.edgeVectorSum cycles = C.edgeVector) hwf C ?_
  intro C ih
  by_cases hgeo : C.IsGeodesic ℓ
  · refine ⟨[C], ?_, ?_⟩
    · intro D hD
      rw [List.mem_singleton] at hD
      subst hD
      exact ⟨hgeo, le_rfl⟩
    · funext e
      simp [CycleList.edgeVectorSum]
  -- choose a bad pair and a shortest path between it, minimising the path length
  obtain ⟨x, y, hxy⟩ := exists_bad_of_not_geodesic hgeo
  obtain ⟨P0, hP0⟩ := exists_shortest ℓ (Cycle.reachable hxy.1 hxy.2.1)
  let T := Σ a : V, Σ b : V, G.Path a b
  let good : Finset T := Finset.univ.filter (fun t => Bad ℓ C t.1 t.2.1)
  have hne : good.Nonempty := ⟨⟨x, y, ⟨P0, hP0.1⟩⟩, by simp [good, hxy]⟩
  obtain ⟨t, ht, hmin⟩ := Finset.exists_min_image good
    (fun t : T => Walk.weightedLength ℓ (t.2.2 : G.Walk t.1 t.2.1)) hne
  obtain ⟨u, v, ⟨P, hPpath⟩⟩ := t
  have hbad : Bad ℓ C u v := by simpa [good] using ht
  have hmin' : ∀ (a b : V) (q : G.Walk a b), q.IsPath → Bad ℓ C a b →
      Walk.weightedLength ℓ P ≤ Walk.weightedLength ℓ q := by
    intro a b q hq hab
    exact hmin ⟨a, b, ⟨q, hq⟩⟩ (by simp [good, hab])
  have hshort : Walk.IsShortest ℓ P := ⟨hPpath, fun q hq => hmin' u v q hq hbad⟩
  have huv : u ≠ v := hbad.ne hpos
  -- the interior of `P` avoids `C`
  have hint : ∀ w ∈ P.support, w ≠ u → w ≠ v → w ∉ C.walk.support := by
    intro w hw hwu hwv hwC
    have hP1 := isShortest_takeUntil ℓ hpos hshort hw
    have hP2 := isShortest_dropUntil ℓ hpos hshort hw
    have hsum : Walk.weightedLength ℓ P =
        Walk.weightedLength ℓ (P.takeUntil w hw) + Walk.weightedLength ℓ (P.dropUntil w hw) := by
      rw [← wl_append, SimpleGraph.Walk.take_spec]
    have hpos1 : 0 < Walk.weightedLength ℓ (P.takeUntil w hw) :=
      wl_pos ℓ hpos _ (SimpleGraph.Walk.not_nil_iff_lt_length.mp
        (SimpleGraph.Walk.not_nil_of_ne hwu.symm))
    have hpos2 : 0 < Walk.weightedLength ℓ (P.dropUntil w hw) :=
      wl_pos ℓ hpos _ (SimpleGraph.Walk.not_nil_iff_lt_length.mp
        (SimpleGraph.Walk.not_nil_of_ne hwv))
    -- neither `(u, w)` nor `(w, v)` is bad, by minimality
    have hnb1 : ¬ Bad ℓ C u w := by
      intro hb
      have := hmin' u w _ hP1.1 hb
      linarith
    have hnb2 : ¬ Bad ℓ C w v := by
      intro hb
      have := hmin' w v _ hP2.1 hb
      linarith
    obtain ⟨q1, hq1, hq1C⟩ := (not_bad_iff hbad.1 hwC).mp hnb1
    obtain ⟨q2, hq2, hq2C⟩ := (not_bad_iff hwC hbad.2.1).mp hnb2
    -- glue them into a shortest `u`–`v` path lying on `C`
    let q := (q1.append q2).bypass
    have hqpath : q.IsPath := SimpleGraph.Walk.bypass_isPath _
    have hqle : Walk.weightedLength ℓ q ≤ Walk.weightedLength ℓ P := by
      have h1 := wl_bypass_le ℓ hpos (q1.append q2)
      rw [wl_append] at h1
      have h2 := hq1.2 _ hP1.1
      have h3 := hq2.2 _ hP2.1
      linarith
    have hqshort : Walk.IsShortest ℓ q :=
      ⟨hqpath, fun r hr => le_trans hqle (hshort.2 r hr)⟩
    apply hbad.2.2 q hqshort
    intro e he
    have he' : e ∈ (q1.append q2).edges :=
      SimpleGraph.Walk.edges_bypass_subset_edges _ he
    rw [SimpleGraph.Walk.edges_append, List.mem_append] at he'
    rcases he' with h | h
    · exact hq1C h
    · exact hq2C h
  have hedge : ∀ e ∈ P.edges, e ∉ C.walk.edges := edges_not_mem hpos hbad hshort hint
  obtain ⟨C1, C2, h1, h2, hev⟩ := exists_two_cycles ℓ hpos C hbad.1 hbad.2.1 huv P hPpath
    hshort.2 hbad.2.2 hint hedge
  obtain ⟨L1, hL1, hs1⟩ := ih C1 h1
  obtain ⟨L2, hL2, hs2⟩ := ih C2 h2
  refine ⟨L1 ++ L2, ?_, ?_⟩
  · intro D hD
    rcases List.mem_append.mp hD with hD | hD
    · exact ⟨(hL1 D hD).1, le_trans (hL1 D hD).2 h1.le⟩
    · exact ⟨(hL2 D hD).1, le_trans (hL2 D hD).2 h2.le⟩
  · funext e
    have e1 := congrFun hs1 e
    have e2 := congrFun hs2 e
    simp only [CycleList.edgeVectorSum] at e1 e2 ⊢
    rw [List.map_append, List.sum_append, e1, e2]
    exact hev e

end OPG500Counterexample

universe u

open OPG500Counterexample in
theorem solution
    {V : Type u} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) (ℓ : EdgeWeight G) (hpositive : IsPositive ℓ)
    (C : Cycle G) :
    ∃ cycles : List (Cycle G),
      (∀ D, D ∈ cycles →
        D.IsGeodesic ℓ ∧
          Walk.weightedLength ℓ D.walk ≤ Walk.weightedLength ℓ C.walk) ∧
      CycleList.edgeVectorSum cycles = C.edgeVector :=
  finite_geodesic_cycles_generate_aux ℓ hpositive C
