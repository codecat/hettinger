suit = require "lib.suit"

StoryDay = require "src.StoryDay"
StoryDay1 = require "src.story.StoryDay1"
StoryDay2 = require "src.story.StoryDay2"
StoryDay3 = require "src.story.StoryDay3"

StockManager = require "src.StockManager"
Portfolio = require "src.Portfolio"

easeInQuart = (x) -> x * x * x * x

class Game
	width: 1024
	height: 768

	day_count: 0
	story_day: nil
	story_text: nil

	story_flags: {}

	intro_timer: 4.0
	money: 0

	force_action: false

	stock_manager: nil
	portfolio: nil

	new: =>
		@font_normal = love.graphics.newFont 12
		@font_status = love.graphics.newFont 24

		@stock_manager = StockManager!
		@portfolio = Portfolio!

		suit.theme.cornerRadius = 2
		suit.theme.color =
			normal:
				bg: { 0.92, 0.89, 0.88 }
				fg: { 0.10, 0.12, 0.13 }
			hovered:
				bg: { 0.88, 0.84, 0.83 }
				fg: { 0.10, 0.12, 0.13 }
			active:
				bg: { 0.77, 0.74, 0.73 }
				fg: { 0.10, 0.12, 0.13 }

		@nextDay!

	keypressed: (key, scancode, isrepeat) => suit.keypressed key
	textedited: (text, start, length) => suit.textedited text, start, length
	textinput: (t) => suit.textinput t

	update: (dt) =>
		if @intro_timer > 0
			@intro_timer -= dt
		else
			@intro_timer = 0

		if @intro_timer < 1.0
			@makeInterface!

	makeInterface: =>
		interface_y = 150 + @story_text\getHeight! + 20
		suit.layout\reset 200, interface_y, 4, 4

		if not @force_action and suit.Button("Sleep until morning", suit.layout\row(200, 20)).hit
			@nextDay!
			return

		@story_day\makeInterface!

		@makeStocksInterface! -- if @story_day\isStocksInterfaceAvailable!

	makeStocksInterface: =>
		x, y = suit.layout\nextRow!
		suit.layout\reset 100, y + 20, 4, 4

		for stock in *@stock_manager.stocks
			suit.Label stock.id, suit.layout\newline(100, 30)
			suit.Label "foo", suit.layout\col!
			suit.Label "bar", suit.layout\col!

	giveMoney: (amount) => @money += amount
	takeMoney: (amount) => @money -= amount

	makeDay: =>
		return StoryDay1! if @day_count == 1
		return StoryDay2! if @day_count == 2
		return StoryDay3! if @day_count == 3
		return StoryDay!

	nextDay: =>
		if @story_day ~= nil
			@story_day\onEndOfDay!

		@intro_timer = 4.0
		@day_count += 1
		@force_action = false

		@story_day = @makeDay!

		@story_day\onStartOfDay!
		@updateStoryText!

	updateStoryText: =>
		@story_text = love.graphics.newText @font_normal, ""
		@story_text\setf @story_day\getText!, @width - 400, "left"

	nextStoryStage: =>
		@story_day.stage += 1
		@updateStoryText!

	hasFlag: (flag) =>
		for f in *@story_flags
			return true if f == flag
		return false

	setFlag: (flag) =>
		table.insert @story_flags, flag

	drawStatusBar: =>
		love.graphics.setColor 0.91, 0.89, 0.88
		love.graphics.rectangle "fill", 0, 0, @width, 100

		love.graphics.setColor 0.10, 0.12, 0.13

		love.graphics.setFont @font_normal
		love.graphics.printf "Day " .. @day_count, @width / 2 - 100, 14, 200, "center"

		love.graphics.setFont @font_status
		love.graphics.printf "$" .. @money, @width / 2 - 300, 38, 600, "center"

	drawStoryText: =>
		love.graphics.draw @story_text, 200, 150

	draw: =>
		love.graphics.clear 0.97, 0.95, 0.94

		@drawStatusBar!
		@drawStoryText!

		love.graphics.setFont @font_normal
		suit.draw!

		if @intro_timer > 0
			alpha = @intro_timer
			if alpha > 1.0
				alpha = 1.0
			alpha = easeInQuart alpha

			love.graphics.setColor(1 - 0.97, 1 - 0.95, 1 - 0.94, alpha)
			love.graphics.rectangle("fill", 0, 0, @width, @height)

			if @intro_timer < 3.25
				love.graphics.setColor(1 - 0.10, 1 - 0.12, 1 - 0.13, alpha)
				love.graphics.setFont @font_status
				love.graphics.printf "Day " .. @day_count, @width / 2 - 300, @height / 2 - 60, 600, "center"

			love.graphics.setFont @font_normal
