open Omamls
open Character

(********** command line interface **********)
let () = 
  print_endline "\n\nWelcome to the Cornell RPG.\n";
  print_endline "Please enter your character name:";
  print_string "> ";
  let name = read_line () in 
  print_endline ("Your character name will be " ^ name ^ ".");
  print_endline "Please enter your character's major: \n\ 
                \"CS\", \"ECE\", \"MechE\", \"ChemE\", \"CivilE\", or \"IS\". \
                Default major is CS!";
  let major = read_line () in 
  print_endline ("Your character major will be " ^ major ^ ".");
  let major1 = match major with 
  | "CS" -> CS
  | "ECE" -> ECE
  | "MechE" -> MechE
  | "ChemE" -> ChemE
  | "CivilE" -> CivilE
  | "IS" -> IS 
  | _ -> CS in 
  let charac = create name major1 in 
  print_endline ("Character named " ^ charac.name ^ " majoring in " ^ major ^ 
  " has been created.");
  print_endline "Your character is ready for battle.";

