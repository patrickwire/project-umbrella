game = Gamestate.new()

WATER = 1
LAND = 2
DESERT = 3
MOUNTEN = 4


AFRICA = 1
WELOVERUSSIA = 2
CORN = 3
KRIM = 4
GANGNAMSTYLE = 5
CASTRO = 6
FUKOSHIMA = 7
NINEELEVEN = 8
KROMBACHER = 9
MOBBYDICK = 10

function game:init()
	music = love.audio.newSource("assets/sfx/loop.ogg")
	music:setLooping(true)
	music:setVolume(0.5)
	music:play()
	 math.randomseed( os.time() )
	actions= {0,0,0,0,0,0,0,0,0,0}
	
	images = {
		map = love.graphics.newImage("assets/maps/weltkarte_final.png"),
		storm = love.graphics.newImage("assets/gfx/orkan.png"),
		storm2 = love.graphics.newImage("assets/gfx/orkan_02.png"),
		box = love.graphics.newImage("assets/gfx/box.png"),
		regenwald = love.graphics.newImage("assets/objects/rainforest.jpg"),
		akw = love.graphics.newImage("assets/objects/atomkraftwerk.png"),
		cities = {
			{image=love.graphics.newImage("assets/objects/Stadt_gross.png"),scale=0.1},
			{image=love.graphics.newImage("assets/objects/feld_gelb.png"),scale=0.1},
			{image=love.graphics.newImage("assets/objects/feld_gruen.png"),scale=0.1},
			{image=love.graphics.newImage("assets/objects/fussballfeld.png"),scale=0.02},
			{image=love.graphics.newImage("assets/objects/Stadium01.png"),scale=0.1},
			{image=love.graphics.newImage("assets/objects/Stadt_klein02.png"),scale=0.4},
			{image=love.graphics.newImage("assets/objects/Stadt_mittel.png"),scale=0.3},
			--{image=love.graphics.newImage("assests/objects/Stadium02.png"),scale=1},
			--{image=love.graphics.newImage("assests/objects/Stadium03.png"),scale=1},
		},
		water = {
			{image = love.graphics.newImage("assets/objects/water1.png"),scale=0.05},
			{image = love.graphics.newImage("assets/objects/water2.png"),scale=0.05},
			{image = love.graphics.newImage("assets/objects/water3.png"),scale=0.1},
			{image = love.graphics.newImage("assets/objects/water4.png"),scale=0.1},
			{image = love.graphics.newImage("assets/objects/water5.png"),scale=0.02},
		},
		desert = {
			{image = love.graphics.newImage("assets/objects/Tipi02.png"),scale=0.05},
			{image = love.graphics.newImage("assets/objects/Tipi02.png"),scale=0.05},
			{image = love.graphics.newImage("assets/objects/pyramide.png"),scale=0.05},
		},
		mountens= {
			{image = love.graphics.newImage("assets/objects/bergdorf.png"),scale=0.4},
			},
		ice = {
			{image = love.graphics.newImage("assets/objects/Igludorf.png"),scale=0.4},
		}
	}

	maps = {
		world = love.image.newImageData("assets/maps/weltkarte.png"),
		actions = love.image.newImageData("assets/maps/weltkarte_actions.png")
	}
	-- sound effect
	sound = love.audio.newSource("assets/sfx/rock_breaking.mp3", "static")

	-- game
	game={
		width = love.graphics.getWidth(),
		height = love.graphics.getHeight()
	}
	world = {
		width = 6937,
		height = 4500
	}
	objects = {}
	
	for i=1,3000 do
		spawn_object()
	end
	create_static_objects()
	
	objectInStorm = {}
	-- player
	x, y = 3862, 1111
	w = images.storm:getWidth()/10
	h = images.storm:getHeight()/10
	scale = 1
	speed = 40
	rotation = 0
	storm = {}
	storm.anim = newAnimation(images.storm, 1017, 1005, 0.06, 1)
	cam = Camera(x, y,1)
	points = 20
	achivments = {}
	
	pause = false
	
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
			x = 0
		end
		if x < 0 then
			x=world.width
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
	music:setVolume(0.5*speed/40)
	scale=math.log(points+2/3)
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
				print(v.action)
				if v.action==CORN then
					actions[CORN]=actions[CORN]-1
				end
				if v.action==GANGNAMSTYLE then
					actions[GANGNAMSTYLE]=actions[GANGNAMSTYLE]-1
				end
				if v.action==AFRICA then
					actions[AFRICA]=actions[AFRICA]-1
				end
				if v.action==KRIM then
					actions[KRIM]=actions[KRIM]-1
				end
				if v.action==WELOVERUSSIA then
					actions[WELOVERUSSIA]=actions[WELOVERUSSIA]-1
				end
				if v.action==KROMBACHER then
					actions[KROMBACHER]=actions[KROMBACHER]-1
				end
				if v.action==NINEELEVEN then
					actions[NINEELEVEN]=actions[NINEELEVEN]-1
				end
				if v.action==FUKOSHIMA then
					actions[FUKOSHIMA]=actions[FUKOSHIMA]-1
				end
				if v.action==CASTRO then
					actions[CASTRO]=actions[CASTRO]-1
				end
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
	-- check achivments
	if actions[CORN] ~=nil and actions[CORN]<=0 then
		table.insert(achivments, {title = "Wer Genmais sätt ...",text="sie haben allen Genmais in den USA zerstöhrt"})
		actions[CORN]=nil
	end
	
	if actions[GANGNAMSTYLE] ~=nil and actions[GANGNAMSTYLE]<=0 then
		table.insert(achivments, {title = "Oppan Gangnam Style",text="Kim Jong Un veranstaltet eien Parade für Dich"})
		actions[GANGNAMSTYLE]=nil
	end
	if actions[AFRICA] ~=nil and actions[AFRICA]<=0 then
		table.insert(achivments, {title = "I bless the rains down in Africa",text="Du hast den Hunger in der 3. Welt besiegt"})
		actions[AFRICA]=nil
	end
	if actions[KRIM] ~=nil and actions[KRIM]<=0 then
		table.insert(achivments, {title = "Weißt du noch Vitalie...",text="Die Ukraiene wurde von den Russen Befreit"})
		actions[KRIM]=nil
	end
	if actions[WELOVERUSSIA] ~=nil and actions[WELOVERUSSIA]<=0 then
		table.insert(achivments, {title = "We love Russia ... not",text="Obama hat ihnen eine Freundschaftsanfrage gestellt"})
		actions[WELOVERUSSIA]=nil
	end
	if actions[KROMBACHER] ~=nil and actions[KROMBACHER]<=0 then
		table.insert(achivments, {title = "Krombacher Regenwaldprojekt",text="Da brauchen wir ganzschön viel Bier um das wieder Aufzubauen..."})
		actions[KROMBACHER]=nil
	end
	if actions[NINEELEVEN] ~=nil and actions[NINEELEVEN]<=0 then
		table.insert(achivments, {title = "9/11 Faster then Al Qaida",text="Da bist du den Terorristen wohl zu vorgekommen"})
		actions[NINEELEVEN]=nil
	end
	if actions[FUKOSHIMA] ~=nil and actions[FUKOSHIMA]<=0 then
		table.insert(achivments, {title = "Bündnis 90/ Die Grünen: Atomwende",text="Du hast alle Atomkraftwerke abgeschaft"})
		actions[FUKOSHIMA]=nil
	end

	if love.keyboard.isDown("escape") then
		love.event.push("quit")
	end
