---
--- Created by stache.
--- DateTime: 22.03.25 17:22
---
-- IMPORTS
local elements = require "elements"
local colours = require "colours"
local fonts = require "fonts"
local cursors = require "cursors"

function calculate_electron_x_y(shell_level, num_electrons, cur_electron, step)
    local step = step or 0
    local r = radius_shell + shell_level * radius_shell_extra
    local sep = 360 / num_electrons
    local ang = math.rad(((cur_electron - 1) * sep) % 360)
    local x = r * math.sin(ang)
    local y = r * math.cos(ang)
    return nucleus_center_x + x, math.random() + nucleus_center_y + y
end

-- INIT
function love.load()
    love.mouse.setCursor(cursors.point)

    w_w = love.graphics.getWidth()
    w_h = love.graphics.getHeight()

    radius_nucleus = 50
    radius_shell = 75
    radius_shell_extra = 40
    radius_electron = 15

    nucleus_center_x = w_w / 2 / 2
    nucleus_center_y = (w_h / 3)

    text_center_x = w_w / 2 / 2
    text_center_y = (2 * w_h / 3)

    -- SAMPLE
    cur_element = elements[11]

    -- Create electron shells
    electrons = {}
    for shell_level, num_electrons in ipairs(cur_element.shells) do
        local shell = {}
        for cur_electron = 1, num_electrons do
            local x, y = calculate_electron_x_y(shell_level, num_electrons, cur_electron, 0)
            local electron = {
                    x = x,
                    y = y,
                    instrument = nil
                }
            table.insert(shell, electron)
        end
        table.insert(electrons, shell)
    end

    -- Get samples
    samples = {}
    sample_files = love.filesystem.getDirectoryItems("samples")
    for i = 1, #sample_files do
        local category_name = sample_files[i]
        cur_samples = love.filesystem.getDirectoryItems("samples/"..category_name)
        local category = {}
        for j = 1, #cur_samples do
            local sample = {
                name = string.sub(cur_samples[j], 1, -5),
                sound = love.audio.newSource("samples/"..category_name.."/"..cur_samples[j], "static"),
            }
            table.insert(category, sample)
            -- sample.sound:play()  -- It's really funny but don't do that lol
        end
        table[category_name] = category
    end
end

-- MAIN LOOP
dt_tot = 0
function love.update(dt)
    dt_tot = dt_tot + dt
--    print(dt_tot)
--    for shell, els in ipairs(electrons) do
--        for i, el in ipairs(els) do
--            local x, y = calculate_electron_x_y(shell, #els, i, dt_tot)
--            el.x = x
--            el.y = y
--        end
--    end
end

function draw_atom()
    love.graphics.setColor(colours.nucleus())
    love.graphics.circle("fill", nucleus_center_x, nucleus_center_y, radius_nucleus)
    for shell, els in ipairs(electrons) do
        love.graphics.setColor(colours.black())
        love.graphics.circle("line", nucleus_center_x, nucleus_center_y, radius_shell + shell * radius_shell_extra)
        love.graphics.setColor(colours.shell[shell]())
        for i, el in ipairs(els) do
            love.graphics.circle("fill", el.x, el.y, radius_electron)
        end
    end

    love.graphics.setColor(colours.black())
    love.graphics.setFont(fonts.atom_symbol)
    local text_width = fonts.atom_symbol:getWidth(cur_element.symbol)
    local text_height = fonts.atom_symbol:getHeight()
    love.graphics.print(cur_element.symbol, nucleus_center_x - text_width / 2, nucleus_center_y - text_height / 2)
end

function draw_infos() -- Need fixing...
    love.graphics.setColor(colours.black())
    love.graphics.setFont(fonts.atom_info)
    local text_width = fonts.atom_info:getWidth(cur_element.name)
    local text_height = fonts.atom_info:getHeight()
    love.graphics.print(cur_element.name, text_center_x - text_width / 2, text_center_y - text_height / 2)
    love.graphics.print(cur_element.conf_short, text_center_x - text_width / 2, text_center_y + text_height / 2)
end

-- DRAWING LOOP
function love.draw()
    love.graphics.setBackgroundColor(colours.bg())

    draw_atom()

    draw_infos()

    -- Debug
    if true then
        love.graphics.setColor(colours.black())
        love.graphics.line(w_w / 2, 0, w_w / 2, w_h)
        love.graphics.line(0, 2 * w_h / 3, w_w / 2, 2 * w_h / 3)
    end
end

-- END
function love.quit()
  --TODO
end
