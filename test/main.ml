open OUnit2
open Omamls
open Character

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

(********************************************************************
   Item Tests
 ********************************************************************)

(********************************************************************
   Battle Tests
 ********************************************************************)

let one_ability_char = Character.add_ability (List.hd Ability.abilities) (Character.create "" ECE 4 100 0)
let empty_ability_char = (Character.create "" ECE 4 100 0)

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
      assert_equal ability_test_one_ability (Battle.print_abilities one_ability_char)
        ~printer:(fun x -> x) );
    ( "Print abilities for no abilities" >:: fun _ ->
      assert_equal ability_test_no_abilities
        (Battle.print_abilities empty_ability_char) ~printer:(fun x -> x) );
  ]

let test =
  "Test Suite for OMamls: Cornell RPG"
  >::: List.flatten [ character_tests; battle_tests ]

let _ = run_test_tt_main test
