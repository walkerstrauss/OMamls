
type time = int * int 

type event = {
  name : string;
  duration : time;
  skill_effect : (string * int) list
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