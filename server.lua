-- Time after which client is considered disconnected, in seconds
TIMEOUT = 1

local socket = require "socket"
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname('*', 65444)

lastId = 0
local clients = {}

-- Go through received messages, send proper replies
function handleRequests()
    local data, ip, port = udp:receivefrom()
    if (data) then
        local ts, id, cmd, parms = data:match("^(%-?[%d.e]*) (%S*) (%S*) (.*)")
        ts = tonumber(ts)
        id = tonumber(id)
        if (cmd == "connect") then
            lastId = lastId + 1
            id = lastId
            clients[id] = {
                ip = ip,
                port = port,
                lastUpdateTime = ts,
                connected = true
            }
            udp:sendto(string.format("%f %d %s %d", ts, 0, "id", id), ip, port)
            print('Connection from ' .. ip .. " " .. port .. " with id " .. id)
        elseif (cmd == "update") then
            if (clients[id] and ts > clients[id].lastUpdateTime) then
                if clients[id] then
                    clients[id].lastUpdateTime = ts
                    for otherId, client in ipairs(clients) do
                        if otherId ~= id then
                            udp:sendto(data, client.ip, client.port)
                        end
                    end
                end
            end
        else
            print("Unknown command:", data)
        end
    end
end

-- Remove timeout clients
function handleTimeouts()
    for id, client in ipairs(clients) do
        if (client.connected and (socket.gettime() - client.lastUpdateTime) > TIMEOUT) then
            client.connected = false
            print("Client disconnected:", id)
            -- TODO: also send notifications to other clients
            -- NOTE: we don't delete client from clients table in case
            -- that client will reconnect later
        end
    end
end

while (true) do
    handleRequests()
    handleTimeouts()
end
