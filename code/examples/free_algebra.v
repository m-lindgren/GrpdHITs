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

  Definition free_alg_signature
    : hit_signature.
  Proof.
    apply TODO.
  Defined.

  (** Projections of an algebra *)             
  Section FreeAlgProjections.
    Variable (X : hit_algebra_one_types free_alg_signature).
    
    Definition free_alg_is_alg
      : hit_algebra_one_types Σ.
    Proof.
      pose X.
      apply TODO.
    Defined.

    Definition free_alg_inc
      : A → alg_carrier free_alg_is_alg.
    Proof.
      pose X.
      apply TODO.
    Defined.
  End FreeAlgProjections.

  (** Builder of algebras *)
  Section FreeAlgBuilder.
    Variable (X : hit_algebra_one_types Σ)
             (inc : A → alg_carrier X).

    Definition make_free_alg_algebra
      : hit_algebra_one_types free_alg_signature.
    Proof.
      pose X. pose inc.
      apply TODO.
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
       pr111 f (Xa a) = Ya a.
  
  Section FreeAlgMapProjections.
    Context {X Y : hit_algebra_one_types free_alg_signature}
            (f : X --> Y).

    Definition free_alg_map_carrier
      : free_alg_is_alg X --> free_alg_is_alg Y.
    Proof.
      pose f.
      apply TODO.
    Defined.

    Definition free_alg_map_on_A
      : preserves_A
          free_alg_map_carrier
          (free_alg_inc X)
          (free_alg_inc Y).
    Proof.
      pose f.
      apply TODO.
    Defined.
  End FreeAlgMapProjections.

  Section FreeAlgMapBuilder.
    Context {X Y : hit_algebra_one_types free_alg_signature}
            (f : free_alg_is_alg X --> free_alg_is_alg Y)
            (Hf : preserves_A f (free_alg_inc X) (free_alg_inc Y)).

    Definition make_free_alg_map
      : X --> Y.
    Proof.
      pose Hf.
      apply TODO.
    Defined.
  End FreeAlgMapBuilder.

  (** Projections of 2-cells *)
  

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
