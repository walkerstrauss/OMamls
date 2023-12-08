type effect_type =
  | Damage of int
  | TurnSkip of int
  | Debuff of (string list option * int)
  | Buff of (string list option * int)
  | AddItem
  | RemoveItem

type effect = { description : string; effect : (effect_type * int) list }

type ability = {
  name : string;
  required : (string * int) list;
  effect : effect option * effect option;
}

let create_ability name required effects = { name; required; effect = effects }
let create_effect description effect = { description; effect }

let punch =
  create_ability "Punch" [ (*("Strength", 1)*) ]
    ( None,
      Some { description = "has been punched!"; effect = [ (Damage 20, 1) ] } )

let slap =
  create_ability "Slap" [ (*("Strength", 1)*) ]
    ( None,
      Some { description = "has been slapped!"; effect = [ (Damage 10, 1) ] } )

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

let meditate =
  create_ability "Meditate"
    [ ("Mindfulness", 100) ]
    ( Some
        {
          description = "is meditating";
          effect = [ (Buff (None, 20), 6); (TurnSkip 100, 1) ];
        },
      None )

let ability_of_string name =
  match name with
  | "Punch" -> punch
  | "Slap" -> slap
  | "Throw Item" -> throw_item
  | "Meditate" -> meditate
  | _ -> failwith "No such ability"

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
