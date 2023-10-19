open Item
open Ability

(**The possible majors to choose from*)
type major = CS | ECE | MechE | ChemE | CivilE | IS
(**The current status of the character*)
type status = Alive | Dead

(**The type of the character*)
type character = {
    name : string;
    health : int * int;
    major : major;
    battle_power : int;
    skills : (string * int) list;
    abilities : ability option list;
    inventory : item list;
    status : status;
}

(**Create the character with its name and selected major
    Returns the full character with 100 hp with base stats*)
val create : string -> major -> character

(**Generate a custom character with lists of options for each major aspect of the character
    Item list and ability list should ideally be sorted from strongest to weakest
    Difficulty (1-4) determines the level of each skill, the overall experience of the character, and the battlepower
    Returns a full character with 100 hp and random stats*)
val generate : (string list * string list) -> major list -> string list -> ability list -> item list -> int -> character

(**Rename the character with an inputted name
    Returns the same character with a different name*)
val rename : string -> character -> character

(**Alter the health of the character with a given int to alter by
    Returns the character with the changed health*)
val change_hp : int -> character -> character

(**Change the major of the character with a given major
    Returns the character with the changed major*)
val change_maj : major -> character -> character

(**Add the inputted item to the character's inventory
    Returns the character with the item added to the front of the inventory list*)
val add_item : item -> character -> character

(**Remove a selected item from the character's inventory
    Returns a pair of an option which returns Some when the item is in the inventory
    and returns None when the item is not in the inventory, and the character with
    its inventory appropriately altered*)
val remove_item : item -> character -> item option * character

(**Add the inputted ability to the character
    Returns the character with the updated ability list
    Returns an error if the ability list is full*)
val add_ability : ability -> character -> character

(**Overwrite the second inputted ability with the first inputted ability
    Returns the character with the overwritten the ability list
    Returns an error if the second inputted ability is not in the characters
    repertoire*)
val overwrite_ability : ability -> ability -> character -> character

(**Updates a the given skill by the given amount
    Returns the character with the updated skill level or with a new skill at 
    the given skill level*)
val update_skill : int -> string -> character -> character