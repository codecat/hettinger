Stock = require "src.Stock"

class ElectrotechStock extends Stock
	new: =>
		super "ETCH", "Electrotech"

		@price = love.math.random(8100, 8900)
