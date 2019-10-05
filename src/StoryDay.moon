class StoryDay
	stage: 0

	new: =>

	onStartOfDay: =>
	onEndOfDay: =>

	getText: => "A new day begins."
	makeInterface: =>

	isStocksInterfaceAvailable: => g_game.day_count >= 3
