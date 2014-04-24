game = Gamestate.new()

WATER = 1
LAND = 2

function game:init()

	pause = false
	images = {
		map = love.graphics.newImage("assests/maps/weltkarte.png"),
		storm = love.graphics.newImage("assests/gfx/orkan.png"),
		storm2 = love.graphics.newImage("assests/gfx/orkan_02.png"),
		cities = {
			{image=love.graphics.newImage("assests/objects/city1.png"),scale=1}
		},
		water = {
			{image = love.graphics.newImage("assests/objects/schiff.png"),scale=0.05}
		},
	}
	-- player
	x, y = 200, 200
	w = images.storm:getWidth()/10
	h = images.storm:getHeight()/10
	scale = 1
	speed = 40
	rotation = 0
	storm = {}
	storm.anim = newAnimation(images.storm, 1017, 1005, 0.06, 1)
	cam = Camera(x, y,1)
	points = 20

	maps = {
		world = love.image.newImageData("assests/maps/weltkarte.png")
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
	
end

function game:update(dt)

	if pause then
		return
	end
		
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
	storm.anim:update(dt)
	speed=speed - dt
	scale=math.log(points+2)/3
	-- rotate storm
	rotation = (rotation + dt * speed/10)%(2*math.pi)

		-- cmaera update
	local dx,dy = x - cam.x, y - cam.y
    cam:move(dx/2, dy/2)
		for i,obj in ipairs(objectInStorm) do
			obj.radius=obj.radius *(1-dt)
			obj.pos=(obj.pos + dt * speed/10)%(2*math.pi)
			if obj.radius <0.01 then
				table.remove(objectInStorm, i)
			end
		end
	cam:zoomTo(5/scale)

		-- update objects
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
				points = points + 1
				speed=speed+3
				if speed >40 then
					speed = 40
				end
				table.remove(objects, i)
			end
		end
		if math.random(10000) <= 2000 * dt then
		spawn_object()
	end
end

function game:draw()

	if pause then
		love.graphics.print("P A U S E", 10,10)
	end
	
	-- draw in wolrd
	cam:attach()
		love.graphics.draw(images.map,0,0)
		for i, v in ipairs(objects) do
			love.graphics.draw(v.image, v.x, v.y, v.rotation , v.scale, v.scale)
		end
	cam:detach()
	storm.anim:draw(game.width/2,game.height/2,rotation,scale/10,scale/10,(w*10/2),(h*10/2))

	for i,obj in ipairs(objectInStorm) do
		if obj.radius>0 then
			rx,ry= vector.rotate(obj.pos,150,0)
			curscale = obj.radius*obj.scale*10
			love.graphics.draw(obj.image,
				game.width/2-obj.image:getWidth()*curscale/2+rx*obj.radius*scale,
				game.height/2-obj.image:getHeight()*curscale/2+ry*obj.radius*scale,
				0,curscale)
		end
	end
	love.graphics.print(cam.x.." "..cam.y)
	love.graphics.print("Objects"..#objects,0,15)
	love.graphics.print("Animations"..#objectInStorm,0,30)
	love.graphics.print("scale"..scale,0,45)
end

function game:keypressed(key)
	if key == "p" then
		pause = not pause
	end
	
	if key == "escape" then
		love.event.quit()
	end
end

function spawn_object()

	local t = {}

	placed =false
	-- position
	repeat
		t.x = math.random(0, world.width - 100)
		t.y = math.random(0, world.height -100)
		t.speed = 0
		objlist = nil
		r,g,b = maps.world:getPixel(t.x,t.y)
		if r==0 and g==255 and b==0 then
			objlist = images.cities
			t.type = LAND
		end
		if r==0 and g==0 and b==255 then
			objlist = images.water
			t.type = WATER
		end
		if objlist ~= nil then
			t.image = objlist[1].image
			t.scale = math.random(40, 100) * 0.003 * objlist[1].scale
		end
	until t.image ~= nil

	t.w = t.image:getWidth() * t.scale
	t.h = t.image:getHeight() * t.scale
	t.rotation = math.random() * math.pi/2-(math.pi/4)
	table.insert(objects, t)
end

function is_colliding(v)
	if vector.dist(v.x+v.w/2*v.scale,v.y+v.h/2*v.scale,x,y)<w*scale/4 then
		print ("center x"..x.." y"..y.."w"..(w*scale/4))
		print ("obj x"..v.x.." y"..v.y.." w"..v.w.." h"..v.h.." dist"..vector.dist(v.x+v.w/2*v.scale,v.y+v.h/2*v.scale,x,y))
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
	t.scale = v.scale

	-- create animation

	table.insert(objectInStorm, t)
end