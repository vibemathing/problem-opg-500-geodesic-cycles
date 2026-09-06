import Mathlib

set_option autoImplicit false

/-!
OPG-500 C06: uncompiled order-theoretic candidate.
Target: obligation:opg500-finite-linear-characterization
This file does not define graph geodesicity and has not been checked.
The accompanying map separates graph realization from this order slice.
-/

namespace OPG500CandidateC06

universe u v

variable {α : Type u} [LinearOrder α] {ι : Type v}

/-- A nonempty finite list in a linear order has an attained minimum. -/
theorem finite_list_minimum :
    ∀ xs : List α, xs ≠ [] →
      ∃ d : α, d ∈ xs ∧ ∀ y : α, y ∈ xs → d ≤ y := by
  intro xs
  induction xs with
  | nil =>
      intro h
      exact (h rfl).elim
  | cons a xs ih =>
      intro _
      by_cases hx : xs = []
      · subst xs
        refine ⟨a, List.mem_cons.mpr (Or.inl rfl), ?_⟩
        intro y hy
        have hya : y = a := by simpa using hy
        subst y
        exact le_rfl
      · obtain ⟨d, hd, hlo⟩ := ih hx
        rcases le_total a d with had | hda
        · refine ⟨a, List.mem_cons.mpr (Or.inl rfl), ?_⟩
          intro y hy
          rcases List.mem_cons.mp hy with hya | hy
          · subst y
            exact le_rfl
          · exact le_trans had (hlo y hy)
        · refine ⟨d, List.mem_cons.mpr (Or.inr hd), ?_⟩
          intro y hy
          rcases List.mem_cons.mp hy with hya | hy
          · subst y
            exact hda
          · exact hlo y hy

/-- Soundness and completeness of a finite cost table give attainment. -/
theorem minimum_of_cost_table
    (cost : ι → α) (xs : List α) (hne : xs ≠ [])
    (hcomplete : ∀ p : ι, cost p ∈ xs)
    (hsound : ∀ y : α, y ∈ xs → ∃ p : ι, cost p = y) :
    ∃ d : α, (∀ p : ι, d ≤ cost p) ∧
      (∃ p : ι, cost p = d) := by
  obtain ⟨d, hd, hlo⟩ := finite_list_minimum xs hne
  refine ⟨d, ?_, hsound d hd⟩
  intro p
  exact hlo (cost p) (hcomplete p)

/-- The smaller of a and b is a uniform choice for every comparison. -/
theorem forall_weak_or_iff_uniform
    (cost : ι → α) (a b : α) :
    (∀ p : ι, a ≤ cost p ∨ b ≤ cost p) ↔
      ((∀ p : ι, a ≤ cost p) ∨ (∀ p : ι, b ≤ cost p)) := by
  constructor
  · intro h
    rcases le_total a b with hab | hba
    · apply Or.inl
      intro p
      rcases h p with ha | hb
      · exact ha
      · exact le_trans hab hb
    · apply Or.inr
      intro p
      rcases h p with ha | hb
      · exact le_trans hba ha
      · exact hb
  · intro h p
    rcases h with ha | hb
    · exact Or.inl (ha p)
    · exact Or.inr (hb p)

/-- Two possibly different strict witnesses yield one common witness. -/
theorem separate_strict_witnesses_iff_common
    (cost : ι → α) (a b : α) :
    ((∃ p : ι, cost p < a) ∧ (∃ q : ι, cost q < b)) ↔
      (∃ p : ι, cost p < a ∧ cost p < b) := by
  constructor
  · rintro ⟨⟨p, hpa⟩, ⟨q, hqb⟩⟩
    rcases le_total (cost p) (cost q) with hpq | hqp
    · exact ⟨p, hpa, lt_of_le_of_lt hpq hqb⟩
    · exact ⟨q, lt_of_le_of_lt hqp hpa, hqb⟩
  · rintro ⟨p, hpa, hpb⟩
    exact ⟨⟨p, hpa⟩, ⟨p, hpb⟩⟩

/-- Weak inclusive comparisons are exactly the absence of a strict shortcut. -/
theorem weak_choice_iff_no_shortcut
    (cost : ι → α) (a b : α) :
    (∀ p : ι, a ≤ cost p ∨ b ≤ cost p) ↔
      ¬ (∃ p : ι, cost p < a ∧ cost p < b) := by
  constructor
  · intro h hs
    rcases hs with ⟨p, hpa, hpb⟩
    rcases h p with hap | hbp
    · exact (not_lt_of_ge hap) hpa
    · exact (not_lt_of_ge hbp) hpb
  · intro h p
    rcases lt_or_ge (cost p) a with hpa | hap
    · rcases lt_or_ge (cost p) b with hpb | hbp
      · exact (h ⟨p, hpa, hpb⟩).elim
      · exact Or.inr hbp
    · exact Or.inl hap

/-- The distinguished indices are genuine choices from the path family. -/
theorem arc_attainment_iff_uniform
    (cost : ι → α) (ia ib : ι) (d : α)
    (hlower : ∀ p : ι, d ≤ cost p)
    (hattained : ∃ p : ι, cost p = d) :
    (cost ia = d ∨ cost ib = d) ↔
      ((∀ p : ι, cost ia ≤ cost p) ∨
       (∀ p : ι, cost ib ≤ cost p)) := by
  constructor
  · intro h
    rcases h with ha | hb
    · apply Or.inl
      intro p
      simpa only [ha] using hlower p
    · apply Or.inr
      intro p
      simpa only [hb] using hlower p
  · intro h
    obtain ⟨p, hp⟩ := hattained
    rcases h with ha | hb
    · have hia : cost ia ≤ d := by simpa only [hp] using ha p
      exact Or.inl (le_antisymm hia (hlower ia))
    · have hib : cost ib ≤ d := by simpa only [hp] using hb p
      exact Or.inr (le_antisymm hib (hlower ib))

/-- Order core of the geodesic pair criterion, conditional on attainment. -/
theorem arc_attainment_iff_no_shortcut
    (cost : ι → α) (ia ib : ι) (d : α)
    (hlower : ∀ p : ι, d ≤ cost p)
    (hattained : ∃ p : ι, cost p = d) :
    (cost ia = d ∨ cost ib = d) ↔
      ¬ (∃ p : ι, cost p < cost ia ∧ cost p < cost ib) := by
  exact (arc_attainment_iff_uniform cost ia ib d hlower hattained).trans
    ((forall_weak_or_iff_uniform cost (cost ia) (cost ib)).symm.trans
      (weak_choice_iff_no_shortcut cost (cost ia) (cost ib)))

/-- Finite table version: minimum assumptions are derived, not postulated. -/
theorem finite_arc_characterization
    (cost : ι → α) (xs : List α) (hne : xs ≠ [])
    (hcomplete : ∀ p : ι, cost p ∈ xs)
    (hsound : ∀ y : α, y ∈ xs → ∃ p : ι, cost p = y)
    (ia ib : ι) :
    ∃ d : α, (∀ p : ι, d ≤ cost p) ∧
      (∃ p : ι, cost p = d) ∧
      ((cost ia = d ∨ cost ib = d) ↔
        ¬ (∃ p : ι, cost p < cost ia ∧ cost p < cost ib)) := by
  obtain ⟨d, hlo, ha⟩ := minimum_of_cost_table cost xs hne hcomplete hsound
  exact ⟨d, hlo, ha, arc_attainment_iff_no_shortcut cost ia ib d hlo ha⟩

end OPG500CandidateC06
