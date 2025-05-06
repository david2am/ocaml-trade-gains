open Trade.Tax

let () =
  let calculate_tax = calculate_tax_builder ~threshold:20000. ~tax_percent:0.2 in
  let input = [
    Buy  { unit_cost = 5000. ; quantity = 10 };
    Sell { unit_cost = 4000. ; quantity = 5  };
    Buy  { unit_cost = 15000.; quantity = 5  };
    Buy  { unit_cost = 4000. ; quantity = 2  };
    Buy  { unit_cost = 23000.; quantity = 2  };
    Sell { unit_cost = 20000.; quantity = 1  };
    Sell { unit_cost = 12000.; quantity = 10 };
    Sell { unit_cost = 15000.; quantity = 3  };
  ] in
  print_endline "\n(Output)";
  print_tax_list @@ List.map calculate_tax input
