function love.conf(t)
	t.title = "Project Umbrella"
	t.window.icon = "assets/gfx/sturm_seitlich.png"
	t.window.width = 0               -- The window width (number)
    t.window.height = 0              -- The window height (number)
    t.window.borderless = true        -- Remove all border visuals from the window (boolean)
    t.window.resizable = true         -- Let the window be user-resizable (boolean)
    t.window.minwidth = 1              -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1             -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = true       -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop" -- Standard fullscreen or desktop fullscreen mode (string)
		 t.window.vsync = true
end
