local Player = Class{
    init = function(self)
        self.name = "Unnamed"
        self.img = {}
		self.img.rocket = love.graphics.newImage('assets/rocket.png')
		self.img.mainEngine = love.graphics.newImage('assets/mainEngine.png')
		self.img.bottomLeftThrust = love.graphics.newImage('assets/bottomLeftThrust.png')
		self.img.bottomRightThrust = love.graphics.newImage('assets/bottomRightThrust.png')
		self.img.topLeftThrust = love.graphics.newImage('assets/topLeftThrust.png')
		self.img.topRightThrust = love.graphics.newImage('assets/topRightThrust.png')
        
        self.body = love.physics.newBody(World.world, 100, 100, "dynamic")
        self.shape = love.physics.newRectangleShape(60, 88)
        self.fixture = love.physics.newFixture(self.body, self.shape, 1)
        self.fixture:setRestitution(0.9)

        self.mainEngine = false
        self.bottomLeftThrust = false
        self.bottomRightThrust = false
        self.topLeftThrust = false
        self.topRightThrust = false

    end
}

function Player:setName(name)
    self.name = name
end

-- Serialize player state for transfer over network
function Player:serialize()
    local vx, vy = self.body:getLinearVelocity()
    return string.format("%f %f %f %f %f %f %s %s %s %s %s",
                                     self.body:getX(),
                                     self.body:getY(),
                                     vx,
                                     vy,
                                     self.body:getAngle(),
                                     self.body:getAngularVelocity(),
                                     tostring(self.mainEngine),
                                     tostring(self.bottomLeftThrust),
                                     tostring(self.bottomRightThrust),
                                     tostring(self.topLeftThrust),
                                     tostring(self.topRightThrust))
end

-- Deserialize player state when received from network
function Player:deserialize(data)
    local x, y, vx, vy, a, av, mE, bLT, bRT, tLT, tRT = data:match("^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%S*) (%S*) (%S*) (%S*) (%S*)$")

    self.body:setX(x)
    self.body:setY(y)
    self.body:setLinearVelocity(vx,vy)
    self.body:setAngle(a)
    self.body:setAngularVelocity(av)
    self.mainEngine = (mE == "true")
    self.bottomLeftThrust = (bLT == "true")
    self.bottomRightThrust = (bRT == "true")
    self.topLeftThrust = (tLT == "true")
    self.topRightThrust = (tRT == "true")
end

function Player:update(dt)
    if not Console:isEnabled() then
        local force = 400
        local force_s = 10
        local torque = 100
        local angle = self.body:getAngle()

        if love.keyboard.isDown("w") then
            self.mainEngine = true
            self.body:applyForce(force * math.sin(angle), - force * math.cos(angle))
        else
            self.mainEngine = false
        end
        if love.keyboard.isDown("q") then
            self.topLeftThrust = true
            self.body:applyTorque(torque)
            local angle = angle + math.pi * 3/4
            self.body:applyForce(force_s * math.sin(angle), - force_s * math.cos(angle))
        else
            self.topLeftThrust = false
        end
        if love.keyboard.isDown("e") then
            self.topRightThrust = true
            self.body:applyTorque(-torque)
            local angle = angle - math.pi * 3/4
            self.body:applyForce(force_s * math.sin(angle), - force_s * math.cos(angle))
        else
            self.topRightThrust = false
        end
        if love.keyboard.isDown("a") then
            self.bottomLeftThrust = true
            self.body:applyTorque(-torque)
            local angle = angle + math.pi * 1/4
            self.body:applyForce(force_s * math.sin(angle), - force_s * math.cos(angle))
        else
            self.bottomLeftThrust = false
        end
        if love.keyboard.isDown("d") then
            self.bottomRightThrust = true
            self.body:applyTorque(torque)
            local angle = angle - math.pi * 1/4
            self.body:applyForce(force_s * math.sin(angle), - force_s * math.cos(angle))
        else
            self.bottomRightThrust = false
        end
    end
end

function Player:render_helper(img)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(img, self.body:getX(), self.body:getY(),
        self.body:getAngle(), 1, 1, img:getWidth() / 2,
        img:getHeight() / 2 - 10)
end

function Player:render()
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))

    self:render_helper(self.img.rocket)
    if self.mainEngine then
        self:render_helper(self.img.mainEngine)
    end
    if self.topLeftThrust then
        self:render_helper(self.img.topLeftThrust)
    end
    if self.topRightThrust then
        self:render_helper(self.img.topRightThrust)
    end
    if self.bottomLeftThrust then
        self:render_helper(self.img.bottomLeftThrust)
    end
    if self.bottomRightThrust then
        self:render_helper(self.img.bottomRightThrust)
    end
end

return Player
