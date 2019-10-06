StoryDay = require "src.StoryDay"

class StoryDay4 extends StoryDay
	new: => super!

	getText: =>
		ret   = "The newspaper reads: \"Eletrotech product launch ends in disaster\". At least Crazy Rides seems to be doing"
		ret ..= "well: \"Skateboarding craze hits Hettinger!\""

		return ret
