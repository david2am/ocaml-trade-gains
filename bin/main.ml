open Trade.Tax

let threshold = 20000.
let tax_percent = 0.2

(* let input = [
  Buy  { unit_cost = 10.; quantity = 10000 };
  Sell { unit_cost = 20.; quantity = 5000  };
  Buy  { unit_cost = 20.; quantity = 10000 };
  Sell { unit_cost = 10.; quantity = 5000  }
]
 *)

let calc_tax = calc_tax_builder threshold tax_percent

let () =
  let result = calc_tax @@ Buy { unit_cost = 10.; quantity = 10000 } in
  print_tax result
