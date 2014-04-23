require("library/AnAL")
Camera = require "hump.camera"
vector = require "hump.vector-light"
Gamestate = require "hump.gamestate"

local menu = {}
local game = {}

function love.load()

	menu = Gamestate.new()
	-- load images
	images = {
		map = love.graphics.newImage("assests/maps/map.gif"),
		storm = love.graphics.newImage("assests/gfx/orkan.png"),
		cities = {love.graphics.newImage("assests/objects/city1.png")},
	}
	maps = {
		world = love.image.newImageData("assests/maps/map.gif")
	}
	-- sound effect
	sound = love.audio.newSource("assests/sfx/crash.ogg", "static")

	-- game
	game={
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight()
	}
	world = {
		width = 4500,
		height = 2234
	}
	objects = {}
	for i=1,1000 do
		spawn_object()
	end
	objectInStorm = {}
	-- player
	x, y = 200, 200
	w = images.storm:getWidth()/10
	h = images.storm:getHeight()/10
	scale = 1
	speed = 40
	rotation = 0

  cam = Camera(x, y,1)

end

function love.update(dt)

	--Bewegung
	if love.mouse.isDown("l")then
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
	end
	speed=speed - dt
		scale=math.log(1001.5-#objects)
		-- cmaera update
		local dx,dy = x - cam.x, y - cam.y
    cam:move(dx/2, dy/2)
		for i,obj in ipairs(objectInStorm) do
			obj.radius=obj.radius *(1-dt)
			obj.pos=(obj.pos + dt * speed/10)%(2*3.18)
			if obj.radius <0.01 then
				table.remove(objectInStorm, i)
			end
		end
		cam:zoomTo(5/scale)
		rotation = (rotation + dt * speed/10)%(2*3.18)
		for i, v in ipairs(objects) do
			-- collision
			if is_colliding(v) then

			-- show animation
				spawn_animation(v)

			-- play/rewind effect
				if sound:isStopped() then
					love.audio.play(sound)
				else
					sound:rewind()
				end
				speed=40
				table.remove(objects, i)
			end
		end

	if love.keyboard.isDown("escape") then
		love.event.push("quit")
	end

end

function love.draw()

	cam:attach()
		love.graphics.draw(images.map,0,0)
		for i, v in ipairs(objects) do
			love.graphics.draw(v.image, v.x, v.y, 0 , v.scale, v.scale)
		end
	cam:detach()
	love.graphics.draw(images.storm,game.width/2,game.height/2,rotation,scale/10,scale/10,(w*10/2),(h*10/2))
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
	love.graphics.print("Objects"..#objects,0,15)
	love.graphics.print("Animations"..#objectInStorm,0,30)
	love.graphics.print("scale"..scale,0,45)
end

function spawn_object()

	local t = {}

	-- size
	t.scale = math.random(40, 100) * 0.003
	t.image = images.cities[1]
	t.w = t.image:getWidth() * t.scale
	t.h = t.image:getHeight() * t.scale
	placed =false
	-- position
	repeat
		t.x = math.random(0, world.width - t.w)
		t.y = math.random(0, world.height - t.w)
		t.speed = 0
		r,g,b=maps.world:getPixel(t.x,t.y)
		if r==255 and r==255 and b==255 then
			table.insert(objects, t)
			placed = true
		end
	until placed
end

function is_colliding(v)

	--if x-w/2*scale <= v.x + v.w and x + w/2*scale >= v.x and y-h/2*scale <= v.y + v.h and y + h/2*scale >= v.y then
	if vector.dist(v.x+v.w/2*v.scale,v.y+v.h/2*v.scale,x,y)<w then
		return true
	end

	return false
end

function spawn_animation(v)

	local t = {}

	-- copy values
	t.image = v.image
	t.pos = 0
	t.radius = 1

	-- create animation

	table.insert(objectInStorm, t)
end

function menu:draw()
	love.graphics.draw(self.background, 0,0)
end

function menu:init()
	self.background = love.graphics.newImage("menu1.jpg")
end

function menu:keyreleased(key)
	if key == "enter" then
		Gamestate.switch(game)
	end
end

function menu:enter(previous)
	Buttons.setActive(Buttons.start)
end
