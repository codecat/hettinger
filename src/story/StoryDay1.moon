suit = require "lib.suit"

StoryDay = require "src.StoryDay"

class StoryDay1 extends StoryDay
	new: => super!

	onEndOfDay: =>
		if g_game.money == 0
			g_game\setFlag "day1_skip_20"

	getText: =>
		ret   = "Welcome to the town of Hettinger. You're not entirely sure how you got here, but you're here now,"
		ret ..= " without cash on hand. Fortunately for you, it looks like someone dropped a $20 bill right in front"
		ret ..= " of you on the sidewalk! How convenient."

		if @stage == 1
			ret ..= "\n\nYou picked up the $20 bill. It fills you with joy! You can't wait to spend it."

		return ret

	makeInterface: =>
		if @stage == 0
			if suit.Button("Pick up $20 bill", suit.layout\col!).hit
				g_game\giveMoney 20
				g_game\nextStoryStage!
