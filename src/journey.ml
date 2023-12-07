open Location
open Character
open Event

type weekday = 
  | Monday 
  | Tuesday 
  | Wednesday
  | Thursday 
  | Friday 

type day = weekday

let print_time (time : time) : string =
  let (hour, minute) = time in 
  match minute with 
  |i when i<10 -> string_of_int hour ^ ":0" ^ string_of_int minute 
  |_ -> string_of_int hour ^ ":" ^ string_of_int minute

let next_day (day : day) :day = 
  match day with 
  | Monday -> Tuesday
  | Tuesday -> Wednesday 
  | Wednesday -> Thursday
  | Thursday -> Friday
  | Friday -> Monday

let add_time (old_time : time) (duration : time) : time = 
  let (hour, minute) = old_time in 
  let (dur_hour, dur_minute) = duration in
  match minute+dur_minute with 
  | i when i>59 -> (hour+dur_hour+1, minute+dur_minute-60)
  | _ -> (hour+dur_hour, minute+dur_minute)

let morrison_hall : location = {place=(Dorm (North, "Toni Morrison Hall")); events=[];}

let day (char1 : character) (week : int) =
  let rec events (location : location) (time : time) = 
    (*print out time and current skill levels*)
    print_endline("The time is " ^ (print_time time) ^ ". " ^ "What would you like to do?");
    (*access current location, give options for which events are available*)

    (*run specified event, updating skills accordingly and adding to the time*)

    (*if time is past midnight, stop giving option for more events (stop calling recursively)*)
    let (hour, minute) = time in
    match hour with
    |i when i>23 -> print_endline("You are done for the day!");
    |_ -> (**events location time*) print_endline ("");
  (*print out the day, start going into events until time is done for the day*)
    print_endline("Currently it is week " ^ string_of_int week ^ ". The day is ");
    print_endline("You wake up in your dorm room.")
  in events morrison_hall (8,0)
