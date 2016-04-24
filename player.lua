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

-- idle image, grid, and animation
local idleImage = love.graphics.newImage('assets/idle.png')
local idleGrid = anim8.newGrid(frameSize.x, frameSize.y, idleImage:getWidth(), idleImage:getHeight(), 0, 0, 1)
local idleAnimation = anim8.newAnimation(idleGrid('1-7', '1-8','1-4', 9), (1 / 60))

local player = {
    x = offsets.x,
    y = 529,
    animation = idleAnimation,
    image = idleImage,
    heading = 0,
    velX = 1,
    velY = 1,
    acceleration = 750,
}

function player:getStartingPosition()
    return self:getStartingX(), self:startingY()
end

function player.getStartingX()
    return starting.x
end

function player.getStartingY()
    return starting.y
end

function player:setIdleAnimation()
    self.animation = idleAnimation
end

function player:draw()
    self.animation:draw(self.image, self.x, self.y, self.heading, 1, 1, offsets.x, offsets.y)
end

function player:update(dt)
    self.animation:update(dt)
end

return player
