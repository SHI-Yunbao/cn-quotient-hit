(*
  Minimal Coq-facing interface for the CN-as-setoid to
  CN-as-quotient-HIT project.

  This file deliberately treats quotient HITs axiomatically.  Plain Coq does
  not provide higher inductive types, but this interface records the exact
  eliminators and path constructor that the paper needs to discuss.
*)

Set Universe Polymorphism.

Record CNSetoid := {
  carrier : Type;
  ic : carrier -> carrier -> Prop;
  ic_refl : forall x, ic x x;
  ic_sym : forall x y, ic x y -> ic y x;
  ic_trans : forall x y z, ic x y -> ic y z -> ic x z
}.

Definition respects (C : CNSetoid) (B : Type) (f : carrier C -> B) : Prop :=
  forall x y, ic C x y -> f x = f y.

Definition is_hset (A : Type) : Prop :=
  forall (x y : A) (p q : x = y), p = q.

Record CNSetoidMap (C D : CNSetoid) := {
  raw_map : carrier C -> carrier D;
  raw_map_respects :
    forall x y, ic C x y -> ic D (raw_map x) (raw_map y)
}.

Module QuotientHIT.
  Parameter qtype : CNSetoid -> Type.

  Parameter qtype_is_set :
    forall C : CNSetoid, is_hset (qtype C).

  Parameter embed :
    forall C : CNSetoid, carrier C -> qtype C.

  Parameter glue :
    forall (C : CNSetoid) (x y : carrier C),
      ic C x y -> embed C x = embed C y.

  Parameter qrec :
    forall (C : CNSetoid) (B : Type) (B_is_set : is_hset B)
      (f : carrier C -> B),
      respects C B f -> qtype C -> B.

  Parameter qrec_beta :
    forall (C : CNSetoid) (B : Type)
      (B_is_set : is_hset B) (f : carrier C -> B)
      (r : respects C B f) (x : carrier C),
      qrec C B B_is_set f r (embed C x) = f x.
End QuotientHIT.

Section EqualityCN.
  Variable A : Type.

  Definition EqualityCN : CNSetoid.
  Proof.
    refine {|
      carrier := A;
      ic := fun x y => x = y
    |}.
    - intro x. reflexivity.
    - intros x y H. symmetry. exact H.
    - intros x y z Hxy Hyz. transitivity y; assumption.
  Defined.
End EqualityCN.

Section PassengerCN.
  Variables Person Journey : Type.

  Definition RawPassenger : Type := Person * Journey.

  Definition same_passenger (x y : RawPassenger) : Prop :=
    fst x = fst y /\ snd x = snd y.

  Definition PassengerCN : CNSetoid.
  Proof.
    refine {|
      carrier := RawPassenger;
      ic := same_passenger
    |}.
    - intros [p j]. split; reflexivity.
    - intros [p1 j1] [p2 j2] [Hp Hj].
      split; symmetry; assumption.
    - intros [p1 j1] [p2 j2] [p3 j3] [Hp12 Hj12] [Hp23 Hj23].
      split.
      + transitivity p2; assumption.
      + transitivity j2; assumption.
  Defined.

  Import QuotientHIT.

  Definition Passenger : Type := qtype PassengerCN.

  Definition passenger_token (p : Person) (j : Journey) : Passenger :=
    embed PassengerCN (p, j).

  (*
    Passenger identity uses the most basic quotient-HIT interface: the path
    constructor turns the passenger identity criterion into equality inside
    the quotient common noun type.
  *)
  Lemma passenger_identity_path :
    forall x y : RawPassenger,
      same_passenger x y ->
      embed PassengerCN x = embed PassengerCN y.
  Proof.
    intros x y H. apply glue. exact H.
  Qed.
End PassengerCN.

