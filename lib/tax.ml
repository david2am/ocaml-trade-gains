type data = { unit_cost : float ; quantity : int }
type trade = Buy of data | Sell of data
type trade_result = Loss | Draw | Win

let calculate_amount data =
  let { unit_cost; quantity } = data in
  let quantity = Int.to_float quantity in

  unit_cost *. quantity

let calculate_weight_avg prev_weight_avg prev_data data =
  let { unit_cost; quantity } = data in
  let quantity = Int.to_float quantity in
  let prev_quantity = Int.to_float prev_data.quantity in

  if prev_quantity = 0. then unit_cost
  else (prev_quantity *. prev_weight_avg +. quantity *. unit_cost) /. (prev_quantity +. quantity)

let calculate_profit weight_avg data =
  let { unit_cost; quantity } = data in
  let quantity = Int.to_float quantity in

  quantity *. (unit_cost -. weight_avg)

(* Sell *)
let map_gross_profit profit =
  match compare profit 0. with
    | -1 -> Loss
    |  1 -> Win
    |  _ -> Draw

let calculate_tax profit tax_percent = profit *. tax_percent

let calculate_net_profit loss profit =
  match compare loss profit with
  | -1 -> (0., profit -. loss) (* no loss, losses are deducted from profits *)
  |  1 -> (loss -. profit, 0.) (* profits are deducted from losses, no profit *)
  |  _ -> (0., 0.)             (* loss balance profits *)

let calc_tax_builder threshold tax_percent = 
  let weight_avg = ref 0. in
  let stocks = ref 0 in
  let gross_profit = ref 0. in
  let prev_data = ref { quantity = 0; unit_cost = 0. } in
  let loss = ref 0. in
  let net_profit = ref 0. in

  fun trade ->
    match trade with
    | Buy data ->
      weight_avg := calculate_weight_avg !weight_avg !prev_data data;
      stocks := !stocks + data.quantity;
      None
    | Sell data ->
      gross_profit := calculate_profit !weight_avg data;
      stocks := !stocks - data.quantity;
      prev_data := data;
      begin match map_gross_profit !gross_profit with
      | Loss ->
        loss := !loss -. !gross_profit; None
      | Draw -> None
      | Win -> 
        let loss_, profit_ = calculate_net_profit !loss !gross_profit in
        let amount = calculate_amount data in
        net_profit := profit_;
        loss := loss_;
        let is_taxable = (!gross_profit > threshold || amount > threshold) && !net_profit > 0. in

        if is_taxable then Some (calculate_tax !net_profit tax_percent ) else None
      end

let print_tax t =
  match t with
  | None -> print_endline "No Tax"
  | Some amount -> Printf.printf "Tax %.2f\n" amount

let print_tax_list taxes = List.iter print_tax taxes
