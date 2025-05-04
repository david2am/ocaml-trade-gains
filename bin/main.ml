open Trade.Tax

let threshold = 20000.
let tax_percent = 0.2

(* Case 1 + 2 *)
let input = [
  Buy  { unit_cost = 10.; quantity = 100 };
  Sell { unit_cost = 15.; quantity = 50  };
  Sell { unit_cost = 15.; quantity = 50  };
  Buy  { unit_cost = 10.; quantity = 10000 };
  Sell { unit_cost = 20.; quantity = 5000  };
  Sell { unit_cost = 5. ; quantity = 5000  };
]

let calc_tax = calc_tax_builder threshold tax_percent

let () =
  print_endline "\nHello, World!";
  print_tax_list (List.map calc_tax input)
