-- Candidate source only. No Lean elaboration or trusted replay is asserted.
-- The cost interface is generic; its real-number instance is a separate step.
import Init

universe u v
namespace OPG500C16

structure CostSpec (K : Type v) where
  zero : K
  add : K → K → K
  le : K → K → Prop
  antisymm : ∀ a b, le a b → le b a → a = b
  zero_add : ∀ a, add zero a = a
  add_zero : ∀ a, add a zero = a
  assoc : ∀ a b c, add (add a b) c = add a (add b c)
  cancel_left : ∀ a b c, le (add a b) (add a c) → le b c
  cancel_right : ∀ a b c, le (add a c) (add b c) → le a b

inductive Walk {V : Type u} (R : V → V → Prop) : V → V → Type u where
  | nil {a : V} : Walk R a a
  | cons {a b c : V} : R a b → Walk R b c → Walk R a c

def append {V : Type u} {R : V → V → Prop} :
    {a b : V} → Walk R a b → {c : V} → Walk R b c → Walk R a c
  | _, _, .nil, _, q => q
  | _, _, .cons h p, _, q => .cons h (append p q)

def cost {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) : {a b : V} → Walk R a b → K
  | _, _, .nil => S.zero
  | _, _, .cons (a := a) (b := b) _ p => S.add (w a b) (cost S w p)

theorem cost_append {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) :
    {a b : V} → (p : Walk R a b) → {c : V} → (q : Walk R b c) →
      cost S w (append p q) = S.add (cost S w p) (cost S w q)
  | _, _, .nil, _, q => (S.zero_add (cost S w q)).symm
  | _, _, .cons h p, _, q => by
      change S.add _ (cost S w (append p q)) = _
      rw [cost_append S w p q]
      exact (S.assoc _ _ _).symm

def Shortest {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) {a b : V} (p : Walk R a b) : Prop :=
  ∀ q : Walk R a b, S.le (cost S w p) (cost S w q)

def Tight {V : Type u} {K : Type v} (R : V → V → Prop)
    (S : CostSpec K) (w : V → V → K) (a b : V) : Prop :=
  R a b ∧ ∀ q : Walk R a b, S.le (w a b) (cost S w q)

theorem shortest_head {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) {a b c : V}
    (h : R a b) (p : Walk R b c) (hp : Shortest S w (.cons h p)) :
    Tight R S w a b := by
  refine And.intro h ?_
  intro q
  have bound := hp (append q p)
  change S.le (S.add (w a b) (cost S w p)) (cost S w (append q p)) at bound
  rw [cost_append S w q p] at bound
  exact S.cancel_right (w a b) (cost S w q) (cost S w p) bound

theorem shortest_tail {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) {a b c : V}
    (h : R a b) (p : Walk R b c) (hp : Shortest S w (.cons h p)) :
    Shortest S w p := by
  intro q
  exact S.cancel_left (w a b) (cost S w p) (cost S w q) (hp (.cons h q))

def AllTight {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) : {a b : V} → Walk R a b → Prop
  | _, _, .nil => True
  | _, _, .cons (a := a) (b := b) _ p => Tight R S w a b ∧ AllTight S w p

theorem shortest_all_tight {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) :
    {a b : V} → (p : Walk R a b) → Shortest S w p → AllTight S w p
  | _, _, .nil, _ => True.intro
  | _, _, .cons h p, hp =>
      And.intro (shortest_head S w h p hp)
        (shortest_all_tight S w p (shortest_tail S w h p hp))

def lift {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) :
    {a b : V} → (p : Walk R a b) → AllTight S w p → Walk (Tight R S w) a b
  | _, _, .nil, _ => .nil
  | _, _, .cons _ p, hp => .cons hp.1 (lift S w p hp.2)

theorem lift_cost {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) :
    {a b : V} → (p : Walk R a b) → (hp : AllTight S w p) →
      cost S w (lift S w p hp) = cost S w p
  | _, _, .nil, _ => rfl
  | _, _, .cons _ p, hp => congrArg (S.add _) (lift_cost S w p hp.2)

def forget {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) :
    {a b : V} → Walk (Tight R S w) a b → Walk R a b
  | _, _, .nil => .nil
  | _, _, .cons h p => .cons h.1 (forget S w p)

theorem forget_cost {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) :
    {a b : V} → (p : Walk (Tight R S w) a b) →
      cost S w (forget S w p) = cost S w p
  | _, _, .nil => rfl
  | _, _, .cons _ p => congrArg (S.add _) (forget_cost S w p)

-- This is the definition of an attained distance, not a supplied tightness
-- or distance-preservation assumption. It quantifies over ALL finite walks.
def DistanceValue {V : Type u} {K : Type v} (R : V → V → Prop)
    (S : CostSpec K) (w : V → V → K) (a b : V) (d : K) : Prop :=
  (∀ p : Walk R a b, S.le d (cost S w p)) ∧
  ∃ p : Walk R a b, cost S w p = d

theorem distance_value_to_tight {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) {a b : V} {d : K}
    (hd : DistanceValue R S w a b d) : DistanceValue (Tight R S w) S w a b d := by
  refine And.intro ?_ ?_
  · intro q
    have bound := hd.1 (forget S w q)
    rw [forget_cost S w q] at bound
    exact bound
  · rcases hd.2 with ⟨p, hp⟩
    have hm : Shortest S w p := by
      intro q
      change S.le (cost S w p) (cost S w q)
      rw [hp]
      exact hd.1 q
    let ht := shortest_all_tight S w p hm
    exact Exists.intro (lift S w p ht) ((lift_cost S w p ht).trans hp)

-- Identifies the all-walk definition of tightness with equality to an
-- actually attained distance. In particular no uniqueness is assumed.
theorem tight_iff_distance {V : Type u} {K : Type v} {R : V → V → Prop}
    (S : CostSpec K) (w : V → V → K) {a b : V} {d : K}
    (h : R a b) (hd : DistanceValue R S w a b d) :
    Tight R S w a b ↔ w a b = d := by
  constructor
  · intro ht
    rcases hd.2 with ⟨p, hp⟩
    have upper := ht.2 p
    rw [hp] at upper
    have lower := hd.1 (Walk.cons h Walk.nil)
    change S.le d (S.add (w a b) S.zero) at lower
    rw [S.add_zero] at lower
    exact S.antisymm (w a b) d upper lower
  · intro heq
    refine And.intro h ?_
    intro p
    rw [heq]
    exact hd.1 p

end OPG500C16

#print axioms OPG500C16.shortest_all_tight
#print axioms OPG500C16.distance_value_to_tight

#print axioms OPG500C16.tight_iff_distance
