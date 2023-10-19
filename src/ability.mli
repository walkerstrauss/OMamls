(**
A type with:
Damage of the amount of damage dealt
TurnSkip with the probability that it skips a turn
Debuff with the skill option and percentage of skill loss
Buff with the skill option and percentage of skill gain
*)
type effect_type = Damage of int| TurnSkip of int | Debuff of (string list option * int) | Buff of (string list option * int) | AddItem | RemoveItem


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
    who the ability affects and what the actual effect is*)
type ability = {
  name : string;
  required : (string * int) list;
  effect : effect option * effect option;
}

(**List of possible abilities a player can have*)
val abilities : ability list