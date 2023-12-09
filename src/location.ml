open Event

(** The campus on which a place is located. Can be either North, 
    Central, South, or West*)
type campus = North | Central | South | West

(** Type of place  within a location that a player 
    is currently located. *)
type place =
  | Dorm of campus * string
  | Hall of campus * string
  | Store of campus * string * time * time
  | Outside of campus

type location = { place : place; events : event list }
(** Type representing character location in the game. *)

(** Converts campus to string representation*)
let campus_to_string (campus : campus) : string =
  match campus with
  | North -> "North"
  | Central -> "Central"
  | South -> "South"
  | West -> "West"

(** Converts string to campus using pattern matching. *)
let campus_of_string (s : string) : campus =
  match s with
  | "North" -> North
  | "Central" -> Central
  | "South" -> South
  | "West" -> West
  | _ -> failwith "Invalid campus"

(** Converts string list to place using pattern matching. List in form 
    [place], [campus], [name], [time1_hr], [time1_min], [time2_hr], [time2_min]
    *)
let place_of_string_list (lst : string list) : place =
  let campus = campus_of_string (List.nth lst 1) in
  let name = List.nth lst 2 in
  match List.hd lst with
  | "Dorm" -> Dorm (campus, name)
  | "Hall" -> Hall (campus, name)
  | "Store" ->
      let time1 =
        (int_of_string (List.nth lst 3), int_of_string (List.nth lst 4))
      in
      let time2 =
        (int_of_string (List.nth lst 5), int_of_string (List.nth lst 6))
      in
      Store (campus, name, time1, time2)
  | "Outside" -> Outside campus
  | _ -> failwith "Invalid place"

(** Returns a tuple of the form ([campus], Some [name]) if the location has a
    name and the form (Outside, None) if the location is outside *)
let get_place_name (loc : location) : campus * string option =
  match loc.place with
  | Store (campus, name, _, _) -> (campus, Some name)
  | Hall (campus, name) -> (campus, Some name)
  | Dorm (campus, name) -> (campus, Some name)
  | Outside campus -> (campus, None)

let outside1 = { place = Outside West; events = [] }

let hans_bethe_house =
  {
    place = Dorm (West, "Hans Bethe House");
    events = [ Event.dinner; Event.test ];
  }
