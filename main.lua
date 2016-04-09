   
--for the player class
player = { x = 90, y = 690, acceleration = 1, vely = 1, velx = 1, img = nil}

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
    
    player.img = love.graphics.newImage('assets/sitting.png')
    backgroundimg = love.graphics.newImage('assets/a.jpg')
    foregroundimg = love.graphics.newImage('assets/fore.png')

end

--draws the objects we loaded above and prints the info I want
function love.draw(dt)
    love.graphics.draw(backgroundimg, 0, 0)
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
    
   -- love.graphics.print("Firstlp:    " .. firstloop, 450, 30)
    love.graphics.print("LaunchVel:  " .. launchvel, 450, 50)
    love.graphics.print("Yvel:       " .. player.vely, 450, 70)
    love.graphics.print("xvel:       " .. player.velx, 450, 90)
    
    if jump then
    love.graphics.print("Jumping", 50, 210)
    end
    if firstloop then
    love.graphics.print("Firstloop", 450,30)
    else
    love.graphics.print("Looping", 450,30)
    end
  
    love.graphics.line(90, 690, mousex, mousey)
end

-- Updating
function love.update(dt)
	-- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
    
    xmousepos = love.mouse.getX()
    ymousepos = love.mouse.getY()
    
    velocity = math.dist(90,690,mousex,mousey)
    angle = math.deg(math.angle(90,690,mousex,mousey))
    

    if jump then
        
        player.img = love.graphics.newImage('assets/flying.png')
        
        if firstloop then
            --player.vely = mousey - 690
            player.vely = 10
            launchvel = player.vely
            firstloop = false
        end

        
        --player.acceleration = player.acceleration - (9.8*dt)
        
        player.vely = player.vely * -9.8 * dt

        --move the guy up
        player.y = player.y - player.vely * dt
        
        
        
        player.velx = mousex - 90
        player.velx = player.velx * dt
        
    end   
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

