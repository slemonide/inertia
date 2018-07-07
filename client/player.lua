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
        self.sound = {}
        self.sound.mainEngine = love.audio.newSource('assets/mainEngine.ogg', 'static')
        self.sound.secondaryEngine = love.audio.newSource('assets/secondaryEngine.wav', 'static')
        self.sound.bigCollision = love.audio.newSource('assets/bigCollision.ogg', 'static')
        self.sound.mediumCollision = love.audio.newSource('assets/mediumCollision.ogg', 'static')
        self.sound.smallCollision = love.audio.newSource('assets/smallCollision.ogg', 'static')
        
        self.body = love.physics.newBody(World.world, 100, 100, "dynamic")
        self.shape = love.physics.newRectangleShape(60, 88)
        self.fixture = love.physics.newFixture(self.body, self.shape, 1)
        self.fixture:setRestitution(0.9)

        self:reset()
    end
}

function Player:reset()
    self.mainEngine = false
    self.bottomLeftThrust = false
    self.bottomRightThrust = false
    self.topLeftThrust = false
    self.topRightThrust = false

    self.body:setPosition(0, 0)
    self.body:setLinearVelocity(0, 0)
    self.body:setAngle(0)
    self.body:setAngularVelocity(0)

    self.sound.mainEngine:stop()
    
    self.changed = true
end

function Player:setName(name)
    self.name = name
end

-- Produce true if player needs to be synchronized with the server
function Player:isOld()
    if self.changed then
        self.changed = false
        return true
    else
        return false
    end
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

function Player:collide(thing)
    local ox, oy = thing:getBody():getLinearVelocity()
    local tx, ty = self.body:getLinearVelocity()

    local mag = math.sqrt((ox - tx) ^ 2 + (oy - ty) ^ 2)
    if (mag < 100) then
        camera:shake(5, 1, 30)
        self.sound.smallCollision:stop()
        self.sound.smallCollision:play()
    elseif (mag < 300) then
        camera:shake(7, 2, 60)
        self.sound.mediumCollision:stop()
        self.sound.mediumCollision:play()
    else
        camera:shake(10, 3, 120)
        self.sound.bigCollision:stop()
        self.sound.bigCollision:play()
    end
end

-- Deserialize player state when received from network
function Player:deserialize(lag, data)
    local x, y, vx, vy, a, av, mE, bLT, bRT, tLT, tRT = data:match("^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*) (%S*) (%S*) (%S*) (%S*) (%S*)$")

    self.body:setX(x + vx * lag)
    self.body:setY(y + vy * lag)
    self.body:setLinearVelocity(vx,vy)
    self.body:setAngle(a + av * lag)
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
            self.changed = true
            self.sound.mainEngine:play()
        else
            if self.mainEngine then
                self.mainEngine = false
                self.changed = true
                self.sound.mainEngine:stop()
            end
        end
        if love.keyboard.isDown("q") then
            self.topLeftThrust = true
            self.body:applyTorque(torque)
            local angle = angle + math.pi * 3/4
            self.body:applyForce(force_s * math.sin(angle), - force_s * math.cos(angle))
            self.changed = true
            self.sound.secondaryEngine:play()
        else
            if self.topLeftThrust then
                self.topLeftThrust = false
                self.changed = true
                self.sound.secondaryEngine:stop()
            end
        end
        if love.keyboard.isDown("e") then
            self.topRightThrust = true
            self.body:applyTorque(-torque)
            local angle = angle - math.pi * 3/4
            self.body:applyForce(force_s * math.sin(angle), - force_s * math.cos(angle))
            self.changed = true
            self.sound.secondaryEngine:play()
        else
            if self.topRightThrust then
                self.topRightThrust = false
                self.changed = true
                self.sound.secondaryEngine:stop()
            end
        end
        if love.keyboard.isDown("a") then
            self.bottomLeftThrust = true
            self.body:applyTorque(-torque)
            local angle = angle + math.pi * 1/4
            self.body:applyForce(force_s * math.sin(angle), - force_s * math.cos(angle))
            self.changed = true
            self.sound.secondaryEngine:play()
        else
            if self.bottomLeftThrust then
                self.bottomLeftThrust = false
                self.changed = true
                self.sound.secondaryEngine:stop()
            end
        end
        if love.keyboard.isDown("d") then
            self.bottomRightThrust = true
            self.body:applyTorque(torque)
            local angle = angle - math.pi * 1/4
            self.body:applyForce(force_s * math.sin(angle), - force_s * math.cos(angle))
            self.changed = true
            self.sound.secondaryEngine:play()
        else
            if self.bottomRightThrust then
                self.bottomRightThrust = false
                self.changed = true
                self.sound.secondaryEngine:stop()
            end
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
--    love.graphics.setColor(0.28, 0.63, 0.05)
--    love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))

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
