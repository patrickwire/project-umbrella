require("AnAL")
Camera = require "hump.camera"
vector = require "hump.vector-light"

function love.load()

	-- load images
	images = {
		spaceship = love.graphics.newImage("spaceship.png"),
		meteor = love.graphics.newImage("meteor.png"),
		animation = love.graphics.newImage("animation.png"),
		map = love.graphics.newImage("map.gif"),
		storm = love.graphics.newImage("storm.png"),
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
	objectInStorm = {{image = images.meteor,pos = 0, radius = 1}}
	-- player
	x, y = 200, 200
	w = images.storm:getWidth()
	h = images.storm:getHeight()

	speed = 40


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
		for i,obj in ipairs(objectInStorm) do
			obj.radius=obj.radius *(1-dt)
			obj.pos=(obj.pos + dt * speed/10)%(2*3.18)
		end

end

function love.draw()

	cam:attach()
	love.graphics.draw(images.map,0,0)
	cam:detach()
	love.graphics.draw(images.storm,game.width/2-(w/2),game.height/2-(h/2))
	for i,obj in ipairs(objectInStorm) do
		if obj.radius>0 then
			rx,ry= vector.rotate(obj.pos,50,0)
			love.graphics.draw(obj.image,
				game.width/2-(obj.image:getWidth()/2*obj.radius)+rx*obj.radius,
				game.height/2-(obj.image:getHeight()/2*obj.radius)+ry*obj.radius,
				0,obj.radius)
		end
	end
	love.graphics.print(cam.x.." "..cam.y)
end
