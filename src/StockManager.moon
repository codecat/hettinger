Stock = require "src.Stock"
ElectrotechStock = require "src.stocks.Electrotech"
CrazyRidesStock = require "src.stocks.CrazyRides"

class StockManager
	stocks: {}

	new: =>
		table.insert @stocks, ElectrotechStock!
		table.insert @stocks, CrazyRidesStock!

	getStock: (id) =>
		for stock in *@stocks
			return stock if stock.id == id
		return nil

	onStartOfDay: =>
		for stock in *@stocks
			stock\onStartOfDay!

	onEndOfDay: =>
		for stock in *@stocks
			stock\onEndOfDay!
