suit = require "lib.suit"

Utils = require "src.Utils"

class StoryDay
	stage: 0

	new: =>

	onStartOfDay: =>
	onEndOfDay: =>

	getText: => "A new day begins."
	makeInterface: =>
		if suit.Button("Sleep until morning ($" .. Utils.formatThousands(g_game.daily_cost) .. ")", suit.layout\row(200, 30)).hit
			g_game\takeMoney g_game.daily_cost
			g_game\nextDay!

	isStocksInterfaceAvailable: => true
