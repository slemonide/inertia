local menu = {}

function menu:init()
end

function menu:draw()
    suit.draw()
end

function menu:textinput(t)
    suit.textinput(t)
end

function menu:keypressed(key)
    suit.keypressed(key)
    love.audio.play(states.menu.snd)
  	if key == "1" then
        menu:stay_circle()
    elseif  key == "2" then
        menu:collect_coins()
    elseif key == "escape" or key == "q" or key == "3" then
        menu:back()
    end
end

function menu:stay_circle()
--    Gamestate.switch(states.menu)
    current_game = games.stay_circle
    Gamestate.switch(states.game)
end

function menu:collect_coins()
--    Gamestate.switch(states.menu)
    print("Collect coins")
end

function menu:back()
    Gamestate.switch(states.menu.main)
end

function menu:update(dt)
    suit.layout:reset(100,100, 20,20)

    state = suit.Button("Stay in the circle (1)", suit.layout:row(200,30))
    if state.entered then love.audio.play(states.menu.snd) end
    if state.hit then menu:stay_circle() end
    
    state = suit.Button("Collect coins (2)", suit.layout:row(200,30))
    if state.entered then love.audio.play(states.menu.snd) end
    if state.hit then menu:collect_coins() end
    
    state = suit.Button("Back (3)", suit.layout:row(200,30))
    if state.entered then love.audio.play(states.menu.snd) end
    if state.hit then menu:back() end
end

return menu
