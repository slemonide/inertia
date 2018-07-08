local game = {}

-- Called each time new game is started
function game:init()
end

-- Called each time new player is joined
function game:onJoin()
    print("New player joined!")
end

-- Called in update loop
function game:update(dt)
    local x, y = Player.body:getX(), Player.body:getY()

    if (math.sqrt(x * x + y * y) > CONFIG.STAY_CIRCLE_RADIUS) then
        states.game_over.score = Client.socket.gettime() - states.game.start_time
        Gamestate.switch(states.game_over)
    end
end

-- Called in draw loop
function game:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle('line', 0, 0, CONFIG.STAY_CIRCLE_RADIUS)
end

return game
