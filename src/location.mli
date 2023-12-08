open Event

(** The which campus a place is located. *)
type campus = North | Central | South | West

(** Type of place  within a location that a player 
    is currently located. *)
type place =
  | Dorm of campus * string
  | Hall of campus * string
  | Store of campus * string * time * time
  | Outside of campus

type location = { place : place; events : event list }
