require("globals")

------------------------
-- Load love
------------------------

function love.load()
    love.graphics.setFont(love.graphics.newFont("assets/unifont-11.0.01.ttf"))

    Stars:generate()
    camera:setFollowStyle('TOPDOWN_TIGHT')
end

------------------------
-- Update
------------------------

function love.update(dt)
    camera:update(dt)
    camera:follow(Player.body:getX(), Player.body:getY())

    Client:update(dt)
    World:update(dt)
    Player:update(dt)
end

------------------------
-- Resize
------------------------

function love.resize(w, h)
    Stars:generate()

    local scale = camera.scale
    camera = Camera()
    camera:setFollowStyle('TOPDOWN_TIGHT')
    camera.scale = scale
end

------------------------
-- Draw
------------------------

function love.draw()
    Stars:render()

    camera:attach()

    World:render()
    PlayerManager:render()

    Player:render()

    camera:detach()
    camera:draw()

    Console:render()
end

------------------------
-- Text Input
------------------------

function love.textinput(t)
    Console:addChar(t)
end

------------------------
-- Keypressed
------------------------

function love.keypressed(key)
    if Console:isEnabled() then
        if key == "escape" then
            Console:disable()
        elseif key == "left" then
            Console:prevChar()
        elseif key == "right" then
            Console:nextChar()
        elseif key == "up" then
            Console:prevMsg()
        elseif key == "down" then
            Console:nextMsg()
        elseif key == "backspace" then
            Console:backspace()
        elseif key == "return" then
            Console:send()
        end
    else
        if key == "f" then
            love.window.setFullscreen(not love.window.getFullscreen())
        elseif key == "escape" then
            Console:enable()
        elseif key == "=" then
            camera.scale = camera.scale * 2
        elseif key == "-" then
            camera.scale = camera.scale / 2
        end
    end
end
