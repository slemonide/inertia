local socket = require "socket"
local serpent = require("serpent")
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname('*', 12345)

local world = {}
local clients = {}

-- Handle clients
while (true) do
    local data, ip, port = udp:receivefrom()
    if (data) then
        local id, cmd, parms = data:match("^(%S*) (%S*) (.*)")
        if (cmd == "connect") then
            clients[id] = {
                ip = ip,
                port = port
            }
            udp:sendto("connected", ip, port)
            print(#clients)
        elseif (cmd == "update") then
            for otherId, client in pairs(clients) do
                if otherId ~= id then
                    udp:sendto(data, client.ip, client.port)
                end
            end
        else
            print("Unknown command:", data)
        end
    end
end
