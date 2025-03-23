---
--- Created by stache.
--- DateTime: 23.03.25 07:12
---
-- Includes
local colours = require "includes.colours"
local cursors = require "includes.cursors"
local elements = require "includes.elements"
local fonts = require "includes.fonts"
local utilities = require "includes.utilities"

-- State machine, kind of
game_state = "main"

local atomic = require "atomic"
local periodic = require "periodic"

-- GLobal variables (ew)
current_element = elements[math.random(#elements)]  -- nil
math.randomseed(os.time())

function love.load()
    game_state = periodic
    game_state.load()
end

function love.update(dt)
    game_state.update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(colours.bg())

    game_state.draw()
end

function love.keypressed(key)
    if game_state.keypressed then
        game_state.keypressed(key)
    end
end

function love.keyreleased(key)
    if game_state.keyreleased then
        game_state.keyreleased(key)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if game_state.mousepressed then
        game_state.mousepressed(x, y, button, istouch, presses)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if game_state.mousereleased then
        game_state.mousereleased(x, y, button, istouch, presses)
    end
end
