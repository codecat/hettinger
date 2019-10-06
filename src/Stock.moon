class Stock
	id: ""
	name: ""

	price: 100
	price_yesterday: 100

	price_delta: 0
	days_in_delta: 0

	lowest_possible: 1

	random_range_low: -6
	random_range_high: 6

	player_purchased_today: 0

	new: (id, name, initialPrice, rangeLow, rangeHigh, lowestPossible) =>
		@id = id
		@name = name

		@lowest_possible = lowestPossible or 1

		@price = initialPrice or 100
		@price += love.math.random -50, 50
		if @price < @lowest_possible
			@price = @lowest_possible

		@price_delta = love.math.random -10, 10
		@price_yesterday = @price + @price_delta

		@random_range_low = rangeLow or -6
		@random_range_high = rangeHigh or 6

	getPrice: => @price
	getPriceYesterday: => @price_yesterday

	onBought: (amount) => @player_purchased_today += 1
	onSold: (amount) => @player_purchased_today -= 1

	onStartOfDay: =>
		@price_yesterday = @price

		--@price += @player_purchased_today * 2
		@player_purchased_today = 0

		rangeStart = @price_delta + @random_range_low
		rangeEnd = @price_delta + @random_range_high

		delta = love.math.random(rangeStart, rangeEnd)
		@price += delta

		print @id .. ": " .. delta

		deltaRangeStart = @random_range_low
		deltaRangeEnd = @random_range_high

		if @days_in_delta > 2
			if @price_delta < 0
				deltaRangeStart = 0
				deltaRangeEnd *= 2
			elseif @price_delta > 0
				deltaRangeEnd = 0
				deltaRangeStart *= 2

		deltaBefore = @price_delta
		@price_delta += love.math.random(deltaRangeStart, deltaRangeEnd)

		if (deltaBefore > 0 and @price_delta < 0)
			@days_in_delta = 0

		@days_in_delta += 1

		if @price < @lowest_possible
			@price = @lowest_possible

	onEndOfDay: =>
