-- Candidate source, pinned to Lean 4.33.0 and Mathlib db584cd6d46c92f209a44c0f1c829460d327499d.
-- No elaboration has been observed. TightWalk is staged from the unchanged C16 file.
import Mathlib
import TightWalk

open OPG500C16
universe u
namespace OPG500C17
noncomputable section

-- No metric-preservation or minimum-existence field is assumed here.
def realCostSpec : CostSpec ℝ where
  zero := 0
  add := (· + ·)
  le := (· ≤ ·)
  antisymm := fun _ _ h k => le_antisymm h k
  zero_add := zero_add
  add_zero := add_zero
  assoc := add_assoc
  cancel_left := fun _ _ _ h => (add_le_add_iff_left _).mp h
  cancel_right := fun _ _ _ h => (add_le_add_iff_right _).mp h

variable {V : Type u} {R : V → V → Prop}
variable (w : V → V → ℝ)

def Positive : Prop := ∀ a b, R a b → 0 < w a b

def edgeCount : {a b : V} → Walk R a b → Nat
  | _, _, .nil => 0
  | _, _, .cons _ p => edgeCount p + 1

def vertices : {a b : V} → Walk R a b → List V
  | a, _, .nil => [a]
  | a, _, .cons _ p => a :: vertices p

def Simple {a b : V} (p : Walk R a b) : Prop := (vertices p).Nodup

abbrev length {a b : V} (p : Walk R a b) : ℝ := cost realCostSpec w p

@[simp] theorem length_nil (a : V) : length w (Walk.nil : Walk R a a) = 0 := rfl
@[simp] theorem length_cons {a b c : V} (h : R a b) (p : Walk R b c) :
    length w (.cons h p) = w a b + length w p := rfl

@[simp] theorem edgeCount_append :
    {a b : V} → (p : Walk R a b) → {c : V} → (q : Walk R b c) →
      edgeCount (append p q) = edgeCount p + edgeCount q
  | _, _, .nil, _, q => by simp [append, edgeCount]
  | _, _, .cons h p, _, q => by
      simp only [append, edgeCount, edgeCount_append]
      omega

@[simp] theorem length_append {a b c : V} (p : Walk R a b) (q : Walk R b c) :
    length w (append p q) = length w p + length w q :=
  cost_append realCostSpec w p q

@[simp] theorem vertices_length : {a b : V} → (p : Walk R a b) →
    (vertices p).length = edgeCount p + 1
  | _, _, .nil => rfl
  | _, _, .cons _ p => by simp [vertices, edgeCount, vertices_length]

theorem length_nonneg (hw : Positive (R := R) w) :
    {a b : V} → (p : Walk R a b) → 0 ≤ length w p
  | _, _, .nil => le_rfl
  | a, _, .cons (b := b) h p =>
      add_nonneg (le_of_lt (hw a b h)) (length_nonneg w hw p)

theorem length_pos (hw : Positive (R := R) w) :
    {a b : V} → (p : Walk R a b) → 0 < edgeCount p → 0 < length w p
  | _, _, .nil, hn => by simp [edgeCount] at hn
  | a, _, .cons (b := b) h p, _ =>
      add_pos_of_pos_of_nonneg (hw a b h) (length_nonneg w hw p)

-- The intermediate vertex is shared by the prefix, loop and suffix in the TYPE.
-- Edge-count descent does not itself need positivity; strict cost descent does.
theorem erase_closed_factor {a v b : V}
    (hw : Positive (R := R) w) (pre : Walk R a v)
    (loop : Walk R v v) (post : Walk R v b) (hn : 0 < edgeCount loop) :
    edgeCount (append pre post) < edgeCount (append pre (append loop post)) ∧
    length w (append pre post) < length w (append pre (append loop post)) := by
  constructor
  · simp only [edgeCount_append]
    omega
  · have hp := length_pos w hw loop hn
    simp only [length_append]
    linarith

