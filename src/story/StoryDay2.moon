suit = require "lib.suit"

StoryDay = require "src.StoryDay"

class StoryDay2 extends StoryDay
	new: => super!

	onStartOfDay: =>
		if g_game\hasFlag "day1_skip_money_on_floor"
			g_game\giveMoney 100, "From police officer"
		g_game.force_action = true

	getText: =>
		ret   = "You had nowhere to go last night, so you decided to sleep in between some buildings, since it provided"
		ret ..= " a little bit of cover from the rain that decided to pour down."

		if g_game\hasFlag "day1_skip_money_on_floor"
			ret ..= "\n\nA police officer walks up to you. Feeling sorry for how you've slept all night, he gives you $100"
			ret ..= " to spend on necessities. \"Hey, I found this $50 bill earlier today on the street! Can you believe"
			ret ..= " it??\" He laughed. You feel a little better about not picking up someone else's money yesterday. You"
			ret ..= " accept the money from the police officer and thank him."

		ret ..= "\n\nSuddenly, you recall you have some knowledge about the stock market! Walking around the town for"
		ret ..= " a few minutes, you find a big building that says: \"Stocks\". A bit on the nose, but okay. Right next"
		ret ..= " to the stocks building, there's a grocery store. Hmm, food is probably more important right now."

		ret ..= "\n\nSeems like it's possible to live on just $10 per day for now. Nice!"

		if @stage == 1
			ret ..= "\n\nYou look through a pile of garbage that somebody just dropped on the ground. You briefly think about"
			ret ..= " the environment and how people are destroying the earth by dumping their garbage right out on the street."
			ret ..= " Your mood quickly turns around as you find $20 in an old chinese food container."

		return ret

	makeInterface: =>
		if suit.Button("Spend $10 on food and sleep until morning", suit.layout\row(300, 20)).hit
			g_game\takeMoney 10, "Daily expenses"
			g_game\nextDay!
			return

		if @stage == 0
			if suit.Button("Scavenge pile of garbage", suit.layout\col(200, 20)).hit
				g_game\giveMoney 20, "Found in trash"
				g_game\nextStoryStage!

	isStocksInterfaceAvailable: => false
