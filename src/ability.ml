type effect_type = Damage of int * int | TurnSkip of int * int | Debuff of (string list option * int) * int | Buff of (string list option * int) * int
type affected = User | Opponent

type effect = {
    name : string;
    description : string;
    effect : effect_type list;
}

type ability = {
  name : string;
  required : (string * int) list;
  affects : affected;
  effect : effect;
}

let abilities = [
  {
    name = "ChatGPT";
    required = [("Writing", 100)];
    affects = User;
    effect = {
      name = "ChatGPT";
      description = "used ChatGPT";
      effect = [Buff ((Some ["General Knowledge"; "Writing"; "Coding"], 15), 5); Debuff ((Some ["Math"], 5), 5)];
    }
  };
  {
    name = "Throw Item";
    required = [("Athleticism", 100); ("Accuracy", 100)];
    affects = Opponent;
    effect = {
      name = "Direct Hit";
      description = "was hit";
      effect = [Damage (15, 1)];
    }
  };
  {
    name = "Meditate";
    required = [("Mindfulness", 100)];
    affects = User;
    effect = {
      name = "Meditation";
      description = "is meditating";
      effect = [Buff ((None, 20), 6); TurnSkip (100, 1)];
    }
  };
  {
    name = "Powernap";
    required = [("Mindfuless", 500)];
    affects = User;
    effect = {
      name = "Sleeping";
      description = "is taking a powernap";
      effect = [Buff ((None, 100), 15); TurnSkip (100, 5)];
    }
  };
  {
    name = "Belittle";
    required = [("Confidence", 100); ("Knowledge", 100); ("Aggressiveness", 100)];
    affects = Opponent;
    effect = {
      name = "Belittlement";
      description = "has been belittled";
      effect = [Debuff ((Some ["Confidence"], 10), 5); Debuff ((None, 5), 5)]
    }
  }
]