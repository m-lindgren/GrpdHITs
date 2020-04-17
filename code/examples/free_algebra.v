(** Here we define the signature for the circle *)
Require Import UniMath.Foundations.All.
Require Import UniMath.MoreFoundations.All.

Require Import UniMath.CategoryTheory.Core.Categories.
Require Import UniMath.CategoryTheory.Groupoids.
Require Import UniMath.Bicategories.Core.Bicat.
Import Bicat.Notations.
Require Import UniMath.Bicategories.Core.Examples.OneTypes.

Require Import UniMath.Algebra.Monoids.
Require Import UniMath.Algebra.Groups.

Require Import prelude.all.
Require Import signature.hit_signature.
Require Import signature.hit.
Require Import algebra.one_types_polynomials.
Require Import algebra.one_types_endpoints.
Require Import algebra.one_types_homotopies.
Require Import displayed_algebras.displayed_algebra.
Require Import initial_grpd_alg.W_poly.
Require Import initial_grpd_alg.initial_groupoid_algebra.
Require Import existence.hit_existence.

Local Open Scope cat.

Definition TODO {A : UU} : A.
Admitted.

(**
NOTE: look for good intermediate definitions to make.
Eg, preserves `A` and projections of 1-cells and 2-cells of algebras
 *)

(** Free `Σ'-algebra generated by `A` *)
Section FreeAlg.
  Variable (Σ : hit_signature)
           (A : one_type).

  Definition free_alg_signature_point_constr
    : poly_code
    := point_constr Σ + C A.

  Definition to_free_alg_endpoint
             {P Q : poly_code}
             (e : endpoint (point_constr Σ) P Q)
    : endpoint free_alg_signature_point_constr P Q.
  Proof.
    induction e as [P | P Q R e₁ IHe₁ e₂ IHe₂
                    | P Q | P Q | P Q | P Q
                    | P Q R e₁ IHe₁ e₂ IHe₂
                    | P T t | C₁ C₂ g | ].
    - (* identity *)
      exact (id_e _ _).
    - (* composition *)
      exact (comp IHe₁ IHe₂).
    - (* left inclusion *)
      exact (ι₁ _ _).
    - (* right inclusion *)
      exact (ι₂ _ _).
    - (* left projection *)
      exact (π₁ _ _).
    - (* right projection *)
      exact (π₂ _ _).
    - (* pair *)
      exact (pair IHe₁ IHe₂).
    - (* constant element *)
      exact (c _ t).
    - (* constant map *)
      exact (fmap g).
    - (* constructor *)
      exact (comp (ι₁ _ _) constr).
  Defined.

  Definition free_alg_signature_path_left
             (j : path_label Σ)
    : endpoint free_alg_signature_point_constr (path_source Σ j) I
    := to_free_alg_endpoint (path_left Σ j).

  Definition free_alg_signature_path_right
             (j : path_label Σ)
    : endpoint free_alg_signature_point_constr (path_source Σ j) I
    := to_free_alg_endpoint (path_right Σ j).

  Definition free_alg_signature_path_arg_left
             (j : homot_label Σ)
    : endpoint
        free_alg_signature_point_constr
        (homot_point_arg Σ j)
        (homot_path_arg_target Σ j)
    := to_free_alg_endpoint (homot_path_arg_left Σ j).

  Definition free_alg_signature_path_arg_right
             (j : homot_label Σ)
    : endpoint
        free_alg_signature_point_constr
        (homot_point_arg Σ j)
        (homot_path_arg_target Σ j)
    := to_free_alg_endpoint (homot_path_arg_right Σ j).

  Definition free_alg_signature_homot_left_endpoint
             (j : homot_label Σ)
    : endpoint free_alg_signature_point_constr (homot_point_arg Σ j) I
    := to_free_alg_endpoint (homot_left_endpoint Σ j).

  Definition free_alg_signature_homot_right_endpoint
             (j : homot_label Σ)
    : endpoint free_alg_signature_point_constr (homot_point_arg Σ j) I
    := to_free_alg_endpoint (homot_right_endpoint Σ j).

  Definition free_alg_signature_homot_endpoint
             {Q TR T : poly_code}
             {al ar : endpoint (point_constr Σ) Q TR}
             {sl sr : endpoint (point_constr Σ) Q T}
             (p : homot_endpoint
                    (path_left Σ)
                    (path_right Σ)
                    al ar
                    sl sr)
    : homot_endpoint
        free_alg_signature_path_left
        free_alg_signature_path_right
        (to_free_alg_endpoint al)
        (to_free_alg_endpoint ar)
        (to_free_alg_endpoint sl)
        (to_free_alg_endpoint sr).
  Proof.
    induction p as [T e | T e₁ e₂ p IHp | T e₁ e₂ e₃ p₁ IHp₁ p₂ IHp₂
                    | T₁ T₂ e₁ e₂ e₃ h IHh
                    | R₁ R₂ T e₁ e₂ e₃ | T e | T e
                    | P R e₁ e₂ | P R e₁ e₂
                    | T₁ T₂ e₁ e₂ e₃ e₄ p₁ IHp₁ p₂ IHp₂
                    | P₁ P₂ P₃ e₁ e₂ e₃
                    | Z x T e | j e | ].
    - (* reflexivity *)
      exact (refl_e _).
    - (* symmetry *)
      exact (inv_e IHp).
    - (* transitivity *)
      exact (trans_e IHp₁ IHp₂).
    - (* ap *)
      exact (ap_e (to_free_alg_endpoint e₃) IHh).
    - (* associativity of composition *)
      apply comp_assoc.
    - (* left unitality *)
      apply comp_id_l.
    - (* right unitality *)
      apply comp_id_r.
    - (* first projection of pair *)
      apply pair_π₁.
    - (* second projection of pair *)
      apply pair_π₂.
    - (* pair of paths *)
      exact (path_pair IHp₁ IHp₂).
    - (* composition with pair *)
      apply comp_pair.
    - (* composition with constant *)
      apply comp_constant.
    - (* path constructor *)
      exact (path_constr j (to_free_alg_endpoint e)).
    - (* path argument *)
      apply path_arg.
  Defined.

  Definition free_alg_signature_homot_left_path
             (j : homot_label Σ)
    : homot_endpoint
        free_alg_signature_path_left
        free_alg_signature_path_right
        (free_alg_signature_path_arg_left j)
        (free_alg_signature_path_arg_right j)
        (free_alg_signature_homot_left_endpoint j)
        (free_alg_signature_homot_right_endpoint j)
    := free_alg_signature_homot_endpoint (homot_left_path Σ j).

  Definition free_alg_signature_homot_right_path
             (j : homot_label Σ)
    : homot_endpoint
        free_alg_signature_path_left
        free_alg_signature_path_right
        (free_alg_signature_path_arg_left j)
        (free_alg_signature_path_arg_right j)
        (free_alg_signature_homot_left_endpoint j)
        (free_alg_signature_homot_right_endpoint j)
    := free_alg_signature_homot_endpoint (homot_right_path Σ j).
 
  Definition free_alg_signature
    : hit_signature.
  Proof.
    simple refine (_ ,, _ ,, _ ,, _ ,, _ ,, _ ,, _ ,, _ ,, _ ,, _  ,, _ ,, _ ,, _ ,, _).
    - exact free_alg_signature_point_constr.
    - exact (path_label Σ).
    - exact (path_source Σ).
    - exact free_alg_signature_path_left.
    - exact free_alg_signature_path_right.
    - exact (homot_label Σ).
    - exact (homot_point_arg Σ).
    - exact (homot_path_arg_target Σ).
    - exact free_alg_signature_path_arg_left.
    - exact free_alg_signature_path_arg_right.
    - exact free_alg_signature_homot_left_endpoint.
    - exact free_alg_signature_homot_right_endpoint.
    - exact free_alg_signature_homot_left_path.
    - exact free_alg_signature_homot_right_path.
  Defined.

  (** Necessary lemma *)
  Definition free_alg_sem_endpoint_UU
             {P Q : poly_code}
             (e : endpoint (point_constr Σ) P Q)
             {X : UU}
             (c : poly_act (point_constr Σ) X ⨿ A → X)
             (x : poly_act P X)
    : sem_endpoint_UU e (λ z, c(inl z)) x
      =
      sem_endpoint_UU (to_free_alg_endpoint e) c x.
  Proof.
    induction e as [P | P Q R e₁ IHe₁ e₂ IHe₂
                    | P Q | P Q | P Q | P Q
                    | P Q R e₁ IHe₁ e₂ IHe₂
                    | P T t | C₁ C₂ g | ].
    - (* identity *)
      apply idpath.
    - (* composition *)
      exact (maponpaths _ (IHe₁ _) @ IHe₂ _).
    - (* left inclusion *)
      apply idpath.
    - (* right inclusion *)
      apply idpath.
    - (* left projection *)
      apply idpath.
    - (* right projection *)
      apply idpath.
    - (* pair *)
      exact (pathsdirprod (IHe₁ _) (IHe₂ _)).
    - (* constant element *)
      apply idpath.
    - (* constant map *)
      apply idpath.
    - (* constructor *)
      apply idpath.
  Defined.

  Definition free_alg_sem_endpoint_UU_natural
             {P Q : poly_code}
             (e : endpoint (point_constr Σ) P Q)
             {X Y : UU}
             {cX : poly_act (point_constr Σ) X ⨿ A → X}
             {cY : poly_act (point_constr Σ) Y ⨿ A → Y}
             {f : X → Y}
             (cf : ∏ x, f(cX x) = cY (poly_map (point_constr Σ + C A) f x))
             (x : poly_act P X)
    : sem_endpoint_UU_natural (to_free_alg_endpoint e) cf x
      =
      maponpaths (poly_map Q f) (!(free_alg_sem_endpoint_UU e cX x))
      @ sem_endpoint_UU_natural e (λ z, cf(inl z)) x
      @ free_alg_sem_endpoint_UU e cY (poly_map P f x).
  Proof.
    induction e as [P | P Q R e₁ IHe₁ e₂ IHe₂
                    | P Q | P Q | P Q | P Q
                    | P Q R e₁ IHe₁ e₂ IHe₂
                    | P T t | C₁ C₂ g | ].
    - (* identity *)
      apply idpath.
    - (* composition *)
      simpl.
      etrans.
      {
        apply maponpaths_2.
        apply IHe₂.
      }
      clear IHe₂.
      etrans.
      {
        do 2 apply maponpaths.
        apply IHe₁.
      }
      clear IHe₁.
      refine (!(path_assoc _ _ _) @ _).
      refine (!_).
      etrans.
      {
        apply maponpaths_2.
        etrans.
        {
          apply maponpaths.
          apply pathscomp_inv.
        }
        apply maponpathscomp0.
      }
      refine (!(path_assoc _ _ _) @ _).
      apply maponpaths.
      refine (!_).
      etrans.
      {
        apply maponpaths.
        etrans.
        {
          apply maponpaths.
          apply path_assoc.
        }
        apply maponpathscomp0.
      }
      refine (path_assoc _ _ _ @ _).
      refine (!_).
      refine (path_assoc _ _ _ @ _).
      etrans.
      {
        apply maponpaths.
        apply homotsec_natural'.
      }
      refine (path_assoc _ _ _ @ _).
      apply maponpaths_2.
      refine (!(path_assoc _ _ _) @ _).
      etrans.
      {
        apply maponpaths.
        refine (!(path_assoc _ _ _) @ _).
        apply maponpaths.
        apply homotsec_natural'.
      }
      do 2 refine (path_assoc _ _ _ @ _).
      refine (!_).
      etrans.
      {
        apply maponpaths.
        apply maponpathscomp0.
      }
      refine (path_assoc _ _ _ @ _).
      apply maponpaths_2.
      refine (!path_assoc _ _ _ @ _).
      etrans.
      {
        apply maponpaths.
        etrans.
        {
          apply maponpaths.
          apply maponpathscomp.
        }
        refine (!_).
        apply (homotsec_natural'
                 (λ z, free_alg_sem_endpoint_UU
                         e₂ cY (poly_map Q f z))).
      }
      refine (path_assoc _ _ _ @ _).
      apply maponpaths_2.
      etrans.
      {
        refine (!_).
        apply (homotsec_natural'
                 (sem_endpoint_UU_natural
                    e₂
                    (λ z : poly_act (point_constr Σ) X, cf (inl z)))).
      }
      apply maponpaths_2.
      refine (!_).
      etrans.
      {
        apply maponpaths.
        refine (!_).
        apply maponpathsinv0.
      }
      apply maponpathscomp.
    - (* left inclusion *)
      apply idpath.
    - (* right inclusion *)
      apply idpath.
    - (* left projection *)
      apply idpath.
    - (* right projection *)
      apply idpath.
    - (* pair *)
      simpl.
      refine (!_).
      etrans.
      {
        etrans.
        {
          apply maponpaths_2.
          etrans.
          {
            apply maponpaths.
            apply pathsdirprod_inv.
          }
          refine (!_).
          apply maponpaths_pathsdirprod.
        }
        etrans.
        {
          apply maponpaths.
          apply pathsdirprod_concat.
        }
        apply pathsdirprod_concat.
      }
      refine (!_).
      exact (paths_pathsdirprod (IHe₁ _) (IHe₂ _)).
    - (* constant element *)
      apply idpath.
    - (* constant map *)
      apply idpath.
    - (* constructor *)
      apply idpath.
  Qed.
  
  Definition free_alg_sem_endpoint_UU_natural'
             {P Q : poly_code}
             (e : endpoint (point_constr Σ) P Q)
             {X Y : UU}
             {cX : poly_act (point_constr Σ) X ⨿ A → X}
             {cY : poly_act (point_constr Σ) Y ⨿ A → Y}
             {f : X → Y}
             (cf : ∏ x, f(cX x) = cY (poly_map (point_constr Σ + C A) f x))
             (x : poly_act P X)
    : maponpaths (poly_map Q f) (free_alg_sem_endpoint_UU e cX x)
      @ sem_endpoint_UU_natural (to_free_alg_endpoint e) cf x
      @ !(free_alg_sem_endpoint_UU e cY (poly_map P f x))
      =
      sem_endpoint_UU_natural e (λ z, cf(inl z)) x.
  Proof.
    etrans.
    {
      apply maponpaths.
      etrans.
      {
        apply maponpaths_2.
        apply free_alg_sem_endpoint_UU_natural.
      }
      refine (!(path_assoc _ _ _) @ _).
      apply maponpaths.
      refine (!(path_assoc _ _ _) @ _).
      etrans.
      {
        apply maponpaths.
        apply pathsinv0r.
      }
      apply pathscomp0rid.
    }
    refine (path_assoc _ _ _ @ _).
    etrans.
    {
      apply maponpaths_2.
      etrans.
      {
        refine (!_).
        apply maponpathscomp0.
      }
      apply maponpaths.
      apply pathsinv0r.
    }
    apply idpath.
  Qed.

  (** Projections of an algebra *)             
  Section FreeAlgProjections.
    Variable (X : hit_algebra_one_types free_alg_signature).

    Definition free_alg_is_prealg
      : hit_prealgebra_one_types Σ.
    Proof.
      use make_hit_prealgebra.
      - exact (alg_carrier X).
      - apply (one_type_isofhlevel (pr111 X)).
      - exact (λ x, alg_constr X (inl x)).
    Defined.

    Definition free_alg_is_path_alg
      : hit_path_algebra_one_types Σ.
    Proof.
      use make_hit_path_algebra.
      - exact free_alg_is_prealg.
      - exact (λ j x,
               free_alg_sem_endpoint_UU _ _ _
               @ alg_path X j x
               @ !(free_alg_sem_endpoint_UU _ _ _)).
    Defined.

    Definition free_alg_is_alg
      : hit_algebra_one_types Σ.
    Proof.
      use make_algebra.
      - exact free_alg_is_path_alg.
      - apply TODO.
    Defined.

    Definition free_alg_inc
      : A → alg_carrier free_alg_is_alg
      := λ a, alg_constr X (inr a).
  End FreeAlgProjections.

  (** Builder of algebras *)
  Section FreeAlgBuilder.
    Variable (X : hit_algebra_one_types Σ)
             (inc : A → alg_carrier X).

    Definition make_free_alg_prealgebra
      : hit_prealgebra_one_types free_alg_signature.
    Proof.
      use make_hit_prealgebra.
      - exact (alg_carrier X).
      - apply (one_type_isofhlevel (pr111 X)).
      - intro x.
        induction x as [x | x].
        + exact (alg_constr X x).
        + exact (inc x).
    Defined.

    Definition make_free_alg_path_algebra
      : hit_path_algebra_one_types free_alg_signature.
    Proof.
      use make_hit_path_algebra.
      - exact make_free_alg_prealgebra.
      - exact (λ j x,
               !(free_alg_sem_endpoint_UU _ _ _)
               @ alg_path X j x
               @ free_alg_sem_endpoint_UU _ _ _).
    Defined.
    
    Definition make_free_alg_algebra
      : hit_algebra_one_types free_alg_signature.
    Proof.
      use make_algebra.
      - exact make_free_alg_path_algebra.
      - apply TODO.
    Defined.
  End FreeAlgBuilder.

  (** Projections of 1-cells *)
  Definition preserves_A
             {X Y : hit_algebra_one_types Σ}
             (f : X --> Y)
             (Xa : A → alg_carrier X)
             (Ya : A → alg_carrier Y)
    : UU
    := ∏ (a : A),
       alg_map_carrier f (Xa a) = Ya a.
  
  Section FreeAlgMapProjections.
    Context {X Y : hit_algebra_one_types free_alg_signature}
            (f : X --> Y).

    Definition free_alg_map_prealg_mor
      : pr11 (free_alg_is_alg X) --> pr11 (free_alg_is_alg Y).
    Proof.
      use make_hit_prealgebra_mor.
      - exact (alg_map_carrier f).
      - exact (λ x, alg_map_commute f (inl x)).
    Defined.

    Definition free_alg_map_preserves_path
      : preserves_path _ (prealg_map_commute free_alg_map_prealg_mor).
    Proof.
      intros j x.
      etrans.
      {
        apply maponpaths.
        refine (!_).
        apply (free_alg_sem_endpoint_UU_natural' (path_right Σ j)).
      }
      simpl.
      refine (path_assoc _ _ _ @ _).
      etrans.
      {
        apply maponpaths_2.
        etrans.
        {
          refine (!_).
          apply maponpathscomp0.
        }
        apply maponpaths.
        refine (!(path_assoc _ _ _) @ _).
        apply maponpaths.
        refine (!(path_assoc _ _ _) @ _).
        etrans.
        {
          apply maponpaths.
          apply pathsinv0l.
        }
        apply pathscomp0rid.
      }
      refine (path_assoc _ _ _ @ _).
      do 2 refine (_ @ !(path_assoc _ _ _)).
      apply maponpaths_2.
      etrans.
      {
        apply maponpaths_2.
        apply maponpathscomp0.
      }
      refine (!(path_assoc _ _ _) @ _).
      etrans.
      {
        apply maponpaths.
        exact (alg_map_path f j x).
      }
      refine (path_assoc _ _ _ @ _).
      apply maponpaths_2.
      refine (!_).
      etrans.
      {
        apply maponpaths_2.
        refine (!_).
        apply (free_alg_sem_endpoint_UU_natural' (path_left Σ j)).
      }
      simpl.
      refine (!(path_assoc _ _ _) @ _).
      apply maponpaths.
      refine (!(path_assoc _ _ _) @ _).
      refine (_ @ pathscomp0rid _).
      apply maponpaths.
      apply pathsinv0l.
    Qed.
        
    Definition free_alg_map_alg_mor
      : free_alg_is_alg X --> free_alg_is_alg Y.
    Proof.
      use make_algebra_map.
      use make_hit_path_alg_map.
      - exact free_alg_map_prealg_mor.
      - exact free_alg_map_preserves_path.
    Defined.

    Definition free_alg_map_on_A
      : preserves_A
          free_alg_map_alg_mor
          (free_alg_inc X)
          (free_alg_inc Y)
      := λ a, alg_map_commute f (inr a).
  End FreeAlgMapProjections.

  Section FreeAlgMapBuilder.
    Context {X Y : hit_algebra_one_types free_alg_signature}
            (f : free_alg_is_alg X --> free_alg_is_alg Y)
            (Hf : preserves_A f (free_alg_inc X) (free_alg_inc Y)).

    Definition make_free_alg_prealg_mor
      : pr11 X --> pr11 Y.
    Proof.
      use make_hit_prealgebra_mor.
      - exact (alg_map_carrier f).
      - intro x.
        induction x as [x | x].
        + exact (alg_map_commute f x).
        + exact (Hf x).
    Defined.

    Definition make_free_alg_preserves_path
      : preserves_path _ (prealg_map_commute make_free_alg_prealg_mor).
    Proof.
      intros j x ; simpl.
      etrans.
      {
        apply maponpaths.
        apply (free_alg_sem_endpoint_UU_natural (path_right _ _)).
      }
      refine (!_).
      etrans.
      {
        apply maponpaths_2.
        apply (free_alg_sem_endpoint_UU_natural (path_left _ _)).
      }
      simpl.
      refine (!(path_assoc _ _ _) @ _).
      etrans.
      {
        apply maponpaths_2.
        apply maponpathsinv0.
      }
      use path_inv_rotate_ll.
      refine (!_).
      do 2 refine (path_assoc _ _ _ @ _).
      etrans.
      {
        apply maponpaths_2.
        etrans.
        {
          apply maponpaths_2.
          refine (!_).
          apply maponpathscomp0.
        }
        etrans.
        {
          refine (!_).
          apply maponpathscomp0.
        }
        apply maponpaths.
        exact (!(path_assoc _ _ _)).
      }
      refine (path_assoc _ _ _ @ _).
      etrans.
      {
        apply maponpaths_2.
        exact (alg_map_path f j x).
      }
      refine (!(path_assoc _ _ _) @ _ @ path_assoc _ _ _).
      apply maponpaths.
      simpl.
      refine (!(path_assoc _ _ _) @ _).
      apply maponpaths.
      refine (!(path_assoc _ _ _) @ _ @ pathscomp0rid _).
      apply maponpaths.
      apply pathsinv0l.
    Qed.

    Definition make_free_alg_mor
      : X --> Y.
    Proof.
      use make_algebra_map.
      use make_hit_path_alg_map.
      - exact make_free_alg_prealg_mor.
      - exact make_free_alg_preserves_path.
    Defined.
  End FreeAlgMapBuilder.

  (** Projections of 2-cells *)
  Section FreeAlgCellProjections.
    Context {X Y : hit_algebra_one_types free_alg_signature}
            {f g : X --> Y}
            (τ : f ==> g).

    Definition free_alg_cell_alg_cell
      : free_alg_map_alg_mor f ==> free_alg_map_alg_mor g.
    Proof.
      use make_algebra_2cell.
      - exact (alg_2cell_carrier τ).
      - abstract
          (intro x ;
           cbn in x ;
           refine (alg_2cell_commute τ (inl x) @ _) ; simpl ;
           apply maponpaths ;
           apply maponpathscomp).
    Defined.

    Definition free_alg_cell_on_A
               (a : A)
      : alg_2cell_carrier τ (alg_constr X (inr a)) @ alg_map_commute g (inr a)
        =
        alg_map_commute f (inr a).
    Proof.
      exact (alg_2cell_commute τ (inr a) @ pathscomp0rid _).
    Qed.
  End FreeAlgCellProjections.

  (** Builder of 2-cells *)
  Section FreeAlgCellBuilder.
    Context {X Y : hit_algebra_one_types free_alg_signature}
            {f g : X --> Y}
            (τ : free_alg_map_alg_mor f ==> free_alg_map_alg_mor g)
            (Hτ : ∏ (a : A),
                  alg_2cell_carrier τ (alg_constr X (inr a)) @ alg_map_commute g (inr a)
                  =
                  alg_map_commute f (inr a)).

    Definition make_free_alg_cell
      : f ==> g.
    Proof.
      use make_algebra_2cell.
      - exact (alg_2cell_carrier τ).
      - abstract
          (intros x ;
           induction x as [x | x] ;
           [ refine (alg_2cell_commute τ x @ _) ; simpl ;
             apply maponpaths ;
             refine (!_) ;
             apply (maponpathscomp inl)
           | simpl ;
             exact (Hτ x @ !(pathscomp0rid _))]).
    Qed.
  End FreeAlgCellBuilder.
  
  (** Mapping principles of free algebra *)
  Section FreeAlgMapping.
    Variable (X : hit_algebra_one_types free_alg_signature)
             (HX : is_initial _ X).

    (** Mapping principle for 1-cells *)
    Section FreeAlgMapOne.
      Variable (Y : hit_algebra_one_types Σ)
               (Yinc : A → alg_carrier Y).
      
      Definition free_alg_one_cell
        : free_alg_is_alg X --> Y.
      Proof.
        apply TODO.
      Defined.

      Definition free_alg_one_cell_on_A
                 (a : A)
        : pr111 free_alg_one_cell (free_alg_inc X a) = Yinc a.
      Proof.
        apply TODO.
      Defined.
    End FreeAlgMapOne.

    (** Mapping principle for 2-cells. *)
    Section FreeAlgMapTwo.
      Variable (Y : hit_algebra_one_types Σ)
               (Yinc : A → alg_carrier Y)
               (f g : free_alg_is_alg X --> Y)
               (Hf : preserves_A f (free_alg_inc X) Yinc)
               (Hg : preserves_A g (free_alg_inc X) Yinc).

      Definition free_alg_two_cell
        : f ==> g.
      Proof.
        pose Hf. pose Hg.
        apply TODO.
      Defined.
    End FreeAlgMapTwo.

    (** Mapping principles for equalities *)
    Section FreeAlgMapEq.
      Variable (Y : hit_algebra_one_types Σ)
               (Yinc : A → alg_carrier Y)
               (f g : free_alg_is_alg X --> Y)
               (Hf : preserves_A f (free_alg_inc X) Yinc)
               (Hg : preserves_A g (free_alg_inc X) Yinc).

    End FreeAlgMapEq.
  End FreeAlgMapping.
End FreeAlg.
