
type ability = {
  name : string;
  effect : int
}

(* let change_major (char: character) (maj : major) : character = 
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

let empty_inventory : ability = {
  name = "Empty inventory";
  effect = (fun char -> {
    name = char.name;
    health = char.health;
    major = char.major;
    battle_power = char.battle_power;
    skills = char.skills;
    abilities = char.abilities; 
    inventory = [];
    experience = char.experience;
    level = char.level
  })
}
   

let add_item (char : character) (i : item) : character =
   {
    name = char.name;
    health = char.health;
    major = char.major;
    battle_power = char.battle_power;
    skills = char.skills; 
    abilities = char.abilities;
    inventory = i :: char.inventory;
    experience = char.experience;
    level = char.level
   }

let remove_item (char : character) (i : item) : character = 
  {
    name = char.name;
    health = char.health;
    major = char.major;
    battle_power = char.battle_power;
    skills = char.skills;
    abilities = char.abilities;
    inventory = List.filter (fun i2 -> (i = i2) = false) char.inventory;
    experience = char.experience;
    level = char.level;
  }
let take_exam : ability = {
  name = "Take exam";
  effect = (fun char -> if char.experience > 500 then {
    name = char.name;
    health = char.health;
    major = char.major;
    battle_power = char.battle_power;
    skills = char.skills;
    abilities = char.abilities;
    inventory = char.inventory;
    experience = 0;
    level = char.level + 1;
  } else char)
}
let study_for_exam : ability = {
  name = "Study for exam";
  effect = (fun char -> {
    name = char.name;
    health = char.health;
    major = char.major;
    battle_power = char.battle_power;
    skills = char.skills;
    abilities = char.abilities;
    inventory = char.inventory;
    experience = char.experience + 100;
    level = char.level;
  })
}
 *)
