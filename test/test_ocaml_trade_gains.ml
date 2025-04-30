(* Tests Cases *)
let test_float_list () =
  let expect = [None; None; Some 1.] in
  let actual = [None; None; Some 1.] in
  
  Alcotest.(check @@ list @@ option @@ float 0.0001) "Case 1" expect actual

let () =
  Alcotest.run "Trade Taxes" [
    "list validation", [
      Alcotest.test_case "validate float list" `Quick test_float_list;
    ]
  ]