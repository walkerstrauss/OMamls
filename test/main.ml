open OUnit2
open Omamls
open Character
open Item

(********************************************************************
   Character Tests
 ********************************************************************)

let char1 = Character.create "Talia" CS

let tests = "Omamls test suite" >::: [
  ("Character name change">::fun _ -> (assert_equal "Momo" (Character.rename "Momo" char1).name));
  ("Character major change">::fun _ -> (assert_equal ECE (Character.change_maj ECE char1).major));
  ("Character change hp - still alive">::fun _ -> (assert_equal (10,100) (Character.change_hp (-90) char1).health));
  ("Character change hp - still alive">::fun _ -> (assert_equal Alive (Character.change_hp (-90) char1).status));
  ("Character change hp - dead">::fun _ -> (assert_equal ((-20),100) (Character.change_hp (-120) char1).health));
  ("Character change hp - dead">::fun _ -> (assert_equal Dead (Character.change_hp (-120) char1).status));
]
let _ = run_test_tt_main tests