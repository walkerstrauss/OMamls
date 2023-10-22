open Omamls
open Character
(*let first_names = 
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
*)
(********** command line interface **********)
let () = 
  print_endline "\n\nWelcome to the Cornell RPG.\n";
  print_endline "Please enter your character name:";
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
  let charac = create name major1 4 100 0 User in
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