Section PassengerIdentityCounterexample.
  Lemma passenger_identity_requires_journey :
    forall (Person Journey : Type) (p : Person) (j1 j2 : Journey),
      @same_passenger Person Journey (p, j1) (p, j2) -> j1 = j2.
  Proof.
    intros Person Journey p j1 j2 H.
    exact (proj2 H).
  Qed.

  Definition one_person : Type := unit.
  Definition two_journeys : Type := bool.

  Definition first_trip : RawPassenger one_person two_journeys := (tt, true).
  Definition second_trip : RawPassenger one_person two_journeys := (tt, false).

  Lemma same_person_is_not_passenger_identity :
    fst first_trip = fst second_trip /\
    ~ @same_passenger one_person two_journeys first_trip second_trip.
  Proof.
    split.
    - reflexivity.
    - intros H. destruct H as [_ Hjourney]. discriminate Hjourney.
  Qed.
End PassengerIdentityCounterexample.

Section ModifiedCN.
  Variable Base : CNSetoid.
  Variable modifier : carrier Base -> Prop.

  Definition RawModified : Type :=
    { x : carrier Base & modifier x }.

  Definition same_modified (u v : RawModified) : Prop :=
    ic Base (projT1 u) (projT1 v).

  Definition ModifiedCN : CNSetoid.
  Proof.
    refine {|
      carrier := RawModified;
      ic := same_modified
    |}.
    - intros [x Hx]. simpl. apply ic_refl.
    - intros [x Hx] [y Hy] H. simpl in *. apply ic_sym. exact H.
    - intros [x Hx] [y Hy] [z Hz] Hxy Hyz.
      simpl in *. eapply ic_trans; eassumption.
  Defined.

  Import QuotientHIT.

  Definition Modified : Type := qtype ModifiedCN.

  Definition modified_token
    (x : carrier Base) (witness : modifier x) : Modified :=
    embed ModifiedCN (existT _ x witness).

  Lemma modifier_witnesses_do_not_count_twice :
    forall (x : carrier Base) (p q : modifier x),
      modified_token x p = modified_token x q.
  Proof.
    intros x p q. apply glue. simpl. apply ic_refl.
  Qed.

  Lemma base_identity_lifts_to_modified_identity :
    forall (x y : carrier Base)
      (px : modifier x) (py : modifier y),
      ic Base x y ->
      modified_token x px = modified_token y py.
  Proof.
    intros x y px py Hxy. apply glue. simpl. exact Hxy.
  Qed.

  (*
    The projection from a modified common noun back to its base common noun is
    a CN-to-quotient observation.  Its respectfulness proof is exactly the
    inherited base identity criterion.
  *)
  Definition modified_to_base_raw (u : RawModified) : qtype Base :=
    embed Base (projT1 u).

  Lemma modified_to_base_raw_respects :
    respects ModifiedCN (qtype Base) modified_to_base_raw.
  Proof.
    intros [x px] [y py] Hxy. simpl in *.
    apply glue. exact Hxy.
  Qed.

  Definition modified_to_base : Modified -> qtype Base :=
    qrec ModifiedCN (qtype Base) (qtype_is_set Base)
      modified_to_base_raw modified_to_base_raw_respects.

  Lemma modified_to_base_beta :
    forall u : RawModified,
      modified_to_base (embed ModifiedCN u) = modified_to_base_raw u.
  Proof.
    intro u. apply qrec_beta.
  Qed.
End ModifiedCN.

