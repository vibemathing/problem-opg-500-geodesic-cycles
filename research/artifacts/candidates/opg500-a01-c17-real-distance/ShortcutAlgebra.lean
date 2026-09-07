-- Source-only next-bridge slice. Geometry is separately stated in proof.md.
-- Same pinned Lean/Mathlib as FiniteRealWalk; no kernel replay is asserted.
import Mathlib

namespace OPG500C17Split

-- Parent A+B; children A+Q and B+Q. Both shortcut inequalities are needed.
theorem two_strictly_shorter (a b q : ℝ) (hqa : q < a) (hqb : q < b) :
    a + q < a + b ∧ b + q < a + b := by
  constructor <;> linarith

-- Used after visits to the cycle have partitioned a competing path.
theorem exists_strict_segment {n : Nat} (p d : Fin n → ℝ)
    (h : (∑ i, p i) < ∑ i, d i) : ∃ i, p i < d i := by
  by_contra hn
  push_neg at hn
  have hsum : (∑ i, d i) ≤ ∑ i, p i := Finset.sum_le_sum (fun i _ => hn i)
  linarith

-- Boolean coordinates represent vectors over F2. No rank/count substitute.
theorem shared_coordinate_cancels (a b q : Bool) :
    Bool.xor (Bool.xor a q) (Bool.xor b q) = Bool.xor a b := by
  cases a <;> cases b <;> cases q <;> rfl

-- Actual children use UNION. Pairwise edge disjointness is a geometry premise,
-- not an automatic consequence of naming objects arcs or a shortcut.
theorem disjoint_union_coordinate (a b q : Bool)
    (hab : a && b = false) (haq : a && q = false) (hbq : b && q = false) :
    Bool.xor (a || q) (b || q) = (a || b) := by
  cases a <;> cases b <;> cases q <;> simp_all

theorem odd_parent_has_odd_child (a b : Bool) (h : Bool.xor a b = true) :
    a = true ∨ b = true := by
  cases a <;> cases b <;> simp_all

end OPG500C17Split

#print axioms OPG500C17Split.two_strictly_shorter
#print axioms OPG500C17Split.exists_strict_segment
#print axioms OPG500C17Split.disjoint_union_coordinate
