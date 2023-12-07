type category =
  | Consumable of int * int
  | Supplies of string * int option
  | Tech of string * int option
  | Misc of string * int option

type item = { name : string; description : string; category : category }

let make_item name description category = { name; description; category }

let consumables_catelog =
  [
    make_item "Iced Tea" "Ice Cold Delicious Beverage. Heals 20 Health"
      (Consumable (20, 4));
    make_item "Lollipops" "Sweet and savory. Heals 10 health."
      (Consumable (10, 4));
    make_item "Cornell Dairy Ice Cream"
      "Legally speaking, this is butter. Heals 25 health."
      (Consumable (25, 5));
    {
      name = "CELSIUS Sparkling Energy Drink";
      description = "Elixir of life for a Cornell engineer. Heals 15 health.";
      category = Consumable (15, 6);
    };
    {
      name = "Mattin's Quesadilla";
      description =
        "A quesadilla with sour cream, salsa, and guacamole. Heals 30 health.";
      category = Consumable (30, 8);
    };
  ]

let supplies_catelog =
  [
    make_item "Cornell ID"
      "Your very own ID card! Keep it with you at all times."
      (Supplies ("placeholder", None));
    make_item "Canada Goose Jacket"
      "Unnecessarily expensive jacket to withstand the cold. Made from real \
       geese!"
      (Supplies ("placeholder", None));
    make_item "Adderall XR 20mg"
      "A very rare commodity due to the National shortage!"
      (Supplies ("placeholder", None));
  ]

let tech_catelog =
  [
    make_item "iPad with Apple Pencil" "Because you're too good for paper."
      (Tech ("placeholder", None));
    make_item "MacBook Pro" "Expensive laptop." (Tech ("placeholder", None));
  ]

let misc_catelog =
  [
    make_item "Poster" "From the Cornell Store's poster sale!"
      (Tech ("placeholder", None));
  ]

let items_catelog =
  [ consumables_catelog; supplies_catelog; tech_catelog; misc_catelog ]
