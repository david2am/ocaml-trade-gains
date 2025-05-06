open Trade.Tax

(* Test cases data *)
let test_data = [
  (* Case 1 *)
  (
    [
      Buy  { unit_cost = 10.; quantity = 100 };
      Sell { unit_cost = 15.; quantity = 50  };
      Sell { unit_cost = 15.; quantity = 50  };
    ],
    [None; None; None]
  );
  (* Case 2 *)
  (
    [
      Buy  { unit_cost = 10.; quantity = 10000 };
      Sell { unit_cost = 20.; quantity = 5000  };
      Sell { unit_cost = 5.;  quantity = 5000  };
    ],
    [None; Some 10000.; None]
  );
  (* Case 3 *)
  (
    [
      Buy  { unit_cost = 10.; quantity = 10000 };
      Sell { unit_cost = 5.;  quantity = 5000  };
      Sell { unit_cost = 20.; quantity = 3000  };
    ],
    [None; None; Some 1000.]
  );
  (* Case 4 *)
  (
    [
      Buy  { unit_cost = 10.; quantity = 10000 };
      Buy  { unit_cost = 25.; quantity = 5000  };
      Sell { unit_cost = 15.; quantity = 10000 };
    ],
    [None; None; None]
  );
  (* Case 5 *)
  (
    [
      Buy  { unit_cost = 10.; quantity = 10000 };
      Buy  { unit_cost = 25.; quantity = 5000  };
      Sell { unit_cost = 15.; quantity = 10000 };
      Sell { unit_cost = 25.; quantity = 5000  };
    ],
    [None; None; None; Some 10000.]
  );
  (* Case 6 *)
  (
    [
      Buy  { unit_cost = 10.; quantity = 10000 };
      Sell { unit_cost = 2.;  quantity = 5000  };
      Sell { unit_cost = 20.; quantity = 2000  };
      Sell { unit_cost = 20.; quantity = 2000  };
      Sell { unit_cost = 25.; quantity = 1000  };
    ],
    [None; None; None; None; Some 3000.]
  );
  (* Case 7 *)
  (
    [
      Buy  { unit_cost = 10.; quantity = 10000 };
      Sell { unit_cost = 2.;  quantity = 5000  };
      Sell { unit_cost = 20.; quantity = 2000  };
      Sell { unit_cost = 20.; quantity = 2000  };
      Sell { unit_cost = 25.; quantity = 1000  };
      Buy  { unit_cost = 20.; quantity = 10000 };
      Sell { unit_cost = 15.; quantity = 5000  };
      Sell { unit_cost = 30.; quantity = 4350  };
      Sell { unit_cost = 30.; quantity = 650   };
    ],
    [None; None; None; None; Some 3000.; None; None; Some 3700.; None]
  );
  (* Case 8 *)
  (
    [
      Buy  { unit_cost = 10.; quantity = 10000 };
      Sell { unit_cost = 50.; quantity = 10000 };
      Buy  { unit_cost = 20.; quantity = 10000 };
      Sell { unit_cost = 50.; quantity = 10000 };
    ],
    [None; Some 80000.;None; Some 60000.]
  );
  (* Case 9 *)
  (
    [
      Buy  { unit_cost = 5000.;  quantity = 10 };
      Sell { unit_cost = 4000.;  quantity = 5  };
      Buy  { unit_cost = 15000.; quantity = 5  };
      Buy  { unit_cost = 4000.;  quantity = 2  };
      Buy  { unit_cost = 23000.; quantity = 2  };
      Sell { unit_cost = 20000.; quantity = 1  };
      Sell { unit_cost = 12000.; quantity = 10 };
      Sell { unit_cost = 15000.; quantity = 3  };
    ],
    [None; None; None; None; None; None; Some 1000.; Some 2400.]
  );
]

(* Create test cases from the data *)
let create_test_case idx (input, expect) =
  let test_name = Printf.sprintf "Case %d" (idx + 1) in
  let test_fun () =
    let calc_tax = calc_tax_builder ~threshold:20000. ~tax_percent:0.2 in
    let actual = List.map calc_tax input in
    
    Alcotest.(check (float 0.0001 |> option |> list)) test_name expect actual
  in
  Alcotest.test_case test_name `Quick test_fun

let () =
  Alcotest.run "Trade Taxes" [
    "Tax Calculation Tests", List.mapi create_test_case test_data 
  ]