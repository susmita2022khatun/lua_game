ball = class()

function ball:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	
	self.dx = 0
	self.dy = 0
	self.d2_x = 0
	self.d2_y = GRAVITY	
end

function ball:reset()

	self.dx = 0
	self.dy = 0
	self.x = VIRTUAL_WIDTH/2
	self.y = VIRTUAL_HEIGHT/4
	self.d2_x = 0
	self.d2_y = GRAVITY	
	
end

function ball:update(dt)

	self.dx = self.dx + self.d2_x*dt --+ 0.002
	self.dy = self.dy + self.d2_y*dt 
	
	self.x = self.x + self.dx*dt 
	self.y = self.y + self.dy*dt
	
end

function ball:render()
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
--[[
function ball:collide(ground)
	
	if self.x > ground.x + ground.width or ground.x > self.x + self.width then
		return false
	end
	
	if self.y > ground.y + ground.height or ground.y > self.y + self.height then
		return false
	end
	return true
end
]]--
