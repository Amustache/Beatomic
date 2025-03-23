---
--- Created by stache.
--- DateTime: 22.03.25 20:57
---
colours = { -- From https://lospec.com/palette-list/metro
    bg = function() return love.math.colorFromBytes(26, 26, 29) end,
    black = function() return love.math.colorFromBytes(237, 252, 255) end,
    nucleus = function() return love.math.colorFromBytes(0, 82, 68) end,
    shell = {
        function() return love.math.colorFromBytes(86, 20, 186) end,
        function() return love.math.colorFromBytes(13, 90, 223) end,
        function() return love.math.colorFromBytes(35, 191, 215) end,
    },
    beat_marker = function() return love.math.colorFromBytes(227, 154, 172) end,
}

return colours
