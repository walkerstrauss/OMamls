open Character
open Item

type ability = {
  name : string;
  effect : character -> character
}

val change_major : character -> major -> character

val sleep_through_class : ability

val empty_inventory : ability

val add_item : character -> item -> character

val remove_item : character -> item -> character 

(** study_for_exam char min char means char studys for min minutes, 
    which increases experience by 10 *)
val study_for_exam : ability

(** take exam char returns a character with an updated skills list if they pass
     the exam. Passing the exam means level and experience is high enough *)
val take_exam : ability