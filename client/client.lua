local Client = Class{
    init = function(self)
        math.randomseed(os.time())
        self.connected = false
        self.id = tostring(math.random(99999))
        self.socket = require "socket"
        self:connect("localhost")
    end
}

function Client:connect(server_name)
    self.udp = self.socket.udp()
    self.udp:settimeout(0)
    if server_name == "localhost" then
        server_name = "0.0.0.0"
    end
    self.udp:setpeername(server_name, 12345)
    self.udp:send(string.format("%s %s $", self.id, 'connect'))
    self.connected = true
end

function Client:update(dt)
    if self.connected then
        repeat
            local data = self.udp:receive()
            if data then
                if (data == "connected") then
                    print("Connected!")
                else
                    local id, cmd, parms = data:match("^(%S*) (%S*) (.*)")

                    if (cmd == "update") then
--                        local x, y, a = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*) (%-?[%d.e]*)$")
--                        assert(x and y and a)
--                        x, y = tonumber(x), tonumber(y)

                        if not PlayerManager.players[id] then
                            PlayerManager.players[id] = PlayerSpawner()
                        end

                        PlayerManager.players[id]:deserialize(parms)
--                        PlayerManager.players[id].body:setX(x)
--                        PlayerManager.players[id].body:setY(y)
--                        PlayerManager.players[id].body:setAngle(a)
                    end
                end
            end
        until not data
    end
    self.udp:send(string.format("%s %s %s", self.id, 'update', Player:serialize()))
end

return Client()
