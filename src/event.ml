type time = int * int

type event = {
  name : string;
  duration : time;
  skill_effect : (string * int) list;
  category : category;
}

and category =
  | Idle
  | Consume
  | Lecture
  | Discussion
  | Buy
  | Meeting
  | Test
  | Special
  | Battle

(** Uses pattern matching to turn string into category*)
let category_of_string (s : string) : category =
  match s with
  | "Idle" -> Idle
  | "Lecture" -> Lecture
  | "Consume" -> Consume
  | "Discussion" -> Discussion
  | "Buy" -> Buy
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

let chicken = make_event "Eat Delicious and Sweet Chicken" 
  (1, 0) [ ("placeholder", 1) ] Consume
let test = make_event "Test" (1, 30) [ ("placeholder", 1) ] Test
let fight = make_event ("Fight someone") (1,45) ([]) Battle
let sleep_in = make_event 
  "Sleep in" (1, 0) [ ("Intelligence", 0); ("Happiness", 10) ] Idle
