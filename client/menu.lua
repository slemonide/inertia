local menu = {}

-- generate some assets (below)
function menu:init()
    menu.snd = menu:generateClickySound()
end

function menu:draw()
    suit.draw()
end

function menu:textinput(t)
    suit.textinput(t)
end

function menu:keypressed(key)
    suit.keypressed(key)
    love.audio.play(menu.snd)
  	if key == "1" then
        menu:playlocally()
    elseif key == "2" then
        menu:playonline()
    elseif key == "3" then
        menu:settings()
    elseif key == "escape" or key == "q" or key == "4" then
		menu:quit()
    end
end

function menu:playlocally()
    Gamestate.switch(states.local_menu)
end

function menu:playonline()
    --Gamestate.switch(states.online_menu)
    Gamestate.switch(states.game)
end

function menu:settings()
    Gamestate.switch(states.settings_menu)
end

function menu:quit()
    love.event.quit()
end

function menu:update(dt)
    suit.layout:reset(100,100, 20,20)

    state = suit.Button("Play Locally (1)", suit.layout:row(200,30))
    if state.entered then love.audio.play(menu.snd) end
    if state.hit then menu:playlocally() end

    state = suit.Button("Play Online (2)", suit.layout:row(200,30))
    if state.entered then love.audio.play(menu.snd) end
    if state.hit then menu:playonline() end
    
    state = suit.Button("Settings (3)", suit.layout:row(200,30))
    if state.entered then love.audio.play(menu.snd) end
    if state.hit then menu:settings() end
    
    state = suit.Button("Quit (4)", suit.layout:row(200,30))
    if state.entered then love.audio.play(menu.snd) end
    if state.hit then menu:quit() end
end

function menu:generateClickySound()
    local snd = love.sound.newSoundData(512, 44100, 16, 1)
    for i = 0,snd:getSampleCount()-1 do
        local t = i / 44100
        local s = i / snd:getSampleCount()
        snd:setSample(i, (.7*(2*love.math.random()-1) + .3*math.sin(t*9000*math.pi)) * (1-s)^1.2 * .3)
    end
    return love.audio.newSource(snd)
end

return menu
