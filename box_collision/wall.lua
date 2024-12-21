wall = class()

function wall:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function wall:render()
    love.graphics.setColor(0,255,0,255)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function wall:collide(box)
    if self.x > box.x + box.dimension or box.x > self.x + self.width then
        return false
    end

    if self.y > box.y + box.dimension or box.y > self.y + self.height then
        return false
    end

    return true
end

