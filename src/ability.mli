(**
A type with:
Damage of the amount of damage dealt
TurnSkip with the probability that it skips a turn
Debuff with the skill option and percentage of skill loss
Buff with the skill option and percentage of skill gain
*)
type effect_type = 
   | Damage of int (*Damage with an int of how much damage is to be done*)
   | TurnSkip of int (*Turnskip with an int of the probability of a turn being skipped out of 100*)
   | Debuff of (string list option * int) (*Debuff with a string list option where
      [None] affects all skills and [Some] affects affected skill by a probability out of 100*)
   | Buff of (string list option * int) (*Buff with a string list option where
   [None] affects all skills and [Some] affects affected skill by a probability out of 100*)
   | AddItem (*Add item to a players inventory*)
   | RemoveItem (*Remove item from a players inventory*)


(**Record of the effect with its name
    its description is what will be said when used
    and a list of the types of effects the action does*)
type effect = {
    name : string;
    description : string;
    effect : (effect_type * int) list;
}

(**Record of the ability with its name,
    the skills required to use and obtain the ability
    and a pair of who the ability affects and what the actual effect is*)
type ability = {
  name : string;
  required : (string * int) list;
  effect : effect option * effect option;
}

(**Function that creates an ability with the inputs
    Returns an ability*)
val create_ability : string -> (string * int) list -> effect option * effect option -> ability

(**Function that creates an effect with the inputs
    Returns an effect*)
val create_effect : string -> string -> (effect_type * int) list -> effect


(**List of possible abilities a player can have*)
val abilities : ability list