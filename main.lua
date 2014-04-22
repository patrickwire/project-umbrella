require("AnAL")
Camera = require "hump.camera"

function love.load()

	-- load images
	images = {
		spaceship = love.graphics.newImage("spaceship.png"),
		meteor = love.graphics.newImage("meteor.jpg"),
		animation = love.graphics.newImage("animation.png"),
	}

	-- sound effect
	sound = love.audio.newSource("crash.ogg", "static")

	-- music
	music = love.audio.newSource("music.mp3")
	music:setLooping(true)
	music:setVolume(0.5)
	--love.audio.play(music)

	-- game
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()

	-- player
	x, y = 0, 0
	w = images.spaceship:getWidth()
	h = images.spaceship:getHeight()
	speed = 300


  cam = Camera(x, y,2)
end

function love.update(dt)
	-- update x
	if love.keyboard.isDown("left") and x > 0 then
		x = x - speed * dt
	elseif love.keyboard.isDown("right") and x + w < width then
		x = x + speed * dt
	end

	-- update y
	if love.keyboard.isDown("up") and y > 0 then
		y = y - speed * dt
	elseif love.keyboard.isDown("down") and y + h < height then
		y = y + speed * dt
	end
    local dx,dy = x - cam.x, y - cam.y
    cam:move(dx/2, dy/2)

end

function love.draw()

	cam:attach()
	love.graphics.draw(images.animation,100,100)
	cam:detach()
	love.graphics.draw(images.spaceship,width/2,width/2)
end
