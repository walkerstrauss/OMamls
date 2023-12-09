open Event

type campus =
  | North
  | Central
  | South
  | West
      (** The campus on which a place is located. Can be either North, 
    Central, South, or West*)

type place =
  | Dorm of campus * string
  | Hall of campus * string
  | Store of campus * string * time * time
  | Outside of campus
      (** Type of place  within a location that a player 
    is currently located. *)

type location = { place : place; events : event list }
(** Type representing character location in the game. *)

val campus_to_string : campus -> string
(** Converts campus to string representation*)

val campus_of_string : string -> campus
(** Converts string to campus using pattern matching. *)

val place_of_string_list : string list -> place
(** Converts string list to place using pattern matching. List in form 
    [place], [campus], [name], [time1_hr], [time1_min], [time2_hr], [time2_min]
    *)

val get_place_name : location -> campus * string option
(** Returns a tuple of the form ([campus], Some [name]) if the location has a
    name and the form (Outside, None) if the location is outside *)

val outside_west : location
val hans_bethe_house : location
