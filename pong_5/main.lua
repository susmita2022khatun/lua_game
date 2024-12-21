require 'class'
require 'paddle'
require 'ball'
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 300


function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	small_font = love.graphics.newFont('Pixellettersfull-BnJ5.ttf', 16)
	score_font = love.graphics.newFont('Pixelletters-RLm3.ttf', 16)
	
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})
	
	player1_score = 0
	player2_score = 0
	
	player1 = paddle(10, 30, 5, 20)
	player2 = paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT -50, 5,20)
	
	ball_ = ball(VIRTUAL_WIDTH/2 -2, VIRTUAL_HEIGHT/2 -2, 4,4)
	gameState = 'start'
end


function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter'or key == 'return' then
		if gameState == 'start' then
			gameState = 'play'
		else
			gameState = 'start'
			
			ball_:reset()
		end
	end
end		


function love.update(dt)
	--player1
	if love.keyboard.isDown('w') then
		player1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.dy = PADDLE_SPEED
	else
		player1.dy = 0
	end 
	
	--player2
	if love.keyboard.isDown('a') then
		player2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('d') then
		player2.dy = PADDLE_SPEED
	else 
		player2.dy = 0
	end 
		
	--ball
	if gameState == 'play' then
		ball_:update(dt)
		
		if ball_:collide(player1) then
			player1_score = player1_score +1
			ball_.dx = -ball_.dx*1.03
			ball_.x = player1.x +5
			
			if ball_.dy < 0 then
				ball_.dy = -math.random(80,250)
			else
				ball_.dy = math.random(80,250)
			end
		end
		
		if ball_:collide(player2) then
			player2_score = player2_score +1
			ball_.dx = -ball_.dx*1.03
			ball_.x = player2.x -4
			
			if ball_.dy < 0 then
				ball_.dy = -math.random(80,250)
			else
				ball_.dy = math.random(80,250)
			end
		end
		
		--boundary condition
		
		if ball_.y <=0 then
			ball_.y = 0
			ball_.dy = -ball_.dy
		end
		
		if ball_.y >= VIRTUAL_HEIGHT -4 then
			ball_.y = VIRTUAL_HEIGHT -4
			ball_.dy = -ball_.dy
		end
		
	end
	player1:update(dt)
	player2:update(dt)
end


function love.draw()
	push:apply('start')
	
	love.graphics.setFont(small_font)
	
	if gameState == 'start' then
		love.graphics.printf('HELLO START STATE', 0, 20, VIRTUAL_WIDTH, 'center')
	else
		love.graphics.printf('HELLO PLAY STATE', 0, 20, VIRTUAL_WIDTH, 'center')
	end
	
	player1:render()
	player2:render()
	ball_:render()
	
	displayFPS()
	
	love.graphics.setFont(small_font)
	love.graphics.print(tostring(player1_score), VIRTUAL_WIDTH/2 -30, VIRTUAL_HEIGHT/3)
	love.graphics.print(tostring(player2_score), VIRTUAL_WIDTH/2 +30, VIRTUAL_HEIGHT/3)
	
	push:apply('end')
end


function displayFPS()
	love.graphics.setFont(small_font)
	love.graphics.setColor(0,255,0,255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10 ,10)
end
