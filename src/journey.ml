type time = Int * Int 

type weekday = 
  | Monday 
  | Tueday 
  | Wednesday
  | Thursday 
  | Friday 
  | Saturday
  | Sunday

type day = weekday * time

type week = Int * day list

type semester = week list
