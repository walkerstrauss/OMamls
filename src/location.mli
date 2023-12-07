(** The type of location that a player is currently located. *)
type location = 
  | Store  
  | Eatery 
  | Dorm of room
  | Hall of room

(** Type of Room within a location that a player 
    is currently located. *)
type room = 
  | Home 
  | Lecture 
  | Lounge 
  | Lobby
  