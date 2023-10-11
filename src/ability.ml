open Character
open Item

type ability = {
  name : string;
  effect : character -> character
}

let change_major (char: character) (maj : major) : character = 
  if char.major = maj then char else {
  name = char.name;
  health = char.health;
  major =  maj;
  battle_power = char.battle_power;
  skills = char.skills;
  abilities = char.abilities;
  inventory = char.inventory;
  experience = char.experience;
  level = char.level;
  }

let sleep_through_class = {
  name = "Sleep through class";
  effect = (fun char -> {name = char.name;
  health = char.health + 100;
  major =  char.major;
  battle_power = char.battle_power;
  skills = char.skills;
  abilities = char.abilities;
  inventory = char.inventory;
  experience = char.experience - 100;
  level = char.level})
}

let empty_inventory : ability = failwith "Unimplemented"

let add_item (char : character) (i : item) : character =
   failwith "Unimplemented"

let remove_item (char : character) (i : item) : character = 
  failwith "Unimplemented "

let study_for_exam : ability = failwith "Unimplemented"

let take_exam : ability = failwith "Unimplemented"