-- A suffix beginning at an occurrence of x; endpoint and simplicity are retained.
theorem simple_suffix (hw : Positive (R := R) w) :
    {a b : V} → (p : Walk R a b) → Simple p → {x : V} → x ∈ vertices p →
      ∃ q : Walk R x b, Simple q ∧ length w q ≤ length w p ∧
        edgeCount q ≤ edgeCount p
  | a, _, .nil, _, x, hx => by
      have hxa : x = a := by simpa [vertices] using hx
      subst x
      exact ⟨.nil, by simp [Simple, vertices], le_rfl, le_rfl⟩
  | a, c, .cons (b := b) h p, hp, x, hx => by
      change (a :: vertices p).Nodup at hp
      change x ∈ a :: vertices p at hx
      rcases List.mem_cons.mp hx with hxa | hxp
      · subst x
        exact ⟨.cons h p, hp, le_rfl, le_rfl⟩
      · obtain ⟨q, hq, hcost, hcount⟩ :=
          simple_suffix w hw p (List.nodup_cons.mp hp).2 hxp
        refine ⟨q, hq, ?_, ?_⟩
        · change length w q ≤ w a b + length w p
          have he := hw a b h
          linarith
        · change edgeCount q ≤ edgeCount p + 1
          omega

-- Structural loop erasure, not an assumed shortest-path existence principle.
theorem exists_simple_le (hw : Positive (R := R) w) :
    {a b : V} → (p : Walk R a b) →
      ∃ q : Walk R a b, Simple q ∧ length w q ≤ length w p ∧
        edgeCount q ≤ edgeCount p
  | _, _, .nil => ⟨.nil, by simp [Simple, vertices], le_rfl, le_rfl⟩
  | a, c, .cons (b := b) h p => by
      classical
      obtain ⟨q, hq, hcost, hcount⟩ := exists_simple_le w hw p
      by_cases ha : a ∈ vertices q
      · obtain ⟨r, hr, hrCost, hrCount⟩ := simple_suffix w hw q hq ha
        refine ⟨r, hr, ?_, ?_⟩
        · change length w r ≤ w a b + length w p
          have he := hw a b h
          linarith
        · change edgeCount r ≤ edgeCount p + 1
          omega
      · refine ⟨.cons h q, ?_, ?_, ?_⟩
        · exact List.nodup_cons.mpr ⟨ha, hq⟩
        · exact add_le_add_left hcost (w a b)
        · change edgeCount q + 1 ≤ edgeCount p + 1
          omega

-- Every tied minimizing WALK is simple under strict positivity, not just
-- the particular simple minimizer later selected from a finite family.
theorem shortest_is_simple (hw : Positive (R := R) w) :
    {a b : V} → (p : Walk R a b) → Shortest realCostSpec w p → Simple p
  | _, _, .nil, _ => by simp [Simple, vertices]
  | a, c, .cons (b := b) h p, hp => by
      classical
      have hm := shortest_tail realCostSpec w h p hp
      have hs := shortest_is_simple w hw p hm
      by_cases ha : a ∈ vertices p
      · obtain ⟨q, _, hq, _⟩ := simple_suffix w hw p hs ha
        have hmin := hp q
        change w a b + length w p ≤ length w q at hmin
        have he := hw a b h
        exact False.elim (by linarith)
      · exact List.nodup_cons.mpr ⟨ha, hs⟩

theorem real_shortest_all_tight {a b : V} (p : Walk R a b)
    (hp : Shortest realCostSpec w p) : AllTight realCostSpec w p :=
  shortest_all_tight realCostSpec w p hp

