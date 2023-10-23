open Character
open Item
open Ability

let get_user_choice (message : string) = 
  print_endline (message);
  print_string "> ";;

let print_abilities (char1 : character): string =
  let print_ability ability : string =
    match ability with 
    | None -> "No Ability"
    | Some a -> a.name
  in  "Please select the following options (1-3):\n
  1. " ^ (print_ability (List.hd char1.abilities)) ^ "\n
  2. " ^ (print_ability (List.nth char1.abilities 1)) ^ "\n
  3. " ^ (print_ability (List.nth char1.abilities 2)) ^ "\n
  4. " ^ (print_ability (List.nth char1.abilities 3) ^ "\n")
  
let print_inventory (char1: character): string = 
  let invent = char1.inventory in 
  let rec print_int (inventory : item list) (counter : int) : string = match inventory with 
  | [] -> ""
  | h :: t -> "\n" ^ string_of_int counter ^ ": " ^ h.name ^ (print_int t (counter + 1)) 
  in ("Please select the following items (1 - " ^ (string_of_int (List.length invent)) ^ "): " ^ (print_int invent 1))

let rec ability_action (player: character) (ability: (effect_type * int) list): character = 
  match ability with
  | [] -> player
  | h :: t -> let updated_player = match h with
    | (Damage damage, _ ) -> (Character.change_hp (-damage) player)
    | (RemoveItem, _) -> if(List.length player.inventory = 0) then (print_endline("No items to be removed!"); player) 
      else (let (_, x) = (Character.remove_item (List.hd player.inventory) player) in (x))
    | (AddItem, _) -> Character.add_item (List.nth consumables_catelog (Random.int 2)) player
    | (_, _) -> player 
  in ability_action updated_player t

let rec attack (char1 : character) (char2 : character) : (character * character) = 
  let choice = (if (char1.host = Computer) then ((Random.int 4) + 1) 
    else (read_int (get_user_choice (print_abilities char1)))) in 
  let ab = (match choice with 
  |1 -> (List.hd char1.abilities)
  |2 -> (List.nth char1.abilities 1)
  |3 -> (List.nth char1.abilities 2)
  |4 -> (List.nth char1.abilities 3) 
  | _ -> Printf.printf("Not an option.\n"); raise Not_found)
  in match ab with
  | None -> Printf.printf ("No ability.\n"); attack char1 char2
  | Some x -> (match x.effect with
      | (Some (e1), Some (e2)) -> (print_endline(char1.name ^ " " ^ e1.description); (ability_action char1 e1.effect), 
          (print_endline(char2.name ^  " " ^ e2.description); (ability_action char2 e2.effect)))
      | (Some (e1), None) -> (print_endline(char1.name ^  " " ^ e1.description); (ability_action char1 e1.effect), char2)
      | (None, Some (e2)) -> (char1, (print_endline(char2.name ^  " " ^ e2.description); (ability_action char2 e2.effect)))
      | (None, None) -> (char1, char2))

let rec items (char1: character) : character = 
  let choice = if (char1.host = Computer) then ((Random.int (List.length char1.inventory)) + 1)
   else (read_int (get_user_choice (print_inventory char1))) in 
   let item = (if (List.length char1.inventory = 0) then (print_endline("Inventory empty!\n"); raise Not_found) 
  else (List.nth char1.inventory (choice-1)))in 
   match item.category with 
   | Consumable (hp_increase, _) -> (let (_, updated_char) = Character.remove_item item char1 
      in (print_endline(char1.name ^ " has used " ^ item.name ^ ". " ^ "Character's health has increased by " 
        ^ (string_of_int hp_increase)^"!\n"); Character.change_hp hp_increase updated_char)) 
   | _ -> Printf.printf("We can't use this item during battle. \n"); items char1

let flee (char1: character): character = 
  if((Random.int 1000) < 25) then(raise Not_found) else (print_endline("Failed to flee battle!"); char1)

let rec move (char1 : character) (char2 : character) : character * character = 
  let move_options = "Select an option (1-3):\n 1. Attack\n 2. Items\n 3. Flee\n" in 
  let choice = if (char1.host = Computer) then (Random.int 2) + 1 else (read_int (get_user_choice move_options)) in 
  match choice with
  |1 ->  (try print_endline(char1.name ^ " has started an attack!"); attack char1 char2 with
    | Not_found -> attack char1 char2)
  |2 -> (try let updated_char = (items char1) in (updated_char, char2) with 
    | _ -> print_endline("Can't get item."); move char1 char2)
  |3 -> (try (flee char1, char2) with 
    | Not_found -> raise (Invalid_argument(char1.name ^ " has fled the battle!")) 
    | _ -> (char1, char2))
  |_ -> Printf.printf("Not a option. \n"); move char1 char2


let battle (char1: character) (char2: character): character = 
  let rec battle_progression (player1 : character) (player2 : character) (turns : int) : character = 
    let (updated_player1, updated_player2) = print_endline("Turn: " ^ (string_of_int (turns/2)) ^ " (" 
      ^ player1.name ^ ")\n" ^ player1.name ^ "'s health: " ^ (let (x, _) = player1.health in string_of_int x) 
      ^ "\n"  ^ player2.name ^ "'s health: " ^ (let (x, _) = player2.health in string_of_int x) ^ "\n"); 
      move player1 player2 in 
    if((updated_player1.status = Alive && updated_player2.status = Alive)) 
      then (battle_progression updated_player2 updated_player1 (turns + 1)) 
      else (if(updated_player1.host = User) then (Printf.printf("Finished battle!"); updated_player1) 
        else (Printf.printf ("Finished battle! "); updated_player2))
  in Printf.printf ("Begin battle!\n\n"); battle_progression char1 char2 2
