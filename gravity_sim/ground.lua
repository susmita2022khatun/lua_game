ground = class()
--[[
function ground:init(x,y,width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
end
]]--

function ground:init(x, y, radius, segments, width)
	self.x = x
	self.y = y
	self.radius = radius
	self.segments = segments
	self.width = width
end

function ground:render()
	startangle = -1*math.pi/4
	endangle = startangle + 3*math.pi/2
	love.graphics.setColor(0,255,0,255)
	love.graphics.setLineWidth(self.width)
	love.graphics.arc("line", self.x, self.y, self.radius, startangle, endangle)
	love.graphics.setColor(0,0,0,255)
	love.graphics.setLineWidth(self.width + 2)
	love.graphics.arc("line", self.x, self.y, self.radius, endangle, 3*math.pi/2 - startangle)
end

function ground:collide(ball)

	local dx = ball.x - self.x
	local dy = ball.y - self.y
	local distance = math.sqrt(dx * dx + dy * dy)


	if distance > self.radius and distance < self.radius + 10 and ball.y > self.y - self.radius*math.sin(math.pi/4) then
		return true 
	end

	return false 
end

