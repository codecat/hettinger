suit = require "lib.suit"

StoryDay = require "src.StoryDay"

class StoryDay1 extends StoryDay
	new: => super!

	onEndOfDay: =>
		if g_game.money == 0
			g_game\setFlag "day1_skip_money_on_floor"

	getText: =>
		ret   = "Welcome to the town of Hettinger. You're not entirely sure how you got here, but you're here now,"
		ret ..= " without cash on hand. Fortunately for you, it looks like someone dropped a $50 bill right in front"
		ret ..= " of you on the sidewalk! Wow, how convenient."

		if @stage == 1
			ret ..= "\n\nYou picked up the $50 bill. It fills you with joy! You can't wait to spend it."

		return ret

	makeInterface: =>
		if suit.Button("Sleep until morning", suit.layout\row(200, 30)).hit
			g_game\nextDay!

		if @stage == 0
			if suit.Button("Pick up $50 bill", suit.layout\col!).hit
				g_game\giveMoney 50, "Found on street"
				g_game\nextStoryStage!

		if suit.Button("Game over", suit.layout\newline!).hit
			g_game\takeMoney 100, "Test game over"

	isStocksInterfaceAvailable: => false
