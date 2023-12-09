open Location
open Character
open Event

(** Days of the week. *)
type weekday = Monday | Tuesday | Wednesday | Thursday | Friday

(** The Day. *)
type day = weekday

(** Prints out the current time.*)
val print_time : time -> string

(** Prints out current location. *)
val print_current_location : location -> string

(** Prints out the event options. *)
val print_events_options : event list -> string

(** Adds time to the current time. *)
val add_time : time -> time -> time 

(** Gets the next day of the week. *)
val next_day: weekday -> weekday

(** Goes through the user's character's day, and their actions throughout the day.*)
val day : character -> int -> character
