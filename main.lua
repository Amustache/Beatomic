---
--- Created by stache.
--- DateTime: 22.03.25 18:46
---
-- Imports
local cron = require "cron"
local elements = require "elements"
local colours = require "colours"
local fonts = require "fonts"
local cursors = require "cursors"
local utilities = require "utilities"

-- Parameters
local bpm = 60

-- Atom
local radius_nucleus = 50
local radius_shell = 75
local radius_shell_extra = 40
local radius_electron = 15

-- UI/UX
local nucleus_center_x = w_w / 2 / 2
local nucleus_center_y = (w_h / 3)
local infos_center_x = w_w / 2 / 2
local infos_center_y = (2 * w_h / 3)
local menu_origin_x = w_w / 2
local menu_origin_y = 0

-- Objets
local shells = {}
local samples = {}
local buttons = {}
local labels = {}
local timers = {}
local shell_counts = {}

-- Variables
local time_elapsed = 0
local active_sample = nil
local active_button = nil
local current_beat = 0

ELEMENT = elements[math.random(#elements)]

function calculate_electron_x_y(shell_level, num_electrons, cur_electron)
    local r = radius_shell + shell_level * radius_shell_extra
    local sep = 360 / num_electrons
    local ang_deg = ((cur_electron - 1) * sep) % 360
    local ang = -math.rad(ang_deg)
    local x = r * math.sin(ang)
    local y = r * math.cos(ang)
    return nucleus_center_x + x, nucleus_center_y + y, ang_deg
end

function love.init()
    love.mouse.setCursor(cursors.point)

    -- Electrons
    for shell_level, num_electrons in ipairs(ELEMENT.shells) do
        local current_shell = {}
        for current_electron = 1, num_electrons do
            local x, y, ang = calculate_electron_x_y(shell_level, num_electrons, current_electron)
            local electron = {
                x = x,
                y = y,
                beat = ang / 360,
                instrument = nil,
            }
            table.insert(current_shell, electron)
        end
        table.insert(shells, current_shell)
        -- Create a time per shell
        local timer = cron.every(1 / (bpm / 60) / num_electrons, function() update_beat_sound(shell_level) end)
        table.insert(timers, timer)
        table.insert(shell_counts, 1)
    end

    -- Debug
    local timer = cron.every(1 / (bpm / 60), function() update_beat_sound(-1) end)
    table.insert(timers, timer)

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
    tone = love.audio.newSource("sfx/tone 6.wav", "static")

    -- Labels & Buttons
    -- For each sample, a button
    local cat_i = 0
    for category_name, current_category in pairs(samples) do
        local label = {
            text = category_name,
            x = menu_origin_x + 25,
            y = menu_origin_y + 25 + (2 * cat_i * 75),
            w = 100,
            h = 50,
        }
        table.insert(labels, label)
        for i, current_sample in ipairs(current_category) do
            local button = {
                category = category_name,
                text = current_sample.name,
                sample = current_sample,
                x_og = menu_origin_x + 150 + ((i - 1) % 5) * 75,
                y_og = menu_origin_y + 25 + (2 * cat_i * 75) + (math.floor((i - 1) / 5) * 75),
                x = menu_origin_x + 150 + ((i - 1) % 5) * 75,
                y = menu_origin_y + 25 + (2 * cat_i * 75) + (math.floor((i - 1) / 5) * 75),
                w = 50,
                h = 50,
                dragging = {
                    active = false,
                    diff_x = 0,
                    diff_y = 0,
                },
            }
            table.insert(buttons, button)
        end
        cat_i = cat_i + 1
    end
end

function button_on_electron(button, el)
    local x = el.x - radius_electron
    local y = el.y - radius_electron
    local w = 2 * radius_electron
    local h = 2 * radius_electron
    return button.x < x and x + w < button.x + button.w and button.y < y and y + h < button.y + button.y
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
            for shell, els in ipairs(shells) do
                for i, el in ipairs(els) do
                    if button_on_electron(active_button, el) then
                        el.instrument = active_button.sample
                    end
                end
            end

            active_button.dragging.active = false
            active_button.x = active_button.x_og
            active_button.y = active_button.y_og
            -- active_button.sample.sound:stop()
            active_button = nil
        end
    end
end

function update_beat_sound(shell_level)
    if shell_level == -1 then
        tone:play()
    else
        local cur_el = shells[shell_level][shell_counts[shell_level]]
        if cur_el.instrument then
            cur_el.instrument.sound:stop()
            cur_el.instrument.sound:play()
        end
        --shells[shell_level][shell_counts[shell_level]].sound
        shell_counts[shell_level] = 1 + (shell_counts[shell_level] % #shells[shell_level])
    end
end

function update_beat_visual()
    current_beat = current_beat + 1
end

--local timer_sound = cron.every(1 / (bpm / 60), update_beat_sound)
local timer_visual = cron.every(1 / (bpm / 60) / 360, update_beat_visual)

function love.update(dt)
    --timer_sound:update(dt)
    for i = 1, #timers do
        timers[i]:update(dt)
    end
    timer_visual:update(dt)

    if active_button and active_button.dragging.active then
        love.mouse.setCursor(cursors.closed)
        active_button.x = love.mouse.getX() - active_button.dragging.diff_x
        active_button.y = love.mouse.getY() - active_button.dragging.diff_y
    else
        love.mouse.setCursor(cursors.point)
        for i = 1, #buttons do
            if mouse_in_area(buttons[i]) then
                love.mouse.setCursor(cursors.open)
                break -- No need to check everything
            end
        end
    end
end

function draw_beat()
    love.graphics.setColor(colours.beat_marker())
    local x, y = calculate_electron_x_y(#ELEMENT.shells, 360, current_beat)
    love.graphics.setLineWidth(10)
    love.graphics.line(nucleus_center_x, nucleus_center_y, x, y)
    love.graphics.setLineWidth(1)
    --love.graphics.rectangle("fill", nucleus_center_x, nucleus_center_y, x - nucleus_center_x, y - nucleus_center_y)
end

function draw_atom()
    love.graphics.setColor(colours.nucleus())
    love.graphics.circle("fill", nucleus_center_x, nucleus_center_y, radius_nucleus)

    for shell, els in ipairs(shells) do
        love.graphics.setColor(colours.black())
        love.graphics.circle("line", nucleus_center_x, nucleus_center_y, radius_shell + shell * radius_shell_extra)
        love.graphics.setColor(colours.shell[shell]())
        for i, el in ipairs(els) do
            love.graphics.circle("fill", el.x, el.y, radius_electron)
            if el.instrument then
                love.graphics.setColor(colours.black())
                love.graphics.setLineWidth(5)
                love.graphics.circle("line", el.x, el.y, radius_electron)
                love.graphics.setLineWidth(1)
                love.graphics.setColor(colours.shell[shell]())
            end
        end
    end

    love.graphics.setColor(colours.black())
    love.graphics.setFont(fonts.atom_symbol)
    local text_width = fonts.atom_symbol:getWidth(ELEMENT.symbol)
    local text_height = fonts.atom_symbol:getHeight()
    love.graphics.print(ELEMENT.symbol, nucleus_center_x - text_width / 2, nucleus_center_y - text_height / 2)
end

function draw_label(label)
    love.graphics.setFont(fonts.regular)
    local text_width = fonts.regular:getWidth(label.text)
    local text_height = fonts.regular:getHeight()

    love.graphics.setColor(colours.nucleus())
    love.graphics.rectangle("fill", label.x, label.y, label.w, label.h, 10, 10)
    love.graphics.setColor(colours.black())
    love.graphics.rectangle("line", label.x, label.y, label.w, label.h, 10, 10)

    -- Text
    love.graphics.setColor(colours.black())
    love.graphics.print(label.text, label.x, label.y)
end

function draw_infos()
    love.graphics.setFont(fonts.atom_info)
    love.graphics.setColor(colours.black())

    local text_width = fonts.atom_info:getWidth(ELEMENT.name)
    love.graphics.printf(ELEMENT.name, infos_center_x - text_width/2, infos_center_y, text_width, "center")

    local text_width = fonts.atom_info:getWidth(ELEMENT.conf_short)
    local text_height = fonts.atom_info:getHeight()
    love.graphics.printf(ELEMENT.conf_short, infos_center_x - text_width/2, infos_center_y + text_height, text_width, "center")
end

function love.draw()
    love.graphics.setBackgroundColor(colours.bg())

    -- Debug
    if true then
        love.graphics.setColor(colours.black())
        love.graphics.line(w_w / 2, 0, w_w / 2, w_h)
        love.graphics.line(0, 2 * w_h / 3, w_w / 2, 2 * w_h / 3)
    end

    draw_beat()

    draw_atom()

    draw_infos()

    for i = 1, #labels do
        draw_label(labels[i])
    end

    for i = 1, #buttons do
        draw_button(buttons[i])
    end
end
