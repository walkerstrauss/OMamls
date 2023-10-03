type major = CS | ECE | MechE | ChemE | CivilE | IS

type character = {
  name : string;
  health : int;
  major : major;
  battle_power : int;
  skills : int list;
  abilities : int;
  inventory : int list;
  experience : int;
  level : int;
}

let create char_name char_major = {name = char_name; health = 100; major = char_major; battle_power = 0; skills = []; abilities = 0; inventory = []; experience = 0; level = 0}

