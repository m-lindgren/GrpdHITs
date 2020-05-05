(**
We determine that the path space of the group quotient
 *)
Require Import UniMath.Foundations.All.
Require Import UniMath.MoreFoundations.All.
Require Import UniMath.Algebra.Monoids.
Require Import UniMath.Algebra.Groups.

Require Import UniMath.CategoryTheory.Core.Categories.
Require Import UniMath.CategoryTheory.Core.Functors.
Require Import UniMath.CategoryTheory.Core.NaturalTransformations.
Require Import UniMath.CategoryTheory.Groupoids.
Require Import UniMath.CategoryTheory.Core.Isos.
Require Import UniMath.Bicategories.Core.Bicat.
Import Bicat.Notations.
Require Import UniMath.Bicategories.Core.Adjunctions.
Require Import UniMath.Bicategories.Core.Examples.OneTypes.
Require Import UniMath.Bicategories.Colimits.Initial.

Require Import UniMath.Bicategories.PseudoFunctors.Display.Base.
Require Import UniMath.Bicategories.PseudoFunctors.Display.Map1Cells.
Require Import UniMath.Bicategories.PseudoFunctors.Display.Map2Cells.
Require Import UniMath.Bicategories.PseudoFunctors.Display.Identitor.
Require Import UniMath.Bicategories.PseudoFunctors.Display.Compositor.
Require Import UniMath.Bicategories.PseudoFunctors.Display.PseudoFunctorBicat.
Require Import UniMath.Bicategories.PseudoFunctors.PseudoFunctor.
Require Import UniMath.Bicategories.Transformations.PseudoTransformation.

Require Import prelude.all.
Require Import signature.hit_signature.
Require Import signature.hit.
Require Import algebra.one_types_polynomials.
Require Import algebra.one_types_endpoints.
Require Import algebra.one_types_homotopies.
Require Import algebra.groupoid_polynomials.
Require Import algebra.groupoid_endpoints.
Require Import algebra.groupoid_homotopies.
Require Import displayed_algebras.displayed_algebra.
Require Import initial_grpd_alg.W_poly.
Require Import initial_grpd_alg.initial_groupoid_algebra.
Require Import initial_grpd_alg.is_initial.
Require Import existence.hit_existence.
Require Import examples.group_quotient.

Require Import fundamental_groups.loops.

Local Open Scope cat.


Definition TODO (A : UU) : A.
Admitted.
(**
Initial groupoid algebra for the group quotient constructed in a special way.
 *)

Variable (G : gr).

Definition group_quot_initial_algebra_precategory_data
  : precategory_data.
Proof.
  use make_precategory_data.
  - use make_precategory_ob_mor.
    + exact unit. 
    + exact (λ _ _, G).
  - exact (λ _, unel G).
  - exact (λ _ _ _, op).
Defined.

Definition group_quot_initial_algebra_is_precategory
  : is_precategory group_quot_initial_algebra_precategory_data.
Proof.
  use make_is_precategory.
  - exact (λ _ _, lunax G).
  - exact (λ _ _, runax G).
  - exact (λ _ _ _ _ x y z, ! assocax G x y z). 
  - exact (λ _ _ _ _, assocax G).
Qed.

Definition group_quot_initial_algebra_precategory
  : precategory.
Proof.
  use make_precategory.
  - exact group_quot_initial_algebra_precategory_data.
  - exact group_quot_initial_algebra_is_precategory.
Defined.

Definition group_quot_initial_algebra_homsets
  : has_homsets group_quot_initial_algebra_precategory.
Proof.
  intros x y.
  apply (pr11 G).
Qed.

Definition group_quot_initial_algebra_category
  : category.
Proof.
  use make_category.
  - exact group_quot_initial_algebra_precategory.
  - exact group_quot_initial_algebra_homsets.
Defined.

Definition group_quot_initial_algebra_is_pregroupoid
  : is_pregroupoid group_quot_initial_algebra_category.
Proof.
  intros ? ? x.
  use is_iso_qinv.
  - exact (grinv G x).
  - split.
    + exact (grrinvax G x).
    + exact (grlinvax G x).
Defined.

Definition group_quot_initial_algebra_carrier
  : groupoid.
Proof.
  use make_groupoid.
  - exact group_quot_initial_algebra_category.
  - exact group_quot_initial_algebra_is_pregroupoid.
Defined.

