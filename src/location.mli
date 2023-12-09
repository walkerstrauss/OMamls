open Event

(** The campus on which a place is located. Can be either North, 
  Central, South, or West*)
type campus =
  | North
  | Central
  | South
  | West

(** Type of place  within a location that a player 
    is currently located. *)
type place =
  | Dorm of campus * string
  | Hall of campus * string
  | Store of campus * string * time * time
  | Outside of campus

(** Type representing character location in the game. *)
type location = { place : place; events : event list }

(** Converts campus to string representation*)
val campus_to_string : campus -> string

(** Converts string to campus using pattern matching. *)
val campus_of_string : string -> campus

val place_of_string_list : string list -> place
(** Converts string list to place using pattern matching. List in form 
    [place], [campus], [name], [time1_hr], [time1_min], [time2_hr], [time2_min]
    *)
val place_of_string_list : string -> place

(** Returns a tuple of the form ([campus], Some [name]) if the location has a
    name and the form (Outside, None) if the location is outside *)

val outside_west : location
val hans_bethe_house : location
val get_place_name : location -> campus * string option

(** checks *)
val same_campus_list : campus -> location list -> location list

