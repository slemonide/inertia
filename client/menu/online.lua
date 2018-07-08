local menu = {}

function menu:init()
    menu.input = {text = server_address}
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
    if key == "return" then
        menu:connect()
    elseif key == "escape" then
        menu:back()
    end
end

function menu:connect()
    Client:connect(server_address)
    current_game = games.sumo
    Gamestate.switch(states.game)
end

function menu:back()
    Gamestate.switch(states.menu.main)
end

function menu:update(dt)

    suit.Input(menu.input, 100,100,200,30)
    server_address = menu.input.text
    
    suit.layout:reset(100,200, 20,20)

    state = suit.Button("Connect (enter)", suit.layout:row(200,30))
    if state.entered then love.audio.play(states.menu.snd) end
    if state.hit then menu:sumo() end
    
    state = suit.Button("Back (esc)", suit.layout:row(200,30))
    if state.entered then love.audio.play(states.menu.snd) end
    if state.hit then menu:back() end
end

return menu
