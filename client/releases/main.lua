require("globals")

function love.load()
    love.graphics.setFont(love.graphics.newFont("assets/unifont-11.0.01.ttf"))

    Gamestate.registerEvents()
    Gamestate.switch(states.menu.main)
end

function love.resize(w, h)
    Stars:generate()

    local scale = camera.scale
    camera = Camera()
    camera:setFollowStyle('TOPDOWN')
    camera.scale = scale
end
