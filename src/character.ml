open Item
open Ability

type major = CS | ECE | MechE | ChemE | CivilE | IS
type status = Alive | Dead

type character = {
  name : string;
  health : int;
  major : major;
  battle_power : int;
  skills : (string * int) list;
  abilities : ability option list;
  inventory : item list;
  experience : int;
  status : status;
}

(**Create the character with a given name and major*)
let create name major = {
  name = name; 
  health = 100;
  major = major; 
  battle_power = 0; 
  skills = []; 
  abilities = [None; None; None; None]; 
  inventory = []; 
  experience = 0; 
  status = Alive;
  }

(**Rename the character *)
let rename name character = {character with name = name}

(**Generate a random character*)
let generate (first, last) majors skills abilities items difficulty = 
  let name = List.nth first (Random.full_int (List.length first)) ^ " " ^ List.nth last (Random.full_int (List.length last)) in
  let major = List.nth majors (Random.full_int (List.length majors)) in
  let skills = let rec skill_select s acc =
    if List.length s = 0 then acc else 
      match Random.full_int (12 / difficulty) with
      | 1 -> skill_select (List.tl s) acc @ [(List.hd s, 0)]
      | _ -> skill_select (List.tl s) acc
    in skill_select skills [] in
  let abilities = let rec ability_select a acc =
    if List.length acc = 4 then acc else
      if List.length a = 0 then acc else
        match Random.full_int (12 / difficulty)  with
        | 1 -> ability_select (List.tl a) acc @ [Some (List.hd a)]
        | _ -> ability_select (List.tl a @ [List.hd a]) acc
      in ability_select abilities [] in
  let inventory = let rec item_select i acc =
    if List.length i = 0 then acc else
      match Random.full_int (12 / difficulty) with
      | 1 -> item_select (List.tl i) acc @ [List.hd i]
      | _ -> item_select (List.tl i) acc
    in item_select items [] in
    {
      name = name;
      health = 100;
      major = major;
      battle_power = 0;
      skills = skills;
      abilities = abilities;
      inventory = inventory;
      experience = 0;
      status = Alive;
    }

(**Change the health of the character and the status of being dead or alive*)
let change_hp hp character =  {character with health = character.health + hp; status = if hp > 0 then Alive else Dead}

(**Change the major of the character*)
let change_maj major character = {character with major = major}

(**Add an item to the character's inventory*)
let add_item item character = {character with inventory = item :: character.inventory}

(**Remove an item from the character's inventory*)
let remove_item item character = 
  match List.find_opt (fun x -> x = item) character.inventory with
  | Some x -> (Some x, {character with inventory = List.find_all (fun x -> x <> x) character.inventory})
  | None -> (None, {character with inventory = character.inventory})

(**Add an ability to the character's repertoire of abilities*)
let add_ability ability character = 
  match List.length (List.find_all (fun x -> x != None) character.abilities) with
  | len when len >= 4 -> failwith "Must Overwrite an Ability"
  | _ -> {character with abilities = 
            List.find_all 
              (fun x -> x != None) 
              character.abilities @ [Some ability] @ List.tl 
                                                      (List.filter 
                                                        (fun x -> x = None) 
                                                        character.abilities)}

(**Overwrite an ability in the character's repertoire of abilities*)
let overwrite_ability ability overwrite character =
  match List.find_opt (fun x -> x = Some overwrite) character.abilities with
  | Some _ -> {character with abilities = (List.find_all (fun x -> x != Some overwrite) character.abilities) @ [Some ability]}
  | None -> failwith "This Ability could not be found!"

(**Update a skill by adding sp to it or create a skill with sp as the initial value*)
let update_skill sp skill character =
  match List.find_opt (fun x -> let y, _ = x in y = skill) character.skills with
  | Some (name, level) -> {character with skills = (name, level + sp) :: List.filter (fun x -> let y,_ = x in y <> skill) character.skills}
  | None -> {character with skills = (skill, sp) :: character.skills}

(**Update the experience of a character by adding xp to the characters experience*)
let update_experience xp character =
  {character with experience = character.experience + xp}