Section BookCopredication.
  Variables Phys Info : Type.

  Variable phys_ic : Phys -> Phys -> Prop.
  Variable phys_ic_refl : forall x, phys_ic x x.
  Variable phys_ic_sym : forall x y, phys_ic x y -> phys_ic y x.
  Variable phys_ic_trans :
    forall x y z, phys_ic x y -> phys_ic y z -> phys_ic x z.

  Variable info_ic : Info -> Info -> Prop.
  Variable info_ic_refl : forall x, info_ic x x.
  Variable info_ic_sym : forall x y, info_ic x y -> info_ic y x.
  Variable info_ic_trans :
    forall x y z, info_ic x y -> info_ic y z -> info_ic x z.

  Definition PhysicalObjectCN : CNSetoid.
  Proof.
    refine {|
      carrier := Phys;
      ic := phys_ic;
      ic_refl := phys_ic_refl;
      ic_sym := phys_ic_sym;
      ic_trans := phys_ic_trans
    |}.
  Defined.

  Definition InformationalObjectCN : CNSetoid.
  Proof.
    refine {|
      carrier := Info;
      ic := info_ic;
      ic_refl := info_ic_refl;
      ic_sym := info_ic_sym;
      ic_trans := info_ic_trans
    |}.
  Defined.

  Record RawBook := {
    book_phys : Phys;
    book_info : Info
  }.

  Definition same_book (x y : RawBook) : Prop :=
    phys_ic (book_phys x) (book_phys y) /\
    info_ic (book_info x) (book_info y).

  Definition BookCN : CNSetoid.
  Proof.
    refine {|
      carrier := RawBook;
      ic := same_book
    |}.
    - intros [p i]. split; [apply phys_ic_refl | apply info_ic_refl].
    - intros [p1 i1] [p2 i2] [Hp Hi].
      split; [apply phys_ic_sym | apply info_ic_sym]; assumption.
    - intros [p1 i1] [p2 i2] [p3 i3] [Hp12 Hi12] [Hp23 Hi23].
      split.
      + eapply phys_ic_trans; eassumption.
      + eapply info_ic_trans; eassumption.
  Defined.

  Import QuotientHIT.

  Definition Book : Type := qtype BookCN.
  Definition PhysicalObject : Type := qtype PhysicalObjectCN.
  Definition InformationalObject : Type := qtype InformationalObjectCN.

  Definition book_token (p : Phys) (i : Info) : Book :=
    embed BookCN {| book_phys := p; book_info := i |}.

  Lemma book_identity_needs_both_criteria :
    forall x y : RawBook,
      phys_ic (book_phys x) (book_phys y) ->
      info_ic (book_info x) (book_info y) ->
      embed BookCN x = embed BookCN y.
  Proof.
    intros x y Hp Hi. apply glue. split; assumption.
  Qed.

  (*
    Book projections are CN-to-set/CN-to-quotient observations: each projection
    is defined out of the book quotient, and its respectfulness proof is
    discharged by the relevant component of the book identity criterion.
  *)
  Definition book_to_physical_raw (b : RawBook) : PhysicalObject :=
    embed PhysicalObjectCN (book_phys b).

  Lemma book_to_physical_raw_respects :
    respects BookCN PhysicalObject book_to_physical_raw.
  Proof.
    intros x y [Hp _]. simpl.
    apply glue. exact Hp.
  Qed.

  Definition book_to_physical : Book -> PhysicalObject :=
    qrec BookCN PhysicalObject (qtype_is_set PhysicalObjectCN)
      book_to_physical_raw book_to_physical_raw_respects.

  Lemma book_to_physical_beta :
    forall b : RawBook,
      book_to_physical (embed BookCN b) = book_to_physical_raw b.
  Proof.
    intro b. apply qrec_beta.
  Qed.

  Definition book_to_informational_raw (b : RawBook) : InformationalObject :=
    embed InformationalObjectCN (book_info b).

  Lemma book_to_informational_raw_respects :
    respects BookCN InformationalObject book_to_informational_raw.
  Proof.
    intros x y [_ Hi]. simpl.
    apply glue. exact Hi.
  Qed.

  Definition book_to_informational : Book -> InformationalObject :=
    qrec BookCN InformationalObject (qtype_is_set InformationalObjectCN)
      book_to_informational_raw book_to_informational_raw_respects.

  Lemma book_to_informational_beta :
    forall b : RawBook,
      book_to_informational (embed BookCN b) = book_to_informational_raw b.
  Proof.
    intro b. apply qrec_beta.
  Qed.
End BookCopredication.

