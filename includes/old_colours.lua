---
--- Created by stache.
--- DateTime: 22.03.25 20:57
---
colours = { -- From https://lospec.com/palette-list/fairydust-8
    bg = function() return love.math.colorFromBytes(242, 251, 235) end,
    black = function() return love.math.colorFromBytes(23, 18, 25) end,
    nucleus = function() return love.math.colorFromBytes(240, 246, 232) end,
    shell = {
        function() return love.math.colorFromBytes(147, 212, 181) end,
        function() return love.math.colorFromBytes(43, 169, 180) end,
        function() return love.math.colorFromBytes(100, 97, 194) end,
    },
    beat_marker = function() return love.math.colorFromBytes(227, 154, 172) end,
}

return colours
