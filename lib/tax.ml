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
  if profit < 0. then Loss
  else if profit > 0. then Win
  else Draw

let calculate_amount data = 
  data.unit_cost *. Int.to_float data.quantity

let calculate_loss_and_profit loss profit =
  let remaining_loss = Float.max 0. (loss -. profit) in
  let net_profit = Float.max 0. (profit -. loss) in
  (remaining_loss, net_profit)

type calculator_state = {
  weight_avg : float;
  stock_qty : int;
  acc_loss : float;
}

let calculate_tax_builder ~threshold ~tax_percent =
  let state = ref { weight_avg = 0.; stock_qty = 0; acc_loss = 0. } in

  fun trade ->
    match trade with
    | Buy data ->
      state := {
        !state with
        weight_avg = calculate_weight_avg !state.weight_avg !state.stock_qty data;
        stock_qty = !state.stock_qty + data.quantity;
      };
      None
    | Sell data ->
      if !state.stock_qty < data.quantity then
        failwith "Cannot sell more stocks than owned";

      let gross_profit = calculate_profit !state.weight_avg data in
      state := { !state with stock_qty = !state.stock_qty - data.quantity };
      
      begin match operation_result gross_profit with
      | Loss -> 
        state := { !state with acc_loss = !state.acc_loss -. gross_profit };
        None
      | Win when calculate_amount data > threshold ->
        let updated_acc_loss, net_profit = calculate_loss_and_profit !state.acc_loss gross_profit in
        state := { !state with acc_loss = updated_acc_loss };
        if net_profit > 0. then Some (net_profit *. tax_percent) else None
      | _ -> None
      end

let print_tax i t =
  let i = i + 1 in
  match t with
  | None -> print_endline ("Op " ^ Int.to_string i ^ " Tax: 0")
  | Some tax -> Printf.printf "Op %d Tax: %.0f\n" i tax

let print_tax_list taxes = 
  List.iteri print_tax taxes
