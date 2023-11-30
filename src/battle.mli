open Character
open Ability

(**A type to tell whose turn it currently is in a state*)
type turn = User | Opponent | End of turn

(**The character type while during a battle where it includes both the character and the long term effects on the character*)
type battle_character = (character * (effect_type * int) list)

(**State of the battle. The point where the players are during a certain turn in the battle*)
type state = (battle_character * turn * battle_character) 

(**The collection of states that make up a battle start to finish*)
type env = state list

(** Prints out a message, and requests for the User to make a choice.*)
val get_user_choice : string -> unit

(** Creates a message string of the list of abilities the character has currently to be used to attack.*)
val print_abilities : character -> string

(** Creates a message string of the list of items the character has currently to be used during battle. *)
val print_inventory : character -> string

(** Checks the selected ability's action and applies all the effects of the ability onto the character.
    Currently, Debuff and Buff hasn't been fully implementated, as skills haven't been implemented. 
    Also, effects are currently 100% accurate on hitting the target. *)
val use_ability : battle_character -> battle_character -> ability -> (battle_character * battle_character) option


val apply_new_effect : battle_character -> effect -> battle_character

val apply_old_effects : battle_character -> battle_character

val has_requirement : character -> (string * int) list -> bool

val is_skipped : (effect_type * int) list -> bool

(** Attacks from character 1 onto character 2. Character 1 has the option of using four abilities, 
    if the ability is none then the character gets to choose their attack abilities again! 
        Returns the new state of each character. *)
val attack : state -> int -> state

(** Checks the character's item, and allows the character to use the item during battle for one turn.
    If item isn't of type consumable, then the character gets to choose another item again. *)
val item : battle_character -> int -> battle_character

(** Creates a probability if the character is successful at escaping and fleeing the battle. If successful, raises 
    an error, otherwise returns the character. *)
val flee : env -> env

(** Character move during battle. During this move, the character has the option of attack, item, and flee. 
    Depending on the choice made, the character's status or health changes. 
    If the option wasn't either attack, item or flee, then the character gets to make the same choice again.*)
val turn : env -> env

(** Creates a battle sequence between two characters. Depending on the outcome, 
    returns the user's updated character status after the battle. *)
val battle : character -> character -> state