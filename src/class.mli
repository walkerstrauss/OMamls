type prelim = int * int

type class' = {
  name : string;
  prelims : prelim list;
  grade : (int * int) option;
}

val generate_prelim : unit -> prelim
val create_class : string -> int -> class'
val prelim_date_checker : prelim list -> int -> int -> bool
val take_prelim : int -> class' -> class'
