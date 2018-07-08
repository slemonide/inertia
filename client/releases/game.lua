local game = {}

function game:init()
    Stars:generate()
    game:reset()
    camera:setFollowStyle('TOPDOWN')
    debug_screen = false
end

function game:reset()
    game.start_time = Client.socket.gettime()
    Player:reset()
    love.audio.stop()
  
    if current_game.init then
        current_game:init()
    end
end

function game:update(dt)
    camera:update(dt)
    camera:follow(Player.body:getX(), Player.body:getY())

    if current_game.update then
        current_game:update()
    end

    Client:update(dt)
    World:update(dt)
    Player:update(dt)
end

function game:resize(w, h)
    Stars:generate()

    local scale = camera.scale
    camera = Camera()
    camera:setFollowStyle('TOPDOWN')
    camera.scale = scale
end

function game:draw()
    Stars:render()

    camera:attach()

    World:render()
    PlayerManager:render()
    
    if current_game.draw then
        current_game:draw()
    end

    Player:render()

    camera:detach()
    camera:draw()

    if debug_screen then
        local vx, vy = Player.body:getLinearVelocity()

        love.graphics.printf(string.format(
        "x: %.3f y: %.3f\nvx: %.3f vy: %.3f\nAngle: %.3f\nAngular Velocity: %.3f\nlag: %.3f",
            Player.body:getX(), Player.body:getY(),
            vx, vy,
            (Player.body:getAngle() % (2*math.pi)) * 180 / math.pi,
            Player.body:getAngularVelocity() * 180 / math.pi,
            Client.lag),
        5, 5, love.graphics.getWidth() - 10)
    end
end

function game:keypressed(key)
    if key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())
    elseif key == "=" then
        camera.scale = camera.scale * 2
    elseif key == "-" then
        camera.scale = camera.scale / 2
    elseif key == "f1" then
        debug_screen = not debug_screen
    end
end

return game
