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
    cursor_state = "idle" -- idle, clickable, clicked
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

    menu_origin_x = w_w / 2
    menu_origin_y = 0

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
        cur_samples = love.filesystem.getDirectoryItems("samples/" .. category_name)
        local category = {}
        for j = 1, #cur_samples do
            local sample = {
                name = string.sub(cur_samples[j], 1, -5),
                sound = love.audio.newSource("samples/" .. category_name .. "/" .. cur_samples[j], "static"),
            }
            table.insert(category, sample)
            -- sample.sound:play()  -- It's really funny but don't do that lol
        end
        samples[category_name] = category
    end

    -- Create buttons
    buttons = {}
    for category_name, category_samples in pairs(samples) do
        local button = {
            x = 100,
            y = 100,
            text = category_name,
            dragging = {active = false, diff_x = 0, diff_y = 0}
        }
        button.w = 1.5 * fonts.regular:getWidth(category_name)
        button.h = 1.5 * fonts.regular:getHeight()
        table.insert(buttons, button)
    end
end

function mouse_can_click(x, y, w, h)
    local mouse_x, mouse_y = love.mouse.getPosition();
    return x < mouse_x and mouse_x < x + w and y < mouse_y  and mouse_y < y + h
end

-- MAIN LOOP
dt_tot = 0
function love.update(dt)
    dt_tot = dt_tot + dt

    cursor_state = "idle"
    for i = 1, #buttons do
        local button = buttons[i]
        if mouse_can_click(button.x, button.y, button.x + button.w, button.y + button.h) then
            cursor_state = "clickable"
        end
    end

    if cursor_state == "idle" then -- idle, clickable, clicked
        love.mouse.setCursor(cursors.point)
    elseif cursor_state == "clickable" then
        love.mouse.setCursor(cursors.open)
    else
        love.mouse.setCursor(cursors.closed)
    end

    --    print(dt_tot)
    --    for shell, els in ipairs(electrons) do
    --        for i, el in ipairs(els) do
    --            local x, y = calculate_electron_x_y(shell, #els, i, dt_tot)
    --            el.x = x
    --            el.y = y
    --        end
    --    end
end

function love.mousepressed(x, y, button)
    if button == "1" and
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

function draw_button(x, y, text, clicked)
    love.graphics.setFont(fonts.regular)
    local text_width = fonts.regular:getWidth(text)
    local text_height = fonts.regular:getHeight()

    love.graphics.setColor(colours.black())
    love.graphics.rectangle("fill", x - 5, y + 5, 1.5 * text_width, 1.5 * text_height, 10, 10)
    love.graphics.setColor(colours.nucleus())
    if clicked then
        love.graphics.rectangle("fill", x - 5, y + 5, 1.5 * text_width, 1.5 * text_height, 10, 10)
        love.graphics.setColor(colours.black())
        love.graphics.rectangle("line", x - 5, y + 5, 1.5 * text_width, 1.5 * text_height, 10, 10)
        love.graphics.print(text, x - 5, y + 5)
    else
        love.graphics.rectangle("fill", x - 5, y, 1.5 * text_width, 1.5 * text_height, 10, 10)
        love.graphics.setColor(colours.black())
        love.graphics.rectangle("line", x - 5, y, 1.5 * text_width, 1.5 * text_height, 10, 10)
        love.graphics.print(text, x - 5, y)
    end
end

function draw_samples()
    for category_name, category in pairs(samples) do
        love.graphics.print(category_name, 100, 100)
    end
end

-- DRAWING LOOP
function love.draw()
    love.graphics.setBackgroundColor(colours.bg())

    -- Debug
    if true then
        love.graphics.setColor(colours.black())
        love.graphics.line(w_w / 2, 0, w_w / 2, w_h)
        love.graphics.line(0, 2 * w_h / 3, w_w / 2, 2 * w_h / 3)
    end

    draw_atom()

    draw_infos()

    draw_samples()

    local button = buttons[1]
    draw_button(button.x, button.y, "test", button.dragging.active)
    --love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
end

-- END
function love.quit()
    --TODO
end
