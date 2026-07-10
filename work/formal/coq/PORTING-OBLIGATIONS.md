# Porting Obligations for a Native Quotient-HIT Development

This checklist records what must be made explicit when the current
Coq-facing axiomatic interface is ported to Cubical Agda, HoTT, or another
setting with native quotient higher inductive types.

Current scaffold: `../agda/CNQuotientHitSkeleton.agda` is an unverified
Cubical Agda-style skeleton.  It mirrors the three interface roles below, but
it still postulates the quotient interface and has not been checked because
`agda` is not available in the current environment.  It now also contains
placeholders for the converse representation schema and the three case-study
obligations.

## Porting Priority

- `native-interface`: Coq `P0`, Agda `P0`; next gate is to replace quotient postulates with a native HIT interface.
- `converse-representation`: Coq `P1`, Agda `P1`; next gate is to prove Phi/Psi inverse laws.
- `passenger-identity`: Coq `P2`, Agda `P2`; next gate is to check passenger carrier and identity path.
- `modified-carrier`: Coq `P2`, Agda `P2`; next gate is to check sigma carrier and inherited identity.
- `modified-projection`: Coq `P2`, Agda `P2`; next gate is to check modified projection eliminator.
- `book-projection`: Coq `P3`, Agda `P3`; next gate is to check physical and informational projection eliminators.

## Quotient HIT Interface

- Skeleton tag: `TODO(native-HIT)`.

- [ ] `QHIT-FORMER`: provide the quotient type former for a carrier and
      identity criterion.
- [ ] `QHIT-POINT`: provide the point constructor from raw candidates into the
      quotient.
- [ ] `QHIT-PATH`: provide the path constructor turning identity-criterion proofs into
      paths between embedded raw candidates.
- [ ] `QHIT-SET`: provide the set-truncation constructor or equivalent proof
      that the quotient is a set.
- [ ] `QHIT-REC`: provide the non-dependent quotient eliminator used by
      quotient-level maps and lifted observations.
- [ ] `QHIT-BETA`: provide the point beta rule for quotient eliminator used at
      embedded raw candidates.

## Native Interface Porting Gates

| Gate | Subobligation | Gate label | Coq target | Agda target |
| --- | --- | --- | --- | --- |
| `NGATE-FORMER` | `QHIT-FORMER` | native quotient former | replace Coq quotient field Q | replace Agda Q postulate |
| `NGATE-POINT` | `QHIT-POINT` | native point constructor | replace Coq embed field | replace Agda [_] postulate |
| `NGATE-PATH` | `QHIT-PATH` | native path constructor | replace Coq glue field | replace Agda glue postulate |
| `NGATE-SET` | `QHIT-SET` | native set truncation | replace Coq qtype_is_set field | replace Agda isSetQ postulate |
| `NGATE-REC` | `QHIT-REC` | native quotient eliminator | replace Coq qrec field | replace Agda qrec postulate |
| `NGATE-BETA` | `QHIT-BETA` | native beta rule | replace Coq qrec beta field | replace Agda qrec-β postulate |

## Adequacy Obligations

- Skeleton tag: `TODO(converse-laws)`.

- [ ] Setoid-map factorisation: every setoid map induces a quotient-level map.
- [ ] Observation invariance: every identity-respecting raw observation induces
      an invariant quotient observation.
- [ ] Converse representation: for set-valued observations, every
      quotient-defined observation corresponds to a raw identity-respecting
      observation.
- [ ] `CONV-PHI`: Phi map from quotient observation.  Given `g : A/R -> B`,
      define `raw_g x = g (embed x)` and derive respectfulness from the path
      constructor.
- [ ] `CONV-PSI`: Psi map by quotient elimination.  Reconstruct a quotient
      observation from a raw map plus a respectfulness proof by quotient
      elimination.
- [ ] Converse inverse laws: prove that the two maps are inverse using the
      quotient beta rule plus the needed eta, uniqueness, or function
      extensionality principle.
