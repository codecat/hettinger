suit = require "lib.suit"

Utils = require "src.Utils"

StoryDay = require "src.StoryDay"
StoryDay1 = require "src.story.StoryDay1"
StoryDay2 = require "src.story.StoryDay2"
StoryDay3 = require "src.story.StoryDay3"
StoryDay4 = require "src.story.StoryDay4"
CharityDriveStoryDay = require "src.story.CharityDriveStoryDay"

StockManager = require "src.StockManager"
Portfolio = require "src.Portfolio"
History = require "src.History"

class Game
	width: 1024
	height: 768

	content_left: 250
	content_right: 10

	day_count: 0
	story_day: nil
	story_text: nil

	story_flags: {}

	intro_timer: 4.0

	money: 0
	money_max: 0
	daily_cost: 10

	stock_worth: 0
	stock_worth_today: -1
	stock_worth_yesterday: 0

	stock_manager: nil
	portfolio: nil
	history: nil

	game_over: false

	new: =>
		@font_normal = love.graphics.newFont 12
		@font_normal_bold = love.graphics.newFont "res/fonts/VeraBd.ttf", 12
		@font_mono = love.graphics.newFont "res/fonts/Cascadia.ttf", 12
		@font_status = love.graphics.newFont 24

		@sound_intro = love.audio.newSource "res/audio/intro.wav", "static"
		@sound_coin = love.audio.newSource "res/audio/coin.wav", "static"
		@sound_coin\setVolume 0.1

		@stock_manager = StockManager!
		@portfolio = Portfolio!
		@history = History!

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

	start: =>
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
		interface_y = 110 + @story_text\getHeight! + 20
		suit.layout\reset @content_left, interface_y, 4, 4

		if @game_over
			suit.layout\push @width / 2 - 96, @height / 2 + 64
			if suit.Button("Restart game", suit.layout\row(192, 20)).hit
				export g_game = Game!
				g_game\start!
			suit.layout\pop!
		else
			@story_day\makeInterface!

			if love.keyboard.isDown "f3"
				if suit.Button("(dev) give $5000", suit.layout\row(200, 20)).hit
					@giveMoney 5000, "dev grant"

			@makeStocksInterface! if @story_day\isStocksInterfaceAvailable!

	makeStocksInterface: =>
		x, y = suit.layout\row 100, 20
		suit.layout\reset @content_left, y + 20, 4, 4

		if love.keyboard.isDown "f3"
			if suit.Button("(dev) simulate stock day", suit.layout\row(200, 20)).hit
				@stock_manager\onEndOfDay!
				@stock_manager\onStartOfDay!

		headerOptions =
			font: @font_normal_bold
			color:
				normal:
					fg: { 0.60, 0.62, 0.63 }

		suit.Label "STOCK", headerOptions, suit.layout\newline(264, 20)
		suit.Label "PRICE", headerOptions, suit.layout\col(80, 20)
		suit.Label "CHANGE", headerOptions, suit.layout\col!
		suit.Label "OWNED", headerOptions, suit.layout\col(60, 20)
		suit.Label "WORTH", headerOptions, suit.layout\col(80, 20)

		for stock in *@stock_manager.stocks
			ownedStock = @portfolio\getOwnedStock(stock.id)
			price = stock\getPrice!
			priceYesterday = stock\getPriceYesterday!

			stockIdOptions =
				align: "right"
				font: @font_mono
				color:
					normal:
						fg: { 0.60, 0.62, 0.63 }

			suit.Label stock.id, stockIdOptions, suit.layout\newline(40, 20)
			suit.Label stock.name, { align: "left" }, suit.layout\col(220, 20)
			suit.Label Utils.formatThousands("$" .. price), suit.layout\col(80, 20)

			change = price - priceYesterday

			changeText = Utils.formatThousands change
			if change > 0
				changeText = "+" .. changeText

			changeOptions =
				color:
					normal:
						fg: { 0.10, 0.12, 0.13 }
				font: @font_normal_bold

			if change > 0
				changeOptions.color.normal.fg = { 0.10, 0.80, 0.13 }
			elseif change < 0
				changeOptions.color.normal.fg = { 0.80, 0.12, 0.13 }

			suit.Label "$" .. changeText, changeOptions, suit.layout\col!

			suit.Label Utils.formatThousands(ownedStock.amount), suit.layout\col(60, 20)
			suit.Label Utils.formatThousands("$" .. (ownedStock.amount * price)), suit.layout\col(80, 20)

			if @money >= price
				if suit.Button("Buy", { id: "buy_" .. stock.id }, suit.layout\col(60, 20)).hit
					@takeMoney price, "Bought " .. stock.name .. " stock"
					@portfolio\addStock stock.id, 1
					stock\onBought 1
					@updateStockWorth!
			else
				suit.layout\col(60, 20)

			if ownedStock.amount > 0
				if suit.Button("Sell", { id: "sell_" .. stock.id }, suit.layout\col(60, 20)).hit
					@giveMoney price, "Sold " .. stock.name .. " stock"
					@portfolio\removeStock stock.id, 1
					stock\onSold 1
					@updateStockWorth!
			else
				suit.layout\col(60, 20)

	giveMoney: (amount, description) =>
		@money += amount
		if @money > @money_max
			@money_max = @money
		@history\add amount, description

		if @intro_timer <= 1
			@sound_coin\stop!
			@sound_coin\play!

	takeMoney: (amount, description) =>
		@money -= amount
		@history\add -amount, description

		if @intro_timer <= 1
			@sound_coin\stop!
			@sound_coin\play!

		if @money < 0
			@game_over = true

	updateStockWorth: =>
		@stock_worth = @getStockWorth!
		@stock_worth_today = -1

	getStockWorth: =>
		ret = 0
		print "Updating stock worth"
		for stock in *@stock_manager.stocks
			ownedStock = @portfolio\getOwnedStock stock.id
			ret += stock\getPrice! * ownedStock.amount
		return ret

	makeDay: =>
		return StoryDay1! if @day_count == 1
		return StoryDay2! if @day_count == 2
		return StoryDay3! if @day_count == 3
		return StoryDay4! if @day_count == 4

		return CharityDriveStoryDay! if @day_count % 5 == 0

		return StoryDay!

	nextDay: =>
		love.audio.stop!

		@intro_timer = 4.0
		if love.keyboard.isDown "f3"
			@intro_timer = 1.0

		@stock_worth_yesterday = @getStockWorth!

		if @story_day ~= nil
			@story_day\onEndOfDay!

			if @story_day\isStocksInterfaceAvailable!
				@stock_manager\onEndOfDay!

		@sound_intro\stop!
		@sound_intro\play!

		@day_count += 1

		@story_day = @makeDay!

		if @story_day\isStocksInterfaceAvailable!
			@stock_manager\onStartOfDay!

		@story_day\onStartOfDay!
		@updateStoryText!

		@updateStockWorth!

		@stock_worth_today = @getStockWorth!
		if @stock_worth_today == 0
			@stock_worth_today = -1

	updateStoryText: =>
		@story_text = love.graphics.newText @font_normal, ""
		@story_text\setf @story_day\getText!, @width - @content_left - @content_right, "left"

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
		love.graphics.printf "Day " .. @day_count, math.floor(@width * 0.5) - 100, 20, 200, "center"

		love.graphics.setFont @font_status
		love.graphics.printf Utils.formatThousands("$" .. @money), math.floor(@width * 0.5) - 300, 44, 600, "center"

		love.graphics.setFont @font_normal
		love.graphics.printf "Stock worth", math.floor(@width * 0.75) - 100, 20, 200, "center"

		love.graphics.setFont @font_status

		stockWorthText = {}
		table.insert stockWorthText, { 0.10, 0.12, 0.13 }
		table.insert stockWorthText, Utils.formatThousands("$" .. @stock_worth)

		if @stock_worth_today ~= -1
			change = @stock_worth_today - @stock_worth_yesterday
			changeText = Utils.formatThousands change
			if change > 0
				changeText = "+" .. changeText

			if change > 0
				table.insert stockWorthText, { 0.10, 0.80, 0.13 }
			elseif change < 0
				table.insert stockWorthText, { 0.80, 0.12, 0.13 }
			else
				table.insert stockWorthText, { 0.10, 0.12, 0.13 }
			table.insert stockWorthText, " $" .. changeText

		love.graphics.setColor 1, 1, 1
		love.graphics.printf stockWorthText, math.floor(@width * 0.75) - 300, 44, 600, "center"

	draw: =>
		love.graphics.clear 0.97, 0.95, 0.94

		@drawStatusBar!

		love.graphics.setColor 0.10, 0.12, 0.13
		love.graphics.draw @story_text, @content_left, 110

		@history\draw!

		if @game_over
			love.graphics.setColor 1 - 0.97, 1 - 0.95, 1 - 0.94, 0.85
			love.graphics.rectangle "fill", 0, 0, @width, @height

			love.graphics.setColor 1 - 0.97, 1 - 0.95, 1 - 0.94
			love.graphics.rectangle "fill", @width / 2 - 200, @height / 2 - 100, 400, 200, 4, 4

			love.graphics.setColor 1 - 0.10, 1 - 0.12, 1 - 0.13
			love.graphics.setFont @font_normal_bold
			love.graphics.printf "Game over.", @width / 2 - 200, @height / 2 - 90, 400, "center"

			love.graphics.setFont @font_normal
			love.graphics.printf "You went bankrupt. All of your remaining stocks vanished and were given to the poor. So you kind of did something good after all! Your largest amount of money owned was:", @width / 2 - 190, @height / 2 - 70, 380

			love.graphics.setFont @font_status
			love.graphics.printf Utils.formatThousands("$" .. @money_max), @width / 2 - 200, @height / 2 - 10, 400, "center"

		love.graphics.setFont @font_normal
		suit.draw!

		if not @game_over and @intro_timer > 0
			alpha = @intro_timer
			if alpha > 1.0
				alpha = 1.0
			alpha = alpha * alpha * alpha * alpha

			love.graphics.setColor 1 - 0.97, 1 - 0.95, 1 - 0.94, alpha
			love.graphics.rectangle "fill", 0, 0, @width, @height

			if @intro_timer < 3
				love.graphics.setColor 1 - 0.10, 1 - 0.12, 1 - 0.13, alpha
				love.graphics.setFont @font_status
				love.graphics.printf "Day " .. @day_count, @width / 2 - 300, @height / 2 - 60, 600, "center"

			love.graphics.setFont @font_normal
