open Ability
open Item
open Csv
open Character

(** Function that takes a filename as input and returns a value of Csv.t where
    the head of the value is the abilities list tail of the value is a list
    containing the items list. *)
let read_data filename =
  let ic = open_in filename in
  let csv_chan = of_channel ~separator:',' ic in
  input_all csv_chan

(** Takes an argument of type [Csv.t] where Csv.t is [string list list] and 
    returns the head of the string list, which is the abilities list. *)
let abilities lst =
  List.map (fun row -> Ability.ability_of_string (List.hd row)) lst

(** Takes an argument of type [Csv.t] where Csv.t is [string list list] and 
    returns the second element of the string list list which is an item list. *)
let items lst =
  List.map (fun row -> Item.item_of_string (List.hd (List.tl row))) lst

(** Takes an argument of type [Csv.t] and generates randomly named character 
    using abilities and items from csv file. *)
let char_of_data lst first_names last_names =
  generate (first_names, last_names) [] [] (abilities lst) (items lst) 2
