type time = int * int

type event = {
  name : string;
  duration : time;
  skill_effect : (string * int) list;
  category : category;
}

and category =
  | Idle
  | Travel
  | Lecture
  | Discussion
  | Party
  | Meeting
  | Test
  | Special
  | Battle

(** Uses pattern matching to turn string into category*)
let category_of_string (s : string) : category =
  match s with
  | "Idle" -> Idle
  | "Travel" -> Travel
  | "Lecture" -> Lecture
  | "Discussion" -> Discussion
  | "Party" -> Party
  | "Meeting" -> Meeting
  | "Test" -> Test
  | "Special" -> Special
  | "Battle" -> Battle
  | _ -> failwith "Invalid category"

(** Function to make an event *)
let make_event (name : string) (duration : time)
    (skill_effect : (string * int) list) (category : category) : event =
  { name; duration; skill_effect; category }

(** Function that turns event to string*)
let event_to_string (ent : event) : string =
  let hour, min = ent.duration in
  ent.name ^ " -> (" ^ string_of_int hour ^ " hrs & " ^ string_of_int min
  ^ " mins)"

let dinner = make_event "Dinner" (1, 0) [ ("placeholder", 1) ] Special
let test = make_event "Test" (1, 30) [ ("placeholder", 1) ] Test
let fight = make_event ("Fight someone") (1,45) ([]) Battle
let sleep_in : event =
  {
    name = "Sleep in";
    duration = (1, 0);
    skill_effect = [ ("Intelligence", 0); ("Happiness", 10) ];
    category = Idle;
  }
