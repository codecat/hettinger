class Stock
	id: ""
	name: ""

	price: 100
	price_yesterday: 100

	price_delta: 0
	days_in_delta: 0

	lowest_possible: 3
	random_range: 5

	player_purchased_today: 0

	new: (id, name) =>
		@id = id
		@name = name

		@price = love.math.random(70, 130)
		@price_delta = love.math.random(-10, 10)
		@price_yesterday = @price + @price_delta

	getPrice: => @price
	getPriceYesterday: => @price_yesterday

	onBought: (amount) => @player_purchased_today += 1
	onSold: (amount) => @player_purchased_today -= 1

	onStartOfDay: =>
		@price_yesterday = @price

		--@price += @player_purchased_today * 2
		@player_purchased_today = 0

		rangeStart = @price_delta - @random_range
		rangeEnd = @price_delta + @random_range
		@price += love.math.random(rangeStart, rangeEnd)

		deltaRangeStart = -@random_range
		deltaRangeEnd = @random_range

		if @days_in_delta > 2
			if @price_delta < 0
				deltaRangeStart = 0
			elseif @price_delta > 0
				deltaRangeEnd = 0

		deltaBefore = @price_delta
		@price_delta += love.math.random(deltaRangeStart, deltaRangeEnd)

		if (deltaBefore > 0 and @price_delta < 0)
			@days_in_delta = 0

		print @id .. " new delta: " .. @price_delta .. " (days in delta: " .. @days_in_delta .. ")"

		@days_in_delta += 1

		if @price < @lowest_possible
			@price = @lowest_possible

	onEndOfDay: =>
