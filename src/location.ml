open Event

type campus = North | Central | South | West

type place =
  | Dorm of campus * string
  | Hall of campus * string
  | Store of campus * string * time * time
  | Outside of campus

type location = { place : place; events : event list }

let campus_to_string (campus : campus) : string =
  match campus with
  | North -> "North"
  | Central -> "Central"
  | South -> "South"
  | West -> "West"

let get_place (loc : location): campus * string option = 
  match loc.place with 
  | Store (campus, name, _, _) -> (campus, Some (name))
  | Hall (campus, name) -> (campus, Some (name))
  | Dorm (campus, name) -> (campus, Some (name))
  | Outside (campus) -> (campus, None)
