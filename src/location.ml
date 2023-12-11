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

(** Gets the remaining campuses that a Player can go to. *)
let get_remander_campuses (campus : campus) : campus list =
  let campus_list = [ North; Central; South; West ] in
  List.filter (fun x -> if campus = x then false else true) campus_list

(** Returns a tuple of the form ([campus], Some [name]) if the location has a
    name and the form (Outside, None) if the location is outside *)
let get_place_name (loc : location) : campus * string option =
  match loc.place with
  | Store (campus, name, _, _) -> (campus, Some name)
  | Hall (campus, name) -> (campus, Some name)
  | Dorm (campus, name) -> (campus, Some name)
  | Outside campus -> (campus, None)

let print_campus_options (campuses : campus list) : string =
  let init =
    "Please select the following options (1 - "
    ^ string_of_int (List.length campuses)
    ^ "):\n"
  in
  let rec campus_print (campus : campus list) (count : int) : string =
    match campus with
    | [] -> ""
    | h :: t ->
        string_of_int count ^ ". " ^ campus_to_string h ^ " (25 mins)\n"
        ^ campus_print t (count + 1)
  in
  init ^ campus_print campuses 1

let print_location_options (lct : location list) : string =
  let init =
    "Please select the following options (1 - "
    ^ string_of_int (List.length lct)
    ^ "):\n"
  in
  let rec lcts_print (located : location list) (count : int) : string =
    let name (loc : location) =
      match get_place_name loc with _, Some name -> name | _, None -> "N/A"
    in
    match located with
    | [] -> ""
    | h :: t ->
        string_of_int count ^ ") " ^ name h ^ " (10mins)\n"
        ^ lcts_print t (count + 1)
  in
  init ^ lcts_print lct 1

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

let outside_west = { place = Outside West; events = [] }

let morrison_hall : location =
  { place = Dorm (North, "Toni Morrison Hall"); 
    events = [ Event.sleep_in; 
    (make_event 
      ("Studying")
    (1,10)
    ([("Intelligence", 4);
    ("Happiness", -1)])
    Idle) ] }

let hans_bethe_house =
  {
    place = Dorm (West, "Hans Bethe House");
    events = [ Event.chicken; Event.test ];
  }

let rec same_campus_list (campus : campus) (locations : location list) :
    location list =
  let checker1 (loc : location) =
    if campus = fst (get_place_name loc) then true else false
  in
  let checker2 (loc : location) : bool =
    match get_place_name loc with _, None -> false | _ -> true
  in
  match locations with
  | [] -> []
  | loct :: t when checker1 loct && checker2 loct ->
      loct :: same_campus_list campus t
  | _ :: t -> same_campus_list campus t

let create_location (plac : place) (ent: event list): location = 
  {place = plac; events = ent} 

let all_locations_list = 
[
  morrison_hall;
  (create_location 
    (Outside North) 
    ([(make_event 
      ("Cloud Watch")
      (1,0)
      ([("Happiness", 10)])
      Idle);
      (make_event 
      ("Fight someone")
      (1,45)
      ([])
      Battle)]));
  (create_location 
    (Outside West) 
    ([(make_event 
      ("Sit on the slope")
      (1,0)
      ([("Happiness", 10)])
      Idle);
      (make_event 
      ("Fight someone")
      (1,45)
      ([])
      Battle)]));
  (create_location 
    (Outside South) 
    ([(make_event 
      ("Walk down a trail")
      (2,0)
      ([("Happiness", 10)])
      Idle);
      (make_event 
      ("Fight someone")
      (1,45)
      ([])
      Battle);
    ]));
  (create_location 
    (Outside Central) 
    ([(make_event 
      ("People watching on Ho Plaza")
      (1,10)
      ([("Happiness", 10)])
      Idle);
      (make_event 
      ("Fight someone")
      (1,45)
      ([])
      Battle)
    ]));
  (create_location 
    (Dorm (North, "Dickson")) 
    ([(make_event 
      ("Studying")
      (1,10)
      ([("Intelligence", 4); ("Happiness", -4)])
      Idle);
      (make_event 
      ("Nap")
      (0,45)
      ([("Happiness", 5)])
      Idle); 
      Event.fight
    ]));
  (create_location 
    (Hall (North, "Helen Newman")) 
    ([(make_event 
      ("Exercise!")
      (3,0)
      ([("Strength", 4); ("Happiness", 1)])
      Idle);
      (make_event 
      ("Socialize")
      (1,30)
      ([("Happiness", 6);
      ("Confidence", 1)])
      Idle);
      Event.fight
    ]));
  (create_location 
    (Hall (Central, "Statler Hall")) 
    ([(make_event 
      ("Attending lecture")
      (1,10)
      ([("Intelligence", 4); ("Happiness", -4)])
      Special);
      Event.test;
      Event.fight
    ]));
  (create_location 
    (Hall (Central, "Duffield")) 
    ([(make_event 
      ("Studying")
      (1,10)
      ([("Intelligence", 4); ("Happiness", -1)])
      Idle);
      (make_event 
      ("Nap")
      (0,45)
      ([("Happiness", 5)])
      Idle);
      Event.fight
    ]));
  (create_location 
    (Dorm (West, "Hans Bethe")) 
    ([(make_event 
      ("Studying")
      (1,10)
      ([("Intelligence", 4); ("Happiness", -1)])
      Idle);
      (make_event 
      ("Nap")
      (0,45)
      ([("Happiness", 5)])
      Idle);
      Event.fight;
      Event.chicken
    ]));
  (create_location 
    (Dorm (West, "Alice Cook")) 
    ([(make_event 
      ("Studying")
      (1,10)
      ([("Intelligence", 4); ("Happiness", -1)])
      Idle);
      (make_event 
      ("Nap")
      (0,45)
      ([("Happiness", 5)])
      Idle);
      Event.fight
    ]));
  (create_location 
    (Hall (South, "CTB")) 
    ([(make_event 
      ("Eat a bagel")
      (1,10)
      ([("Happiness", 10)])
      Consume);
      (make_event 
      ("Nap on the floor")
      (0,45)
      ([("Happiness", 5)])
      Idle);
      Event.fight
    ]));
  (create_location 
    (Store (Central, "Cornell Store", (11,0), (17,0))) 
    ([(make_event 
      ("Buy an item")
      (0,30)
      ([])
      Buy);
      (make_event 
      ("Fight the store keeper")
      (1,45)
      ([])
      Battle)
    ]));
]
