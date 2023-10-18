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
    abilities : ability list;
    inventory : item list;
    experience : int;
    level : int;
    status : status;
}

(**Create the character with its name and selected major
    Returns the full character with 100 hp with base stats*)
val create : string -> major -> character

(**Rename the character with an inputted name
    Returns the same character with a different name*)
val rename : string -> character -> character

(**Alter the health of the character with a given int to alter by
    Returns the character with the changed health*)
val change_hp : int -> character -> character

(**Change the major of the character with a given major
    Returns the character with the changed major*)
val change_maj : major -> character -> character

(**Add an the inputted item to the character's inventory
    Returns the character with the item added to the front of the inventory list*)
val add_item : item -> character -> character

(**Remove a selected item from the character's inventory
    Returns a pair of an option which returns Some when the item is in the inventory
    and returns None when the item is not in the inventory, and the character with
    its inventory appropriately altered*)
val remove_item : item -> character -> item option * character