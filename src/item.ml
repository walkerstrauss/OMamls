type category =
  | Consumable of int * int
  | Supplies of string * int option
  | Tech of string * int option
  | Misc of string * int option

type item = { name : string; description : string; category : category }

let make_item name description category = { name; description; category }

let rename_item item name =
  { name; description = item.description; category = item.category }

let iced_tea =
  make_item "Iced Tea" "Ice Cold Delicious Beverage. Heals 20 Health"
    (Consumable (20, 4))

let lollipop =
  make_item "Lollipop" "Sweet and savory. Heals 10 health." (Consumable (10, 4))

let ice_cream =
  make_item "Cornell Dairy Ice Cream"
    "Legally speaking, this is butter. Heals 25 health."
    (Consumable (25, 5))

let celcius =
  make_item "CELSIUS Sparkling Energy Drink"
    "Elixir of life for a Cornell engineer. Heals 15 health."
    (Consumable (15, 6))

let quesadilla =
  make_item "Mattin's Quesadilla"
    "A quesadilla with sour cream, salsa, and guacamole. Heals 30 health."
    (Consumable (30, 8))

let cornell_id =
  make_item "Cornell ID" "Your very own ID card! Keep it with you at all times."
    (Supplies ("placeholder", None))

let cg_jacket =
  make_item "Canada Goose Jacket"
    "Unnecessarily expensive jacket to withstand the cold. Made from real \
     geese!"
    (Supplies ("placeholder", None))

let adderal =
  make_item "Adderall XR 20mg"
    "A very rare commodity due to the National shortage!"
    (Supplies ("placeholder", None))

let ipad =
  make_item "iPad with Apple Pencil" "Because you're too good for paper."
    (Tech ("placeholder", None))

let mac =
  make_item "MacBook Pro" "Expensive laptop." (Tech ("placeholder", None))

let poster =
  make_item "Poster" "From the Cornell Store's poster sale!"
    (Tech ("placeholder", None))

let item_of_string s =
  match s with
  | "Iced Tea" -> iced_tea
  | "Lollipop" -> lollipop
  | "Cornell Dairy Ice Cream" | "Ice Cream" -> ice_cream
  | "Celcius" | "CELCIUS" | "CELCIUS Sparkling Energy Drink" -> celcius
  | "Quesadilla" -> quesadilla
  | "Cornell ID" -> cornell_id
  | "Canada Goose Jacket" -> cg_jacket
  | "Adderal" -> adderal
  | "iPad with Apple Pencil" | "iPad" -> ipad
  | "MacBook Pro" | "Macbook Pro" -> mac
  | "Poster" -> poster
  | _ -> failwith "Not a valid item"

let consumables_catelog = [ iced_tea; lollipop; ice_cream; celcius; quesadilla ]
let supplies_catelog = [ cornell_id; cg_jacket; adderal ]
let tech_catelog = [ ipad; mac ]
let misc_catelog = [ poster ]

let items_catelog =
  [ consumables_catelog; supplies_catelog; tech_catelog; misc_catelog ]
