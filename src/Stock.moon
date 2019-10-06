class Stock
	id: ""
	name: ""

	price: 100
	price_yesterday: 100

	lowest_possible: 3
	random_range: 10

	player_purchased_today: 0

	new: (id, name) =>
		@id = id
		@name = name

		@price = love.math.random(70, 130)
		@price_yesterday = @price + love.math.random(-10, 10)

	getPrice: => @price
	getPriceYesterday: => @price_yesterday

	onBought: (amount) => @player_purchased_today += 1
	onSold: (amount) => @player_purchased_today -= 1

	onStartOfDay: =>
		@price += @player_purchased_today * 2
		@player_purchased_today = 0

		@price += love.math.random(-@random_range, @random_range)

		if @price < @lowest_possible
			@price = @lowest_possible

	onEndOfDay: =>
		@price_yesterday = @price
