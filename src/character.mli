open Item

type major = CS | ECE | MechE | ChemE | CivilE | IS

type character = {
    name : string;
    health : int;
    major : major;
    battle_power : int;
    skills : int list;
    abilities : int list;
    inventory : item list;
    experience : int;
    level : int;
}

val create : character -> character

val rename : character -> character

val change_hp : character -> character