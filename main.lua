
--for the player class
player = { x = 90, y = 400, acceleration = 20000, velY = 1, velX = 1, img = nil}

--set the count
 --set the count
    mousepos = 0
    jump = false
    firstloop = true
    launchvel = 0
    mousex = 1
    mousey = 1

-- loads the two backgrounds and the player
function love.load(arg)

  decay = 150
  terminalVelocity = 400
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()

    player.img = love.graphics.newImage('assets/sitting.png')
    backgroundimg = love.graphics.newImage('assets/a.jpg')
    foregroundimg = love.graphics.newImage('assets/fore.png')

end

--draws the objects we loaded above and prints the info I want
function love.draw(dt)
    love.graphics.draw(backgroundimg, 0, 100)
    love.graphics.draw(foregroundimg, 0, 775)
    love.graphics.draw(player.img, player.x, player.y)

    love.graphics.print("X Mouse Position: " .. xmousepos, 50, 50)
    love.graphics.print("Y Mouse Position: " .. ymousepos, 50, 70)
    love.graphics.print("End x Pos: " .. mousex, 50, 90)
    love.graphics.print("End y Pos: " .. mousey, 50, 110)
    love.graphics.print("Velocity: " .. velocity, 50, 130)
    love.graphics.print("Angle: " .. angle, 50, 150)
    love.graphics.print("Xposition: " .. player.x, 50, 170)
    love.graphics.print("Yposition: " .. player.y, 50, 190)

    love.graphics.print("LaunchVel:  " .. launchvel, 450, 50)
    love.graphics.print("Yvel:       " .. player.velY, 450, 70)
    love.graphics.print("xvel:       " .. player.velX, 450, 90)

    if jump then
    love.graphics.print("Jumping", 50, 210)
    end

    love.graphics.line(90, 400, mousex, mousey)
end

-- Updating
function love.update(dt)
	-- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

    xmousepos = love.mouse.getX()
    ymousepos = love.mouse.getY()

    velocity = (math.dist(90,400,mousex,mousey))/500000
    angle = -1*(math.angle(90,400,mousex,mousey))

    if jump then

      player.img = love.graphics.newImage('assets/flying.png')

      player.velX = -1*(math.sin(angle) * player.acceleration * dt)
    	player.velY = -1*(math.cos(angle) * -player.acceleration * dt)

      --terminalVelocity
    	-- if player.velY ~= 0 and player.velY < terminalVelocity then
    	-- 	player.velY = player.velY + (decay * dt)
    	-- end
    	-- if player.velY > terminalVelocity then
    	-- 	player.velY = terminalVelocity
    	-- end
    	--if player.y >= 500 then
    		--player.y = 500
    		--player.velY = 0
    		--player.velX = 0
    	--end

        moveFox(dt)
    end
end

function moveFox(dt)
    player.x = player.x + player.velX * dt
    player.y = (player.y + player.velY * dt)

    -- if player.x > width then
    --     player.x = 0
    -- elseif player.x < 0 then
    --     player.x = width
    -- end
    -- if player.y > height then
    --     player.y = 0
    -- elseif player.y < 0 then
    --     player.y = height
    -- end
end



--gets the position of mouse release
function love.mousereleased(x, y, button)
   if button == 1 then
      mousex = x
      mousey = y
     jump = true
   end
end



function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function math.dist(x1,y1, x2,y2)
        return ((x2-x1)^2+(y2-y1)^2)^0.5
end
