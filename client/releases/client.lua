local Client = Class{
    init = function(self)
        self.connected = false
        self.id = -1
        self.lag = 0
        self.socket = require "socket"
        self.timer = self.socket.gettime()
    end
}

function Client:connect(server_name)
    self.udp = self.socket.udp()
    self.udp:settimeout(0)
    if server_name == "localhost" then
        server_name = "0.0.0.0"
    end
    if self.udp:setpeername(server_name, 65444) then
        self.udp:send(string.format("%f %s %s $", self.socket.gettime(), self.id, 'connect'))
        self.connected = true
    end
end

function Client:update(dt)
    if self.connected then
        repeat
            local data = self.udp:receive()
            if data then
                local ts, id, cmd, parms = data:match("^(%-?[%d.e]*) (%S*) (%S*) (.*)")

                self.lag = self.socket.gettime() - ts
                if (cmd == "id") then
                    self.id = tonumber(parms)
                elseif (cmd == "update") then
                    if not PlayerManager.players[id] then
                        PlayerManager.players[id] = PlayerSpawner()
                    end

                    PlayerManager.players[id]:deserialize(self.lag, parms)
                end
            end
        until not data
        if ((self.socket.gettime() - self.timer) > CONFIG.MIN_UPDATE_DELAY) then
            self.udp:send(string.format("%f %d %s %s", self.socket.gettime(), self.id, 'update', Player:serialize()))
            self.timer = self.socket.gettime()
        end
    end
end

return Client()