(*
  CN-to-CN interface: a setoid map between common nouns induces a
  quotient-level map between their quotient-HIT presentations.
*)
Section CNToCNFactorisation.
  Import QuotientHIT.

  Variables C D : CNSetoid.
  Variable F : CNSetoidMap C D.

  Definition quotient_map_raw (x : carrier C) : qtype D :=
    embed D (raw_map C D F x).

  Lemma quotient_map_raw_respects :
    respects C (qtype D) quotient_map_raw.
  Proof.
    intros x y Hxy. unfold quotient_map_raw.
    apply glue. apply raw_map_respects. exact Hxy.
  Qed.

  Definition quotient_map : qtype C -> qtype D :=
    qrec C (qtype D) (qtype_is_set D)
      quotient_map_raw quotient_map_raw_respects.

  Lemma quotient_map_beta :
    forall x : carrier C,
      quotient_map (embed C x) = embed D (raw_map C D F x).
  Proof.
    intro x. apply qrec_beta.
  Qed.

  Record SetoidMapFactorisation := {
    setoid_factor_map : qtype C -> qtype D;
    setoid_factor_beta :
      forall x : carrier C,
        setoid_factor_map (embed C x) = embed D (raw_map C D F x)
  }.

  Definition quotient_map_factorisation : SetoidMapFactorisation := {|
    setoid_factor_map := quotient_map;
    setoid_factor_beta := quotient_map_beta
  |}.

  Lemma quotient_map_sends_source_identity_to_path :
    forall (x y : carrier C) (Hxy : ic C x y),
      quotient_map (embed C x) = quotient_map (embed C y).
  Proof.
    intros x y Hxy.
    rewrite (glue C x y Hxy).
    reflexivity.
  Qed.

  Lemma quotient_map_uses_target_identity :
    forall (x y : carrier C) (Hxy : ic C x y),
      embed D (raw_map C D F x) = embed D (raw_map C D F y).
  Proof.
    intros x y Hxy.
    apply glue. apply raw_map_respects. exact Hxy.
  Qed.
End CNToCNFactorisation.

(*
  CN-to-set interface: an identity-respecting raw observation descends to a
  set-valued observation on the quotient presentation.
*)
Section CNToSetObservation.
  Import QuotientHIT.

  Variable C : CNSetoid.
  Variable B : Type.
  Variable B_is_set : is_hset B.
  Variable f : carrier C -> B.
  Variable f_respects : respects C B f.

  Definition lifted : qtype C -> B :=
    qrec C B B_is_set f f_respects.

  Lemma lifted_beta :
    forall x : carrier C,
      lifted (embed C x) = f x.
  Proof.
    intro x. apply qrec_beta.
  Qed.

  Lemma lifted_is_constant_on_identity_criterion :
    forall (x y : carrier C) (H : ic C x y),
      lifted (embed C x) = lifted (embed C y).
  Proof.
    intros x y H.
    rewrite (glue C x y H).
    reflexivity.
  Qed.

  Record LiftedObservationAdequacy := {
    lifted_observation : qtype C -> B;
    lifted_observation_beta :
      forall x : carrier C,
        lifted_observation (embed C x) = f x;
    lifted_observation_invariant :
      forall (x y : carrier C) (H : ic C x y),
        lifted_observation (embed C x) = lifted_observation (embed C y)
  }.

  Definition lifted_observation_adequacy : LiftedObservationAdequacy := {|
    lifted_observation := lifted;
    lifted_observation_beta := lifted_beta;
    lifted_observation_invariant := lifted_is_constant_on_identity_criterion
  |}.
End CNToSetObservation.

