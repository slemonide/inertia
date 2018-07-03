local Client = Class{
    init = function(self)
        math.randomseed(os.time())
        self.connected = false
        self.id = tostring(math.random(99999))
        self.socket = require "socket"
        self:connect("108.63.252.129")
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
                        if not PlayerManager.players[id] then
                            PlayerManager.players[id] = PlayerSpawner()
                        end

                        PlayerManager.players[id]:deserialize(parms)
                    end
                end
            end
        until not data
    end
    if Player:isOld() then
        self.udp:send(string.format("%s %s %s", self.id, 'update', Player:serialize()))
    end
end

return Client()
