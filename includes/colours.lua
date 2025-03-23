---
--- Created by stache.
--- DateTime: 22.03.25 20:57
---
local function clamp01(x)
	return math.min(math.max(x, 0), 1)
end

function colorFromBytes(r, g, b, a)
	if type(r) == "table" then
		r, g, b, a = r[1], r[2], r[3], r[4]
	end
	r = clamp01(math.floor(r + 0.5) / 255)
	g = clamp01(math.floor(g + 0.5) / 255)
	b = clamp01(math.floor(b + 0.5) / 255)
	a = a ~= nil and clamp01(math.floor(a + 0.5) / 255) or nil
	return r, g, b, a
end

colours = { -- From https://lospec.com/palette-list/metro
    bg = function() return colorFromBytes(26, 26, 29) end,
    black = function() return colorFromBytes(237, 252, 255) end,
    nucleus = function() return colorFromBytes(0, 82, 68) end,
    shell = {
        function() return colorFromBytes(86, 20, 186) end,
        function() return colorFromBytes(13, 90, 223) end,
        function() return colorFromBytes(35, 191, 215) end,
    },
    beat_marker = function() return colorFromBytes(227, 154, 172) end,
}

return colours
