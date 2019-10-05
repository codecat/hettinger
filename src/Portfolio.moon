class Portfolio
	stocks: {}

	new: =>

	getOwnedAmount: (id) =>
		ret = @stocks[id]
		return ret if ret ~= nil
		return 0

	addStock: (id, amount) =>
		if @stocks[id] ~= nil
			@stocks[id] += amount
		else
			@stocks[id] = amount
