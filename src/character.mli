open Item
open Ability
open Class

(**The possible majors to choose from*)
type major = CS | ECE | MechE | ChemE | CivilE | IS

(**The current status of the character*)
type status = Alive | Dead

type character = {
  name : string;
  health : int * int;
  major : major;
  battle_power : int;
  skills : (string * int) list;
  abilities : ability option list;
  inventory : item list;
  status : status;
  classes : class' list;
  brbs : int;
}
(**The type of the character*)

val create : string -> major -> int -> int -> int -> character
(**Create the character with its name and selected major
    Returns the full character with 100 hp with base stats*)

val generate :
  string list * string list ->
  major list ->
  string list ->
  ability list ->
  item list ->
  int ->
  character
(** Generate a custom character with lists of options for each major aspect of 
    the character. Item list and ability list should ideally be sorted from 
    strongest to weakest. Difficulty (1-4) determines the level of each skill, 
    the overall experience of the character, and the battlepower. Returns a 
    character with 100 hp and random stats*)

val rename : string -> character -> character
(** Rename the character with an inputted name.
    Returns the same character with a different name*)

val change_brb : int -> character -> character * int
(** Changes the amount of brbs a Character has. *)

val change_hp : int -> character -> character
(** Alter the health of the character with a given int to alter by.
    Returns the character with the changed health*)

val change_maj : major -> character -> character
(** Change the major of the character with a given major.
    Returns the character with the changed major*)

val add_item : item -> character -> character
(** Add the inputted item to the character's inventory.
    Returns the character with the item added to the front of the 
    inventory list*)

val remove_item : item -> character -> item option * character
(** Remove a selected item from the character's inventory.
    Returns a pair of an option which returns Some when the item is in the 
    inventory and returns None when the item is not in the inventory, 
    and the character with its inventory appropriately altered*)

val add_class : class' -> character -> character
(**Adds a given class to the character's courseload, returning the new character
  with the added class when finished. If this class is already added, this 
  method fails.
    *)

val drop_class : class' -> character -> character
(**Drops a given class from the character's courseload, returning the new 
    character with the dropped class when finished. If the character does not
    already have this class, it is returned unchanged.*)

val overwrite_class : class' -> character -> character
(**Overwrites a given class' properties in a character's list of classes.*)

val add_ability : ability -> character -> character
(**Add the inputted ability to the character
    Returns the character with the updated ability list
    Returns an error if the ability list is full*)

val overwrite_ability : ability -> ability -> character -> character
(**Overwrite the second inputted ability with the first inputted ability
    Returns the character with the overwritten the ability list
    Returns an error if the second inputted ability is not in the characters 
    repertoire*)

val update_skill : int -> string -> character -> character
(**Updates a the given skill by the given amount
    Returns the character with the updated skill level or with a new skill at 
    the given skill level*)

val abilities_to_list : character -> string list
(**Convert the abilities of a character to a list
    Returns the name of the character's abilities*)

val has_skills : character -> (string * int) list -> bool
(**Returns whether or not a character has each of the given skills in the 
    given skill list. If it doesn't have one of the skills in the list, this 
    method returns false.*)

val gpa : character -> float
(**Calculates the character's gpa from all the classes they are currently taking,
    returning the overall GPA as a float. If they have no classes, or no grade,
    it counts as a 4.0*)

val first_names : string list
(**List of first names used for NPCs that you can fight*)

val last_names : string list
(**List of last names used for NPCs that you can fight*)
