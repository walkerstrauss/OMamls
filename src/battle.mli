open Character
open Ability

(** Prints out a message, and requests for the User to make a choice.*)
val get_user_choice : string -> unit

(** Creates a message string of the list of abilities the character has currently to be used to attack.*)
val print_abilities : character -> string

(** Creates a message string of the list of items the character has currently to be used during battle. *)
val print_inventory : character -> string

(** Checks the selected ability's action and applies all the effects of the ability onto the character.
    Currently, Debuff and Buff hasn't been fully implementated, as skills haven't been implemented. 
    Also, effects are currently 100% accurate on hitting the target. *)
val ability_action : character -> (effect_type * int) list -> character

(** Attacks from character 1 onto character 2. Character 1 has the option of using four abilities, 
    if the ability is none then the character gets to choose their attack abilities again! 
        Returns the new state of each character. *)
val attack : character -> character -> character * character

(** Checks the character's item, and allows the character to use the item during battle for one turn.
    If item isn't of type consumable, then the character gets to choose another item again. *)
val items : character -> character

(** Creates a probability if the character is successful at escaping and fleeing the battle. If successful, raises 
    an error, otherwise returns the character. *)
val flee : character -> character

(** A message of the overall move options the character has in a specific turn in battle.*)
val move_option : string

(** Character move during battle. During this move, the character has the option of attack, item, and flee. 
    Depending on the choice made, the character's status or health changes. 
    If the option wasn't either attack, item or flee, then the character gets to make the same choice again.*)
val move : character -> character -> character * character

(** Creates a battle sequence between two characters. Depending on the outcome, 
    returns the user's updated character status after the battle. *)
val battle : character -> character -> character