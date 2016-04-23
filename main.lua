anim8 = require 'anim8'

function love.load(arg)

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    -- loads the two backgrounds and the player
    backgroundimg = love.graphics.newImage('assets/background.jpg')

    playerFrameX = 125
    playerFrameY = 70
    local playerImage = love.graphics.newImage('assets/idle.png')
    flyingImage = love.graphics.newImage('assets/flying.png')
    local g = anim8.newGrid(playerFrameX, playerFrameY, playerImage:getWidth(), playerImage:getHeight())
    animation = anim8.newAnimation(
        g(
            '1-7', '1-8',
            '1-4', 9
        ), (1 / 60))

    bunnyImg = love.graphics.newImage('assets/bunny.png')

    offsetX = playerFrameX / 2
    offsetY = playerFrameY / 2

    player = {
        x = offsetX,
        y = 529,
        image = playerImage,
        heading = 0,
        velX = 1,
        velY = 1,
        acceleration = 20,
    }

    win = false
    lose = false

    startingX = player.x
    startingY = player.y

    --set the count
    --set the count
    mousepos = 0
    jump = false
    firstloop = true
    launchvel = 0
    mousex = 1
    mousey = 1
    angledeg = 0

    love.graphics.setNewFont(30)

end

--draws the objects we loaded above and prints the info I want
function love.draw(dt)
    love.graphics.draw(backgroundimg)
    animation:draw(player.image, player.x, player.y, player.heading, 1, 1, offsetX, offsetY)
    love.graphics.print("https://github.com/spantz/rocket-fox", 10, 0)

    if win then
      love.graphics.print("KILLED THAT BASTARD", 650, 20)
    else
        love.graphics.draw(bunnyImg, 900, 500)
    end

    if lose then
      love.graphics.print("Missed, Idiot", 650, 20)
    end

    -- love.graphics.print("X Mouse Position: " .. xmousepos, 200, 20)
    -- love.graphics.print("Y Mouse Position: " .. ymousepos, 200, 40)
    -- love.graphics.print("End x Pos: " .. mousex, 200, 60)
    -- love.graphics.print("End y Pos: " .. mousey, 200, 80)
    -- love.graphics.print("Velocity: " .. velocity, 200, 100)
    -- love.graphics.print("Angle: " .. angle, 200, 120)
    -- love.graphics.print("Xposition: " .. player.x, 350, 20)
    -- love.graphics.print("Yposition: " .. player.y, 350, 40)
    -- love.graphics.print("Heading  : " .. player.heading, 350, 60)
    --
    -- love.graphics.print("LaunchVel:  " .. launchvel, 650, 20)
    -- love.graphics.print("Yvel:       " .. player.velY, 650, 50)
    -- love.graphics.print("xvel:       " .. player.velX, 650, 70)
    -- love.graphics.print("degangle:       " .. degangle, 650, 90)
    --
    -- if jump then
    --     love.graphics.print("Jumping", 50, 210)
    -- end
    --
    love.graphics.line(player.x, player.y, love.mouse.getX(), love.mouse.getY())
end

-- Updating
-- function love.update(dt)
--     animation:update(dt)
-- 	-- I always start with an easy way to exit the game
-- 	if love.keyboard.isDown('escape') then
-- 		love.event.push('quit')
-- 	end
--
--     xmousepos = love.mouse.getX()
--     ymousepos = love.mouse.getY()
--
--     velocity = (math.dist(offsetX,offsetY,mousex,mousey))
--     angle = (math.angle(offsetX,offsetY,mousex,mousey))
--
--     degangle = math.deg(angle)
--
--     if jump then
--       player.img = love.graphics.newImage('assets/flying.png')
--
--       -- radsin = math.sin(angle)
--       -- degsin = math.deg(radsin)
--       --
--       -- radcos = math.cos(angle)
--       -- degcos = math.deg(radcos)
--
--       if firstloop then
--         player.velY = 3*(startingY - mousey)
--         player.velX = 2*(mousex - startingX)
--         firstloop = false
--       else
--         player.velY = player.velY + (-1500 * dt)
--
--       -- player.velX = (radsin * player.acceleration * dt)
--     	-- player.velY = (radcos * -player.acceleration * dt)
--
--       -- player.velX = (player.velX * player.acceleration * dt)
--     	-- player.velY = (player.velY * -player.acceleration * dt)
--       moveFox(dt)
--    end
--
--     end
-- end

function love.update(dt)
    animation:update(dt)
    -- I always start with an easy way to exit the game
     if love.keyboard.isDown('escape') then
        love.event.push('quit')
     end
    xmousepos = love.mouse.getX()
    ymousepos = love.mouse.getY()
    velocity = (math.dist(offsetX,offsetY,mousex,mousey))
    angle = (math.angle(offsetX,offsetY,mousex,mousey))
    degangle = math.deg(angle)

    if jump then
      player.img = love.graphics.newImage('assets/flying.png')
      player.heading = getHeadingOfFox(player.x, player.y, xmousepos, ymousepos)
      if looping then
        player.velY = player.velY + (-1500 * dt)
        moveFox(dt)
        if player.y > 550 then
          looping = false
          done = true
        end
      end
      if firstloop then
          player.velY = 3*(startingY - mousey)
          player.velX = 3*(mousex - startingX)
          startingVelY = player.velY
          if player.velX < 800 then
            player.velX = player.velX
          elseif player.velX > 800 then
            player.velX = 800
          end
          if player.velY < 1000 then
            player.velY = player.velY
          elseif player.velY > 1000 then
            player.velY = 1000
          end
          firstloop = false
          looping = true
     end
   end
   if done then
     if player.x > 700 and player.x < 1050 then
       win = true
     else
      lose = true
    end
  end
end

function moveFox(dt)
    player.x = player.x + player.velX * dt
    player.y = (player.y - player.velY * dt)

end

--gets the position of mouse release
function love.mousereleased(x, y, button)
   if button == 1 then
      mousex = x
      mousey = y
      jump = true
   end
end

function getHeadingOfFox(playerX, playerY, mouseX, mouseY)
    local yDiff = mouseY - playerY
    local xDiff = mouseX - playerX
    local heading = math.atan(yDiff / xDiff)

    if xDiff < 0 then
        local radiansToAdd = math.rad(90)
        if yDiff < 0 and heading > 0 then
            heading = (radiansToAdd * -1) - (radiansToAdd - heading)
        elseif yDiff > 0 and heading < 0 then
            heading = (radiansToAdd + (radiansToAdd + heading))
        end
    end

    return heading, yDiff, xDiff
end

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function math.dist(x1,y1, x2,y2)
        return ((x2-x1)^2+(y2-y1)^2)^0.5
end
