open Printf
open Character

let rec strGenerator n str acc =
  if n = 0 then acc else strGenerator (n - 1) str (acc ^ str)

let spaceGenerator n = strGenerator n " " ""

let title x =
  let len = 94 - String.length x in
  match len mod 2 with
  | 1 ->
      printf "x |%s%s%s| x \n"
        (spaceGenerator ((len / 2) + 1))
        x
        (spaceGenerator (len / 2))
  | _ ->
      printf "x |%s%s%s| x \n"
        (spaceGenerator (len / 2))
        x
        (spaceGenerator (len / 2))

let progressBar value max_value =
  if value > max_value then failwith "Value cannot be greater than max value"
  else
    let percentage =
      int_of_float
        (Float.round (float_of_int value /. float_of_int max_value *. 10.))
    in
    let hp = strGenerator percentage "█" "" in
    let mhp = strGenerator (10 - percentage) "▒" "" in
    hp ^ mhp

let header text =
  printf
    "+----------------------------------------------------------------------\n\
    \    ----------------------------+ \n";
  text;
  printf
    "x====================================================================\n\
    \    ==============================x \n"

let footer text =
  printf
    "x==================================================================\n\
    \    ================================x \n";
  text;
  printf
    "+------------------------------------------------------\n\
    \    --------------------------------------------+ \n"

(*let instore name currScreen currency items storeName =
  match currScreen with
  | "Main" ->
      header ("Welcome to " ^ storeName);
      printf "x | [̲̅$̲̅(̲̅ιο̲̅̅)̲̅$̲̅] : 0                                                                                 | x \n";
      printf "x |                                                  1. Abilities                                | x \n";
      printf "x |                                                                                              | x \n";
      printf "x |                                                  2. Inventory                                | x \n";
      printf "x |                                                                                              | x \n";
      printf "x |                                                  3. Flee                                     | x \n";
      printf "x |                                                                                              | x \n";
      printf "+---------------------------------------------------------------
      -----------------------------------+ \n";
  | "Buy" ->
    header ("Welcome to " ^ storeName);
      printf "x | [̲̅$̲̅(̲̅ιο̲̅̅)̲̅$̲̅] : 0                                                                                 | x \n";
      printf "x |                                                  1. Abilities                                | x \n";
      printf "x |                                                                                              | x \n";
      printf "x |                                                  2. Inventory                                | x \n";
      printf "x |                                                                                              | x \n";
      printf "x |                                                  3. Flee                                     | x \n";
      printf "x |                                                                                              | x \n";
      printf "+----------------------------------------------------------
      ----------------------------------------+ \n";
  | "Sell" ->
    header ("Welcome to " ^ storeName);
      printf "x | [̲̅$̲̅(̲̅ιο̲̅̅)̲̅$̲̅] : 0                                                                                 | x \n";
      printf "x |                                                  1. Abilities                                | x \n";
      printf "x |                                                                                              | x \n";
      printf "x |                                                  2. Inventory                                | x \n";
      printf "x |                                                                                              | x \n";
      printf "x |                                                  3. Flee                                     | x \n";
      printf "x |                                                                                              | x \n";
      printf "+--------------------------------------------------------
      ------------------------------------------+ \n";
  | _ -> failwith "Store doesn't have this screen"
*)

(* let character_creation state input =
   match state with
   | "name" ->
     header (title "What shall we call you?");
   | "major" ->
     header (title "What is your intended major");
   | "confirmation" ->
     header (title "Are you happy with yourself?");
   | _ -> failwith "This state does not exist"
*)

let namePrint name rowSpace =
  if String.length name < rowSpace then
    name ^ spaceGenerator (rowSpace - String.length name)
  else String.sub name 0 (rowSpace - 4) ^ "..."

let battle state p1 p2 =
  Helper.clear_terminal ();
  match state with
  | "main" ->
      header (title (p1.name ^ " is battling " ^ p2.name ^ "!"));
      printf
        "x |                                          |         \
         |                                          | x\n";
      printf
        "x |                                          |         \
         |                                          | x\n";
      printf
        "x |                                          |         \
         |                                          | x\n";
      printf
        "x \
         |-----------------------------------------------------------------------------------------------| \
         x\n";
      printf
        "x | [U] -> %s|         | <1> Abilities       | <3> Flee           | x\n"
        (namePrint
           (p1.name ^ " " ^ progressBar (fst p1.health) (snd p1.health))
           54);
      printf
        "x | [O] -> %s|         | <2> Inventory       | <CTRL-D> Quit      | x\n"
        (namePrint
           (p2.name ^ " " ^ progressBar (fst p2.health) (snd p2.health))
           54);
      footer (title "OMaml's Test")
  | "abilities" ->
      header (title "Checking the arsenal!");
      printf "x | [1] -> %s|         |  [1] -> %s| x" (namePrint p1.name 34)
        (namePrint p2.name 34);
      printf "x |        %s|         |         %s| x"
        (namePrint (progressBar (fst p1.health) (snd p1.health)) 34)
        (namePrint (progressBar (fst p2.health) (snd p2.health)) 34);
      printf
        "x |                                          |         \
         |                                          | x";
      printf
        "x |                                          |         \
         |------------------------------------------| x";
      printf
        "x |                                          |         | <1> %s| <3> \
         %s| x"
        (namePrint (List.nth (abilities_to_list p1) 0) 18)
        (namePrint (List.nth (abilities_to_list p1) 3) 18);
      printf
        "x |                                          |         | <2> %s| <4> \
         %s| x"
        (namePrint (List.nth (abilities_to_list p1) 2) 18)
        (namePrint (List.nth (abilities_to_list p1) 4) 18);
      footer (title "OMaml's Test")
  | _ -> failwith "This state is not found"
