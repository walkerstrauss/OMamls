open OUnit2
open Omamls
open Character
open Ability
open Item

(** Test Plan:
  Item.ml, Abilities.ml, Character.ml were tested through OUnit, and some functions within battle.ml 
  were tested through OUnit. While, the rest of the files were manually tested, as we were testing
  for the user's input and actions. The test cases were developed through using black and glass box 
  ideology on each function to test for edge cases. This is to ensure that when the user plays the RPG
  that the game is running, and functioning as intended regardless of the User's choices in the game.
*)

(********************************************************************
   Character Tests
 ********************************************************************)

let char1 = Character.create "Talia" CS 4 100 0
let char2 = Character.create "" CS 4 100 0
let chargen1 = Character.generate ([ "John" ], [ "Cena" ]) [ CS ] [] [] [] 3
let iced_tea = List.hd Item.consumables_catelog
let cornell_id = List.hd Item.supplies_catelog
let multichar1 = char1 |> add_item iced_tea
let multichar2 = char1 |> add_item iced_tea |> add_item iced_tea

let multichar3 =
  char1 |> add_item iced_tea |> add_item iced_tea |> add_item iced_tea

let multichar4 = char1 |> add_item iced_tea |> add_item cornell_id
let punch = List.hd Ability.abilities
let slap = List.hd (List.tl Ability.abilities)
let abilichar1 = char1 |> add_ability punch

let abilichar4 =
  char1 |> add_ability punch |> add_ability punch |> add_ability punch
  |> add_ability punch

let character_tests =
  [
    ( "Character creation | Name: Untitled" >:: fun _ ->
      assert_equal "Untitled" char2.name ~printer:(fun x -> x) );
    ( "Character renaming | Name: Untitled" >:: fun _ ->
      assert_equal "Untitled" (char1 |> rename "").name ~printer:(fun x -> x) );
    ( "Character name change" >:: fun _ ->
      assert_equal "Momo" (Character.rename "Momo" char1).name
        ~printer:(fun x -> x) );
    ( "Character name change" >:: fun _ ->
      assert_equal "Untitled" (Character.rename "" char1).name
        ~printer:(fun x -> x) );
    ("Character generation" >:: fun _ -> assert_equal "John Cena" chargen1.name);
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
    ( "Character empty inventory" >:: fun _ ->
      assert_equal 0 (List.length char1.inventory) );
    ( "Character add item" >:: fun _ ->
      assert_equal 1 (List.length (char1 |> add_item iced_tea).inventory) );
    ( "Character remove from none" >:: fun _ ->
      assert_equal (None, char1) (char1 |> remove_item iced_tea) );
    ( "Character remove item" >:: fun _ ->
      assert_equal (Some iced_tea, char1) (multichar1 |> remove_item iced_tea)
    );
    ( "Character remove item dupe" >:: fun _ ->
      assert_equal
        (Some iced_tea, multichar1)
        (multichar2 |> remove_item iced_tea)
        ~printer:(fun (_, x) -> string_of_int (List.length x.inventory)) );
    ( "Character remove item triple dupe" >:: fun _ ->
      assert_equal
        (Some iced_tea, multichar2)
        (multichar3 |> remove_item iced_tea)
        ~printer:(fun (_, x) -> string_of_int (List.length x.inventory)) );
    ( "Character remove item with multiple in inventory" >:: fun _ ->
      assert_equal
        (Some cornell_id, multichar1)
        (multichar4 |> remove_item cornell_id)
        ~printer:(fun (_, x) -> string_of_int (List.length x.inventory)) );
    ( "Character add ability" >:: fun _ ->
      assert_equal [ "Punch" ] (abilities_to_list abilichar1) );
    ( "Character must overwrite ability" >:: fun _ ->
      assert_equal abilichar4 (add_ability punch abilichar4) );
    ( "Character override ability" >:: fun _ ->
      assert_equal
        [ "Slap"; "Punch"; "Punch"; "Punch" ]
        (abilities_to_list (overwrite_ability slap punch abilichar4)) );
    ( "Character override dupe" >:: fun _ ->
      assert_equal
        [ "Punch"; "Punch"; "Punch"; "Punch" ]
        (abilities_to_list (overwrite_ability punch punch abilichar4)) );
  ]

(********************************************************************
   Item Tests
 ********************************************************************)

let i1 = Item.make_item "name" "description" (Consumable (20, 4))
let i2 = Item.make_item "name2" "description2" (Consumable (40, 3))

