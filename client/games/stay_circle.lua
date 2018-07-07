local game = {}

function game:update(dt)
    local x, y = Player.body:getX(), Player.body:getY()

    if (math.sqrt(x * x + y * y) > CONFIG.STAY_CIRCLE_RADIUS) then
        states.game_over.score = Client.socket.gettime() - states.game.start_time
        states.game_over.game = game
        Gamestate.switch(states.game_over)
    end

    if math.random() < 0.01 then
        local ang = math.random() * 2 * math.pi
        local mag = math.random() * math.min(100, states.game.start_time)
        Player.body:applyLinearImpulse(mag*math.sin(ang),mag*math.cos(ang))
    end
end

function game:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle('line', 0, 0, CONFIG.STAY_CIRCLE_RADIUS)
end

return game
