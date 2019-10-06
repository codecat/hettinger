OwnedStock = require "src.OwnedStock"

class Portfolio
	stocks: {}

	new: =>
		@stocks = {}

	getOwnedStock: (id) =>
		if @stocks[id] == nil
			@stocks[id] = OwnedStock id, 0
		return @stocks[id]

	addStock: (id, amount) => @getOwnedStock(id)\add amount
	removeStock: (id, amount) => @getOwnedStock(id)\remove amount
