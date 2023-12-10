type time = int * int
(** Time of the day. Represents (Hour, Minutes).
    Minutes must be at most 60 at any given time, 
    and hour must be between 0 - 24! *)

type event = {
  name : string;
  duration : time;
  skill_effect : (string * int) list;
  category : category;
}

(** Type of event that is happening to the character*)
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

val category_of_string : string -> category
(** Uses pattern matching to turn string into category*)

val make_event : string -> time -> (string * int) list -> category -> event
(** Function to make an event *)

val event_to_string : event -> string
(** Function that turns event to string*)

val dinner : event
val sleep_in : event
val test : event
val fight : event
