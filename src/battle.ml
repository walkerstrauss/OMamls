open Character
open Item
open Ability
open Helper

(**A type to tell whose turn it currently is in a state*)
type turn = User | Opponent | End of turn

type battle_character = character * (effect_type * int) list
(** The character type while during a battle where it includes both the 
    character and the long term effects on the character*)

type state = battle_character * turn * battle_character
(** State of the battle. The point where the players are during a certain turn 
    in the battle*)

type env = state list
(**The collection of states that make up a battle start to finish*)

type battle_summary = {
  winner : character option;
  loser : character option;
  cycles : int;
  turns : int;
  env : env;  (** Type representing summary of battle *)
}

(** Prints out a message, and requests for the User to make a choice.*)
let get_user_choice (message : string) =
  print_endline message;
  print_string "> "

(** Creates a message string of the list of abilities the character has 
  currently to be used to attack.*)
let print_abilities (character : character) : string =
  let print_ability (ability : ability option) : string =
    match ability with None -> "No Ability" | Some a -> a.name
  in
  "Please select the following options (1 - 4):\n 1. "
  ^ print_ability (List.hd character.abilities)
  ^ "\n 2. "
  ^ print_ability (List.nth character.abilities 1)
  ^ "\n 3. "
  ^ print_ability (List.nth character.abilities 2)
  ^ "\n 4. "
  ^ print_ability (List.nth character.abilities 3)
  ^ "\n"

(** Recursively prints int *)
let rec read_int_rec x : int =
  try
    let ln = read_line x in
    int_of_string (String.trim ln)
  with Failure _ -> read_int_rec x

let print_inventory (character : character) : string =
  let init =
    "Please select the following options (1 - "
    ^ string_of_int (List.length character.inventory)
    ^ "):\n"
  in
  let rec print_items (items : item list) (count : int) : string =
    match items with
    | [] -> ""
    | h :: t ->
        " " ^ string_of_int count ^ ". " ^ h.name ^ " -> " ^ h.description
        ^ "\n"
        ^ print_items t (count + 1)
  in
  init ^ print_items character.inventory 1

let rec use_ability (user : battle_character) (opp : battle_character)
    (ability : ability) : (battle_character * battle_character) option =
  let { name; required; effect } = ability in
  if has_skills (fst user) required then
    match effect with
    | Some e1, None ->
        Printf.printf "%s used %s!\n" (fst user).name name;
        Some (apply_new_effect user e1, opp)
    | None, Some e2 ->
        Printf.printf "%s used %s on %s!\n" (fst user).name name (fst opp).name;
        Some (user, apply_new_effect opp e2)
    | Some e1, Some e2 ->
        Printf.printf "%s used %s!\n" (fst user).name name;
        Some (apply_new_effect user e1, apply_new_effect opp e2)
    | None, None -> None
  else None

and apply_new_effect (character : battle_character) (effect : effect) :
    battle_character =
  let rec app_aux (character : battle_character)
      (impacts : (effect_type * int) list) : battle_character =
    match impacts with
    | [] -> character
    | (Damage amt, n) :: t ->
        Printf.printf "%s : HP : %n -> %n took %n damage from the attack!\n"
          (fst character).name
          (fst (fst character).health)
          (fst (fst character).health - amt)
          amt;
        app_aux
          ( change_hp (-amt) (fst character),
            if n - 1 > 0 then (Damage amt, n - 1) :: snd character
            else snd character )
          t
    | (TurnSkip s, n) :: t ->
        app_aux
          ( fst character,
            if n > 0 then (TurnSkip s, n + 1) :: snd character
            else snd character )
          t
    | (Debuff d, n) :: t ->
        app_aux
          ( fst character,
            if n > 0 then (Debuff d, n) :: snd character else snd character )
          t
    | (Buff b, n) :: t ->
        app_aux
          ( fst character,
            if n > 0 then (Buff b, n) :: snd character else snd character )
          t
    | _ -> failwith "Todo"
  in
  app_aux character effect.effect

