type category =
  | Consumable of int * int
  | Supplies of string * int option
  | Tech of string * int option
  | Misc of string * int option

type item = { name : string; description : string; category : category }

let consumables_catelog =
  [
    {
      name = "Iced Tea";
      description = "Ice Cold Delicious Beverage. Heals 20 health.";
      category = Consumable (20, 4);
    };
    {
      name = "Lolipops";
      description = "Sweet and savory. Heals 10 health.";
      category = Consumable (10, 4);
    };
    {
      name = "Cornell Dairy Ice Cream";
      description = "Legally speaking, this is butter. Heals 25 health.";
      category = Consumable (25, 5);
    };
  ]

let supplies_catelog =
  [
    {
      name = "Cornell ID";
      description = "Your very own ID card! Keep it with you at all times.";
      category = Supplies ("placeholder", None);
    };
    {
      name = "Canada Goose Jacket";
      description =
        "Unnecessarily expensive jacket to withstand the cold. \n\
        \        Made from real geese!";
      category = Supplies ("placeholder", None);
    };
    {
      name = "Adderall XR 20mg";
      description = "A very rare commodity due to the National shortage!";
      category = Supplies ("placeholder", None);
    };
  ]

let tech_catelog =
  [
    {
      name = "iPad with Apple Pencil";
      description = "Because you're too good for paper.";
      category = Tech ("placeholder", None);
    };
    {
      name = "MacBook Pro";
      description = "Expensive laptop.";
      category = Tech ("placeholder", None);
    };
  ]

let misc_catelog =
  [
    {
      name = "Poster";
      description = "From the Cornell Store's poster sale!";
      category = Tech ("placeholder", None);
    };
  ]

let items_catelog =
  [ consumables_catelog; supplies_catelog; tech_catelog; misc_catelog ]
