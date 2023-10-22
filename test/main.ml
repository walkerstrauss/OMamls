open OUnit2
open Omamls
open Character

(********************************************************************
   Character Tests
 ********************************************************************)

let char1 = Character.create "Talia" CS 4 100 0 User
let char2 = Character.create "" CS 4 100 0 User

let tests = [
  ("Character creation | Name: Untitled">::fun _ -> (assert_equal "Untitled" char2.name));
  ("Character name change">::fun _ -> (assert_equal "Momo" (Character.rename "Momo" char1).name));
  ("Character name change">::fun _ -> (assert_equal "Untitled" (Character.rename "" char1).name));
  ("Character major change">::fun _ -> (assert_equal ECE (Character.change_maj ECE char1).major));
  ("Character change hp - still alive">::fun _ -> (assert_equal (10,100) (Character.change_hp (-90) char1).health));
  ("Character change hp - still alive">::fun _ -> (assert_equal Alive (Character.change_hp (-90) char1).status));
  ("Character change hp - dead">::fun _ -> (assert_equal ((-20),100) (Character.change_hp (-120) char1).health));
  ("Character change hp - dead">::fun _ -> (assert_equal Dead (Character.change_hp (-120) char1).status));
]

let char2 = Character.add_ability (List.hd Ability.abilities) char1
let char2_ability_test = "Please select the following options (1-3):\n 
1. Pickpocket \n 
2. No Ability \n 
3. No Ability \n 4. No Ability"

let build_tests = [
  ("Character print abilities" >::fun _ -> (assert_equal char2_ability_test (Battle.print_abilities char2)))
]

let test = "Test Suite for OMamls: Cornell RPG"
  >::: List.flatten [tests; build_tests]

let _ = run_test_tt_main test