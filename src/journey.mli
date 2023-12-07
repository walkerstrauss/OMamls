(** Time of the day. Represents (Hour, Minutes).
    Minutes must be at most 60 at any given time, 
    and hour must be between 0 - 24! *)
type time = int * int 

(** Days of the week. *)
type weekday = 
  | Monday 
  | Tueday 
  | Wednesday
  | Thursday 
  | Friday 
  | Saturday
  | Sunday

(** The Day, and time. *)
type day = weekday * time

(** The current week. Represents the current week of the semester, and day. *)
type week = int * day list

(** Semester. *)
type semester = week list