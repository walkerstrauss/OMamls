type prelim = int * int

type class' = {
  name : string;
  prelims : prelim list;
  grade : (int * int) option;
}

val generate_prelim : unit -> prelim
val create_class : string -> int
val take_prelim : int -> class'
