local PlayerManager = Class{
    init = function(self)
        self.players = {}
    end
}

function PlayerManager:render()
	for _, player in pairs(self.players) do
        player:render()
	end
end

return PlayerManager()
