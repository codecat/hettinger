Stock = require "src.Stock"

class CrazyRidesStock extends Stock
	new: =>
		super "CRAY", "Crazy Rides"

		@price = love.math.random 6, 10

	onEndOfDay: =>
		if g_game.day_count == 3
			@price_delta = love.math.random @random_range + 1, @random_range + 5
