(**
A type with:
Damage of the amount of damage dealt
TurnSkip with the probability that it skips a turn
Debuff with the skill option and percentage of skill loss
Buff with the skill option and percentage of skill gain
*)
type effect_type =
  | Damage of int
  | TurnSkip of int
  | Debuff of (string list option * int)
  | Buff of (string list option * int)
  | AddItem
  | RemoveItem

type effect = { description : string; effect : (effect_type * int) list }
(**Record of the effect with its name
    its description is what will be said when used
    and a list of the types of effects the action does*)

type ability = {
  name : string;
  required : (string * int) list;
  effect : effect option * effect option;
}
(**Record of the ability with its name,
   the skills required to use and obtain the ability
   and a pair of who the ability affects and what the actual effect is*)

let create_ability name required effects = { name; required; effect = effects }
(**Function that creates an ability with the inputs
    Returns an ability*)
let create_effect description effect = { description; effect }
(**Function that creates an effect with the inputs
    Returns an effect*)
    

let punch =
  create_ability "Punch" [ (*("Strength", 1)*) ]
    ( None,
      Some { description = "has been punched!"; effect = [ (Damage 20, 1) ] } )
(** Ability representing a punch. *)

let slap =
  create_ability "Slap" [ (*("Strength", 1)*) ]
    ( None,
      Some { description = "has been slapped!"; effect = [ (Damage 10, 1) ] } )
(** Ability representing a slap. *)

let throw_item =
  create_ability "Throw Item"
    [ ("Athleticism", 100); ("Accuracy", 100) ]
    ( Some
        {
          description = "has thrown something very impressingly";
          effect = [ (RemoveItem, 1) ];
        },
      Some { description = "was hit by something"; effect = [ (Damage 15, 1) ] }
    )
(** Ability representing throwing an item. *)

let meditate =
  create_ability "Meditate"
    [ ("Mindfulness", 100) ]
    ( Some
        {
          description = "is meditating";
          effect = [ (Buff (None, 20), 6); (TurnSkip 100, 1) ];
        },
      None )
(** Ability representing meditating. *)

let ability_of_string name =
  match name with
  | "Punch" -> punch
  | "Slap" -> slap
  | "Throw Item" -> throw_item
  | "Meditate" -> meditate
  | _ -> failwith "No such ability"
(** Function that returns ability associated with input string *)

let abilities =
  [
    punch;
    slap;
    throw_item;
    meditate;
    (* pickpocket;
       chat_gpt;
       powernap;
       belittle; *)

    (* {
         name = "Pickpocket";
         required = [("Discretion", 100)];
         effect = (Some {
           name = "Gain Item";
           description = "has unassumingly gained an item";
           effect = [AddItem, 1];
         }, Some {
           name = "Lose Item";
           description = "has inconspicuously lost an item";
           effect = [RemoveItem, 1];
         })
       }; *)
    (* {
         name = "ChatGPT";
         required = [("Writing", 100); ("Discretion", 50)];
         effect = (Some {
           name = "ChatGPT";
           description = "used ChatGPT";
           effect = [Buff (Some ["General Knowledge"; "Writing"; "Coding"], 15), 5; Debuff (Some ["Math"], 5), 5];
         }, None)
       }; *)
    (* {
         name = "Powernap";
         required = [("Mindfuless", 500)];
         effect =  (Some {
           name = "Sleeping";
           description = "is taking a powernap";
           effect = [Buff (None, 100), 15; TurnSkip 100, 5];
         }, None)
       };
       {
         name = "Belittle";
         required = [("Confidence", 100); ("Knowledge", 100); ("Aggressiveness", 100)];
         effect = (None, Some{
           name = "Belittlement";
           description = "has been belittled";
           effect = [Debuff (Some ["Confidence"], 10), 5; Debuff (None, 5), 5]
         })
       } *)
  ]
  (**List of possible abilities a player can have*)
