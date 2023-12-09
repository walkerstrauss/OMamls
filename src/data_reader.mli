open Ability
open Item
open Event
open Location
open Csv
open Character

val read_data : string -> Csv.t
(** Function that takes a filename as input and returns a value of Csv.t where
    the head of the value is the abilities list tail of the value is a list
     containing the items list. *)

val abilities_helper : Csv.t -> ability list
(** Takes an argument of type [Csv.t] where the string list list is in the 
    format: <[abilities], [items], [events], [locations]> and returns the
    abilities list. Note: only works for already defined abilities. *)

val items_helper : Csv.t -> item list
(** Takes an argument of type [Csv.t] where Csv.t is [string list list] and 
    returns the second element of the string list list which is an item list. 
    Note: only works for already defined abilities. *)

(* val events : Csv.t -> event list *)
(** Takes an argument of type [Csv.t] where the string list list is in the 
    format: <[abilities], [items], [events], [locations]> and returns the third
    element of the string list list, which is the event list. Note: only works
    for already defined events. *)

(* val locations : Csv.t -> location list *)
(** Takes an argument of type [Csv.t] where the string list list is in the 
    format: <[abilities], [items], [events], [locations]> and returns the head 
    of the string list, which is the locations list. Note: only works for
    already defined locations. *)

val char_of_data : Csv.t -> string list -> string list -> character
(** Takes an argument of type [Csv.t] and generates randomly named character 
    using abilities and items from csv file. *)

val abilities_of_csv : string -> ability list
(** Takes argument for filename and uses Csv module to create Csv.t of csv file 
    in the format <[name],[bool1] [description1] [amount1], [bool3] 
    [amount2] where the inputs to create_ability are in the format: 
      name = name
      requireed = []
      effect = 
      (if [bool2] = true then Some (create_effect description1 damage
         (amount1)) else None, 
       if [bool3] = true then Some (create_effect description2 damage
         (amount2)) else None) *)

(* val items_of_csv : string -> ability list
   val events_of_csv : string -> event list
   val locations_of_csv : string -> location list *)
