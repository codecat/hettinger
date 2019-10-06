Stock = require "src.Stock"
ElectrotechStock = require "src.stocks.Electrotech"
CrazyRidesStock = require "src.stocks.CrazyRides"

class StockManager
	stocks: {}

	new: =>
		@stocks = {}
		table.insert @stocks, Stock("NITO", "Nimble Tools", 1600, -6, 44)
		table.insert @stocks, Stock("PEAR", "Pear Inc.", 230)
		table.insert @stocks, ElectrotechStock!
		table.insert @stocks, Stock("POOP", "Peer-oriented Operating Platforms")
		table.insert @stocks, Stock("BIRD", "Big Radios")
		table.insert @stocks, CrazyRidesStock!
		table.insert @stocks, Stock("BOB", "Bob", 30, -20, 30)
		table.insert @stocks, Stock("MCRO", "Macro Software Inc.", 140)
		table.insert @stocks, Stock("CCF", "CC Flooring", 60)
		table.insert @stocks, Stock("CCF", "Backyard Mechanics", 80)
		table.insert @stocks, Stock("BTC", "Buttcoin", 7300, -200, 200, 1200)
		table.insert @stocks, Stock("4AS", "4-A's Touchless Car Wash", 120)
		table.insert @stocks, Stock("HBBY", "Healthy Baby Group", 170)
		table.insert @stocks, Stock("TNT", "Technoman & Tunegirl", 40)
		table.insert @stocks, Stock("CNN", "C&N Cafe", 70)
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
