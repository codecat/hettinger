HistoryItem = require "src.HistoryItem"

class History
	items: {}

	new: =>

	add: (amount, description) =>
		newItem = HistoryItem amount, description, g_game.day_count, g_game.money
		table.insert @items, newItem

	draw: =>
		padding = 10
		x = padding
		y = 110
		w = g_game.content_left - padding * 2

		rangeNum = 35
		rangeStart = #@items
		rangeEnd = #@items - rangeNum
		if rangeEnd < 1
			rangeEnd = 1

		currentDay = g_game.day_count

		for i = rangeStart, rangeEnd, -1
			item = @items[i]

			if item.day_count ~= currentDay
				currentDay = item.day_count

				love.graphics.setColor 0.70, 0.72, 0.73
				love.graphics.rectangle "fill", x, y + 7, w, 1

				y += 16

			y += item\draw(x, y, w) + 4
