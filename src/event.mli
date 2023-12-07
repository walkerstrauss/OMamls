
(** Time of the day. Represents (Hour, Minutes).
    Minutes must be at most 60 at any given time, 
    and hour must be between 0 - 24! *)
type time = int * int 

type event = {
    name : string;
    duration : time;
    skill_effect : (string * int) list
}

(** Type of event that is happening to the character*)
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