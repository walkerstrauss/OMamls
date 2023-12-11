type prelim = int * int

type class' = {
  name : string;
  prelims : prelim list;
  grade : (int * int) option;
}

let generate_prelim () : prelim =
  let day =
    Random.int 5 + 1
    (* match Random.int 5 + 1 with
       | 1 -> Monday
       | 2 -> Tuesday
       | 3 -> Wednesday
       | 4 -> Thursday
       | 5 -> Friday
       | _ -> failwith "Unreachable!" *)
  in
  (day, Random.int 14 + 1)

let create_class (name : string) (prelim_count : int) : class' =
  let rec generate_prelim_list (count : int) : prelim list =
    if count = 0 then []
    else generate_prelim () :: generate_prelim_list (count - 1)
  in
  { name; prelims = generate_prelim_list prelim_count; grade = None }

let rec prelim_date_checker (prelims : prelim list) (week: int) (day : int): bool = 
  match prelims with 
  | [] -> false
  | (tst_day, tst_week) :: t when ((tst_day = day) && (tst_week = week)) -> true
  | _ :: t -> prelim_date_checker t week day 

let take_prelim (preparedness : int) (class' : class') : class' =
  match class'.prelims with
  | [] -> class'
  | _ :: t ->
      let grade = Random.int (100 - preparedness) + preparedness in
      let total_grade =
        match class'.grade with
        | None -> Some (grade, 1)
        | Some (init, count) ->
            Some (((init * count) + grade) / (count + 1), count + 1)
      in
      { class' with prelims = t; grade = total_grade }

let courses_list: class' list = 
  [(create_class "CS1110" 3); (create_class "ENGL1710" 1)]