local Stars = Class{
    init = function(self)
        self.stars = {}
    end
}

function Stars:generate()
    self.stars = {}
    for i=1,CONFIG.STARS_MAX do
        local star = {}
        local createStar = true
        star.pos = {
            x = math.random(love.graphics.getWidth()),
            y = math.random(love.graphics.getHeight())
        }
        for _, otherStar in ipairs(self.stars) do
            if math.sqrt((otherStar.pos.x - star.pos.x)^2
                + (otherStar.pos.y - star.pos.y)^2) < CONFIG.STAR_MIN_DISTANCE then
                createStar = false
                break
            end
        end
        if createStar then
            star.color = {math.random(155) + 100, math.random(155) + 100, math.random(155) + 100}
            table.insert(self.stars, star)
        end
    end
end

function Stars:render()
	for _, star in ipairs(self.stars) do
		love.graphics.setColor(star.color)
		love.graphics.circle("fill", star.pos.x, star.pos.y, 1)
	end
end

return Stars()

