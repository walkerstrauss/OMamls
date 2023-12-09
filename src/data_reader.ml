open Ability
open Item
open Event
open Location
open Csv
open Character

(** Function that takes a filename as input and returns a value of Csv.t. *)
let read_data (filename : string) : Csv.t =
  let ic = open_in filename in
  let csv_chan = of_channel ~separator:',' ic in
  input_all csv_chan

(** Takes an argument of type [Csv.t] where the string list list is in the 
    format: <[abilities], [items], [events], [locations]> and returns the head 
    of the string list list, which is the abilities list. *)
let abilities_helper (lst : Csv.t) : ability list =
  List.map (fun row -> Ability.ability_of_string (List.hd row)) lst

(** Takes an argument of type [Csv.t] where the string list list is in the 
    format: <[abilities], [items], [events], [locations]>  and returns the 
    second element of the string list list which is an item list. *)
let items_helper (lst : Csv.t) : item list =
  List.map (fun row -> Item.item_of_string (List.nth row 1)) lst

(** Takes an argument of type [Csv.t] where the string list list is in the 
    format: <[abilities], [items], [events], [locations]> and returns the third
    element of the string list list, which is the event list. Note: only works
   for already defined events. *)
(* let events (lst : Csv.t) : event list =
   List.map (fun row -> Event.event_of_string (List.nth row 2)) lst *)

(** Takes an argument of type [Csv.t] where the string list list is in the 
    format: <[abilities], [items], [events], [locations]> and returns the head 
    of the string list, which is the locations list. Note: only works for 
    already defined locations. *)
(* let locations (lst : Csv.t) : location list =
   List.map (fun row -> Location.location_of_string (List.nth row 3)) lst *)

(** Takes an argument of type [Csv.t] and generates randomly named character 
    using abilities and items from csv file. *)
let char_of_data lst first_names last_names =
  generate (first_names, last_names) [] [] (abilities_helper lst)
    (items_helper lst) 2

(** Helper function for below. *)
let abilities_of_data data_lst =
  List.map
    (fun row ->
      let name = List.hd row in
      let bool1 = bool_of_string (List.nth row 1) in
      let description1 = List.nth row 2 in
      let effect1 =
        if bool1 then
          Some
            (create_effect description1
               [ (Damage (int_of_string (List.nth row 3)), 1) ])
        else None
      in
      let bool2 = bool_of_string (List.nth row 4) in
      let description2 = List.nth row 5 in
      let effect2 =
        if bool2 then
          Some
            (create_effect description2
               [ (Damage (int_of_string (List.nth row 6)), 1) ])
        else None
      in
      create_ability name [] (effect1, effect2))
    data_lst

(** Takes argument for filename and uses Csv module to create Csv.t of csv file 
where each row represents an ability where <[name],[bool1] [description1] 
[amount1], [bool2], [description2], [amount2] and inputs to create_ability are
 in the format: 
name = name
requireed = []
effect = 
(if [bool1] = true then Some (create_effect description1 damage
   (amount1)) else None, 
   if [bool2] = true then Some (create_effect description2 damage
   (amount2)) else None) 
   Then creates ability list of Csv.t *)
let abilities_of_csv filename =
  let data_lst = read_data filename in
  abilities_of_data data_lst

(** Takes argument of Csv.t and creates item list.
   Csv.t in format: [name], [description], [category], [fst], [snd] *)
let items_of_data d =
  List.map
    (fun row ->
      let s = List.nth row 2 in
      let category =
        match s with
        | "Consumable" ->
            let fst, snd =
              (int_of_string (List.nth row 3), int_of_string (List.nth row 4))
            in
            Consumable (fst, snd)
        | "Supplies" -> Supplies (List.nth row 3, None)
        | "Tech" -> Tech (List.nth row 3, None)
        | "Misc" -> Misc (List.nth row 3, None)
        | _ -> failwith "Not a item category"
      in
      make_item (List.hd row) (List.nth row 1) category)
    d

(** Takes argument for filename and uses Csv module to create item list.
    Csv in format: [name], [description], [category], [fst], [snd] *)
let items_of_csv filename =
  let d = read_data filename in
  items_of_data d

(** Takes argument of type [Csv.t] and generates event list*)
let events_of_data d =
  List.map
    (fun row ->
      let name = List.hd row in
      let duration =
        (int_of_string (List.nth row 1), int_of_string (List.nth row 2))
      in
      let skill_effect = [ (List.nth row 3, int_of_string (List.nth row 4)) ] in
      let category = Event.category_of_string (List.nth row 5) in
      make_event name duration skill_effect category)
    d

(** Takes an argument for filename and uses Csv module to create event list. 
    Csv.t from csv should be in the format: [name] [dur_hr] [dur_min] 
    [skill effect string] [skill effect int] [category] *)
let events_of_csv filename =
  let d = read_data filename in
  events_of_data d

(** Takes argument of type [Csv.t] and generates location list. Csv.t should be 
    in the form [place], [campus], [name], [time1_hr], [time1_min], [time2_hr],
    [time2_min], 
    [name1] [dur_hr1] [dur_min1], [skill effect string1] 
    [skill effect int1] [category1],
    [name2] ... for more events *)
let locations_of_data d =
  let rec drop n lst =
    match lst with
    | [] -> []
    | h :: t -> if n = 0 then h :: drop n t else drop (n - 1) t
  in
  let rec events lst acc =
    match lst with
    | [] -> acc
    | h :: h2 :: h3 :: h4 :: h5 :: h6 :: t ->
        let acc2 = events_of_data [ [ h; h2; h3; h4; h5; h6 ] ] @ acc in
        events t acc2
    | _ -> failwith "String list list is in wrong format"
  in
  List.map
    (fun row ->
      let place = Location.place_of_string_list row in
      let row2 = drop 7 row in
      let ev_lst = events row2 [] in
      { place; events = ev_lst })
    d

(** Takes an argument for filename and uses Csv module to create location list.*)
let locations_of_csv filename =
  let d = read_data filename in
  locations_of_data d
