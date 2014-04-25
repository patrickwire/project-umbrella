intro = Gamestate.new()

local time = 0
local image1 = {}
local image2 = {}

function intro:init()

	screen	={
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight()
	}
	
	flagglass = true
	
	nooo = love.audio.newSource("assets/sfx/NOOOOOOO.ogg", "static")
	glass = love.audio.newSource("assets/sfx/glass.ogg", "static")
	ohno = love.audio.newSource("assets/sfx/Ohhh_nooo_mann_.ogg", "static")
	flysound = love.audio.newSource("assets/sfx/flysound.ogg", "static")
	siren = love.audio.newSource("assets/sfx/Siren.ogg", "static")
	tornado = love.audio.newSource("assets/sfx/Tornado.ogg", "static")
	
	time = 0
	
	image1 = {
		pic = love.graphics.newImage("assets/intro/storyboard01.png"),
		opacity = 0
	}
	
	image2 = {
		pic = love.graphics.newImage("assets/intro/storyboard02.png"),
		opacity = 0
	}
	
	image3 = {
		pic = love.graphics.newImage("assets/intro/storyboard03.png"),
		opacity = 0
	}
	
	image4 = {
		pic = love.graphics.newImage("assets/intro/storyboard04.png"),
		opacity = 0
	}
	
	image5 = {
		pic = love.graphics.newImage("assets/intro/storyboard05.png"),
		opacity = 0
	}

	image6 = {
		pic = love.graphics.newImage("assets/intro/storyboard06.png"),
		opacity = 0
	}
	loading = {
		font = 40,
		text = "L O A D I N G",
		setfont = 12,
		opacity = 0
	}
		
end

function intro:enter()
	time = 0
end

function intro:update(dt)

	time = time + dt
	
	--sounds
	if time > 4 and time < 12 then
		love.audio.play(flysound)
	end
	
	if time > 10 and time < 20 then
		love.audio.play(tornado)
	end
	
	if time > 16 and time < 20 then
		love.audio.play(siren)
	end
	
	--einblenden
	if time > 1 and time < 5 then
		image1.opacity = (time -1) * 0.25
	end
	
	if time > 4 and time < 8 then
		image2.opacity = (time - 4) * 0.25
	end
	
	if time > 7 and time < 11 then
		image3.opacity = (time -7) * 0.25
	end
	
	if time > 10 and time < 14 then
		
		if flagglass == true then
			love.audio.play(glass)
			flagglass = false
		end
		image4.opacity = (time - 10) * 0.25
	end
	
	if time > 13 and time < 17 then		
		image5.opacity = (time -13) * 0.25
	end
	
	if time > 16 and time < 20 then
		image6.opacity = (time - 16) * 0.25
	end
	
	if time > 19 and time < 23 then
		loading.opacity = (time - 19) * 0.25
	end
	
	--ausblenden
	if time > 6 and time < 7 then
		image1.opacity = 1 - ((time -6) *0.25)
	end
	
	if time > 9 and time < 10 then
		image2.opacity = 1 - ((time -9) *0.25)
	end
	
	if time >  12 and time < 13 then
		image3.opacity = 1 - ((time -6) *0.25)
	end
	
	if time > 15 and time < 16 then
		image4.opacity = 1 - ((time -7) *0.25)
	end
	
	if time > 18 and time < 19 then
		image5.opacity = 1 - ((time -8) *0.25)
	end
	
	if time > 21 and time < 22 then
		image6.opacity = 1 - ((time -9) *0.25)
	end
	
	if time > 24 and time < 25 then
		loading.opacity = 1 - ((time - 11) + 0.25)
	end

end

function intro:draw()
	
	love.graphics.setColor(255, 255, 255, image1.opacity * 255)
	love.graphics.draw(image1.pic, 0, 0,0,screen.width/1024,screen.height/768)
	
	love.graphics.setColor(255, 255, 255, image2.opacity * 255)
	love.graphics.draw(image2.pic, 0, 0,0,screen.width/1024,screen.height/768)
	
	love.graphics.setColor(255, 255, 255, image3.opacity * 255)
	love.graphics.draw(image3.pic, 0, 0,0,screen.width/1024,screen.height/768)
	
	love.graphics.setColor(255, 255, 255, image4.opacity * 255)
	love.graphics.draw(image4.pic, 0, 0,0,screen.width/1024,screen.height/768)
	
	love.graphics.setColor(255, 255, 255, image5.opacity * 255)
	love.graphics.draw(image5.pic, 0, 0,0,screen.width/1024,screen.height/768)
	
	love.graphics.setColor(255, 255, 255, image6.opacity * 255)
	love.graphics.draw(image6.pic, 0, 0,0,screen.width/1024,screen.height/768)
	love.graphics.setColor(255, 255, 255, loading.opacity * 255)
	
	love.graphics.setNewFont(loading.font)
	love.graphics.print(loading.text, 400, 300)
	love.graphics.setNewFont(newfont)

end

function intro:keypressed(key)
	Gamestate.switch(game)
end

function intro:mousepressed()
	Gamestate.switch(game)
end