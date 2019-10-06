Stock = require "src.Stock"

class CrazyRidesStock extends Stock
	new: =>
		super "CRAY", "Crazy Rides"

		@price = love.math.random(6, 10)
