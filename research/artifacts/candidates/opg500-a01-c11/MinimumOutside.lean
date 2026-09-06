-- Candidate only. These proof terms have not been elaborated by Lean.
-- Graph realization and the existence of a minimum are explicit obligations.
import Init

universe u v
namespace OPG500C11

-- Membership closed under combination forces a child outside whenever
-- the combined object lies outside. No linear-algebra axiom is hidden here.
theorem outsideChild
    {V : Type v} (combine : V → V → V) (inside : V → Prop)
    (closed : ∀ a b, inside a → inside b → inside (combine a b))
    (a b : V) (hout : ¬ inside (combine a b)) :
    ¬ inside a ∨ ¬ inside b :=
  Or.elim (Classical.em (inside a))
    (fun ha => Or.inr (fun hb => hout (closed a b ha hb)))
    (fun hna => Or.inl hna)

-- For graph use: objects are simple cycles, code is their F2 edge vector,
-- inside is membership in the triangle span, good means geodesic,
-- and smaller means strictly smaller weighted length. All are PARAMETERS.
theorem minimumOutside
    {C : Type u} {V : Type v}
    (combine : V → V → V) (code : C → V)
    (inside : V → Prop) (good : C → Prop)
    (smaller : C → C → Prop)
    (closed : ∀ a b, inside a → inside b → inside (combine a b))
    (split : ∀ c, ¬ good c → ∃ a, ∃ b,
      smaller a c ∧ smaller b c ∧ code c = combine (code a) (code b))
    (c : C) (hc : ¬ inside (code c))
    (hmin : ∀ a, ¬ inside (code a) → ¬ smaller a c) : good c :=
  Classical.byContradiction (fun hbad =>
    Exists.elim (split c hbad) (fun a ha =>
      Exists.elim ha (fun b hb =>
        hc (Eq.mpr (congrArg inside hb.2.2)
          (closed (code a) (code b)
            (Classical.byContradiction (fun hna => hmin a hna hb.1))
            (Classical.byContradiction (fun hnb => hmin b hnb hb.2.1)))))))

-- This corollary does not pretend to derive a finite minimum by itself.
-- The finite graph/cycle argument must actually supply hminimum.
theorem existsGoodOutside
    {C : Type u} {V : Type v}
    (combine : V → V → V) (code : C → V)
    (inside : V → Prop) (good : C → Prop)
    (smaller : C → C → Prop)
    (closed : ∀ a b, inside a → inside b → inside (combine a b))
    (split : ∀ c, ¬ good c → ∃ a, ∃ b,
      smaller a c ∧ smaller b c ∧ code c = combine (code a) (code b))
    (hminimum : ∃ c, ¬ inside (code c) ∧
      ∀ a, ¬ inside (code a) → ¬ smaller a c) :
    ∃ c, good c ∧ ¬ inside (code c) :=
  Exists.elim hminimum (fun c hc =>
    Exists.intro c (And.intro
      (minimumOutside combine code inside good smaller closed split c hc.1 hc.2)
      hc.1))

end OPG500C11

#print axioms OPG500C11.outsideChild
#print axioms OPG500C11.minimumOutside
#print axioms OPG500C11.existsGoodOutside
