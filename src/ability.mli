open Character
open Item

type character 

type ability = {
  name : string;
  effect : character -> character
}

val change_major : character -> major -> character

val sleep_through_class : character -> character 

val empty_inventory : character -> character

val add_item : character -> item -> character

val remove_item : character -> item -> character 

(** study_for_exam char min char means char studys for min minutes, 
    which increases experience by min * 10 *)
val study_for_exam : character -> int -> character

(** take exam char returns a character with an updated skills list if they pass
     the exam. Passing the exam means level and experience is high enough *)
val take_exam : character -> character