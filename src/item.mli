(** Item Categories that items can belongs. Currently items could be a 
Consumable, Supplies, Tech, or Miscellaneous. 
Consumable is of the following (Health increase, Expiration Date).*)
type category =
  | Consumable of int * int
  | Supplies of string * int option
  | Tech of string * int option
  | Misc of string * int option

type item = { name : string; description : string; category : category }
(** Type for items that characters equip. *)

val consumables_catelog : item list
(** Catelog of all Consumable items.*)

val supplies_catelog : item list
(** Catelog of all Supplies items.*)

val tech_catelog : item list
(** Catelog of all Tech items.*)

val misc_catelog : item list
(** Catelog of all Misc items.*)

val items_catelog : item list list
(** Catelog of all current items.*)
