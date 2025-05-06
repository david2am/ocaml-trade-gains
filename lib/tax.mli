type data = { unit_cost : float ; quantity : int }
type trade = Buy of data | Sell of data

val calc_tax_builder : threshold:float -> tax_percent:float -> trade -> float option
val print_tax_list : float option list -> unit