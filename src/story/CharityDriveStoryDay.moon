suit = require "lib.suit"

StoryDay = require "src.StoryDay"

Utils = require "src.Utils"

available_charities = {
	{ "Children's Hospital", "helping the children" }
	{ "Trans Rights", "restoring the rights of transgender people" }
	{ "Doctors Without Border Walls", "helping people all over the world" }
	{ "The Hettinger Dog Shelter", "giving treats to all the good boys" }
	{ "Cat Rescue International", "giving homeless cats a nice place to stay" }
	{ "Weed For Old People", "helping old people get high" }
	{ "Bob", "being Bob" }
}

class CharityDriveStoryDay extends StoryDay
	new: =>
		super!

		@charity = available_charities[love.math.random 1, #available_charities]

	getText: =>
		ret = "A local charity has noticed your wealth! " .. @charity[1] .. " is asking for a small donation towards their good cause of " .. @charity[2] .. "."

		if @stage == 1
			if @donated < 10
				ret ..= "\n\nYou donated towards the charity. \"Thank you for your small - but important - contribution!\" You're left feeling a little bit judged on"
				ret ..= " the size of your donation, but you feel good about it either way."
			elseif @donated >= 500
				ret ..= "\n\nYou donated a very generous amount towards the charity. \"WOW, thank you so much!\" A nice feeling of warmth goes through your body."
				ret ..= " You surely did a great thing today."
			else
				ret ..= "\n\nYou generously donated towards the charity. \"Thank you so much!\""

		return ret

	makeInterface: =>
		if @stage == 1
			super!

		if @stage == 0
			@makeDonationButton 1, true
			@makeDonationButton 5, true
			@makeDonationButton 10, true
			@makeDonationButton 50
			@makeDonationButton 100
			@makeDonationButton 500
			@makeDonationButton 1000

	makeDonationButton: (amount, foced) =>
		if not forced and amount > g_game.money
			return

		if suit.Button(Utils.formatThousands("$" .. amount), suit.layout\row(100, 20)).hit
			@donated = amount
			g_game\takeMoney amount, "Charity: " .. @charity[1]
			g_game\nextStoryStage!

	isStocksInterfaceAvailable: => @stage == 1
