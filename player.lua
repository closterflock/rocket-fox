local anim8 = require 'anim8'

local frameSize = {
    x = 124,
    y = 69
}

local offsets = {
    x = frameSize.x / 2,
    y = frameSize.y / 2
}

local starting = {
    x = offsets.x,
    y = 529
}

function regenerateCrouchAnimation(grid)
    return anim8.newAnimation(grid('1-7', '1-8','1-3', 9), (1 / 59), 'pauseAtEnd')
end

function regenerateCrouchToFlyingAnimation(grid, callback)
    print('crouch to flying')
    return anim8.newAnimation(grid('1-7', '1-8', '1-3', 9), (1 / 59), callback)
end

-- idle image, grid, and animation
local idleImage = love.graphics.newImage('assets/idle.png')
local idleGrid = anim8.newGrid(frameSize.x, frameSize.y, idleImage:getWidth(), idleImage:getHeight(), 0, 0, 1)
local idleAnimation = anim8.newAnimation(idleGrid('1-7', '1-8','1-4', 9), (1 / 60))

-- crouch image, grid, and animation
local crouchImage = love.graphics.newImage('assets/crouch.png')
local crouchGrid = anim8.newGrid(frameSize.x, frameSize.y, crouchImage:getWidth(), crouchImage:getHeight(), 0, 0, 1)
local crouchAnimation = regenerateCrouchAnimation(crouchGrid)

-- crouchToFlying image, grid, and animation
local crouchToFlyingImage = love.graphics.newImage('assets/crouch-to-flying.png')
local crouchToFlyingGrid = anim8.newGrid(frameSize.x, frameSize.y, crouchToFlyingImage:getWidth(), crouchToFlyingImage:getHeight(), 0, 0, 1)
local crouchToFlyingAnimation = regenerateCrouchToFlyingAnimation(crouchToFlyingGrid)

-- flying image, grid, and animation
local flyingImage = love.graphics.newImage('assets/flying.png')
local flyingGrid = anim8.newGrid(frameSize.x, frameSize.y, flyingImage:getWidth(), flyingImage:getHeight(), 0, 0, 1)
local flyingAnimation = anim8.newAnimation(flyingGrid('1-7', '1-8','1-3', 9), (1 / 59))

local player = {
    x = offsets.x,
    y = 529,
    animation = idleAnimation,
    image = idleImage,
    heading = 0,
    velX = 1,
    velY = 1,
    acceleration = 750,
    standing = true,
    slingshot = false,
    flying = false
}

function player:setImageAndAnimation(image, animation)
    self.image = image
    self.animation = animation
end

function player:setIdleAnimation()
    self:setImageAndAnimation(idleImage, idleAnimation)
end

function player:transitionToFlying()
    local callback = function() self:setFlyingAnimation() end
    crouchToFlyingAnimation = regenerateCrouchToFlyingAnimation(crouchToFlyingGrid, callback)
    self:setImageAndAnimation(crouchToFlyingImage, crouchToFlyingAnimation)
end

function player:setFlyingAnimation()
    self:setImageAndAnimation(flyingImage, flyingAnimation)
end

function player:regenerateCrouchAnimation()
    crouchAnimation = regenerateCrouchAnimation(crouchGrid)
    self:setImageAndAnimation(crouchImage, crouchAnimation)
end

function player:draw()
    self.animation:draw(self.image, self.x, self.y, self.heading, 1, 1, offsets.x, offsets.y)
end

function player:updateHeading(mouseX, mouseY)
local xDiff = mouseX - self.x
    local yDiff = mouseY - self.y
    local heading = math.atan(yDiff / xDiff)

    if xDiff < 0 then
        local radiansToAdd = math.rad(90)
        if yDiff < 0 and heading > 0 then
            heading = (radiansToAdd * -1) - (radiansToAdd - heading)
        elseif yDiff > 0 and heading < 0 then
            heading = (radiansToAdd + (radiansToAdd + heading))
        end
    end

    self.heading = heading
end

function player:update(dt)
    self.animation:update(dt)
    if self.flying then
        self:movePlayer(dt)
        local mouseX = love.mouse.getX()
        local mouseY = love.mouse.getY()
        self:updateHeading(mouseX, mouseY)
        self:decayY(dt)
        self:checkForGround()
        if love.mouse.isDown(1) then
            player:boostTowardsMouse(mouseX, mouseY, dt)
        end
    end
end

function player:checkForGround()
    if self.y > 550 then
        self.y = 550
        self:stopPlayer()
    end
end

function player:decayY(dt)
    if self.velY < 1000 then
        self.velY = self.velY - (dt * 500)
    elseif self.velY > 1000 then
        self.velY = 1000
    end
end

function player:onGround()
    return self:animationIs(idleAnimation)
end

function player:animationIs(animation)
    return (self.animation == animation)
end

function player:stopPlayer()
    self.velX = 0
    self.velY = 0
    self.flying = false
    self.standing = true
    self.heading = 0
    self:setIdleAnimation()
    print('standing mode')
end

function player:movePlayer(dt)
    self.x = self.x + self.velX * dt
    self.y = (self.y - self.velY * dt)
end

function player:initialJump(mouseX, mouseY)
    self.velY = -5*(self.y - mouseY)
    self.velX = -5*(mouseX - self.x)
    self.flying = true
    print(self.velY)
    print(self.velX)
end

function player:mouseReleased(mouseX, mouseY, button)
    if button == 1 then
        if self.slingshot then
            print('flying mode')
            self:initialJump(mouseX, mouseY)
            self.slingshot = false
            self.flying = true
            self:transitionToFlying()
        end
    end
end

function player:mousePressed(mouseX, mouseY, button)
    if button == 1 then
        if self.standing then
            if self:pointIntersectsPlayer(mouseX, mouseY) then
                print('slingshot mode')
                self.standing = false
                self.slingshot = true
                self:regenerateCrouchAnimation()
            end
        end
    end
end

function player:getHitBoxSides()
    local negativeX = self.x - frameSize.x
    local positiveX = self.x + frameSize.x
    local negativeY = self.y - frameSize.y
    local positiveY = self.y + frameSize.y

    return negativeX, positiveX, negativeY, positiveY
end

function player:pointIntersectsPlayer(x, y)
    local negativeX, positiveX, negativeY, positiveY = self:getHitBoxSides()
    return (x > negativeX and x < positiveX) and (y > negativeY and y < positiveY)
end

function player:boostTowardsMouse(mouseX, mouseY, dt)
    self.velX = self.velX + math.cos(self.heading) * self.acceleration * dt
    self.velY = self.velY - math.sin(self.heading) * self.acceleration * dt
end

return player
