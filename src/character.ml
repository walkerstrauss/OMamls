open Item
open Ability

type major = CS | ECE | MechE | ChemE | CivilE | IS
type status = Alive | Dead
type host = User | Computer

type character = {
  name : string;
  health : int * int;
  major : major;
  battle_power : int;
  skills : (string * int) list;
  abilities : ability option list;
  inventory : item list;
  status : status;
  brbs : int;
  host : host;
}

(**Create the character with a given name and major*)
let create name major host = {
  name = name; 
  health = (100, 100);
  major = major; 
  battle_power = 0; 
  skills = []; 
  abilities = [None; None; None; None]; 
  inventory = []; 
  status = Alive;
  brbs = 0;
  host = host;
  }

(**Rename the character *)
let rename name character = {character with name = name}

(**Generate a random character*)
let generate (first, last) majors skills abilities items difficulty = 
  let name = List.nth first (Random.full_int (List.length first)) ^
   " " ^ 
   List.nth last (Random.full_int (List.length last)) in
  let major = List.nth majors (Random.full_int (List.length majors)) in
  let skills = let rec skill_select s acc =
    if List.length s = 0 then acc else 
      match Random.full_int 3 with
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
      health = 100, 100;
      major = major;
      battle_power = 0;
      skills = skills;
      abilities = abilities;
      inventory = inventory;
      status = Alive;
      brbs = 0;
      host = Computer;
    }

(**Change the health of the character and the status of being dead or alive*)
let change_hp hp character =  
  {character with 
    health = (let (chp, mhp) = character.health in if chp + hp > mhp then (mhp, mhp) else (chp + hp, mhp)); 
    status = let (chp, _) = character.health in if chp + hp > 0 then Alive else Dead}

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

let abilities_to_list character =
  let rec converter character n acc =
    match n with
    | n when n < 4 -> 
      (match List.nth character.abilities n with
      | Some x -> acc @ [x.name]
      | None -> acc @ [""])
    | _ -> acc
    in converter character 4 []