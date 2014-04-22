require("AnAL")
Camera = require "hump.camera"
vector = require "hump.vector-light"

function love.load()

	-- load images
	images = {
		spaceship = love.graphics.newImage("spaceship.png"),
		meteor = love.graphics.newImage("meteor.jpg"),
		animation = love.graphics.newImage("animation.png"),
		map = love.graphics.newImage("map.gif"),
	}

	-- sound effect
	sound = love.audio.newSource("crash.ogg", "static")

	-- music
	music = love.audio.newSource("music.mp3")
	music:setLooping(true)
	music:setVolume(0.5)
	--love.audio.play(music)

	-- game
	game={
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight()
	}
	world = {
		width = 4500,
		height = 2234
	}

	-- player
	x, y = 0, 0
	w = images.spaceship:getWidth()
	h = images.spaceship:getHeight()

	speed = 100


  cam = Camera(x, y,5)
end

function love.update(dt)
	-- update x


	-- update y
		nx,ny = vector.normalize(vector.sub(game.width/2,game.height/2,love.mouse.getX(),love.mouse.getY()))
    x =x - nx * dt * speed
		y =y - ny * dt * speed
		if x > world.width then
			x=world.width
		end
		if x < 0 then
			x=0
		end
		if y>world.height then
			y=world.height
		end
		if y < 0 then
			y=0
		end
		local dx,dy = x - cam.x, y - cam.y
    cam:move(dx/2, dy/2)

end

function love.draw()

	cam:attach()
	love.graphics.draw(images.map,0,0)
	cam:detach()
	love.graphics.draw(images.spaceship,game.width/2,game.height/2)
	love.graphics.print(cam.x.." "..cam.y)
	love.graphics.print(nx.." "..ny,30,30)
end
