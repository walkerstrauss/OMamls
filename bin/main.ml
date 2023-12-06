open Omamls
open Character
open Battle
open Item
open Journey
open Helper

let first_names = 
  [
    "Walker";
    "Talia";
    "Momo";
    "Greg";
    "Cyrus";
    "Billy";
    "Lily";
    "Melissa";
    "Chris";
    "John";
  ]

  let last_names = 
  [
    "Strauss";
    "Rubeo";
    "Shummo";
    "Guerrier";
    "Irani";
    "Simonelli";
    "Winagle";
    "Eckert";
    "Stewart";
    "Smith"
  ]

let major_list = [CS; ECE; MechE; ChemE; CivilE; IS]

(********** command line interface **********)
let () = 
  clear_terminal ();
  print_endline "\n\nWelcome to the Cornell RPG.\n";
  print_endline "Please enter your character first last name:";
  print_string "> ";
  let name = read_line () in 
  print_endline ("\nYour character name will be " ^ name ^ ".");
  print_endline "\nPlease enter your character's major: \
                \n\"CS\", \"ECE\", \"MechE\", \"ChemE\", \"CivilE\", or \"IS\". \
                Default major is CS!";
  print_string "> ";
  let major = read_line () in 
  let major1 = match major with 
  | "CS" -> CS
  | "ECE" -> ECE
  | "MechE" -> MechE
  | "ChemE" -> ChemE
  | "CivilE" -> CivilE
  | "IS" -> IS 
  | _ -> CS in 
  let charac = (create name major1 4 100 0) in
  let major2 = match major1 with 
  | CS -> "CS"
  | ECE -> "ECE"
  | MechE -> "MechE"
  | ChemE -> "ChemE"
  | CivilE -> "CivilE"
  | IS -> "IS" in 
  print_endline ("Your character major will be " ^ major2 ^ ".");
  print_endline ("\nCharacter named " ^ charac.name ^ " majoring in " ^ major ^ 
  " has been created.");
  print_endline "\nYour character is ready for battle.";
  let charac_cpu = add_item (List.nth consumables_catelog 1) (add_item (List.hd consumables_catelog) (generate (first_names, last_names) major_list [] Ability.abilities Item.consumables_catelog 2)) in
  let battle_charac = add_item (List.nth consumables_catelog 1) (add_item (List.hd consumables_catelog) (add_ability (List.nth Ability.abilities 1) 
    (add_ability (List.hd Ability.abilities) charac))) in
  match battle battle_charac charac_cpu with
  | (user, End User, _) -> Printf.printf "%s has won the battle!" (fst user).name
  | (user, End Opponent, _) -> Printf.printf "%s as died. Game Over!" (fst user).name
  | _ -> raise (Invalid_argument "Unreachable")