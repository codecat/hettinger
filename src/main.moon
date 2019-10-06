Game = require "src.Game"

export g_game

love.load = ->
	g_game = Game!
	g_game\start!

love.update = (dt) -> g_game\update dt
love.draw = -> g_game\draw!

love.textedited = (text, start, length) -> g_game\textedited text, start, length
love.textinput = (t) -> g_game\textinput t
love.keypressed = (key, scancode, isrepeat) -> g_game\keypressed key, scancode, isrepeat
