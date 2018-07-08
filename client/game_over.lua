local menu = {}

function menu:init()
    menu.score = menu.score or 0
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
        menu:playAgain()
    elseif key == "escape" or key == "q" or key == "2" then
        menu:back()
    end
end

function menu:enter()
    states.game:reset()
end

function menu:playAgain()
    Gamestate.switch(states.game)
end

function menu:back()
    Gamestate.switch(states.menu.main)
end

function menu:update(dt)
    love.audio.stop()

    suit.Label("Game Over!", {align="center"}, 100,100,200,30)
    suit.Label("Score: " .. menu.score, {align="center"}, 100,150,200,30)

    suit.layout:reset(100,200, 20,20)
    
    state = suit.Button("Play Again (1)", suit.layout:row(200,30))
    if state.entered then love.audio.play(states.menu.snd) end
    if state.hit then menu:playAgain() end
    
    state = suit.Button("Back (2)", suit.layout:row(200,30))
    if state.entered then love.audio.play(states.menu.snd) end
    if state.hit then menu:back() end
end

return menu
