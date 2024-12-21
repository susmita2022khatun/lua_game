push = require 'push'
require 'class'
require 'ball'
require 'ground'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

GRAVITY =  100

local elasticity = 1
local err = 0.06

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	main_font = love.graphics.newFont('Pixellettersfull-BnJ5.ttf', 16)
	
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})
	
	collision_count = 0
	
	ball = ball(VIRTUAL_WIDTH/2 + err, VIRTUAL_HEIGHT/4, 4,4)
	--ground = ground(0, VIRTUAL_HEIGHT-10, VIRTUAL_WIDTH, 10)
	ground = ground(VIRTUAL_WIDTH/2, 3*VIRTUAL_HEIGHT/4, VIRTUAL_HEIGHT/4, 100, 10)
	
	gameState = 'start'
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	
	if key == 'enter' or key == 'return' then
		if gameState == 'start' then
			collision_count = 0
			gameState = 'play'
		else
			gameState = 'start'
			
			ball:reset()
		end
	end
end

function love.update(dt)
    if gameState == 'play' then
        ball:update(dt)
        
        if ground:collide(ball) then
            collision_count = collision_count + 1
            
            local dx = ball.x - ground.x
            local dy = ball.y - ground.y
            local distance = math.sqrt(dx * dx + dy * dy)
            
            local nx = dx / distance
            local ny = dy / distance
            
            local dotProduct = ball.dx * nx + ball.dy * ny
            
            ball.dx = ball.dx - 2 * dotProduct * nx
            ball.dy = ball.dy - 2 * dotProduct * ny
            
            ball.dx = ball.dx * elasticity
            ball.dy = ball.dy * elasticity
            
        end
    end
end


function love.draw()
	push:apply('start')
	
	love.graphics.setFont(main_font)
	
	if gameState == 'start' then
		love.graphics.printf('HELLO START STATE', 0, 20, VIRTUAL_WIDTH, 'center')
	else
		love.graphics.printf('HELLO PLAY STATE', 0, 20, VIRTUAL_WIDTH, 'center')
	end
	
	ground:render()
	ball:render()	
	
	love.graphics.setFont(main_font)
	love.graphics.print('Collision count: ' .. tostring(collision_count), VIRTUAL_WIDTH/2 , VIRTUAL_HEIGHT/5)
	
	displayFPS()
	
	push:apply('end')
end

function displayFPS()
	love.graphics.setFont(main_font)
	love.graphics.setColor(0,255,0,255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()),10,10)
end