-- A finite encoding by duplicate-free vertex words. Edge proofs do not become
-- unbounded combinatorial data: they live in Prop and costs depend on vertices.
abbrev SimpleWord (V : Type u) := {xs : List V // xs.Nodup}

def wordCost : List V → ℝ
  | [] => 0
  | [_] => 0
  | a :: b :: rest => w a b + wordCost w (b :: rest)

theorem vertices_starts : {a b : V} → (p : Walk R a b) →
    ∃ xs, vertices p = a :: xs
  | _, _, .nil => ⟨[], rfl⟩
  | _, _, .cons _ p => ⟨vertices p, rfl⟩

-- Injectivity is proved in the original Walk type, using proof irrelevance
-- only for edge witnesses in Prop; no coarser path quotient is substituted.
theorem vertices_injective : {a b : V} → (p q : Walk R a b) →
    vertices p = vertices q → p = q
  | _, _, .nil, .nil, _ => rfl
  | _, _, .nil, .cons _ q, he => by
      obtain ⟨xs, hx⟩ := vertices_starts q
      simp [vertices, hx] at he
  | _, _, .cons _ p, .nil, he => by
      obtain ⟨xs, hx⟩ := vertices_starts p
      simp [vertices, hx] at he
  | a, c, .cons (b := b) h p, .cons (b := d) k q, he => by
      have ht : vertices p = vertices q := (List.cons.inj he).2
      obtain ⟨xs, hx⟩ := vertices_starts p
      obtain ⟨ys, hy⟩ := vertices_starts q
      have hd : b = d := (List.cons.inj (hx.symm.trans (ht.trans hy))).1
      subst d
      have hpq := vertices_injective p q ht
      cases hpq
      rfl

theorem finite_simple_walks [Fintype V] (a b : V) :
    Finite {p : Walk R a b // Simple p} := by
  apply Finite.of_injective
    (fun p : {p : Walk R a b // Simple p} =>
      (⟨vertices p.val, p.property⟩ : SimpleWord V))
  intro p q h
  exact Subtype.ext (vertices_injective p.val q.val (congrArg Subtype.val h))

theorem wordCost_vertices : {a b : V} → (p : Walk R a b) →
    wordCost w (vertices p) = length w p
  | _, _, .nil => rfl
  | a, c, .cons (b := b) h p => by
      obtain ⟨xs, hx⟩ := vertices_starts p
      change wordCost w (a :: vertices p) = w a b + length w p
      calc
        wordCost w (a :: vertices p) = w a b + wordCost w (vertices p) := by
          rw [hx]
          rfl
        _ = w a b + length w p := congrArg (fun t => w a b + t) (wordCost_vertices w p)

-- This really is a finite family, using Mathlib's finite type of all Nodup lists.
def pathWords [Fintype V] (a b : V) : Finset (SimpleWord V) := by
  classical
  exact Finset.univ.filter (fun xs => ∃ p : Walk R a b, vertices p = xs.val)

theorem mem_pathWords [Fintype V] {a b : V} (xs : SimpleWord V) :
    xs ∈ pathWords (R := R) a b ↔ ∃ p : Walk R a b, vertices p = xs.val := by
  classical
  simp [pathWords]

theorem pathWords_nonempty_iff [Fintype V] (hw : Positive (R := R) w) (a b : V) :
    (pathWords (R := R) a b).Nonempty ↔ Nonempty (Walk R a b) := by
  constructor
  · rintro ⟨xs, hxs⟩
    obtain ⟨p, _⟩ := (mem_pathWords xs).mp hxs
    exact ⟨p⟩
  · rintro ⟨p⟩
    obtain ⟨q, hq, _, _⟩ := exists_simple_le w hw p
    exact ⟨⟨vertices q, hq⟩, (mem_pathWords _).mpr ⟨q, rfl⟩⟩

-- Nonempty is derived from a walk; no connectedness is invented.
theorem exists_shortest_simple [Fintype V] (hw : Positive (R := R) w)
    {a b : V} (hab : Nonempty (Walk R a b)) :
    ∃ p : Walk R a b, Simple p ∧ Shortest realCostSpec w p := by
  classical
  let s := pathWords (R := R) a b
  have hs : s.Nonempty := (pathWords_nonempty_iff w hw a b).mpr hab
  obtain ⟨xs, hxs, hmin⟩ := s.exists_min_image (fun t => wordCost w t.val) hs
  obtain ⟨p, hp⟩ := (mem_pathWords xs).mp hxs
  have hpSimple : Simple p := by
    unfold Simple
    rw [hp]
    exact xs.property
  refine ⟨p, hpSimple, ?_⟩
  intro r
  obtain ⟨q, hq, hcost, _⟩ := exists_simple_le w hw r
  have hmem : (⟨vertices q, hq⟩ : SimpleWord V) ∈ s :=
    (mem_pathWords _).mpr ⟨q, rfl⟩
  have bound := hmin ⟨vertices q, hq⟩ hmem
  change length w p ≤ length w r
  calc
    length w p = wordCost w xs.val := by rw [← hp, wordCost_vertices]
    _ ≤ wordCost w (vertices q) := bound
    _ = length w q := wordCost_vertices w q
    _ ≤ length w r := hcost

theorem exists_distanceValue [Fintype V] (hw : Positive (R := R) w)
    {a b : V} (hab : Nonempty (Walk R a b)) :
    ∃ d : ℝ, DistanceValue R realCostSpec w a b d := by
  obtain ⟨p, _, hp⟩ := exists_shortest_simple w hw hab
  exact ⟨length w p, hp, p, rfl⟩

theorem distanceValue_unique {a b : V} {d e : ℝ}
    (hd : DistanceValue R realCostSpec w a b d)
    (he : DistanceValue R realCostSpec w a b e) : d = e := by
  obtain ⟨p, hp⟩ := hd.2
  obtain ⟨q, hq⟩ := he.2
  have hde := hd.1 q
  have hed := he.1 p
  rw [hq] at hde
  rw [hp] at hed
  exact le_antisymm hde hed

theorem distanceValue_iff_reachable [Fintype V] (hw : Positive (R := R) w)
    (a b : V) :
    (∃ d : ℝ, DistanceValue R realCostSpec w a b d) ↔ Nonempty (Walk R a b) := by
  constructor
  · rintro ⟨d, hd⟩
    obtain ⟨p, _⟩ := hd.2
    exact ⟨p⟩
  · exact exists_distanceValue w hw

theorem diagonal_distanceValue (hw : Positive (R := R) w) (a : V) :
    DistanceValue R realCostSpec w a a 0 :=
  ⟨length_nonneg w hw, Walk.nil, rfl⟩

-- This is the complete first metric bridge, conditional only on finiteness,
-- positive edge weights and reachability, not on a supplied distance value.
theorem finite_real_tight_distance [Fintype V] (hw : Positive (R := R) w)
    {a b : V} (hab : Nonempty (Walk R a b)) :
    ∃ d : ℝ, DistanceValue R realCostSpec w a b d ∧
      DistanceValue (Tight R realCostSpec w) realCostSpec w a b d := by
  obtain ⟨d, hd⟩ := exists_distanceValue w hw hab
  exact ⟨d, hd, distance_value_to_tight realCostSpec w hd⟩

theorem real_tight_iff_distance {a b : V} {d : ℝ} (h : R a b)
    (hd : DistanceValue R realCostSpec w a b d) :
    Tight R realCostSpec w a b ↔ w a b = d :=
  tight_iff_distance realCostSpec w h hd

theorem unreachable_has_no_distance (a b : V) (h : ¬ Nonempty (Walk R a b)) :
    ¬ ∃ d : ℝ, DistanceValue R realCostSpec w a b d := by
  rintro ⟨d, hd⟩
  obtain ⟨p, _⟩ := hd.2
  exact h ⟨p⟩

end
end OPG500C17

#print axioms OPG500C17.erase_closed_factor
#print axioms OPG500C17.shortest_is_simple
#print axioms OPG500C17.exists_simple_le
#print axioms OPG500C17.exists_shortest_simple
#print axioms OPG500C17.finite_real_tight_distance
#print axioms OPG500C17.real_tight_iff_distance