- [ ] `CONV-PHI-PSI`: left inverse on raw respectful observations.  Use the
      quotient beta rule for the first component of
      `Phi (Psi (f,rho)) = (f,rho)`.
- [ ] `CONV-RESP-PROOFS`: respectfulness proof coherence.  Use setness of `B`
      or proof irrelevance to identify respectfulness proofs in the second
      component.
- [ ] `CONV-PSI-PHI`: right inverse by quotient induction.  Use quotient
      induction to reduce `Psi (Phi g) q = g q` to embedded raw candidates.
- [ ] `CONV-FUNEXT`: function extensionality for quotient observations.
      Conclude `Psi (Phi g) = g` as equality of functions.
- [ ] State the uniqueness, eta, or function-extensionality principle needed
      for the converse representation result.

## Converse Representation Porting Gates

| Gate | Subobligation | Gate label | Coq target | Agda target |
| --- | --- | --- | --- | --- |
| `CGATE-PHI` | `CONV-PHI` | transport quotient observation to raw observation | define Coq Phi map | define Agda Phi map |
| `CGATE-PSI` | `CONV-PSI` | lift raw respectful observation by quotient elimination | define Coq Psi map | define Agda Psi map |
| `CGATE-PHI-PSI` | `CONV-PHI-PSI` | prove Phi after Psi is identity | prove Coq Phi-Psi inverse | prove Agda Phi-Psi inverse |
| `CGATE-RESP-PROOFS` | `CONV-RESP-PROOFS` | prove respectfulness proof coherence | prove Coq proof coherence | prove Agda proof coherence |
| `CGATE-PSI-PHI` | `CONV-PSI-PHI` | prove Psi after Phi is identity | prove Coq Psi-Phi inverse | prove Agda Psi-Phi inverse |
| `CGATE-FUNEXT` | `CONV-FUNEXT` | use function extensionality for quotient observations | add Coq function extensionality gate | add Agda function extensionality gate |

## Case-Study Obligations

- Skeleton tags: `TODO(passenger-carrier)`, `TODO(modified-carrier)`,
  `TODO(modified-projection)`, `TODO(book-projections)`.

- [ ] `PASS-RAW-CARRIER`: raw passenger carrier.  Choose the raw passenger
      representation, such as person/journey pairs.
- [ ] `PASS-IDENTITY-REL`: passenger identity relation.  State the identity
      criterion for passenger tokens.
- [ ] `PASS-CN-SETOID`: passenger common-noun setoid.  Package the raw carrier
      and identity criterion as a common-noun setoid.
- [ ] `PASS-QUOTIENT-INTERFACE`: passenger quotient interface.  Instantiate the
      quotient-HIT interface for the passenger common noun.
- [ ] `PASS-IDENTITY-PATH`: passenger identity path.  Show that passenger
      identity proofs induce paths between embedded passenger tokens.
- [ ] `MOD-RAW-CARRIER`: raw modified carrier.  Use a sigma-style carrier
      whose elements contain a base common-noun object and modifier evidence.
- [ ] `MOD-INHERITED-IDENTITY`: inherited modified identity.  Define modified
      identity from the base common noun's identity criterion.
- [ ] `MOD-CN-SETOID`: modified common-noun setoid.  Package the raw carrier
      and inherited identity criterion as a common-noun setoid.
- [ ] `MOD-WITNESS-COLLAPSE`: modifier witness collapse.  Show that modifier
      witnesses do not count twice.
- [ ] `MOD-QUOTIENT-INTERFACE`: modified quotient interface.  Instantiate the
      quotient-HIT interface for the modified common noun.
- [ ] `MPROJ-RAW-MAP`: modified-to-base raw projection.  Define the projection
      from a modified token to the base quotient.
- [ ] `MPROJ-RESP-PROOF`: modified projection respectfulness proof.  Prove the
      projection respects the modified identity criterion.
