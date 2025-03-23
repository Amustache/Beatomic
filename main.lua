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
local moonshine = require "includes.moonshine"

atomic = require "atomic"
periodic = require "periodic"

function love.load()
    love.mouse.setCursor(cursors.point)

    -- Shaders
    effect = moonshine(moonshine.effects.chromasep)
                  .chain(moonshine.effects.crt)
                  .chain(moonshine.effects.scanlines)
      effect.crt.distortionFactor = {1.02, 1.02}
      effect.scanlines.opacity = 0.3

    if game_state == "main" then
        game_state = periodic
        game_state.load()
    else
        game_state = periodic
        game_state.load()
    end
end

function love.update(dt)
    if game_state == "main" then
        --
    else
        game_state.update(dt)
    end
end

function love.draw()
    effect(function()
        love.graphics.setBackgroundColor(colours.bg())

        if game_state == "main" then
            --
        else
            game_state.draw()
        end
    end)
end

function love.keypressed(key)
    if game_state == "main" then
        --
    else
        if game_state.keypressed then
            game_state.keypressed(key)
        end
    end
end

function love.keyreleased(key)
    if game_state == "main" then
        --
    else
        if game_state.keyreleased then
            game_state.keyreleased(key)
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if game_state == "main" then
        --
    else
        if game_state.mousepressed then
            game_state.mousepressed(x, y, button, istouch, presses)
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if game_state == "main" then
        --
    else
        if game_state.mousereleased then
            game_state.mousereleased(x, y, button, istouch, presses)
        end
    end
end
