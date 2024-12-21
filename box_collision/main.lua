require 'class'
push = require 'push'
require 'box'
require 'wall'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

BOX_SPEED = -100
DENSITY = 10

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    main_font = love.graphics.newFont('Pixellettersfull-BnJ5.ttf', 16)
    small_font = love.graphics.newFont('Pixellettersfull-BnJ5.ttf', 16)

    sound = {['collide'] = love.audio.newSource('metal-hit-84608.mp3', 'static')}
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    collision_count = 0
    box_1 = box(3 * VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 3, 100, BOX_SPEED, DENSITY, 1)
    box_2 = box(VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 3, 10, 0, DENSITY, 1)
    wall = wall(VIRTUAL_WIDTH / 4 - 30, VIRTUAL_HEIGHT / 3 - 10, 5, 50)

    gameState = 'start'
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            box_1:reset()
            box_2:reset()
        end
    end
end

function love.update(dt)
    if gameState == 'play' then
        box_1:update(dt)
        box_2:update(dt)

        m1 = (box_1.dimension) * (box_1.dimension)
        m2 = (box_2.dimension) * (box_2.dimension)
        if box_1:collide(box_2) then
            sound['collide']:play()
            collision_count = collision_count + 1
            a = box_1.dx
            b = box_2.dx
            box_1.dx = (2 * m2 / (m1 + m2)) * b + ((m1 - m2) / (m1 + m2)) * a
            box_2.dx = ((m2 - m1) / (m1 + m2)) * b + (2 * m1 / (m1 + m2)) * a
        end

        if wall:collide(box_2) then
            sound['collide']:play()
            collision_count = collision_count + 1
            box_2.dx = -1*box_2.dx
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

    box_1:render()
    box_2:render()
    wall:render()

    love.graphics.setFont(small_font)
    love.graphics.print(tostring(collision_count), VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 4)

    push:apply('end')
end

