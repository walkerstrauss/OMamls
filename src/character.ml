type major = CS | ECE | MechE | ChemE | CivilE | IS

type character = {
  name : string;
  health : int;
  major : major;
  battle_power : int;
  skills : int list;
  abilities : int list;
  inventory : int list;
  experience : int;
  level : int;
}

let create char_name char_major = {
  name = char_name; 
  health = 100;
  major = char_major; 
  battle_power = 0; 
  skills = []; 
  abilities = []; 
  inventory = []; 
  experience = 0; 
  level = 0
  }

let rename char_name char_to_change = {char_to_change with name = char_name}

let change_hp change char_to_change = {char_to_change with health = char_to_change.health + change}


