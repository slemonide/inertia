local Console = Class{
    init = function(self)
        self.log = {}
        self.charPos = 1 -- position of the cursor
        self.currentMsg = ""
        self.response = ""
        self.enabled = false
    end
}

function Console:isEnabled()
    return self.enabled
end

function Console:enable()
    self.enabled = true
end

function Console:disable()
    self.enabled = false
end

function Console:prevChar()
    if self.charPos > 1 then
        self.charPos = self.charPos - 1
    end
end

function Console:nextChar()
    if self.charPos <= string.len(self.currentMsg) then
        self.charPos = self.charPos + 1
    end
end

function Console:prevMsg()
    --self.msgPos = self.msgPos + 1
end

function Console:nextMsg()
    --self.msgPos = self.msgPos - 1
end

function Console:send()
    if utf8.sub(self.currentMsg, 0, 1) == "/" then
        self:handleCommand(utf8.sub(self.currentMsg, 2))
    else
        self.response = self.currentMsg
    end

    table.insert(self.log, self.currentMsg)
    self.currentMsg = ""
    self.charPos = 1
end

function Console:handleCommand(text)
    if string.len(text) > 0 then

        command = utf8.sub(text, 0, 4)
        params = utf8.sub(text, 6)

        if command == "help" then
            self.response = 
[[
Help:
Type /help to print this help
Type /name <name> to change name
Type /cnct <server> to connect to server
]]
        elseif command == "name" then
            Player:setName(params)
        elseif command == "cnct" then
            Client:connect(params)
            self.response = "Connecting to " .. params
        else
            self.response = "Incorrect command. Type /help for help"
        end
    else
        self.response = "Incorrect command. Type /help for help"
    end
end

function Console:backspace()
    if self.charPos > 1 then
        local pre  = utf8.sub(self.currentMsg, 1, self.charPos - 2)
        local post = utf8.sub(self.currentMsg,    self.charPos)

        self.currentMsg = pre .. post
        self.charPos = self.charPos - 1
    end
end

function Console:addChar(key)
    if self.enabled then
        local pre  = utf8.sub(self.currentMsg, 1, self.charPos - 1)
        local post = utf8.sub(self.currentMsg,    self.charPos)

        self.currentMsg = pre .. key .. post
        self.charPos = self.charPos + 1
    end
end

function Console:render()
    if self.enabled then
        local pre  = utf8.sub(self.currentMsg, 1, self.charPos - 1)
        local post = utf8.sub(self.currentMsg,    self.charPos)

        love.graphics.printf(pre .. "|" .. post, 5, 5, love.graphics.getWidth() - 10)
        love.graphics.printf(self.response, 5, 50, love.graphics.getWidth() - 10)
    end
end

return Console()
