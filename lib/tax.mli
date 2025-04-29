type data = { unit_cost : float ; quantity : int }
type trade = Buy of data | Sell of data
type tax =  NoTax | Tax of float
type trade_result = Loss | Draw | Win
type state = ProcessProfit | ProcessAmount

val calc_tax_builder : float -> float -> trade -> tax
val print_tax : tax -> unit
val print_tax_list : tax list -> unit