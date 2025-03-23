---
--- Created by stache.
--- DateTime: 23.03.25 07:24
---
local periodic = {}

-- Objects
local buttons = {}

-- Variables
local active_button = nil

-- "Map"
local map = {
    { "",      "I",     "II", "[...]", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII" },
    { "I",     1,       "",   "",      "",     "",    "",   "",    "",     2 },
    { "II",    3,       4,    "...",   5,      6,     7,    8,     9,      10 },
    { "III",   11,      12,   "...",   13,     14,    15,   16,    17,     18 },
    { "[...]", "[...]", "",   "[...]", "",     "",    "",   "",    "",     "[...]" },
}

function periodic.load()
    print("scene periodic loaded")

    for i = 1, #map do
        for j = 1, #map[i] do
            local x_o = 25
            local y_o = 25
            local rec_w = 90
            local rec_h = 110
            local x = x_o + (j - 1) * rec_w
            local y = y_o + (i - 1) * rec_h
            local number = tonumber(map[i][j])
            if number then
                atom = elements[number]
                text = elements[number].symbol
            else
                atom = nil
                text = map[i][j]
            end
            local button = {
                atom = atom,
                text = text,
                x = x,
                y = y,
                w = rec_w,
                h = rec_h,
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

function periodic.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for i = 1, #buttons do
            if mouse_in_area(buttons[i]) and buttons[i].atom then
                -- Click button
                active_button = buttons[i]
                active_button.dragging.active = true
                break -- No need to loop anymore
            end
        end
    end
end

function periodic.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        if active_button then
            active_button.dragging.active = false
            active_button = nil
        end
    end
end

function periodic.update(dt)
end

function periodic.draw()
    local x_o = 25
    local y_o = 25
    local rec_w = 90
    local rec_h = 110

    love.graphics.setFont(fonts.regular)
    love.graphics.setColor(colours.black())
    for i = 1, #buttons do
        local button = buttons[i]
        if button.atom then
            -- love.graphics.rectangle("line", button.x, button.y, button.w, button.h)
            draw_button(button)
        else
            local text_width = fonts.atom_info:getWidth(button.text)
            local text_height = fonts.atom_info:getHeight()
            love.graphics.printf(button.text, button.x, button.y + button.h / 2 - text_height / 2, 100, "center")
        end
    end
end

return periodic
