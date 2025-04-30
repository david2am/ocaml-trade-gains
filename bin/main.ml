open Trade.Tax

let threshold = 20000.
let tax_percent = 0.2
(* let input = [
  Buy  { unit_cost = 10.; quantity = 10000 };
  Sell { unit_cost = 20.; quantity = 5000  };
  Sell { unit_cost = 5. ; quantity = 5000  };
] *)

(* Case 2 *)
(* let input = [
  Buy  { unit_cost = 10.; quantity = 100 };
  Sell { unit_cost = 15.; quantity = 50  };
  Sell { unit_cost = 15.; quantity = 50  };
  Buy  { unit_cost = 10.; quantity = 10000 };
  Sell { unit_cost = 20.; quantity = 5000  };
  Sell { unit_cost = 5. ; quantity = 5000  };
] *)

(* Case 3 *)
(* let input = [
  Buy  { unit_cost = 10.; quantity = 10000 };
  Sell { unit_cost = 5.; quantity = 5000   };
  Sell { unit_cost = 20.; quantity = 3000  };
] *)

(* Case 4 *)
(* let input = [
  Buy  { unit_cost = 10.; quantity = 10000 };
  Buy  { unit_cost = 25.; quantity = 5000  };
  Sell { unit_cost = 15.; quantity = 10000  };
] *)

(* Case 5 x *)

(* let input = [
  Buy  { unit_cost = 10.; quantity = 10000 };
  Buy  { unit_cost = 25.; quantity = 5000  };
  Sell { unit_cost = 15.; quantity = 10000 };
  Sell { unit_cost = 25.; quantity = 5000  }; (* x 10000 *)
] *)

(* Case 6 *)
(* let input = [
  Buy  { unit_cost = 10.; quantity = 10000 };
  Sell { unit_cost = 2.;  quantity = 5000  };
  Sell { unit_cost = 20.; quantity = 2000  };
  Sell { unit_cost = 20.; quantity = 2000  };
  Sell { unit_cost = 25.; quantity = 1000  };
] *)


(* Case 7 x *)
(* let input = [
  Buy  { unit_cost = 10.; quantity = 10000 };
  Sell { unit_cost = 2.;  quantity = 5000  };
  Sell { unit_cost = 20.; quantity = 2000  };
  Sell { unit_cost = 20.; quantity = 2000  };
  Sell { unit_cost = 25.; quantity = 1000  };
  Buy  { unit_cost = 20.; quantity = 10000 };
  Sell { unit_cost = 15.; quantity = 5000  };
  Sell { unit_cost = 30.; quantity = 4350  }; (* x *)
  Sell { unit_cost = 30.; quantity = 650  };
] *)

(* Case 8 x *)
(* let input = [
  Buy  { unit_cost = 10.; quantity = 10000 };
  Sell { unit_cost = 50.; quantity = 10000 };
  Buy  { unit_cost = 20.; quantity = 10000 };
  Sell { unit_cost = 50.; quantity = 10000 }; (* x 60000 *)
] *)

(* Case 9 x *)
let input = [
  Buy  { unit_cost = 5000.;  quantity = 10 };
  Sell { unit_cost = 4000.;  quantity = 5  };
  Buy  { unit_cost = 15000.; quantity = 5  };
  Buy  { unit_cost = 4000.;  quantity = 2  };
  Buy  { unit_cost = 23000.; quantity = 2  };
  Sell { unit_cost = 20000.; quantity = 1  };
  Sell { unit_cost = 12000.; quantity = 10 }; (* x 1000 *)
  Sell { unit_cost = 15000.; quantity = 3  }; (* x 24000 *)
]

let calc_tax = calc_tax_builder threshold tax_percent

let () =
  print_endline "\n";
  print_tax_list (List.map calc_tax input)
