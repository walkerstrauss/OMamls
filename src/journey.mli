open Location
open Character
open Event
open Item

(** Days of the week. *)
type weekday = Monday | Tuesday | Wednesday | Thursday | Friday

val all_locations_list : location list
(** Represents all the locations in the game. *)

val weekday_to_string : weekday -> string
(** Transform a weekday into an string. *)

val weekday_to_int : weekday -> int
(** Transform a weekday into an int comparison. *)

val print_time : time -> string
(** Prints out the current time.*)

val print_current_location : location -> string
(** Prints out current location. *)

val print_events_options : event list -> string
(** Prints out the event options. *)

val next_day : weekday -> weekday
(** Gets the next day of the week. *)

val add_time : time -> time -> time
(** Adds time to the current time. *)

val get_user_choice : string -> unit
(** Gets the user choice of a option. *)

val read_int_rec : unit -> int
(** Transform the user choice into 
    an integer comparison. *)

val outside_checker : location -> bool
(** Checks a location if the location is Outside or not. *)

val out_loc_of_campus : location -> location
(** Gets the outside location of a specific campus. *)

val item_use : character -> item -> character
(** Uses an item for a specific character, 
    and returns newly effected character. *)

val cycle : location -> time -> character -> int -> weekday -> character
(** Goes through a cycle of events that a player goes through. 
    Where, it represents a choice of events that a player is able 
    to make during the day before the day ends. *)

val day_cycle : character -> int -> weekday -> character
(** Goes through the user's character's day, and their actions throughout the day.*)
