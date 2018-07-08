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
        menu:sumo()
    elseif key == "escape" or key == "q" or key == "1" then
        menu:back()
    end
end

function menu:sumo()
    current_game = games.sumo
    Gamestate.switch(states.game)
end

function menu:back()
    Gamestate.switch(states.menu.main)
end

function menu:update(dt)
    suit.layout:reset(100,100, 20,20)

    state = suit.Button("Sumo (1)", suit.layout:row(200,30))
    if state.entered then love.audio.play(states.menu.snd) end
    if state.hit then menu:sumo() end
    
    state = suit.Button("Back (2)", suit.layout:row(200,30))
    if state.entered then love.audio.play(states.menu.snd) end
    if state.hit then menu:back() end
end

return menu
