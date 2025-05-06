type data = { unit_cost : float ; quantity : int }
type trade = Buy of data | Sell of data
type trade_result = Loss | Draw | Win

let calculate_weight_avg old_w_avg stocks { unit_cost; quantity } =
  let quantity = Int.to_float quantity in
  let stocks = Int.to_float stocks in

  if stocks = 0. then
    unit_cost
  else
    (old_w_avg *. stocks  +. unit_cost *. quantity) /. (stocks +. quantity)

let calculate_profit weight_avg data = 
  (data.unit_cost -. weight_avg) *. Int.to_float data.quantity

let operation_result profit =
  match compare profit 0. with
    | -1 -> Loss
    |  1 -> Win
    |  _ -> Draw

let calculate_amount data = 
  data.unit_cost *. Int.to_float data.quantity

let calculate_loss_and_profit loss profit =
  if loss > profit then
    loss -. profit, 0.
  else
    0., profit -. loss    

let calc_tax_builder threshold tax_percent =
  let weight_avg = ref 0. in
  let stock_qty = ref 0 in
  let acc_loss = ref 0. in

  fun trade ->
    match trade with
    | Buy data ->
      weight_avg := calculate_weight_avg !weight_avg !stock_qty data;
      stock_qty := !stock_qty + data.quantity;
      None
    | Sell data ->
      if !stock_qty < data.quantity then
        failwith "Cannot sell more stocks than owned";

      stock_qty := !stock_qty - data.quantity;
      let gross_profit = calculate_profit !weight_avg data in

      begin match operation_result gross_profit with
      | Loss -> acc_loss := !acc_loss -. gross_profit; None
      | Win when calculate_amount data > threshold ->
        let loss, net_profit = calculate_loss_and_profit !acc_loss gross_profit in
        acc_loss := loss;

        if net_profit > 0. then
          Some (net_profit *. tax_percent) 
        else 
          None
      | _ -> None
      end

let print_tax t =
  match t with
  | None -> print_endline "No Tax"
  | Some tax -> Printf.printf "Tax %.2f\n" tax

let print_tax_list taxes = 
  List.iter print_tax taxes
