
recurring_bills = [
	"rent",
	"power bills",
	"water bills",
	"membership dues",
	"HOA fees",
	"protection money",
	"spaghetti money",
	"tuition",
	"fertilizer",
	"meral fees",
	"AWS costs",
	"munitions",
	"legal fees",
	"union dues",
	"slippage fees",
	"corkage fees"
]

module.exports = (robot) ->
	robot.respond /(what'?s the )?(total )?cost of (ownership of|owning a)/i, (msg) ->
		cost_type = msg.random ["single", "financed", "single_recurring"]

		if cost_type == "single"
			single_cost = msg.random [5..250]
			msg.send "Probably like $#{single_cost}"
		if cost_type == "financed"
			single_cost = msg.random [230..900]
			monthly_cost = msg.random [20..300]
			util_cost = msg.random [5..190]
			util = msg.random recurring_bills
			msg.send "For you? $#{single_cost} down, $#{monthly_cost}/month! Watch out for the $#{util_cost}/mo in #{util}, though."
		if cost_type == "single_recurring"
			single_cost = msg.random [100..300]
			util_cost = msg.random [5..800]
			util = msg.random recurring_bills
			msg.send "Hmm... not too bad. You can get one for $#{single_cost}, but there's also $#{util_cost}/mo in #{util}."
