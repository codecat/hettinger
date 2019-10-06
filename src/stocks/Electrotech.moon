Stock = require "src.Stock"

class ElectrotechStock extends Stock
	new: =>
		super "ETCH", "Electrotech"

		@price = love.math.random 970, 1190

	onEndOfDay: =>
		if g_game.day_count == 3
			@price_delta = love.math.random -60, -40