let item_tests =
  [
    ("Test make_item with name" >:: fun _ -> assert_equal "name" i1.name);
    ( "Test make_item with description" >:: fun _ ->
      assert_equal "description" i1.description );
    ( "Test make_item with category" >:: fun _ ->
      assert_equal (Consumable (20, 4)) i1.category );
    ("Test make_item with name2" >:: fun _ -> assert_equal "name2" i2.name);
    ( "Test make_item with description" >:: fun _ ->
      assert_equal "description2" i2.description );
    ( "Test make_item with category" >:: fun _ ->
      assert_equal (Consumable (40, 3)) i2.category );
    ( "Test rename with name2" >:: fun _ ->
      assert_equal "Walker" (rename_item i2 "Walker").name );
    ( "Test rename with name2 part 2" >:: fun _ ->
      assert_equal "Momo" (rename_item i1 "Momo").name );
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

(********************************************************************
   Data Reader Tests
 ********************************************************************)

let d1 = [ [ "Punch"; "Celcius" ]; [ "Slap"; "Cornell Dairy Ice Cream" ] ]

let d2 =
  [ [ "Slap"; "iPad" ]; [ "Punch"; "MacBook" ]; [ "Meditate"; "Celcius" ] ]

let d3 =
  [
    [ "Punch"; "false"; ""; "1"; "true"; "has been punched!"; "20" ];
    [ "Slap"; "false"; ""; "1"; "true"; "has been slapped!"; "10" ];
  ]

let d4 =
  [
    [
      "Iced Tea";
      "Ice Cold Delicious Beverage. Heals 20 Health";
      "Consumable";
      "20";
      "4";
    ];
  ]

let d5 =
  [
    [ "Test"; "1"; "30"; "placeholder"; "1"; "Test" ];
    [ "Dinner"; "1"; "0"; "placeholder"; "1"; "Special" ];
  ]

let d6 =
  [
    [
      "Dorm";
      "West";
      "Hans Bethe House";
      "";
      "";
      "";
      "";
      "Dinner";
      "1";
      "0";
      "placeholder";
      "1";
      "Special";
      "Test";
      "1";
      "30";
      "placeholder";
      "1";
      "Test";
    ];
  ]

let data_reader_tests =
  [
    ( "Test abilities_helper with d1" >:: fun _ ->
      assert_equal
        [ Ability.punch; Ability.slap ]
        (Data_reader.abilities_helper d1) );
    ( "Test abilities_helper with empty list" >:: fun _ ->
      assert_equal [] (Data_reader.abilities_helper []) );
    ( "Test abilities_helper with longer list d2" >:: fun _ ->
      assert_equal
        [ Ability.slap; Ability.punch; Ability.meditate ]
        (Data_reader.abilities_helper d2) );
    ( "Test items_helper with d1" >:: fun _ ->
      assert_equal
        [ Item.celcius; Item.ice_cream ]
        (Data_reader.items_helper d1) );
    ( "Test items_helper with empty list" >:: fun _ ->
      assert_equal [] (Data_reader.items_helper []) );
    ( "Test items_helper with longer list d2" >:: fun _ ->
      assert_equal
        [ Item.ipad; Item.mac; Item.celcius ]
        (Data_reader.items_helper d2) );
    ( "Test abilities_of_data with d3" >:: fun _ ->
      assert_equal
        [ Ability.punch; Ability.slap ]
        (Data_reader.abilities_of_data d3) );
    ( "Test abilities_of_data with []" >:: fun _ ->
      assert_equal [] (Data_reader.abilities_of_data []) );
    ( "Test items_of_data with d4" >:: fun _ ->
      assert_equal [ Item.iced_tea ] (Data_reader.items_of_data d4) );
    ( "Test items_of_data with []" >:: fun _ ->
      assert_equal [] (Data_reader.items_of_data []) );
    ( "Test events_of_data with d5" >:: fun _ ->
      assert_equal [ Event.test; Event.dinner ] (Data_reader.events_of_data d5)
    );
    ( "Test events_of_data with empty list" >:: fun _ ->
      assert_equal [] (Data_reader.events_of_data []) );
    ( "Test locations_of_data with d6" >:: fun _ ->
      assert_equal
        (Location.Dorm (West, "Hans Bethe House"))
        (d6 |> Data_reader.locations_of_data |> List.hd).place );
    ( "Test locations_of_data with d6" >:: fun _ ->
      assert_equal
        [ Location.hans_bethe_house ]
        (d6 |> Data_reader.locations_of_data) );
  ]

let test =
  "Test Suite for OMamls: Cornell RPG"
  >::: List.flatten
         [
           character_tests;
           battle_tests;
           ability_tests;
           item_tests;
           data_reader_tests;
         ]

let _ = run_test_tt_main test
