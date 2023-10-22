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
  1. " ^ (print_ability (List.hd char1.abilities)) ^ "\n 2. " ^ (print_ability (List.nth char1.abilities 2)) ^ "\n 
  3. " ^ (print_ability  (List.nth char1.abilities 2)) ^ "\n 4. " ^ (print_ability  (List.nth char1.abilities 2))
  
let print_inventory (char1: character): string = 
  let invent = char1.inventory in 
  let rec print_int (inventory : item list) (counter: int): string = match inventory with 
  | [] -> ""
  | h :: t -> "\n" ^ string_of_int counter ^ ": " ^ h.name ^ (print_int t (counter + 1)) 
  in ("Please select the following items (1 - " ^ (string_of_int (List.length invent)) ^ "): " ^ (print_int invent 0))

let rec ability_action (player: character) (ability: (effect_type * int) list): character = 
  match ability with
  | [] -> player
  | h :: t -> let updated_player = match h with
    | (Damage damage, _ ) -> (Character.change_hp (-damage) player)
    | (RemoveItem, _) -> let (_, x) = (Character.remove_item (List.hd player.inventory) player) in (x)
    | (AddItem, _) -> Character.add_item (List.nth consumables_catelog (Random.int 2)) player
    | (_, _) -> player 
  in ability_action x t

let rec attack (char1 : character) (char2 : character) : (character * character) = 
  let choice = (if (char1.host = Computer) then ((Random.int 4) + 1) 
    else (read_int (get_user_choice (print_abilities char1)))) in 
  let ab = (match choice with 
  |1 -> (List.hd char1.abilities)
  |2 -> (List.nth char1.abilities 1)
  |3 -> (List.nth char1.abilities 2)
  |4 -> (List.nth char1.abilities 3) 
  | _ -> Printf.printf("Not an option.\n"); attack char1 char2)
  in match ab with
  | None -> Printf.printf ("No ability.\n"); attack char1 char2
  | Some x -> (match x.effect with
      | (Some (e1), Some (e2)) -> ((ability_action char1 e1.effect), (ability_action char2 e2.effect)))

let rec items (char1: character) : character = 
  let choice = if (char1.host = Computer) then ((Random.int (List.length char1.inventory)) + 1)
   else (read_int (get_user_choice (print_inventory char1))) in 
   let item = List.nth char1.inventory choice in 
   match item with 
   | Consumable (hp_increase, _) -> (let (_, updated_char) = Character.remove_item item char1 
      in Character.change_hp hp_increase updated_char)
   | _ -> Printf.printf("We can't use this item during battle. \n"); items char1

let flee (char1: character): character = 
  if((Random.int 500) < 25) then(raise Invalid_argument("Fled Battle.")) else (char1)

let rec move (char1 : character) (char2 : character) : character * character = 
  let move_options = "Select an option (1-3):\n 1. Attack\n 2. Items\n 3. Flee\n" in 
  let choice = if (char1.host = Computer) then (Random.int 3) + 1 else (read_int (get_user_choice move_options)) in 
  match choice with
  |1 ->  attack char1 char2 
  |2 -> let updated_char = items char1 in (updated_char, char2)
  |3 -> (try flee char1 with 
    | Invalid_argument -> Printf.printf("End Battle");  
    | _ -> (char1, char2))
  |_ -> Printf.printf("Not a option. \n"); move char1 char2


let battle (char1 : character) (char2 : character): character = 
  let rec battle_progression (player1 : character) (player2 : character) (turns : int) : character = 
    let (updated_player1, updated_player2) = (Printf.printf ("Turn: " ^ (string_of_int (turn/2))); move player1 player2) in 
      if(updated_player1.status = Alive && updated_player2 = Alive) 
        then (battle_progression updated_player2 updated_player1 (turns + 1)) 
        else (if(updated_player1.host = User) then (Printf.printf("Finished battle!"); updated_player1) 
          else (Printf.printf ("Finished battle!"); updated_player2))
  in Printf.printf ("Begin battle!") in battle_progression char1 char2 2