and apply_old_effects (character : battle_character) : battle_character =
  let rec app_aux (character : character) (effects : (effect_type * int) list)
      (remaining : (effect_type * int) list) : battle_character =
    match effects with
    | [] -> (character, remaining)
    | (Damage amt, n) :: t ->
        Printf.printf
          "%s : HP : %n -> %n took %n damage from a previous attack!\n"
          character.name
          (fst character.health - amt)
          (fst character.health) amt;
        app_aux
          (change_hp (-amt) character)
          t
          (if n - 1 > 0 then (Damage amt, n - 1) :: remaining else remaining)
    | (TurnSkip s, n) :: t ->
        app_aux character t
          (if n - 1 > 0 then (TurnSkip s, n - 1) :: remaining else remaining)
    | (Debuff d, n) :: t ->
        app_aux character t
          (if n - 1 > 0 then (Debuff d, n - 1) :: remaining else remaining)
    | (Buff b, n) :: t ->
        app_aux character t
          (if n - 1 > 0 then (Buff b, n - 1) :: remaining else remaining)
    | _ -> failwith "Todo"
  in
  app_aux (fst character) (snd character) []

and is_skipped (curr_effects : (effect_type * int) list) : bool =
  match
    List.find_opt
      (fun (effect, _) -> match effect with TurnSkip _ -> true | _ -> false)
      curr_effects
  with
  | Some (TurnSkip s, _) -> if Random.int 100 + 1 <= s then true else false
  | None -> false
  | _ -> false

and use_item (character : battle_character) (item : item) : battle_character =
  match item.category with
  | Consumable (hp, _) ->
      let inc =
        if hp + fst (fst character).health > snd (fst character).health then
          snd (fst character).health - fst (fst character).health
        else hp
      in
      Printf.printf "%s : HP : %n -> %n consumed some %s!\n"
        (fst character).name
        (fst (fst character).health)
        (fst (fst character).health + inc)
        item.name;
      (snd (remove_item item (change_hp inc (fst character))), snd character)
  | _ -> failwith "Can't use that here!"

(** Attacks from character 1 onto character 2. Character 1 has the option of using four abilities, 
    if the ability is none then the character gets to choose their attack abilities again! 
        Returns the new state of each character. *)
let rec attack (state : state) (n : int) : state =
  let er, ee, comp =
    match state with
    | user, User, opp -> (*clear_lines 7;*) (user, opp, User)
    | user, Opponent, opp -> (opp, user, Opponent)
    | _ -> failwith "Shouldn't be here"
  in
  match List.nth_opt (fst er).abilities (n - 1) with
  | Some (Some ability) -> (
      match use_ability er ee ability with
      | Some (er', ee') ->
          if comp = User then (er', Opponent, ee') else (ee', User, er')
      | None ->
          Printf.printf "%s does not have sufficient ability to do this.\n"
            (fst er).name;
          state)
  | _ ->
      Printf.printf "No ability.\n";
      state

