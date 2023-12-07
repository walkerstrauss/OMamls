type time = int * int 

type weekday = 
  | Monday 
  | Tueday 
  | Wednesday
  | Thursday 
  | Friday 
  | Saturday
  | Sunday

type day = weekday * time

type week = int * day list

type semester = week list
