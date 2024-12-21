box = class()

function box:init(x, y, dimension, velocity, density, elasticity)
    self.x = x
    self.y = y
    self.dimension = dimension
    self.density = density
    self.elasticity = elasticity

    self.dx = velocity
    self.dy = 0
    self.org_x = x
    self.org_y = y
end

function box:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function box:reset()
    self.x = self.org_x
    self.y = self.org_y
    self.dx = self.velocity
    self.dy = 0
end

function box:render()
    love.graphics.rectangle('fill', self.x, self.y, self.dimension, self.dimension)
end

function box:collide(other_box)
    if self.x > other_box.x + other_box.dimension or other_box.x > self.x + self.dimension then
        return false
    end

    if self.y > other_box.y + other_box.dimension or other_box.y > self.y + self.dimension then
        return false
    end

    return true
end

