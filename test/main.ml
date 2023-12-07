open OUnit2
open Omamls
open Character
open Ability

(********************************************************************
   Character Tests
 ********************************************************************)

let char1 = Character.create "Talia" CS 4 100 0
let char2 = Character.create "" CS 4 100 0

let character_tests =
  [
    ( "Character creation | Name: Untitled" >:: fun _ ->
      assert_equal "Untitled" char2.name );
    ( "Character name change" >:: fun _ ->
      assert_equal "Momo" (Character.rename "Momo" char1).name );
    ( "Character name change" >:: fun _ ->
      assert_equal "Untitled" (Character.rename "" char1).name );
    ( "Character major change" >:: fun _ ->
      assert_equal ECE (Character.change_maj ECE char1).major );
    ( "Character change hp - still alive" >:: fun _ ->
      assert_equal (10, 100) (Character.change_hp (-90) char1).health );
    ( "Character change hp - still alive" >:: fun _ ->
      assert_equal Alive (Character.change_hp (-90) char1).status );
    ( "Character change hp - dead" >:: fun _ ->
      assert_equal (-20, 100) (Character.change_hp (-120) char1).health );
    ( "Character change hp - dead" >:: fun _ ->
      assert_equal Dead (Character.change_hp (-120) char1).status );
  ]

(********************************************************************
    Ability Tests
  ********************************************************************)

let a1 = Ability.create_ability "Punch" [ ("Strength", 1) ] (None, None)

let a2 =
  Ability.create_ability ""
    [ ("", 2) ]
    ( Some { description = "has been punched!"; effect = [ (Damage 20, 1) ] },
      None )

let e1 = Ability.create_effect "has been hit" [ (Damage 10, 1) ]
let e2 = Ability.create_effect "" []

let ability_tests =
  [
    ( "Create ability with no effects name" >:: fun _ ->
      assert_equal "Punch" a1.name );
    ( "Create ability with no effects required" >:: fun _ ->
      assert_equal [ ("Strength", 1) ] a1.required );
    ( "Create ability with no effects effects" >:: fun _ ->
      assert_equal (None, None) a1.effect );
    ("Create ability with effects name" >:: fun _ -> assert_equal "" a2.name);
    ( "Create ability with effects required" >:: fun _ ->
      assert_equal [ ("", 2) ] a2.required );
    ( "Create ability with effects effects" >:: fun _ ->
      assert_equal
        ( Some { description = "has been punched!"; effect = [ (Damage 20, 1) ] },
          None )
        a2.effect );
    ( "Create effect with description has been hit" >:: fun _ ->
      assert_equal "has been hit" e1.description );
    ( "Create effect with damage 10" >:: fun _ ->
      assert_equal [ (Damage 10, 1) ] e1.effect );
    ( "Create effect with no description" >:: fun _ ->
      assert_equal "" e2.description );
    ("Create effect with no effect" >:: fun _ -> assert_equal [] e2.effect);
  ]
(********************************************************************
   Item Tests
 ********************************************************************)

(********************************************************************
   Battle Tests
 ********************************************************************)

let one_ability_char =
  Character.add_ability
    (List.hd Ability.abilities)
    (Character.create "" ECE 4 100 0)

let empty_ability_char = Character.create "" ECE 4 100 0

let ability_test_one_ability =
  "Please select the following options (1 - 4):\n\
  \ 1. Punch\n\
  \ 2. No Ability\n\
  \ 3. No Ability\n\
  \ 4. No Ability\n"

let ability_test_no_abilities =
  "Please select the following options (1 - 4):\n\
  \ 1. No Ability\n\
  \ 2. No Ability\n\
  \ 3. No Ability\n\
  \ 4. No Ability\n"

let battle_tests =
  [
    ( "Character print abilities" >:: fun _ ->
      assert_equal ability_test_one_ability
        (Battle.print_abilities one_ability_char) ~printer:(fun x -> x) );
    ( "Print abilities for no abilities" >:: fun _ ->
      assert_equal ability_test_no_abilities
        (Battle.print_abilities empty_ability_char) ~printer:(fun x -> x) );
  ]

let test =
  "Test Suite for OMamls: Cornell RPG"
  >::: List.flatten [ character_tests; battle_tests; ability_tests ]

let _ = run_test_tt_main test
