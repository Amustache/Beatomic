---
--- Created by stache.
--- DateTime: 22.03.25 18:46
---
-- Imports
local elements = require "elements"
local colours = require "colours"
local fonts = require "fonts"
local cursors = require "cursors"

-- Parameters
local ELEMENT = elements[11] -- debug
local w_w = love.graphics.getWidth()
local w_h = love.graphics.getHeight()

-- Atom
local radius_nucleus = 50
local radius_shell = 75
local radius_shell_extra = 40
local radius_electron = 15

-- UI/UX
local cursor_state = "point" -- point, open, closed
local nucleus_center_x = w_w / 2 / 2
local nucleus_center_y = (w_h / 3)
local infos_center_x = w_w / 2 / 2
local infos_center_y = (2 * w_h / 3)
local menu_origin_x = w_w / 2
local menu_origin_y = 0

-- Objets
local shells = {}
local samples = {}
local active_sample = nil
local buttons = {}
local active_button = nil

function calculate_electron_x_y(shell_level, num_electrons, cur_electron)
    local r = radius_shell + shell_level * radius_shell_extra
    local sep = 360 / num_electrons
    local ang = math.rad(((cur_electron - 1) * sep) % 360)
    local x = r * math.sin(ang)
    local y = r * math.cos(ang)
    return nucleus_center_x + x, math.random() + nucleus_center_y + y
end

function love.load()
    love.mouse.setCursor(cursors.point)

    -- Electrons
    for shell_level, num_electrons in ipairs(ELEMENT.shells) do
        local current_shell = {}
        for current_electron = 1, num_electrons do
            local x, y = calculate_electron_x_y(shell_level, num_electrons, current_electron)
            local electron = {
                x = x,
                y = y,
                instrument = nil,
            }
            table.insert(current_shell, electron)
        end
        table.insert(shells, current_shell)
    end

    -- Samples
    local sample_folders = love.filesystem.getDirectoryItems("samples")
    for i = 1, #sample_folders do
        local category_name = sample_folders[i]
        local sample_files = love.filesystem.getDirectoryItems("samples" .. "/" .. category_name)
        local current_category = {}
        for j = 1, #sample_files do
            local current_sample = {
                name = string.sub(sample_files[j], 1, -5),
                sound = love.audio.newSource("samples/" .. category_name .. "/" .. sample_files[j], "static"),
            }
            table.insert(current_category, current_sample)
            -- current_sample.sound:play()  -- It's really funny but don't do that lol
        end
        samples[category_name] = current_category
    end

    -- Buttons
    -- For each sample, a button
    for category_name, current_category in pairs(samples) do
        for i, current_sample in ipairs(current_category) do
            local button = {
                category = category_name,
                text = current_sample.name,
                sample = current_sample,
                x = 100,
                y = 100,
                w = 100,
                h = 50,
                dragging = {
                    active = false,
                    diff_x = 0,
                    diff_y = 0,
                },
            }
            table.insert(buttons, button)
        end
    end
end

function mouse_in_area(obj)
    local mouse_x, mouse_y = love.mouse.getPosition();
    return obj.x < mouse_x and mouse_x < obj.x + obj.w and obj.y < mouse_y and mouse_y < obj.y + obj.h
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for i = 1, #buttons do
            if mouse_in_area(buttons[i]) then
                -- Set current button
                active_button = buttons[i]

                -- Drag button
                active_button.dragging.active = true
                active_button.dragging.diff_x = x - active_button.x
                active_button.dragging.diff_y = y - active_button.y

                active_button.sample.sound:play()
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        if active_button then
            active_button.dragging.active = false
            active_button.sample.sound:stop()
            active_button = nil
        end
    end
end

function love.update(dt)
    if active_button and active_button.dragging.active then
        love.mouse.setCursor(cursors.closed)
        active_button.x = love.mouse.getX() - active_button.dragging.diff_x
        active_button.y = love.mouse.getY() - active_button.dragging.diff_y
    else
        love.mouse.setCursor(cursors.point)
        for i = 1, #buttons do
            if mouse_in_area(buttons[i]) then
                love.mouse.setCursor(cursors.open)
                break  -- No need to check everything
            end
        end
    end
end

function draw_button(button)
    love.graphics.setFont(fonts.regular)
    local text_width = fonts.regular:getWidth(button.text)
    local text_height = fonts.regular:getHeight()

    -- Shadow
    love.graphics.setColor(colours.black())
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h, 10, 10)

    -- Actual button
    love.graphics.setColor(colours.nucleus())
    local x = button.x
    local y = button.y
    if not button.dragging.active then
        x = button.x - 5
        y = button.y - 5
    end
    love.graphics.rectangle("fill", x, y, button.w, button.h, 10, 10)
    love.graphics.setColor(colours.black())
    love.graphics.rectangle("line", x, y, button.w, button.h, 10, 10)

    -- Text
    love.graphics.setColor(colours.black())
    love.graphics.print(button.text, x, y)
end

function love.draw()
    love.graphics.setBackgroundColor(colours.bg())

    for i = 1, #buttons do
        draw_button(buttons[i])
    end
end
