suit = require "lib.suit"

Utils = require "src.Utils"

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
		@font_normal_bold = love.graphics.newFont "res/fonts/VeraBd.ttf", 12
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

		if not @force_action and suit.Button("Sleep until morning", suit.layout\row(200, 30)).hit
			@nextDay!
			return

		@story_day\makeInterface!

		@makeStocksInterface! -- if @story_day\isStocksInterfaceAvailable!

	makeStocksInterface: =>
		x, y = suit.layout\row 100, 30
		suit.layout\reset 200, y + 20, 4, 4

		headerOptions =
			color:
				normal:
					fg: { 0.60, 0.62, 0.63 }
			font: @font_normal_bold

		suit.Label "STOCK", headerOptions, suit.layout\newline(100, 30)
		suit.Label "PRICE", headerOptions, suit.layout\col!
		suit.Label "CHANGE", headerOptions, suit.layout\col!
		suit.Label "OWNED", headerOptions, suit.layout\col!
		suit.Label "WORTH", headerOptions, suit.layout\col!

		for stock in *@stock_manager.stocks
			ownedStock = @portfolio\getOwnedStock(stock.id)
			price = stock\getPrice!
			priceYesterday = stock\getPriceYesterday!

			suit.Label stock.id, suit.layout\newline(100, 30)
			suit.Label Utils.formatThousands("$" .. price), suit.layout\col!

			change = price - priceYesterday
			changeOptions =
				color:
					normal:
						fg: { 0.10, 0.12, 0.13 }
				font: @font_normal_bold

			if price > priceYesterday
				changeOptions.color.normal.fg = { 0.10, 0.80, 0.13 }
			elseif price < priceYesterday
				changeOptions.color.normal.fg = { 0.80, 0.12, 0.13 }

			suit.Label Utils.formatThousands("$" .. change), changeOptions, suit.layout\col!

			suit.Label ownedStock.amount, suit.layout\col!
			suit.Label Utils.formatThousands("$" .. (ownedStock.amount * price)), suit.layout\col!

			if @money >= price
				if suit.Button("Buy", { id: "buy_" .. stock.id }, suit.layout\col(60, 30)).hit
					@money -= price
					@portfolio\addStock stock.id, 1
					stock\onBought 1
			else
				suit.layout\col(60, 30)

			if ownedStock.amount > 0
				if suit.Button("Sell", { id: "sell_" .. stock.id }, suit.layout\col(60, 30)).hit
					@money += price
					@portfolio\removeStock stock.id, 1
					stock\onSold 1
			else
				suit.layout\col(60, 30)

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
		@stock_manager\onEndOfDay!

		@intro_timer = 4.0
		@day_count += 1
		@force_action = false

		@story_day = @makeDay!

		@stock_manager\onStartOfDay!
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
		love.graphics.printf "Day " .. @day_count, @width / 2 - 100, 20, 200, "center"

		love.graphics.setFont @font_status
		love.graphics.printf Utils.formatThousands("$" .. @money), @width / 2 - 300, 44, 600, "center"

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
