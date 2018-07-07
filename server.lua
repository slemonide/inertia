local socket = require "socket"
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname('*', 65444)

local clients = {}

-- Handle clients
while (true) do
    local data, ip, port = udp:receivefrom()
    if (data) then
   --     local tic = socket.gettime()

        local ts, id, cmd, parms = data:match("^(%-?[%d.e]*) (%S*) (%S*) (.*)")
        ts = tonumber(ts)
        id = tonumber(id)
        if (cmd == "connect") then
            id = #clients + 1
            clients[id] = {
                ip = ip,
                port = port,
                lastUpdateTime = ts
            }
            udp:sendto(string.format("%f %d %s %d", ts, 0, "id", id), ip, port)
            print('Connection from ' .. ip .. " " .. port .. " with id " .. id)
        elseif (cmd == "update") then
            if (clients[id] and ts > clients[id].lastUpdateTime) then
                if clients[id] then
                    clients[id].lastUpdateTime = ts
                    for otherId, client in pairs(clients) do
                        if otherId ~= id then
                            udp:sendto(data, client.ip, client.port)
                            --udp:sendto(string.format("%s %s %s", id, 'update', parms), client.ip, client.port)
                        end
                    end
                end
            else
                print("Time Travel Detected! Notify SERN!")
            end
        else
            print("Unknown command:", data)
        end

--        print("Delay:", tostring(socket.gettime() - tic))
    end
end
