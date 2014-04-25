menu = Gamestate.new()
screen	={
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight()
}
function menu:draw()
	title = love.graphics.newImage("title.png")
	love.graphics.draw(title, 0, 0,0,screen.width/1024,screen.height/768)
end

function menu:keypressed(key)
	if key == "return" then
		Gamestate.switch(intro)
	end
	
	if key == "escape" then
		love.event.push("quit")
	end
end