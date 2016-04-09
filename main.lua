   
--for the player class
player = { x = 90, y = 690, speed = 75, img = nil, vely = 1, velx = 1 }

--set the count 
 --set the count 
    mousepos = 0
    xpos = 90

    ypos1 = 0.
    ypos2 = 0.
    ypos3 = 0.
    ypos4 = 0.
ypos5 = 0
    angle3 = 0.


ypos = 690
jump = false
radangle = 1
degangle = 1
tanrad = 0
tandeg = 0

-- loads the two backgrounds and the player
function love.load(arg)
    
    playerimg = love.graphics.newImage('assets/b.jpg')
    backgroundimg = love.graphics.newImage('assets/a.jpg')
    foregroundimg = love.graphics.newImage('assets/fore.png')
    
   mousex = 1
   mousey = 1
    tan = 0
    cos = 0
    angle1 = 0
    cos1 = 0
 
end





--draws the objects we loaded above and prints the info I want
function love.draw(dt)
    love.graphics.draw(backgroundimg, 0, 0)
    love.graphics.draw(foregroundimg, 0, 775)
    love.graphics.draw(playerimg, player.x, player.y)
    
    love.graphics.print("Speed: " .. player.speed, 50, 30)
    love.graphics.print("X Mouse Position: " .. xmousepos, 50, 50)
    love.graphics.print("Y Mouse Position: " .. ymousepos, 50, 70)
    love.graphics.print("End x Pos: " .. mousex, 50, 90)
    love.graphics.print("End y Pos: " .. mousey, 50, 110)
    love.graphics.print("Velocity: " .. velocity, 50, 130)
    love.graphics.print("Xposition: " .. player.x, 50, 150)
    love.graphics.print("Yposition: " .. player.y, 50, 170)
    

    love.graphics.print("radangle: " .. radangle, 200, 20)
    love.graphics.print("degangle: " .. degangle, 200, 40)
    love.graphics.print("tanrad: " .. tanrad, 200, 60)
    love.graphics.print("tandeg: " ..tandeg, 200, 80)
    love.graphics.print("Ypos1: " .. ypos1, 200, 100)
    love.graphics.print("Ypos2: " .. ypos2, 200, 120)
    love.graphics.print("Ypos3: " .. ypos3, 200, 140)
    love.graphics.print("Ypos4: " .. ypos4, 200, 160)
    love.graphics.print("Ypos5: " .. ypos5, 200, 180)
    
  
    love.graphics.print("xvel:   " .. player.velx, 450, 90)
    
    if jump then
    love.graphics.print("Jumping", 50, 210)
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
    
    --radangle = -1*(math.angle(90,690,mousex,mousey))
    radangle = .767945
    degangle = math.deg(radangle)

    if jump then
        tanrad = math.tan(radangle)
        tandeg = math.deg(tanrad)
  
        ypos1 = 690+(120*tanrad)
        
        ypos2 = -9.8*(120^2)
        
        cos = math.cos(radangle)
        cos1 = math.deg(cos)
        
        ypos3 = 2*(2*cos)^2
        
        ypos4 = ypos2/ypos3
        ypos5 = ypos1-ypos4
        
        
        player.x = 120 -- + .01
        player.y = -1*ypos5
        
        
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