(** It forms a groupoid algebra *)
Definition group_quot_initial_algebra_base_data
  : functor_data
      (⦃ point_constr (group_quot_signature G) ⦄ group_quot_initial_algebra_carrier : groupoid)
      (group_quot_initial_algebra_carrier).
Proof.
  use make_functor_data.
  - exact (λ x, x).
  - exact (λ _ _ _, unel G).
Defined.

Definition group_quot_initial_algebra_base_is_functor
  : is_functor group_quot_initial_algebra_base_data.
Proof.
  split.
  - exact (λ _, idpath _).
  - exact (λ _ _ _ _ _, ! runax G  _).
Qed.

Definition group_quot_initial_algebra_base
  : (⦃ point_constr (group_quot_signature G) ⦄ group_quot_initial_algebra_carrier : groupoid)
    ⟶
    group_quot_initial_algebra_carrier.
Proof.
  use make_functor.
  - exact group_quot_initial_algebra_base_data.
  - exact group_quot_initial_algebra_base_is_functor.
Defined.

Definition group_quot_initial_prealgebra
  : hit_prealgebra_grpd (group_quot_signature G).
Proof.
  use make_hit_prealgebra_grpd.
  - exact group_quot_initial_algebra_carrier.
  - exact group_quot_initial_algebra_base.
Defined.

Definition group_quot_initial_algebra_loop
  : sem_endpoint_grpd_data_functor_data
      (group_quot_base_ep (group_quot_path_arg G tt))
      group_quot_initial_prealgebra
    ⟹
    sem_endpoint_grpd_data_functor_data
    (group_quot_base_ep (group_quot_path_arg G tt))
    group_quot_initial_prealgebra.
Proof.
  use make_nat_trans.
  - exact (λ x, x). 
  - intros x y eq.
    exact (lunax G y @ ! eq @ ! runax G x).
Defined.

Definition group_quot_initial_path_algebra
  : hit_path_algebra_grpd (group_quot_signature G).
Proof.
  use make_hit_path_algebra_grpd.
  - exact group_quot_initial_prealgebra.
  - exact (λ _, group_quot_initial_algebra_loop).
Defined.

Definition group_quot_initial_is_hit_algebra
  : is_hit_algebra_grpd
      (group_quot_signature G)
      group_quot_initial_path_algebra.
Proof.
  intros j x ?.
  induction j.
  - simpl; cbn.
    rewrite (grlinvax G _).
    repeat rewrite (lunax G _).
    apply idpath.
  - simpl; cbn.
    repeat rewrite (grlinvax G _).
    repeat rewrite (lunax G _).
    repeat rewrite (runax G _).
    apply idpath.
Qed.  

Definition group_quot_initial_algebra
  : hit_algebra_grpd (group_quot_signature G).
Proof.
  use make_algebra_grpd.
  - exact group_quot_initial_path_algebra.
  - exact group_quot_initial_is_hit_algebra.
Defined.


(* WIP from here *)







(** The UMP for 1-cells *)
Local Notation "f ^ z" := (morph_power f z).