- [ ] `MPROJ-LIFTED-MAP`: lifted modified-to-base map.  Define the quotient map
      from the modified quotient to the base quotient.
- [ ] `MPROJ-QREC-USE`: quotient eliminator for modified projection.  Build the
      lifted map by quotient elimination from the raw map and respectfulness
      proof.
- [ ] `BOOK-PHYS-RAW-MAP`: physical book raw projection.  Define the raw
      projection from a book token to the physical quotient.
- [ ] `BOOK-PHYS-RESP-PROOF`: physical book projection respectfulness proof.
      Prove that the physical projection respects book identity.
- [ ] `BOOK-PHYS-LIFTED-MAP`: lifted physical book projection.  Define the
      quotient map from the book quotient to the physical quotient.
- [ ] `BOOK-PHYS-QREC-USE`: quotient eliminator for physical book projection.
      Build the lifted physical projection by quotient elimination.
- [ ] `BOOK-INFO-RAW-MAP`: informational book raw projection.  Define the raw
      projection from a book token to the informational quotient.
- [ ] `BOOK-INFO-RESP-PROOF`: informational book projection respectfulness
      proof.  Prove that the informational projection respects book identity.
- [ ] `BOOK-INFO-LIFTED-MAP`: lifted informational book projection.  Define
      the quotient map from the book quotient to the informational quotient.
- [ ] `BOOK-INFO-QREC-USE`: quotient eliminator for informational book
      projection.  Build the lifted informational projection by quotient
      elimination.

## Passenger Identity Porting Gates

| Gate | Subobligation | Gate label | Coq target | Agda target |
| --- | --- | --- | --- | --- |
| `PGATE-RAW-CARRIER` | `PASS-RAW-CARRIER` | check raw passenger carrier | define Coq RawPassenger | define Agda RawPassenger |
| `PGATE-IDENTITY-REL` | `PASS-IDENTITY-REL` | check passenger identity relation | define Coq same-passenger | define Agda same-passenger |
| `PGATE-CN-SETOID` | `PASS-CN-SETOID` | package passenger CN setoid | define Coq PassengerCN | define Agda PassengerCN |
| `PGATE-QUOTIENT-INTERFACE` | `PASS-QUOTIENT-INTERFACE` | instantiate passenger quotient interface | define Coq passenger quotient interface | define Agda QP module |
| `PGATE-IDENTITY-PATH` | `PASS-IDENTITY-PATH` | prove passenger identity path | prove Coq passenger identity path | prove Agda passenger-identity-path |

## Modified Carrier Porting Gates

| Gate | Subobligation | Gate label | Coq target | Agda target |
| --- | --- | --- | --- | --- |
| `MODGATE-RAW-CARRIER` | `MOD-RAW-CARRIER` | check raw modified carrier | define Coq RawModified | define Agda RawModified |
| `MODGATE-INHERITED-IDENTITY` | `MOD-INHERITED-IDENTITY` | check inherited modified identity | define Coq same-modified | define Agda same-modified |
| `MODGATE-CN-SETOID` | `MOD-CN-SETOID` | package modified CN setoid | define Coq ModifiedCN | define Agda ModifiedCN |
| `MODGATE-WITNESS-COLLAPSE` | `MOD-WITNESS-COLLAPSE` | check modifier witness collapse | prove Coq witness collapse coherence | prove Agda witness collapse coherence |
| `MODGATE-QUOTIENT-INTERFACE` | `MOD-QUOTIENT-INTERFACE` | instantiate modified quotient interface | define Coq modified quotient interface | define Agda QM module |

## Modified Projection Porting Gates

