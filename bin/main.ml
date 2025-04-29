type operation = Buy | Sell

type stock_operation = { operation : operation ; unit_cost : float ; quantity : int }

type tax = { tax : float }

let input = [
  { operation = Buy;  unit_cost = 10.; quantity = 10000 };
  { operation = Sell; unit_cost = 20.; quantity = 5000  };
  { operation = Buy;  unit_cost = 20.; quantity = 10000 };
  { operation = Sell; unit_cost = 10.; quantity = 5000  };
]

let output = [
  { tax = 0. };
  { tax = 10000. };
  { tax = 0. };
  { tax = 0. }
]

let tax_percent = 0.2
let threshold = 20000.




let () =
  print_endline "\nInput:";
  print_endline "\n\nOutput:";


