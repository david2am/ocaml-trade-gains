open Trade.Tax

(* Case 1 *)
let data_1 = (
  [
    Buy  { unit_cost = 10.; quantity = 100 };
    Sell { unit_cost = 15.; quantity = 50  };
    Sell { unit_cost = 15.; quantity = 50  };
  ],
  [None; None; None]
)


(* Case 2 *)
let data_2 = (
  [
    Buy  { unit_cost = 10.; quantity = 10000 };
    Sell { unit_cost = 20.; quantity = 5000  };
    Sell { unit_cost = 5.;  quantity = 5000  };
  ],
  [None; Some 10000.; None]
)


(* Case 3 *)
let data_3 = (
  [
    Buy  { unit_cost = 10.; quantity = 10000 };
    Sell { unit_cost = 5.;  quantity = 5000  };
    Sell { unit_cost = 20.; quantity = 3000  };
  ],
  [None; None; Some 1000.]
)


(* Case 4 *)
let data_4 = (
  [
    Buy  { unit_cost = 10.; quantity = 10000 };
    Buy  { unit_cost = 25.; quantity = 5000  };
    Sell { unit_cost = 15.; quantity = 10000 };
  ],
  [None; None; None]
)


(* Case 5 x *)
let data_5 = (
  [
    Buy  { unit_cost = 10.; quantity = 10000 };
    Buy  { unit_cost = 25.; quantity = 5000  };
    Sell { unit_cost = 15.; quantity = 10000 };
    Sell { unit_cost = 25.; quantity = 5000  };
  ],
  [None; None; None; Some 10000.]
)


(* Case 6 *)
let data_6 = [
  Buy  { unit_cost = 10.; quantity = 10000 };
  Sell { unit_cost = 2.;  quantity = 5000  };
  Sell { unit_cost = 20.; quantity = 2000  };
  Sell { unit_cost = 20.; quantity = 2000  };
  Sell { unit_cost = 25.; quantity = 1000  };
],
[None; None; None; None; Some 3000.]


(* Case 7 x *)
let data_7 = (
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
)


(* Case 8 x *)
let data_8 = (
  [
    Buy  { unit_cost = 10.; quantity = 10000 };
    Sell { unit_cost = 50.; quantity = 10000 };
    Buy  { unit_cost = 20.; quantity = 10000 };
    Sell { unit_cost = 50.; quantity = 10000 };
  ],
  [None; Some 80000.;None; Some 60000.]
)


(* Case 9 x *)
let data_9 = (
  [
    Buy  { unit_cost = 5000.;  quantity = 10 };
    Sell { unit_cost = 4000.;  quantity = 5  };
    Buy  { unit_cost = 15000.; quantity = 5  };
    Buy  { unit_cost = 4000.;  quantity = 2  };
    Buy  { unit_cost = 23000.; quantity = 2  };
    Sell { unit_cost = 20000.; quantity = 1  };
    Sell { unit_cost = 12000.; quantity = 10 }; (* x 2000 *)
    Sell { unit_cost = 15000.; quantity = 3  };
  ],
  [None; None; None; None; None; None; Some 1000.; Some 2400.]
)

let test_case (input, expect) = fun () ->
  let threshold = 20000. in
  let tax_percent = 0.2 in
  let calc_tax = calc_tax_builder threshold tax_percent in

  let expect = expect in
  let actual = List.map calc_tax input in
  
  Alcotest.(check (float 0.0001 |> option |> list)) "Case 1" expect actual


let () =
  Alcotest.run "Trade Taxes" [
    "list validation", [
      Alcotest.test_case "Case 1" `Quick @@ test_case data_1;
      Alcotest.test_case "Case 2" `Quick @@ test_case data_2;
      Alcotest.test_case "Case 3" `Quick @@ test_case data_3;
      Alcotest.test_case "Case 4" `Quick @@ test_case data_4;
      Alcotest.test_case "Case 5" `Quick @@ test_case data_5;
      Alcotest.test_case "Case 6" `Quick @@ test_case data_6;
      Alcotest.test_case "Case 7" `Quick @@ test_case data_7;
      Alcotest.test_case "Case 8" `Quick @@ test_case data_8;
      Alcotest.test_case "Case 9" `Quick @@ test_case data_9;
    ]
  ]