(** The day, and week of a prelim for a class.*)
type prelim = int * int

(** Properties of a class that a player is enrolled into. *)
type class' = {
  name : string;
  prelims : prelim list;
  grade : (int * int) option;
}

(** Generates random prelim days for a class. *)
val generate_prelim : unit -> prelim

(** Creates a class with n amount of prelims. *)
val create_class : string -> int -> class'

(** Checks if the current day is the same as the prelim. *)
val prelim_date_checker : prelim list -> int -> int -> bool

(** Takes the prelim if the prelim_data_checker is true. 
    Prelim date has to be the same as the current date. *)
val take_prelim : int -> class' -> class'

(** Lists of courses that a player can take. *)
val courses_list : class' list