end

function game:draw()

	
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
			--	game.width/2-(obj.image:getWidth()*obj.scale/2*obj.radius)+rx*obj.radius*scale/10,
			--	game.height/2-(obj.image:getHeight()*obj.scale/2*obj.radius)+ry*obj.radius*scale/10,
				game.width/2-obj.image:getWidth()*curscale/2+rx*obj.radius*scale,
				game.height/2-obj.image:getHeight()*curscale/2+ry*obj.radius*scale,
				0,curscale)
		end
	end
	for i,achiv in ipairs(achivments) do
		love.graphics.draw(images.box,game.width-300,i*43)
		love.graphics.setNewFont(18)
		love.graphics.printf(achiv.title,game.width-300-3,i*43,300-6,"center")
		love.graphics.setNewFont(10)
		love.graphics.printf(achiv.text,game.width-300-3,i*43+22,300-6,"center")
		love.graphics.setNewFont(12)
	end
	--love.graphics.print(cam.x.." "..cam.y)
	--love.graphics.print("Objects"..#objects,0,15)
	--love.graphics.print("Animations"..#objectInStorm,0,30)
	--love.graphics.print("scale"..scale,0,45)
	love.graphics.setNewFont(22)
	love.graphics.draw(images.box,0,43)
	love.graphics.print(math.floor(speed*4).." miles per hour",10,50)
	love.graphics.setNewFont(12)
	if pause then
		love.graphics.setNewFont(40)
		love.graphics.print("P A U S E",400, 300)
		love.graphics.setNewFont(12)
	end
end

function game:keypressed(key)
	if key == "p" then
		pause = not pause
	end
end

function spawn_object()

	local t = {}

	-- size



	placed =false
	-- position
	repeat
		t.x = math.random(0, world.width-1)
		t.y = math.random(0, world.height-1)
		t.speed = 0
		objlist = nil
		t.action = 0
		
		-- get correct texture list
		r,g,b = maps.world:getPixel(t.x,t.y)
		if r==0 and g==255 and b==0 then
			objlist = images.cities
			t.type = LAND
		end
		if r==0 and g==0 and b==255 then
			objlist = images.water
			t.type = WATER
		end
		if r==255 and g==255 and b==0 and math.random(1,3)==1 then
			objlist = images.desert
			t.type = DESERT
		end
		if r==103 and g==59 and b==21 and math.random(1,3)==1 then
			objlist = images.mountens
			t.type = MOUNTEN
		end
		
		-- load image
		if objlist ~= nil then
			rand = math.random(1,#objlist)
			if r==21 and g==40 and b==140 and t.type == LAND then
				rand = 2
			end
			t.number = rand
			t.image = objlist[rand].image
			t.scale = math.random(40, 100) * 0.003 * objlist[rand].scale
		end
		
		--special actions
		r,g,b = maps.actions:getPixel(t.x,t.y)
		--Africa
		if r==140 and g==130 and b==21 then
			t.action = AFRICA
		end
		--WELOVERUSSIA
		if r==255 and g==0 and b==0 then
			t.action = WELOVERUSSIA
		end
		--CORN
		if r==21 and g==40 and b==140 and t.type == LAND then
			t.action = CORN
		end
		--KRIM
		if r==255 and g==0 and b==228 then
			t.action = KRIM
		end
		--GANGNAMSTYLE
		if r==87 and g==93 and b==126 then
			t.action = GANGNAMSTYLE
		end
		--CSTRO
		if false then
			t.action = CASTRO
		end
		--FUKOSHIMA
		if false then
			t.action = FUKOSHIMA
		end
		--NINEELEVEN
		if false then
			t.action = NINEELEVEN
		end
		--KROMBACHER
		if r==169 and g==141 and b==141 then
			t.action = KROMBACHER
			t.image = images.regenwald
			t.scale = 1
		end
	until t.image ~= nil
	if t.action~=0 then 
		actions[t.action]=actions[t.action]+1
	end
	t.w = t.image:getWidth() * t.scale
	t.h = t.image:getHeight() * t.scale
	t.rotation = math.random() * math.pi/2-(math.pi/4)
	table.insert(objects, t)
end

function is_colliding(v)

	--if x-w/2*scale <= v.x + v.w and x + w/2*scale >= v.x and y-h/2*scale <= v.y + v.h and y + h/2*scale >= v.y then
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

function create_static_objects()
	---new york
	t={}
	t.x,t.y = 2032,1272
	t.scale=0.1
	t.image = images.cities[1].image
	t.w = t.image:getWidth() * t.scale
	t.h = t.image:getHeight() * t.scale
	t.action = NINEELEVEN
	actions[NINEELEVEN]=1
	table.insert(objects, t)
	
	--guantanamo
	t={}
	t.x,t.y = 1676,1916
	t.scale=0.1
	t.image = images.cities[6].image
	t.w = t.image:getWidth() * t.scale
	t.h = t.image:getHeight() * t.scale
	t.action = CASTRO
	actions[CASTRO]=1
	table.insert(objects, t)
	t={}
	--atomkraft
	t.x,t.y = 5920,1448
	t.scale=0.4
	t.image = images.akw
	t.w = t.image:getWidth() * t.scale
	t.h = t.image:getHeight() * t.scale
	t.action = FUKOSHIMA
	actions[FUKOSHIMA]=3
	table.insert(objects, t)
	t.x,t.y = 3418,1273
	t.scale=0.4
	t.image = images.akw
	t.w = t.image:getWidth() * t.scale
	t.h = t.image:getHeight() * t.scale
	t.action = FUKOSHIMA
	actions[FUKOSHIMA]=3
	table.insert(objects, t)
	t.x,t.y = 949,1444
	t.scale=0.4
	t.image = images.akw
	t.w = t.image:getWidth() * t.scale
	t.h = t.image:getHeight() * t.scale
	t.action = FUKOSHIMA
	actions[FUKOSHIMA]=3
	table.insert(objects, t)
end