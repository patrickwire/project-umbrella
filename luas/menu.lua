menu = Gamestate.new()

function menu:draw()
	title = love.graphics.newImage("title.png")
	love.graphics.draw(title, 10, 10)
end

function menu:keypressed(key)
	if key == "return" then
		Gamestate.switch(game)
	end
	
	if key == "escape" then
		love.event.push("quit")
	end
end