Section Group_quotInitialAlgUMPOne.
  Variable (G : hit_algebra_grpd group_quot_signature).

  Local Notation "'Gloop'" := (pr1 (alg_path_grpd G loop) tt).

  Definition group_quot_initial_algebra_ump_1_carrier_data_0
    : alg_carrier_grpd G
    := alg_constr_grpd G tt.

  Definition group_quot_initial_algebra_ump_1_carrier_data_1
             (z : hz)
    : alg_carrier_grpd G ⟦ group_quot_initial_algebra_ump_1_carrier_data_0 ,
                           group_quot_initial_algebra_ump_1_carrier_data_0 ⟧
    := Gloop ^ z.
  
  Definition group_quot_initial_algebra_ump_1_carrier_data
    : functor_data
        group_quot_initial_algebra_precategory_data
        (alg_carrier_grpd G).
  Proof.
    use make_functor_data.
    - exact (λ _, group_quot_initial_algebra_ump_1_carrier_data_0).
    - exact (λ _ _, group_quot_initial_algebra_ump_1_carrier_data_1). 
  Defined.

  Definition group_quot_initial_algebra_ump_1_carrier_is_functor
    : is_functor group_quot_initial_algebra_ump_1_carrier_data.
  Proof.
    split.
    - exact (λ _, idpath _).
    - intros ? ? ?.
      cbn -[hz] ; unfold group_quot_initial_algebra_ump_1_carrier_data_1.
      intros f g.
      exact (morph_power_plus Gloop f g).
  Qed.

  Definition group_quot_initial_algebra_ump_1_carrier
    : group_quot_initial_algebra_carrier ⟶ alg_carrier_grpd G.
  Proof.
    use make_functor.
    - exact group_quot_initial_algebra_ump_1_carrier_data.
    - exact group_quot_initial_algebra_ump_1_carrier_is_functor.
  Defined.

  Definition group_quot_initial_algebra_ump_1_commute_data
    : nat_trans_data
        (functor_composite_data
           group_quot_initial_algebra_base_data
           group_quot_initial_algebra_ump_1_carrier_data)
        (functor_composite_data
           (poly_act_functor
              group_quot_point_constr
              group_quot_initial_algebra_ump_1_carrier)
           (alg_constr_grpd G)).
  Proof.
    intros x.
    induction x ; simpl.
    apply id₁.
  Defined.

  Definition group_quot_initial_algebra_ump_1_commute_is_nat_trans
    : is_nat_trans
        _ _
        group_quot_initial_algebra_ump_1_commute_data.
  Proof.
    intros x y f.
    induction x, y.
    simpl.
    cbn.
    rewrite !id_left.
    assert (f = idpath _) as p.
    { apply isapropunit. }
    rewrite p.
    exact (!(functor_id (alg_constr_grpd G : _ ⟶ _) _)).
  Qed.
    
  Definition group_quot_initial_algebra_ump_1_commute
    : functor_composite_data
        group_quot_initial_algebra_base_data
        group_quot_initial_algebra_ump_1_carrier_data
      ⟹
      functor_composite_data
        (poly_act_functor
           group_quot_point_constr
           group_quot_initial_algebra_ump_1_carrier)
        (alg_constr_grpd G).
  Proof.
    use make_nat_trans.
    - exact group_quot_initial_algebra_ump_1_commute_data.
    - exact group_quot_initial_algebra_ump_1_commute_is_nat_trans.
  Defined.

  Definition group_quot_initial_prealgebra_ump_1
    : pr11 group_quot_initial_algebra --> pr11 G.
  Proof.
    use make_hit_prealgebra_mor.
    - exact group_quot_initial_algebra_ump_1_carrier.
    - exact group_quot_initial_algebra_ump_1_commute.
  Defined.

  (** Might need to change once the definitions can be unfolded more *)
  Definition group_quot_initial_algebra_ump_1_path
             (j : path_label group_quot_signature)
             (x : unit)
    : # (pr11 group_quot_initial_prealgebra_ump_1)
        (group_quot_initial_algebra_loop_data x)
      · (pr112 group_quot_initial_prealgebra_ump_1) x
      =
      (pr112 group_quot_initial_prealgebra_ump_1) x · pr1 ((pr21 G) j) x.
  Proof.
    cbn.
    induction x, j.
    cbn.
    rewrite !id_right, id_left.
    apply idpath.
  Qed.
  
  Definition group_quot_initial_algebra_ump_1
    : group_quot_initial_algebra --> G.
  Proof.
    use make_algebra_map_grpd.
    use make_hit_path_alg_map_grpd.
    - exact group_quot_initial_prealgebra_ump_1.
    - exact group_quot_initial_algebra_ump_1_path.
  Defined.
End Group_quotInitialAlgUMPOne.


