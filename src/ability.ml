type effect_type = Damage of int| TurnSkip of int | Debuff of (string list option * int) | Buff of (string list option * int) | AddItem | RemoveItem

type effect = {
    name : string;
    description : string;
    effect : (effect_type * int) list;
}

type ability = {
  name : string;
  required : (string * int) list;
  effect : effect option * effect option;
}

let create_ability name required effects = 
  {
    name = name;
    required = required;
    effect = effects;
  }

let create_effect name description effect =
  {
    name = name;
    description = description;
    effect = effect;
  }

let abilities = [
  {
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
  };
  {
    name = "ChatGPT";
    required = [("Writing", 100); ("Discretion", 50)];
    effect = (Some {
      name = "ChatGPT";
      description = "used ChatGPT";
      effect = [Buff (Some ["General Knowledge"; "Writing"; "Coding"], 15), 5; Debuff (Some ["Math"], 5), 5];
    }, None)
  };
  {
    name = "Throw Item";
    required = [("Athleticism", 100); ("Accuracy", 100)];
    effect = (Some {
      name = "Throw Item";
      description = "has thrown something very impressingly";
      effect = [RemoveItem, 1];
    }, Some {
      name = "Hit by item";
      description = "was hit by something";
      effect = [Damage 15, 1];
    })
  };
  {
    name = "Meditate";
    required = [("Mindfulness", 100)];
    effect = (Some {
      name = "Meditation";
      description = "is meditating";
      effect = [Buff (None, 20), 6; TurnSkip 100, 1];
    }, None)
  };
  {
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
  }
]