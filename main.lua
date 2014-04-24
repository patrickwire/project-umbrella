require("library/AnAL")
Camera = require "hump.camera"
vector = require "hump.vector-light"
Gamestate = require "hump.gamestate"

require "luas/game"
require "luas/menu"

function love.load()
	Gamestate.switch(menu)
	Gamestate.init()
end

function love.update(dt)
	Gamestate.update(dt)
end

function love.draw()
	Gamestate.draw()
end

function love.keypressed(key)
	Gamestate.keypressed(key)
end
