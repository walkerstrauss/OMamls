type category = Consumable of int * int | Supplies of string * int option | Tech of string * int option | Misc of string * int option

type item = {
    name : string;
    description : string;
    category : category; 
}

let consumables_catelog = [
    {
        name = "Ice Tea";
        description = "Ice Cold Delicious Beverage. Heals 20 health.";
        category = Consumable (20, 4);
    }
    ;
    {
        name = "Lolipops";
        description = "Sweet and savory. Heals 10 health.";
        category = Consumable (10, 4);
    }
]

let supplies_catelog = [
]

let tech_catelog = [
]

let misc_catelog = [
]

let items_catelog = [consumables_catelog; supplies_catelog; tech_catelog; misc_catelog]