(*
  Converse representation: quotient-level observations determine raw
  observations that respect the identity criterion, and respectful raw
  observations are reconstructed by quotient elimination.  The inverse laws
  below are derived from function extensionality, setness/proof-irrelevance,
  and quotient induction as explicit premises; no unconditional converse axiom
  is retained.
*)
Section ConverseRepresentation.
  Import QuotientHIT.

  Variable C : CNSetoid.
  Variable B : Type.
  Variable B_is_set : is_hset B.

  Record RawRespectfulObservation := {
    raw_observation : carrier C -> B;
    raw_observation_respects : respects C B raw_observation
  }.

  Definition Phi (g : qtype C -> B) : RawRespectfulObservation.
  Proof.
    refine {|
      raw_observation := fun x => g (embed C x)
    |}.
    intros x y Hxy.
    rewrite (glue C x y Hxy).
    reflexivity.
  Defined.

  Definition Psi (obs : RawRespectfulObservation) : qtype C -> B :=
    qrec C B B_is_set
      (raw_observation obs) (raw_observation_respects obs).

  Lemma Phi_Psi_inverse_pointwise :
    forall (obs : RawRespectfulObservation) (x : carrier C),
      raw_observation (Phi (Psi obs)) x = raw_observation obs x.
  Proof.
    intros obs x. unfold Psi. simpl. apply qrec_beta.
  Qed.

  Lemma Psi_Phi_inverse_on_embed :
    forall (g : qtype C -> B) (x : carrier C),
      Psi (Phi g) (embed C x) = g (embed C x).
  Proof.
    intros g x. unfold Psi. simpl. apply qrec_beta.
  Qed.

  Definition funext_for_converse : Prop :=
    forall (A D : Type) (f g : A -> D),
      (forall x : A, f x = g x) -> f = g.

  Definition proof_irrelevance_for_converse : Prop :=
    forall (P : Prop) (p q : P), p = q.

  Definition quotient_prop_induction_for_converse : Prop :=
    forall P : qtype C -> Prop,
      (forall x : carrier C, P (embed C x)) ->
      forall z : qtype C, P z.

  Lemma Phi_Psi_inverse_from_funext_proof_irrelevance :
    funext_for_converse ->
    proof_irrelevance_for_converse ->
    forall obs : RawRespectfulObservation,
      Phi (Psi obs) = obs.
  Proof.
    intros funext proof_irrel [ro rr].
    remember (Phi (Psi {| raw_observation := ro;
                          raw_observation_respects := rr |})) as lhs.
    destruct lhs as [ro' rr'].
    assert (Hraw : ro' = ro).
    {
      apply funext. intro x.
      change (raw_observation
        {| raw_observation := ro'; raw_observation_respects := rr' |} x =
        ro x).
      rewrite Heqlhs. simpl. apply qrec_beta.
    }
    destruct Hraw.
    f_equal.
    apply proof_irrel.
  Qed.

  Lemma Psi_Phi_inverse_from_funext_qind :
    funext_for_converse ->
    quotient_prop_induction_for_converse ->
    forall g : qtype C -> B,
      Psi (Phi g) = g.
  Proof.
    intros funext qind g.
    apply funext.
    intro z.
    apply (qind (fun z => Psi (Phi g) z = g z)).
    intro x.
    apply Psi_Phi_inverse_on_embed.
  Qed.

  Record ObservationEquivalence := {
    to_quotient_observation :
      RawRespectfulObservation -> (qtype C -> B);
    to_raw_observation :
      (qtype C -> B) -> RawRespectfulObservation;
    raw_quotient_roundtrip :
      forall obs : RawRespectfulObservation,
        to_raw_observation (to_quotient_observation obs) = obs;
    quotient_raw_roundtrip :
      forall g : qtype C -> B,
        to_quotient_observation (to_raw_observation g) = g
  }.

  Theorem conditional_observation_equivalence :
    funext_for_converse ->
    proof_irrelevance_for_converse ->
    quotient_prop_induction_for_converse ->
    ObservationEquivalence.
  Proof.
    intros funext proof_irrel qind.
    refine {|
      to_quotient_observation := Psi;
      to_raw_observation := Phi
    |}.
    - apply Phi_Psi_inverse_from_funext_proof_irrelevance;
        assumption.
    - apply Psi_Phi_inverse_from_funext_qind;
        assumption.
  Qed.
End ConverseRepresentation.
