local game = {}

function game:init()
    Stars:generate()
    game:reset()
    camera:setFollowStyle('TOPDOWN')
end

function game:reset()
    game.start_time = Client.socket.gettime()
    Player:reset()

    love.audio.stop()
end

function game:update(dt)
    camera:update(dt)
    camera:follow(Player.body:getX(), Player.body:getY())

    if current_game then
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
    
    if current_game then
        current_game:draw()
    end

    Player:render()

    camera:detach()
    camera:draw()
end

function game:keypressed(key)
    if key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())
    elseif key == "=" then
        camera.scale = camera.scale * 2
    elseif key == "-" then
        camera.scale = camera.scale / 2
    end
end

return game
