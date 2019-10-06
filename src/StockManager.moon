Stock = require "src.Stock"
ElectrotechStock = require "src.stocks.Electrotech"
CrazyRidesStock = require "src.stocks.CrazyRides"

class StockManager
	stocks: {}

	new: =>
		table.insert @stocks, Stock("NITO", "Nimble Tools", 1600, -6, 18)
		table.insert @stocks, Stock("PEAR", "Pear Inc.", 230)
		table.insert @stocks, ElectrotechStock!
		table.insert @stocks, Stock("POOP", "Peer-oriented Operating Platforms")
		table.insert @stocks, Stock("BIRD", "Big Radios")
		table.insert @stocks, CrazyRidesStock!
		table.insert @stocks, Stock("BOB", "Bob", 30, -20, 20)
		table.insert @stocks, Stock("MCRO", "Macro Software Inc.", 140)
		table.insert @stocks, Stock("CRAP", "Crooked Applications")
		table.insert @stocks, Stock("MCD", "McDarwin Corp", 210)
		table.insert @stocks, Stock("HBBY", "Healthy Baby Group", 170)
		table.insert @stocks, Stock("TNT", "Technoman & Tunegirl", 40)
		table.insert @stocks, Stock("DOW", "Jones Corp", 26500, -100, 100)

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
