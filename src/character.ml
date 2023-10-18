open Item
open Ability

type major = CS | ECE | MechE | ChemE | CivilE | IS
type status = Alive | Dead

type character = {
  name : string;
  health : int;
  major : major;
  battle_power : int;
  skills : int list;
  abilities : ability option list;
  inventory : item list;
  experience : int;
  level : int;
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
  level = 0;
  status = Alive;
  }

(**Rename the character *)
let rename name character = {character with name = name}

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
  match List.find_opt (fun x -> x = overwrite) character.abilities with
  | Some _ -> {character with abilities = (List.find_all (fun x -> x != overwrite) character.abilities) @ [Some ability]}
  | None -> failwith "This Ability could not be found!"


