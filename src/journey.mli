open Location
open Character
open Event
open Item

(** Days of the week. *)
type weekday = Monday | Tuesday | Wednesday | Thursday | Friday

(** Represents all the locations in the game. *)
val all_locations_list : location list

(** Transform a weekday into an string. *)
val weekday_to_string : weekday -> int

(** Transform a weekday into an int comparison. *)
val weekday_to_int : weekday -> int

(** Prints out the current time.*)
val print_time : time -> string

(** Prints out current location. *)
val print_current_location : location -> string

(** Prints out the event options. *)
val print_events_options : event list -> string

(** Gets the next day of the week. *)
val next_day: weekday -> weekday

(** Adds time to the current time. *)
val add_time : time -> time -> time

(** Gets the user choice of a option. *)
val get_user_choice : string -> unit

(** Transform the user choice into 
    an integer comparison. *)
val read_int_rec : unit -> int

(** Checks a location if the location is Outside or not. *)
val outside_checker : location -> bool

(** Gets the outside location of a specific campus. *)
val out_loc_of_campus : location -> location

(** Uses an item for a specific character, 
    and returns newly effected character. *)
val item_use : character -> item -> character

(** Goes through a cycle of events that a player goes through. 
    Where, it represents a choice of events that a player is able 
    to make during the day before the day ends. *)
val cycle : location -> time -> character -> character

(** Goes through the user's character's day, and their actions throughout the day.*)
val day_cycle : character -> int -> weekday -> character