(** Checks the character's item, and allows the character to use the item during battle for one turn.
    If item isn't of type consumable, then the character gets to choose another item again. *)
and item (character : battle_character) (n : int) : battle_character =
  match List.nth_opt (fst character).inventory (n - 1) with
  | Some i -> use_item character i
  | None ->
      Printf.printf "No item used!\n";
      character

(** Creates a probability if the character is successful at escaping and fleeing the battle. If successful, raises 
    an error, otherwise returns the character. *)
and flee (env : env) : env =
  match Random.int 1000 < 25 with
  | true -> (
      match List.hd env with
      | user, User, opp -> (user, End Opponent, opp) :: env
      | user, Opponent, opp -> (user, End User, opp) :: env
      | _ -> raise (Invalid_argument "Unreachable"))
  | false -> (
      match List.hd env with
      | user, User, opp ->
          Printf.printf "%s failed to flee!\n" (fst user).name;
          turn ((user, Opponent, opp) :: env)
      | user, Opponent, opp ->
          Printf.printf "%s failed to flee!\n" (fst opp).name;
          turn ((user, User, opp) :: env)
      | _ -> raise (Invalid_argument "Unreachable"))

(** Character move during battle. During this move, the character has the option
    of attack, item, and flee. Depending on the choice made, the character's 
    status or health changes. If the option wasn't either attack, item or flee,
    then the character gets to make the same choice again.*)
and turn (env : env) : env =
  match List.hd env with
  | user, User, opp -> (
      (*Graphics.battle "main" (fst user) (fst opp);*)
      Printf.printf "\n%s's Turn\n" (fst user).name;
      let user' = apply_old_effects user in
      if fst (fst user').health <= 0 then (user', End Opponent, opp) :: env
      else if is_skipped (snd user') then (
        Printf.printf "%s : HP -> %n is out for the round!\n" (fst user).name
          (fst (fst user).health);
        turn ((user', Opponent, opp) :: env))
      else
        let turn_options =
          "Select an option (1 - 3):\n 1. Attack\n 2. Items \n 3. Flee\n"
        in
        match read_int_rec (get_user_choice turn_options) with
        | 1 ->
            (*clear_lines 6;*)
            print_endline ((fst user').name ^ " chose to attack!");
            turn
              (attack (user', User, opp)
                 (read_int_rec (get_user_choice (print_abilities (fst user))))
              :: env)
        | 2 ->
            (*clear_lines 6;*)
            print_endline ((fst user').name ^ " is getting an item!");
            let user' =
              item user
                (read_int_rec (get_user_choice (print_inventory (fst user))))
            in
            turn ((user', User, opp) :: env)
        | 3 ->
            (*clear_lines 6;*)
            print_endline ((fst user').name ^ " is attempting to flee!");
            flee env
        | _ -> turn env)
  | user, Opponent, opp -> (
      (*Graphics.battle "main" (fst user) (fst opp);*)
      let opp' = apply_old_effects opp in
      if fst (fst opp').health <= 0 then (user, End User, opp') :: env
      else if is_skipped (snd opp') then turn ((user, User, opp') :: env)
      else
        match Random.int 50 + 1 with
        | x when x <= 30 ->
            Printf.printf "\n%s's Turn\n" (fst opp).name;
            print_endline ((fst opp').name ^ " chose to attack!");
            turn (attack (user, Opponent, opp') (Random.int 4 + 1) :: env)
        | x when x <= 45 ->
            let len = List.length (fst opp).inventory in
            if len > 0 then (
              Printf.printf "\n%s's Turn\n" (fst opp).name;
              print_endline ((fst opp').name ^ " is getting an item!");
              let opp' = item opp (Random.int len + 1) in
              turn ((user, Opponent, opp') :: env))
            else turn env
        | _ ->
            Printf.printf "\n%s's Turn\n" (fst opp).name;
            print_endline ((fst opp').name ^ " is attempting to flee!");
            flee env)
  | _, End _, _ -> env

let battle (user : character) (opp : character) : env =
  turn [ ((user, []), User, (opp, [])) ]

(** Function that creates a value of type [battle_summary] from the env. *)
let summary (env : env) : battle_summary =
  let rec summary_aux (env : env) (curr : battle_summary) =
    match env with
    | [] -> failwith "This battle is not completed yet!"
    | (user, User, opp) :: t ->
        if match t with (_, Opponent, _) :: _ -> true | _ -> false then
          summary_aux t
            {
              curr with
              cycles = curr.cycles + 1;
              turns = curr.turns + 1;
              env = (user, User, opp) :: curr.env;
            }
        else
          summary_aux t
            {
              curr with
              turns = curr.turns + 1;
              env = (user, User, opp) :: curr.env;
            }
    | (user, Opponent, opp) :: t ->
        summary_aux t
          {
            curr with
            turns = curr.turns + 1;
            env = (user, User, opp) :: curr.env;
          }
    | (user, End x, opp) :: _ ->
        if x = User then
          { curr with winner = Some (fst user); loser = Some (fst opp) }
        else { curr with winner = Some (fst opp); loser = Some (fst user) }
  in
  summary_aux (List.rev env)
    { winner = None; loser = None; cycles = 0; turns = 0; env = [] }
