open Location
open Character
open Event
open Battle
open Item

type weekday =
  | Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday

let all_locations_list = Data_reader.locations_of_csv "data/Location.csv"

let weekday_to_string (day : weekday): string = 
  match day with 
  | Monday -> "Monday"
  | Tuesday -> "Tuesday"
  | Wednesday -> "Wednesday"
  | Thursday -> "Thursday"
  | Friday -> "Friday"

let weekday_to_int (day : weekday): int =
  match day with 
  | Monday -> 1
  | Tuesday -> 2
  | Wednesday -> 3
  | Thursday -> 4
  | Friday -> 5

let print_time (time : time) : string =
  let (hour, minute) = time in
  match minute with
  |i when i<10 -> string_of_int hour ^ ":0" ^ string_of_int minute
  |_ -> string_of_int hour ^ ":" ^ string_of_int minute

let print_current_location (location: location): string = 
  match (get_place location) with 
  | (campus, Some (name)) -> ("Currently at " 
    ^ name 
    ^ " on " 
    ^ (campus_to_string campus))
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

let next_day (day : weekday) :weekday = 
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

let get_user_choice (message : string) =
  print_endline message;
  print_string "> "

let rec read_int_rec x : int =
  try
    let ln = read_line x in
      int_of_string (String.trim ln)
  with Failure _ -> read_int_rec x

let outside_checker (location : location): bool = 
  match location.place with 
  |Outside (_) -> true
  |_ -> false

let out_loc_of_campus (location : location) : location = 
  let (campus, place) = get_place_name location in
  (List.find 
    (fun x -> match x.place with 
    | Outside camp when campus -> true
    | _ -> false) all_locations_list)

let item_use (user : character) (item : item) : character =
  match item.category with
  | Consumable (hp, max) -> if (hp = max) 
    then (Printf.printf "Already have full health!\n"; user)
    else (Printf.printf "Consumed %s!\n" item.name;
      remove_item item (change_hp hp user))
  | _ -> Printf.printf "Used %s!\n" item.name; user

let rec cycle (location : location) (time : time) (user : character): character = 
  let outside = outside_checker location in
  let choices = if outside then "1. Move \n2. Action \n3. Inventory" 
    else "1. Action \n2. Inventory \n3. Exit" 
  in let (char1, time) = 
  let (updated_char, new_time, new_loc) = 
    match read_int_rec (get_user_choice ("The time is " ^ (print_time time) ^ ".\n" 
        ^ print_location location 
        ^ ". What would you like to do? (1 - 3)\n" ^ choice)) with 
      | 1 -> if outside 
        then move user time location 
        else action user time location 
      | 2 -> if outside 
        then action user time location 
        else (item user, time, location)
      | 3 -> if outside 
        then (item user, time, location) 
        else (Printf.printf "Exiting the building.%s";
          (user, time, (out_loc_of_campus location)))
  in let (hour, minute) = time
  in match hour with
    |i when i>23 -> print_endline("You are done for the day!"); updated_char
    |_ -> cycle new_loc new_time updated_char

and move (user : character) (time : time) (location : location) (week : int) (day: weekday) = 
  let campus = (fst (get_place_name location)) in
  match read_int_rec (get_user_choice 
    ("Would you like to leave " ^ (campus_to_string campus) ^ " ? (1 - 2)\n 1. Yes\n 2. No")) with 
  | 1 -> let campus_list = get_remander_campuses campus in 
    let choice = read_int_rec (get_user_choice (print_campus_options campus_list)) in 
    let selected_campus = List.nth campus_list (choice - 1) in 
    let new_loc = List.find (fun x -> match get_place_name x with 
      | (camp, None) when selected_campus = camp -> true 
      | _ -> false) all_locations_list in 
    (user, (add_time time (0, 25)), new_loc)
  | 2 -> let loc_of_campus = same_campus_list campus all_locations_list in 
    let choice = read_int_rec (get_user_choice (print_location_options loc_of_campus)) in 
    (user, (add_time time (0, 10)), List.nth all_locations_list (choice - 1))
  | _ -> move user time location week day

and action (user : character) (time : time) (location : location) =
  let events_list = location.events in 
  let choice = read_int_rec (get_user_choice (print_events_options events_list)) in 
  let event = List.nth events_list (choice - 1) in 
  let updated_user = 
  match event.category with 
  | Test -> let (intelligence, amount) = List.find 
    (fun (x, y) -> x = "Intellegence") user.skills 
    in let course = List.find_opt 
      (fun x -> prelim_date_checker x.prelims week (weekday_to_int day)) 
      user.classes 
    in match course with 
      | None -> Printf.printf "Currently %s has no prelims today!"; action user time location
      | Some mat -> let new_course = take_prelim amount mat 
        in Printf.printf "%s took the %s prelim!"; overwrite_class mat user
        {user with classes = new_course}
  | Battle -> let result = 
    summary (battle user (generate first_names last_names 
      [CS; ECE; MechE] [("Happiness", 50); ("Intellegence", 1); ("Strength", 1)] 
      abilities consumables_catelog 3)) 
    in match result.winner with
    | player when player.name = user.name -> 
      Printf.printf "%s has won the battle!" player.name; player
    | _ -> Printf.printf "%s has lost the battle!" user.name; result.loser
  | _ -> let (skill, amount) = event.skill_effect in 
    Printf.printf "decided to do %s for " event.name; update_skill amount skill user
  in if updated_user.status = Dead 
    then ((change_hp updated_user 100000), (add_time time (24, 0)), location) 
    else (updated_char, (add_time time duration_time), location)

and item (user : character): character =
  let choice = read_int_rec (get_user_choice (print_inventory character))
  in match List.nth_opt user.inventory (n - 1) with
    | Some i -> item_use user i
    | None -> (Printf.printf "No item used!\n"; user)

let day_cycle (char1 : character) (week : int) (day : weekday): character =
  let message = ("Currently it is week " 
    ^ string_of_int week 
    ^ ". The day is " 
    ^ weekday_to_string day ".")
  in 
  Printf.printf "%s" message; (cycles morrison_hall (8, 0) (week) (day))
  