open Location
open Character
open Event
open Battle
open Item

type weekday = Monday | Tuesday | Wednesday | Thursday | Friday

(* let all_locations_list = Data_reader.locations_of_csv "data/Location.csv" *)

let weekday_to_string (day : weekday) : string =
  match day with
  | Monday -> "Monday"
  | Tuesday -> "Tuesday"
  | Wednesday -> "Wednesday"
  | Thursday -> "Thursday"
  | Friday -> "Friday"

let weekday_to_int (day : weekday) : int =
  match day with
  | Monday -> 1
  | Tuesday -> 2
  | Wednesday -> 3
  | Thursday -> 4
  | Friday -> 5

let print_time (time : time) : string =
  let hour, minute = time in
  match minute with
  | i when i < 10 -> string_of_int hour ^ ":0" ^ string_of_int minute
  | _ -> string_of_int hour ^ ":" ^ string_of_int minute

let print_current_location (location : location) : string =
  match get_place_name location with
  | campus, Some name ->
      "Currently at " ^ name ^ " on " ^ campus_to_string campus
  | campus, None -> "Currently at " ^ campus_to_string campus

let print_events_options (lst : event list) : string =
  let init =
    "Please select the following options (1 - "
    ^ string_of_int (List.length lst)
    ^ "):\n"
  in
  let rec events_print (events : event list) (count : int) : string =
    match events with
    | [] -> ""
    | h :: t ->
        string_of_int count ^ ": " ^ h.name ^ "\n" ^ events_print t (count + 1)
  in
  init ^ events_print lst 1

let next_day (day : weekday) : weekday =
  match day with
  | Monday -> Tuesday
  | Tuesday -> Wednesday
  | Wednesday -> Thursday
  | Thursday -> Friday
  | Friday -> Monday

let add_time (old_time : time) (duration : time) : time =
  let hour, minute = old_time in
  let dur_hour, dur_minute = duration in
  match minute + dur_minute with
  | i when i > 59 -> (hour + dur_hour + 1, minute + dur_minute - 60)
  | _ -> (hour + dur_hour, minute + dur_minute)

let get_user_choice (message : string) =
  print_endline message;
  print_string "> "

let rec read_int_rec x : int =
  try
    let ln = read_line x in
    int_of_string (String.trim ln)
  with Failure _ -> read_int_rec x

let outside_checker (location : location) : bool =
  match location.place with Outside _ -> true | _ -> false

let out_loc_of_campus (location : location) : location =
  let campus, _ = get_place_name location in
  List.find
    (fun x ->
      match x.place with Outside camp when camp = campus -> true | _ -> false)
    all_locations_list

let item_use (user : character) (item : item) : character =
  match item.category with
  | Consumable (hp, max) ->
      if hp = max then (
        Printf.printf "Already have full health!\n";
        user)
      else (
        Printf.printf "Consumed %s!\n" item.name;
        snd (remove_item item (change_hp hp user)))
  | _ ->
      Printf.printf "Used %s!\n" item.name;
      user

let rec cycle (location : location) (time : time) (user : character)
    (week : int) (day : weekday) : character =
  let outside = outside_checker location in
  let choices =
    if outside then "1. Move \n2. Action \n3. Inventory"
    else "1. Action \n2. Inventory \n3. Exit"
  in
  let updated_char, new_time, new_loc =
    match
      read_int_rec
        (get_user_choice
           ("The time is " ^ print_time time ^ ".\n"
           ^ print_current_location location
           ^ ". What would you like to do? (1 - 3)\n" ^ choices))
    with
    | 1 ->
        if outside then move user time location
        else action user time location week day
    | 2 ->
        if outside then action user time location week day
        else (item user, time, location)
    | 3 ->
        if outside then (item user, time, location)
        else (
          Printf.printf "Exiting the building.\n";
          (user, time, out_loc_of_campus location))
    | _ -> failwith "Unreachable"
  in
  let hour, _ = time in
  match hour with
  | i when i > 23 ->
      print_endline "You are done for the day!";
      updated_char
  | _ -> cycle new_loc new_time updated_char week day

and move (user : character) (time : time) (location : location) =
  let campus = fst (get_place_name location) in
  match
    read_int_rec
      (get_user_choice
         ("Would you like to leave " ^ campus_to_string campus
        ^ " ? (1 - 2)\n 1. Yes\n 2. No"))
  with
  | 1 ->
      let campus_list = get_remander_campuses campus in
      let choice =
        read_int_rec (get_user_choice (print_campus_options campus_list))
      in
      let selected_campus = List.nth campus_list (choice - 1) in
      let new_loc =
        List.find
          (fun x ->
            match get_place_name x with
            | camp, None when selected_campus = camp -> true
            | _ -> false)
          all_locations_list
      in
      (user, add_time time (0, 25), new_loc)
  | 2 ->
      let loc_of_campus = same_campus_list campus all_locations_list in
      let choice =
        read_int_rec (get_user_choice (print_location_options loc_of_campus))
      in
      (user, add_time time (0, 10), List.nth loc_of_campus (choice - 1))
  | _ -> failwith "Todo"

and action (user : character) (time : time) (location : location) (week : int)
    (day : weekday) =
  let events_list = location.events in
  let choice =
    read_int_rec (get_user_choice (print_events_options events_list))
  in
  let event = List.nth events_list (choice - 1) in
  let updated_user =
    match event.category with
    | Test -> (
        let _, amount =
          List.find (fun (x, _) -> x = "Intellegence") user.skills
        in
        let course =
          List.find_opt
            (fun (x : Class.class') ->
              Class.prelim_date_checker x.prelims week (weekday_to_int day))
            user.classes
        in
        match course with
        | None ->
            Printf.printf "Currently %s has no prelims today!\n" user.name;
            let user', _, _ = action user time location week day in
            user'
        | Some mat ->
            let new_course = Class.take_prelim amount mat in
            Printf.printf "%s took the %s prelim!\n" user.name new_course.name;
            overwrite_class mat user)
    | Battle -> (
        let result =
          summary
            (battle user
               (generate (first_names, last_names) [ CS; ECE; MechE ]
                  [ "Happiness"; "Intellegence"; "Strength" ]
                  Ability.abilities consumables_catelog 3))
        in
        match result.winner with
        | Some player when player.name = user.name ->
            Printf.printf "%s has won the battle!\n" player.name;
            player
        | Some _ -> (
            Printf.printf "%s has lost the battle!\n" user.name;
            match result.loser with
            | Some player -> player
            | None -> failwith "Unreachable"))
    | _ -> (Printf.printf "decided to do %s !\n" event.name;
            List.fold_left
              (fun char1 (skill, amount) -> update_skill amount skill char1)
              user event.skill_effect)
  in
  let user' = updated_user in
  if user'.status = Dead then
    (change_hp 100000 user', add_time time (24, 0), location)
  else (user', add_time time event.duration, location)

and item (user : character) : character =
  let choice = read_int_rec (get_user_choice (print_inventory user)) in
  match List.nth_opt user.inventory (choice - 1) with
  | Some i -> item_use user i
  | None ->
      Printf.printf "No items used!\n";
      user

and day_cycle (char1 : character) (week : int) (day : weekday) : character =
  let message =
    "Currently it is week " ^ string_of_int week ^ ". The day is "
    ^ weekday_to_string day ^ ".\n"
  in
  Printf.printf "%s" message;
  cycle morrison_hall (8, 0) char1 week day
