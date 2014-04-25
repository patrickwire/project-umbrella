require("library/AnAL")
Camera = require "hump.camera"
vector = require "hump.vector-light"
Gamestate = require "hump.gamestate"

require "class/game"
require "class/menu"

function love.load()
	music = love.audio.newSource("assets/sfx/loop.ogg")
	music:setLooping(true)
	music:setVolume(0.5)
	music:play()
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
