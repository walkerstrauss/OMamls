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
  | Battle of Battle.env

(** Uses pattern matching to turn string into category*)
let category_of_string (s : string) (env : Battle.env option) : category =
  match (s, env) with
  | "Idle", None -> Idle
  | "Travel", None -> Travel
  | "Lecture", None -> Lecture
  | "Discussion", None -> Discussion
  | "Party", None -> Party
  | "Meeting", None -> Meeting
  | "Test", None -> Test
  | "Special", None -> Special
  | "Battle", Some env -> Battle env
  | "Battle", None -> Battle []
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

let dinner =
  {
    name = "Dinner";
    duration = (1, 0);
    skill_effect = [ ("placeholder", 1) ];
    category = Special;
  }

let test =
  {
    name = "Test";
    duration = (1, 30);
    skill_effect = [ ("placeholder", 1) ];
    category = Test;
  }