| Gate | Subobligation | Gate label | Coq target | Agda target |
| --- | --- | --- | --- | --- |
| `MPGATE-RAW-MAP` | `MPROJ-RAW-MAP` | modified-to-base raw projection | define Coq modified-to-base raw map | define Agda modified-to-base-raw |
| `MPGATE-RESP-PROOF` | `MPROJ-RESP-PROOF` | modified projection respectfulness proof | prove Coq modified projection respectfulness | prove Agda modified-to-base-raw-resp |
| `MPGATE-LIFTED-MAP` | `MPROJ-LIFTED-MAP` | lifted modified-to-base map | define Coq modified-to-base lifted map | define Agda modified-to-base |
| `MPGATE-QREC-USE` | `MPROJ-QREC-USE` | quotient eliminator for modified projection | use Coq quotient eliminator for modified projection | use Agda QM.qrec for modified projection |

## Book Projection Porting Gates

| Gate | Subobligation | Gate label | Coq target | Agda target |
| --- | --- | --- | --- | --- |
| `BGATE-PHYS-RAW-MAP` | `BOOK-PHYS-RAW-MAP` | physical book raw projection | define Coq book-to-physical raw map | define Agda book-to-physical-raw |
| `BGATE-PHYS-RESP-PROOF` | `BOOK-PHYS-RESP-PROOF` | physical book projection respectfulness proof | prove Coq physical book projection respectfulness | prove Agda book-to-physical-raw-resp |
| `BGATE-PHYS-LIFTED-MAP` | `BOOK-PHYS-LIFTED-MAP` | lifted physical book projection | define Coq book-to-physical lifted map | define Agda book-to-physical |
| `BGATE-PHYS-QREC-USE` | `BOOK-PHYS-QREC-USE` | quotient eliminator for physical book projection | use Coq quotient eliminator for physical book projection | use Agda QBk.qrec for physical book projection |
| `BGATE-INFO-RAW-MAP` | `BOOK-INFO-RAW-MAP` | informational book raw projection | define Coq book-to-informational raw map | define Agda book-to-informational-raw |
| `BGATE-INFO-RESP-PROOF` | `BOOK-INFO-RESP-PROOF` | informational book projection respectfulness proof | prove Coq informational book projection respectfulness | prove Agda book-to-informational-raw-resp |
| `BGATE-INFO-LIFTED-MAP` | `BOOK-INFO-LIFTED-MAP` | lifted informational book projection | define Coq book-to-informational lifted map | define Agda book-to-informational |
| `BGATE-INFO-QREC-USE` | `BOOK-INFO-QREC-USE` | quotient eliminator for informational book projection | use Coq quotient eliminator for informational book projection | use Agda QBk.qrec for informational book projection |

## Interface Separation

- [ ] Treat identity-path lemmas as the raw-to-quotient path interface:
      identity-criterion proofs induce paths between embedded raw candidates.
- [ ] Treat setoid-map factorisation as the CN-to-CN interface:
      `(A,R) -> (B,S)` induces `A/R -> B/S`.
- [ ] Treat set-valued observation invariance as the CN-to-set interface:
      an identity-respecting `A -> B` induces `A/R -> B`.
- [ ] Do not use CN-to-set observation invariance to claim preservation of a
      target common noun's identity criterion.
- [ ] Do not use CN-to-CN factorisation to claim the converse representation
      theorem for arbitrary set-valued observations.

## Semantic Side Conditions

- [x] Mark all observation targets that must be sets in the Coq-facing
      recursor and every current observation caller.
- [ ] Decide where modifier evidence is represented as propositional or
      truncated evidence.
- [ ] Keep dot-type projections separate from quotient identity criteria:
      dot-types explain multi-aspect predication, while quotient HITs encode
      the common noun identity criterion.

## Scope Discipline

- [x] Mark the current observations as non-dependent and set-valued.
- [x] Apply the converse representation schema only to non-dependent
      set-valued observations.
- [ ] Do not use the set-valued schema as a substitute for dependent quotient
      elimination.
- [ ] Add separate obligations for dependent eliminations whose targets vary
      over inhabitants of the quotient.
- [ ] Add separate coherence obligations for any later interaction with
      coercive subtyping or dot-type projection rules.
