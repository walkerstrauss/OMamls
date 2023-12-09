open Location
open Character
open Event

type weekday = 
  | Monday 
  | Tuesday 
  | Wednesday
  | Thursday 
  | Friday 

type day = weekday

let print_time (time : time) : string =
  let (hour, minute) = time in 
  match minute with 
  |i when i<10 -> string_of_int hour ^ ":0" ^ string_of_int minute 
  |_ -> string_of_int hour ^ ":" ^ string_of_int minute

let print_location (location: location): string = 
  match get_place location with 
  | (campus, Some (name)) -> "Currently at " 
    ^ name ^ " on " 
    ^ (campus_to_string campus)
  | (campus, None) -> "Currently at " ^ (campus_to_string campus)

let print_events_options (lst: event list): string = 
  let init = 
    "Please select the following options (1 - "
    ^ string_of_int (List.length lst)
    ^ "):\n" 
  in 
  let rec events_print (events: event list) (count: int): string =
    match events with 
    | [] -> ""
    | h :: t -> ((string_of_int count) ^ ": " ^ (h.name) ^ "\n" ^ (events_print t (count + 1)))
  in init ^ events_print lst 1

let next_day (day : day) :day = 
  match day with 
  | Monday -> Tuesday
  | Tuesday -> Wednesday 
  | Wednesday -> Thursday
  | Thursday -> Friday
  | Friday -> Monday

let add_time (old_time : time) (duration : time) : time = 
  let (hour, minute) = old_time in 
  let (dur_hour, dur_minute) = duration in
  match minute+dur_minute with 
  | i when i>59 -> (hour+dur_hour+1, minute+dur_minute-60)
  | _ -> (hour+dur_hour, minute+dur_minute)

let sleep_in : event = {name="Sleep in (1 hour)"; duration=(1,0); skill_effect=[("Smartness", 0);("Happiness", 10)]}
let morrison_hall : location = {place=(Dorm (North, "Toni Morrison Hall")); events=[sleep_in];}

let get_user_choice (message : string) =
  print_endline message;
  print_string "> "

let rec read_int_rec x : int =
  try
    let ln = read_line x in
    int_of_string (String.trim ln)
  with Failure _ -> read_int_rec x

let day (char1 : character) (week : int) =
  let rec events (location : location) (time : time) = 
    print_endline("The time is " ^ (print_time time) ^ ".\n" 
      ^ print_location location ^ ". What would you like to do?");
      read_int_rec (get_user_choice )
    (*access current location, give options for which events are available*)
    let opt = read_int_rec (get_user_choice (print_events_options location.events)) in
    let event = List.nth location.events (opt-1) in 
    let time = add_time time (event.duration) in
    (*run specified event, updating skills accordingly and adding to the time*)

    (*if time is past midnight, stop giving option for more events (stop calling recursively)*)
    let (hour, minute) = time in
    match hour with
    |i when i>23 -> print_endline("You are done for the day!");
    |_ -> (**events location time*) print_endline ("");
  (*print out the day, start going into events until time is done for the day*)
    print_endline("Currently it is week " ^ string_of_int week ^ ". The day is ");
    print_endline("You wake up in your dorm room.")
  in events morrison_hall (8,0)
