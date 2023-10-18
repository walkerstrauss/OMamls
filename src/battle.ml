open Character
open Item
open Ability

let rec get_user_choice () =
  Printf.printf "Select an option (1-3):\n";
  Printf.printf "1. Attack\n";
  Printf.printf "2. Items\n";
  Printf.printf "3. Flee\n";

let print_abilities (char1 : character) =
  let print_ability (ab) (num) =
    match ab with 
    | None -> Printf.printf "No ability\n";
    | Some a -> Printf.printf (num ^ a.name ^ "\n");
  in 

  let ability1 = List.hd char1.abilities in 
  let ability2 = List.nth char1.abilities 1 in
  let ability3 = List.nth char1.abilities 2 in
  let ability4 = List.nth char1.abilities 3 in
  
  let () = print_ability ability1 "1. " in
  let () = print_ability ability2 "2. " in 
  let () = print_ability ability3 "3. " in
  let () = print_ability ability4 "4. " in 

  ()

let attack (char1 : character) (char2 : character) : () = 
  let () = print_abilities char1 in 
  let choice = int_of_string (read_line()) in 
  match choice with 
  |1 -> Character.change_hp (List.hd char1.abilities).effect char2
  |2 -> Character.change_hp (List.nth char1.abilities 1).effect char2
  |3 -> Character.change_hp (List.nth char1.abilities 2).effect char2
  |4 -> Character.change_hp (List.nth char1.abilities 3).effect char2
  in 
  ()

let rec move (char1 : character) (char2 : character) = 
  let () = get_user_choice () in 
  let choice = int_of_string (read_line()) in 
  match choice with
  |1 ->  let () = attack char1 char2 in
  |2 -> let () = items char1 in
  |3 -> let () = flee char1 in
  in 
  if (char1.status = Alive && char2.status = Alive) then move char1 char2 else ()

