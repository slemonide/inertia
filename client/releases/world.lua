local World = Class{
    init = function(self)
        love.physics.setMeter(64)
        self.world = love.physics.newWorld(0, 0, true)
        self.world:setCallbacks(self.beginContact,
                                self.endContact,
                                self.preSolve,
                                self.postSolve)
        self.objects = {}
--[[
        local topWall = {}
        topWall.body = love.physics.newBody(self.world, 5, 5000)
        topWall.shape = love.physics.newRectangleShape(10, 10000)
        topWall.fixture = love.physics.newFixture(topWall.body, topWall.shape)
        self.objects.topWall = topWall
        
        local downWall = {}
        downWall.body = love.physics.newBody(self.world, 10000, 5000)
        downWall.shape = love.physics.newRectangleShape(10, 10000)
        downWall.fixture = love.physics.newFixture(downWall.body, downWall.shape)
        self.objects.downWall = downWall
        
        local leftWall = {}
        leftWall.body = love.physics.newBody(self.world, 5000, 5)
        leftWall.shape = love.physics.newRectangleShape(10000, 10)
        leftWall.fixture = love.physics.newFixture(leftWall.body, leftWall.shape)
        self.objects.leftWall = leftWall
        
        local rightWall = {}
        rightWall.body = love.physics.newBody(self.world, 5000, 10000)
        rightWall.shape = love.physics.newRectangleShape(10000, 10)
        rightWall.fixture = love.physics.newFixture(rightWall.body, rightWall.shape)
        self.objects.rightWall = rightWall
--]]
    end
}

function World:update(dt)
    self.world:update(dt)
end

function World:render()
--[[
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon("fill", self.objects.leftWall.body:getWorldPoints(
                                  self.objects.leftWall.shape:getPoints()))
    
    love.graphics.setColor(0.63, 0.28, 0.05)
    love.graphics.polygon("fill", self.objects.topWall.body:getWorldPoints(
                                  self.objects.topWall.shape:getPoints()))
    
    love.graphics.setColor(0.05, 0.63, 0.28)
    love.graphics.polygon("fill", self.objects.rightWall.body:getWorldPoints(
                                  self.objects.rightWall.shape:getPoints()))
    
    love.graphics.setColor(0.05, 0.28, 0.63)
    love.graphics.polygon("fill", self.objects.downWall.body:getWorldPoints(
                                  self.objects.downWall.shape:getPoints()))
--]]
end

function World.beginContact(a, b, coll)
    if (a == Player.fixture) then
        Player:collide(b)
    end
    if (b == Player.fixture) then
        Player:collide(a)
    end
end
 
function World.endContact(a, b, coll)
end
 
function World.preSolve(a, b, coll)
end
 
function World.postSolve(a, b, coll, normalimpulse, tangentimpulse)
end

return World()
