Utils = require "src.Utils"

class HistoryItem
	amount: 0
	new_balance: 0

	description: ""
	description_text: nil

	day_count: 0

	new: (amount, description, dayCount, newBalance) =>
		@amount = amount
		@description = description
		@day_count = dayCount
		@new_balance = newBalance

	draw: (x, y, w) =>
		changeText = Utils.formatThousands @amount

		if @amount > 0
			love.graphics.setColor 0.10, 0.80, 0.13
			changeText = "+" .. changeText
		else
			love.graphics.setColor 0.80, 0.12, 0.13

		love.graphics.setFont g_game.font_normal_bold
		love.graphics.printf "$" .. changeText, x, y, 60, "right"

		if @description_text == nil
			@description_text = love.graphics.newText g_game.font_normal, ""
			@description_text\setf @description, w - 64, "left"

		love.graphics.setColor 0.60, 0.62, 0.63
		love.graphics.draw @description_text, x + 64, y

		return @description_text\getHeight!
