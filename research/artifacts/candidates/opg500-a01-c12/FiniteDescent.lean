-- Candidate only. No Lean elaboration or axiom-output replay is claimed.
-- The finite table and every graph-realization hypothesis stay explicit.
import Init

universe u v
namespace OPG500C12

-- Ordinary finite-list occurrence, including duplicates and arbitrary order.
def InTable {C : Type u} (x : C) : List C → Prop
  | [] => False
  | a :: xs => x = a ∨ InTable x xs

-- A nonempty predicate-restricted part of a finite table has a weak minimum
-- in every total preorder. No antisymmetry or unique minimum is assumed.
theorem restrictedMinimum
    {C : Type u} (P : C → Prop) (leq : C → C → Prop)
    (hrefl : ∀ a, leq a a)
    (htrans : ∀ a b c, leq a b → leq b c → leq a c)
    (htotal : ∀ a b, leq a b ∨ leq b a)
    (table : List C) :
    (∃ x, InTable x table ∧ P x) →
      ∃ m, InTable m table ∧ P m ∧
        ∀ x, InTable x table → P x → leq m x :=
  List.rec
    (motive := fun xs => (∃ x, InTable x xs ∧ P x) →
      ∃ m, InTable m xs ∧ P m ∧
        ∀ x, InTable x xs → P x → leq m x)
    (fun h => Exists.elim h (fun x hx => False.elim hx.1))
    (fun a xs ih h =>
      Or.elim (Classical.em (∃ x, InTable x xs ∧ P x))
        (fun htail => Exists.elim (ih htail) (fun m hm =>
          Or.elim (Classical.em (P a))
            (fun hPa => Or.elim (htotal a m)
              (fun ham => Exists.intro a (And.intro (Or.inl rfl)
                (And.intro hPa (fun x hx hPx => Or.elim hx
                  (fun hxa => Eq.mpr (congrArg (fun z => leq a z) hxa) (hrefl a))
                  (fun hxt => htrans a m x ham (hm.2.2 x hxt hPx))))))
              (fun hma => Exists.intro m (And.intro (Or.inr hm.1)
                (And.intro hm.2.1 (fun x hx hPx => Or.elim hx
                  (fun hxa => Eq.mpr (congrArg (fun z => leq m z) hxa) hma)
                  (fun hxt => hm.2.2 x hxt hPx))))))
            (fun hNPa => Exists.intro m (And.intro (Or.inr hm.1)
              (And.intro hm.2.1 (fun x hx hPx => Or.elim hx
                (fun hxa => False.elim (hNPa (Eq.mp (congrArg P hxa) hPx)))
                (fun hxt => hm.2.2 x hxt hPx)))))))
        (fun hnotail =>
          let hPa : P a := Exists.elim h (fun x hx => Or.elim hx.1
            (fun hxa => Eq.mp (congrArg P hxa) hx.2)
            (fun hxt => False.elim (hnotail (Exists.intro x (And.intro hxt hx.2)))));
          Exists.intro a (And.intro (Or.inl rfl)
            (And.intro hPa (fun x hx hPx => Or.elim hx
              (fun hxa => Eq.mpr (congrArg (fun z => leq a z) hxa) (hrefl a))
              (fun hxt => False.elim (hnotail (Exists.intro x (And.intro hxt hPx)))))))))
    table

-- Replaces the supplied-minimum premise of C11 by complete finite enumeration.
-- For C10: C=all T-cycles, V=F2 edge vectors, inside=triangle span,
-- good=T-geodesic, leq=weak length comparison, smaller=strict comparison.
theorem finiteGoodOutside
    {C : Type u} {V : Type v}
    (combine : V → V → V) (code : C → V)
    (inside : V → Prop) (good : C → Prop)
    (leq smaller : C → C → Prop)
    (hrefl : ∀ a, leq a a)
    (htrans : ∀ a b c, leq a b → leq b c → leq a c)
    (htotal : ∀ a b, leq a b ∨ leq b a)
    (hcompat : ∀ a b, leq a b → ¬ smaller b a)
    (closed : ∀ a b, inside a → inside b → inside (combine a b))
    (split : ∀ c, ¬ good c → ∃ a, ∃ b,
      smaller a c ∧ smaller b c ∧ code c = combine (code a) (code b))
    (table : List C)
    (complete : ∀ c, InTable c table)
    (outside : ∃ c, ¬ inside (code c)) :
    ∃ c, good c ∧ ¬ inside (code c) :=
  Exists.elim
    (restrictedMinimum (fun c => ¬ inside (code c)) leq hrefl htrans htotal table
      (Exists.elim outside (fun c hc => Exists.intro c (And.intro (complete c) hc))))
    (fun m hm =>
      let hmin : ∀ a, ¬ inside (code a) → ¬ smaller a m :=
        fun a ha => hcompat m a (hm.2.2 a (complete a) ha);
      Exists.intro m (And.intro
        (Classical.byContradiction (fun hbad =>
          Exists.elim (split m hbad) (fun a ha =>
            Exists.elim ha (fun b hb =>
              hm.2.1 (Eq.mpr (congrArg inside hb.2.2)
                (closed (code a) (code b)
                  (Classical.byContradiction (fun hna => hmin a hna hb.1))
                  (Classical.byContradiction (fun hnb => hmin b hnb hb.2.1))))))))
        hm.2.1))

end OPG500C12

#print axioms OPG500C12.restrictedMinimum
#print axioms OPG500C12.finiteGoodOutside