Definition functor_on_min_1
           {G : groupoid}
           (F : group_quot_initial_algebra_carrier ⟶ G)
  : #F (-(1))%hz
    =
    @grpd_inv _ (F tt) (F tt) (#F 1)%hz.
Proof.
  refine (_ @ id_left _).
  use move_grpd_inv_left.
  refine (!_).
  etrans.
  {
    exact (!(@functor_comp _ _ F tt tt tt _ _)).
  }
  refine (_ @ functor_id _ _).
  apply maponpaths.
  apply hzlminus.
Qed.

Definition group_quot_alg_mor_on_loop
           {G₁ G₂ : hit_algebra_grpd group_quot_signature}
           (F : G₁ --> G₂)
  : # (pr111 F : _ ⟶ _) (alg_path_grpd G₁ loop tt) · (pr112 (pr11 F)) tt
    =
    (pr112 (pr11 F)) tt · alg_path_grpd G₂ loop tt.
Proof.
  pose (pr21 F loop) as m.
  simpl in m.
  pose (nat_trans_eq_pointwise m tt) as p.
  exact p.
Qed.

Section Group_quotInitialAlgUMPTwo.
  Variable (G : hit_algebra_grpd group_quot_signature)
           (F₁ F₂ : group_quot_initial_algebra --> G).

  Definition group_quot_initial_algebra_ump_2_carrier_data
    : nat_trans_data (pr111 (pr1 F₁)) (pr111 (pr1 F₂))
    := λ x, pr11 (pr211 F₁) x · grpd_inv (pr11 (pr211 F₂) x).

  Definition group_quot_initial_algebra_ump_2_is_nat_trans
    : is_nat_trans _ _ group_quot_initial_algebra_ump_2_carrier_data.
  Proof.
    intros x y.
    induction x, y.
    unfold group_quot_initial_algebra_ump_2_carrier_data.
    intro f.
    refine (assoc _ _ _ @ _).
    refine (!_) ; use move_grpd_inv_left.
    revert f.
    use hz_ind ; simpl.
    - rewrite (functor_id (pr111 F₁)), id_left.
      rewrite (functor_id (pr111 F₂)), id_right.
      refine (_ @ assoc _ _ _).
      refine (!(id_right _) @ _).
      apply maponpaths.
      use move_grpd_inv_right.
      rewrite id_right.
      apply idpath.
    - intros n IHn.
      rewrite nattohzandS.
      etrans.
      {
        apply maponpaths_2.
        exact (@functor_comp _ _ (pr111 F₁) _ tt _ 1%hz (nattohz n)).
      }
      refine (assoc' _ _ _ @ _).
      etrans.
      {
        apply maponpaths.
        exact IHn.
      }
      clear IHn.
      rewrite !assoc.
      apply maponpaths_2.
      refine (!_).
      etrans.
      {
        apply maponpaths.
        exact (@functor_comp _ _ (pr111 F₂) _ tt _ 1%hz (nattohz n)).
      }
      rewrite !assoc.
      apply maponpaths_2.
      refine (!_).
      etrans.
      {
        apply maponpaths_2.
        exact (group_quot_alg_mor_on_loop F₁).
      }
      refine (assoc' _ _ _ @ _ @ assoc _ _ _).
      apply maponpaths.
      use move_grpd_inv_right.
      refine (_ @ assoc' _ _ _).
      use move_grpd_inv_left.
      exact (!(group_quot_alg_mor_on_loop F₂)).
    - intros n IHn.
      rewrite !toℤneg_S.
      etrans.
      {
        apply maponpaths_2.
        unfold hzminus.
        rewrite hzpluscomm.
        exact (@functor_comp _ _ (pr111 F₁) _ tt _ (-(1))%hz (toℤneg n)).
      }
      refine (assoc' _ _ _ @ _).
      etrans.
      {
        apply maponpaths.
        exact IHn.
      }
      clear IHn.
      rewrite !assoc.
      apply maponpaths_2.
      refine (!_).
      etrans.
      {
        apply maponpaths.
        unfold hzminus.
        rewrite hzpluscomm.
        exact (@functor_comp _ _ (pr111 F₂) _ tt _ (-(1))%hz (toℤneg n)).
      }
      rewrite !assoc.
      apply maponpaths_2.
      rewrite !functor_on_min_1.
      refine (_ @ assoc _ _ _).
      use move_grpd_inv_right.
      refine (!_).
      etrans.
      {
        do 2 (refine (assoc _ _ _ @ _) ; apply maponpaths_2).
        exact (group_quot_alg_mor_on_loop F₁).
      }
      rewrite !assoc'.
      apply maponpaths.
      pose (group_quot_alg_mor_on_loop F₂).
      refine (_ @ id_right _).
      use move_grpd_inv_right.
      refine (!_).
      etrans.
      {
        refine (assoc _ _ _ @ _) ; apply maponpaths_2.
        exact (!(group_quot_alg_mor_on_loop F₂)).
      }
      rewrite !assoc.
      refine (!_).
      use move_grpd_inv_left.
      rewrite id_left.
      refine (!_).
      use move_grpd_inv_left.
      apply idpath.
  Qed.
  
  Definition group_quot_initial_algebra_ump_2_carrier
    : pr111 (pr1 F₁) ⟹ pr111 (pr1 F₂).
  Proof.
    use make_nat_trans.
    - exact group_quot_initial_algebra_ump_2_carrier_data.
    - exact group_quot_initial_algebra_ump_2_is_nat_trans.
  Defined.

  Definition group_quot_initial_algebra_ump_2
    : F₁ ==> F₂.
  Proof.
    simple refine (((_ ,, _) ,, λ _, tt) ,, tt).
    - exact group_quot_initial_algebra_ump_2_carrier.
    - abstract
        (use nat_trans_eq ;
         [ apply (pr1 (pr111 G))
         | simpl ;
           intro x ;
           unfold group_quot_initial_algebra_ump_2_carrier_data ;
           rewrite <- assoc ;
           apply maponpaths ;
           rewrite (functor_id (pr21 (pr1 G))) ;
           refine (!_) ;
           apply move_grpd_inv_right ;
           rewrite id_right ;
           apply idpath]).
  Defined.
End Group_quotInitialAlgUMPTwo.

Section Group_quotInitialAlgUMPEq.
  Variable (G : hit_algebra_grpd group_quot_signature)
           (F₁ F₂ : group_quot_initial_algebra --> G)
           (τ₁ τ₂ : F₁ ==> F₂).

  Definition group_quot_ump_eq
    : τ₁ = τ₂.
  Proof.
    use subtypePath.
    { intro ; apply isapropunit. }
    use subtypePath.
    { intro ; use impred ; intro ; apply isapropunit. }
    use subtypePath.
    { intro ; apply grpd_bicat. }
    use nat_trans_eq.
    { apply (pr1 (pr111 G)). }
    intro x ; induction x.
    pose (nat_trans_eq_pointwise (pr211 τ₁) tt) as p.
    pose (nat_trans_eq_pointwise (pr211 τ₂) tt) as q.
    cbn in p, q.
    rewrite (functor_id (pr21 (pr1 G))), id_right in p.
    rewrite (functor_id (pr21 (pr1 G))), id_right in q.
    pose (maponpaths (λ z, z · grpd_inv (pr11 (pr211 F₂) tt)) (p @ !q)) as r.
    simpl in r.
    refine (_ @ r @ _).
    - rewrite <- assoc.
      refine (!(id_right _) @ _).
      apply maponpaths.
      apply move_grpd_inv_left.
      rewrite id_left.
      apply idpath.
    - rewrite <- assoc.
      refine (!_).
      refine (!(id_right _) @ _).
      apply maponpaths.
      apply move_grpd_inv_left.
      rewrite id_left.
      apply idpath.
  Qed.
End Group_quotInitialAlgUMPEq.

Definition group_quot_initial_algebra_unique_maps
  : unique_maps group_quot_initial_algebra.
Proof.
  use make_unique_maps.
  - exact group_quot_initial_algebra_ump_1.
  - intros G f g.
    use make_invertible_2cell.
    + exact (group_quot_initial_algebra_ump_2 G f g).
    + apply hit_alg_is_invertible_2cell.
  - exact group_quot_ump_eq.
Defined.    

(** Path space of the group_quot at base *)
Definition group_quot_path_space_base
  : UU
  := ((pr111 (initial_groupoid_algebra group_quot_signature) : groupoid)
        ⟦ poly_initial_alg group_quot_point_constr tt
        , poly_initial_alg group_quot_point_constr tt ⟧).

Definition group_quot_path_space_base_is_Z
  : group_quot_path_space_base ≃ hz.
Proof.
  pose (left_adjoint_equivalence_grpd_algebra_is_fully_faithful
          (unique_maps_unique_adj_eqv
             _ _ _
             (initial_groupoid_algebra_is_initial _)
             group_quot_initial_algebra_unique_maps)
          (poly_initial_alg group_quot_point_constr tt)
          (poly_initial_alg group_quot_point_constr tt))
    as f.
  exact (make_weq _ f).
Defined.

Definition group_quot_path_space_encode_decode
  : group_quot_base group_quot = group_quot_base group_quot
    ≃
    group_quot_path_space_base
  := hit_path_space
       group_quot_signature
       (poly_initial_alg group_quot_point_constr tt)
       (poly_initial_alg group_quot_point_constr tt).

Definition group_quot_path_space_is_Z
  : group_quot_base group_quot = group_quot_base group_quot ≃ hz
  := (group_quot_path_space_base_is_Z ∘ group_quot_path_space_encode_decode)%weq.
*)
