type time = int * int

type event = {
  name : string;
  duration : time;
  skill_effect : (string * int) list;
}

type category =
  | Idle
  | Travel
  | Lecture
  | Discussion
  | Party
  | Meeting
  | Test
  | Special
  | Battle of Battle.env

let event_to_string (ent : event) : string =
  let hour, min = ent.duration in
  ent.name ^ " -> (" ^ string_of_int hour ^ " hrs & " ^ string_of_int min
  ^ " mins)"
