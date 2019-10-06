StoryDay = require "src.StoryDay"

class StoryDay3 extends StoryDay
	new: => super!

	getText: =>
		ret   = "You enter the stocks building and look around. In front of you is a table of companies and their values."
		ret ..= " You overhear a few people talk about a company called Electrotech: \"They have this big new announcement"
		ret ..= " coming tomorrow of a new product, it's supposed to be revolutionary and change our lives forever!\""

		ret ..= "\n\nThat sounds promising. It looks like they're one of the biggest stock players though. Perhaps something"
		ret ..= " smaller can be invested in..."

		ret ..= "\n\nYou recall your friend from back in New York excitedly talking about a new skateboarding company called"
		ret ..= " Crazy Rides. You look through the table of companies and decide what you want to invest in."

		return ret
