open Ability
open Item
open Csv
open Character

val read_data : string -> Csv.t
(** Function that takes a filename as input and returns a value of Csv.t where
    the head of the value is the abilities list tail of the value is a list
     containing the items list. *)

val abilities : Csv.t -> ability list
(** Takes an argument of type [Csv.t] where Csv.t is [string list list] and 
    returns the head of the string list, which is an ability list. *)

val items : Csv.t -> item list
(** Takes an argument of type [Csv.t] where Csv.t is [string list list] and 
    returns the second element of the string list list which is an item list. *)

val char_of_data : Csv.t -> string list -> string list -> character
(** Takes an argument of type [Csv.t] and generates randomly named character 
using abilities and items from csv file. *)
