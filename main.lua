anim8 = require 'anim8'
player = require 'player'

function love.load(arg)
    bunny1up = true
    bunny1down = false
    bunny1left = true
    bunny1right = false
    bunny1alive = true

    mousepos = 0
    standing = true
    slingshot = false
    flying = false
    done = false
    firstloop = true
    launchvel = 0
    mousex = 1
    mousey = 1
    angledeg = 0

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    -- loads the two backgrounds and the player
    backgroundimg = love.graphics.newImage('assets/background.jpg')

    local bunnyImage = love.graphics.newImage('assets/bunnybunnybunny.png')
    local bunnyG = anim8.newGrid(95, 78, bunnyImage:getWidth(), bunnyImage:getHeight())

    bunnyAnimation = anim8.newAnimation(bunnyG('1-7', '1-8','1-4', 9), (1 / 60))

    bunny1 = {
        x = 1050,
        y = 94,
        image = bunnyImage,
        VelX = 50,
        VelY = 50,
    }

    love.graphics.setNewFont(30)
end

--draws the objects we loaded above and prints the info I want
function love.draw()
    love.graphics.draw(backgroundimg)
    player:draw()
    if bunny1alive then
        bunnyAnimation:draw(bunny1.image, bunny1.x, bunny1.y)
    end

    -- animation:draw(player.image, player.x, player.y, player.heading, 1, 1, offsetX, offsetY)

    if standing then
        love.graphics.print("Standing: ", 400, 40)
    elseif slingshot then
        love.graphics.print("slingshot: ", 400, 40)
    elseif flying then
        love.graphics.print("flying: ", 400, 40)
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
    -- love.graphics.line(startingX, startingY, mousex, mousey)
end

function love.update(dt)
    bunnyAnimation:update(dt)
    player:update(dt)

    if love.keyboard.isDown('escape') then
       love.event.push('quit')
    end

    movebunnys(dt)

    xmousepos = love.mouse.getX()
    ymousepos = love.mouse.getY()
    -- velocity = (math.dist(offsetX,offsetY,mousex,mousey))
    -- angle = (math.angle(offsetX,offsetY,mousex,mousey))
    -- degangle = math.deg(angle)

    if flying then
        player.heading = getHeadingOfFox(player.x, player.y, xmousepos, ymousepos)
        player.img = love.graphics.newImage('assets/flying.png')
        if love.mouse.isDown(1) then
            boostTowardsMouse(xmousepos, ymousepos, dt)
        end
        if looping then
            player.velY = player.velY + (-500 * dt)
            moveFox(dt)
            if player.y > 550 then
                looping = false
                done = true
            end
        end
        if firstloop then
            player.velY = -5*(player.getStartingY() - mousey)
            player.velX = -5*(mousex - player.getStartingX())
            startingVelY = player.velY
            if player.velX > -800 then
                player.velX = 1*player.velX
            elseif player.velX < -800 then
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
        flying = false
        done = true
    end
end

function movebunnys(dt)
    if player.x > (bunny1.x -50) and player.y < (bunny1.x +50) and player.y > (bunny1.y -50) and player.y < (bunny1.y +50) then
        bunny1alive = false
    elseif bunny1alive then
        if bunny1up then
            bunny1.y = (bunny1.y - bunny1.VelY * dt)
        elseif bunny1down then
            bunny1.y = (bunny1.y + bunny1.VelY * dt)
        end

        if bunny1.y > 200 and bunny1down then
            bunny1up = true
            bunny1down = true
        elseif bunny1.y < 0 and bunny1up then
            bunny1up = false
            bunny1down = true
        end

        if bunny1left then
            bunny1.x = (bunny1.x - bunny1.VelX * dt)
        elseif bunny1right then
            bunny1.x = (bunny1.x + bunny1.VelX * dt)
        end

        if bunny1.x > 1050 and bunny1right then
            bunny1left = true
            bunny1right = false
            bunnyImg = love.graphics.newImage('assets/bunny.png')
        elseif bunny1.x < 34 and bunny1left then
            bunny1left = false
            bunny1right = true
            bunnyImg = love.graphics.newImage('assets/reversebunny.png')
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
        if slingshot then
            mousex = x
            mousey = y
            slingshot = false
            flying = true
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then -- the primary button
        if standing then
            if xmousepos > player.x - 250 and xmousepos < player.x + 250 and ymousepos > 460 and ymousepos < 560 then
                standing = false
                slingshot = true
            end
        end
    end
end

function boostTowardsMouse(mouseX, mouseY, dt)
    player.velX = player.velX + math.cos(player.heading) * player.acceleration * dt
    player.velY = player.velY - math.sin(player.heading) * player.acceleration * dt
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

function math.angle(x1,y1, x2,y2)
    return math.atan2(y2-y1, x2-x1)
end

function math.dist(x1,y1, x2,y2)
        return ((x2-x1)^2+(y2-y1)^2)^0.5
end
