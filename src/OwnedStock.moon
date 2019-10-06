class OwnedStock
	id: ""
	amount: 0

	new: (id, amount) =>
		@id = id
		@amount = amount or 0

	add: (amount) =>
		@amount += amount

	remove: (amount) =>
		@amount -= amount
		if @amount < 0
			@amount = 0
