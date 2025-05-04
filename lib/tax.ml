type data = { unit_cost : float ; quantity : int }
type trade = Buy of data | Sell of data
type trade_result = Loss | Draw | Win

let calculate_amount data = data.unit_cost *. Int.to_float data.quantity

let calculate_weight_avg prev_weight_avg stock_qty data =
  let { unit_cost; quantity } = data in
  let quantity = Int.to_float quantity in
  let prev_quantity = Int.to_float stock_qty in

  if prev_quantity = 0. then unit_cost
  else (prev_quantity *. prev_weight_avg +. quantity *. unit_cost) /. (prev_quantity +. quantity)

let calculate_profit weight_avg data = (Int.to_float data.quantity) *. (data.unit_cost -. weight_avg)

(* Sell *)
let map_gross_profit profit =
  match compare profit 0. with
    | -1 -> Loss
    |  1 -> Win
    |  _ -> Draw

let calculate_tax profit tax_percent = profit *. tax_percent

let calculate_net_profit loss profit =
  if loss > profit then
    (loss -. profit, 0.)  (* profits are deducted from losses, no profit *)
  else
    (0., profit -. loss)  (* no loss, losses are deducted from profits *)

let calc_tax_builder threshold tax_percent =
  let weight_avg = ref 0. in
  let stock_qty = ref 0 in
  let loss = ref 0. in

  fun trade ->
    match trade with
    | Buy data ->
      weight_avg := calculate_weight_avg !weight_avg !stock_qty data;
      stock_qty := !stock_qty + data.quantity;
      None
    | Sell data ->
      if !stock_qty < data.quantity then
        failwith "Cannot sell more stocks than owned";

      let gross_profit = calculate_profit !weight_avg data in
      stock_qty := !stock_qty - data.quantity;
      begin match map_gross_profit gross_profit with
      | Loss ->
        loss := !loss -. gross_profit; None
      | Draw -> None
      | Win -> 
        let loss_, net_profit = calculate_net_profit !loss gross_profit in
        loss := loss_;
        let amount = calculate_amount data in
        let is_taxable = (gross_profit > threshold || amount > threshold) && net_profit > 0. in

        if is_taxable then Some (calculate_tax net_profit tax_percent ) else None
      end

let print_tax t =
  match t with
  | None -> print_endline "No Tax"
  | Some amount -> Printf.printf "Tax %.2f\n" amount

let print_tax_list taxes = List.iter print_tax taxes
