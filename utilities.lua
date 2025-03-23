---
--- Created by stache.
--- DateTime: 23.03.25 06:22
---
-- Parameters
math.randomseed(os.time())
w_w = love.graphics.getWidth()
w_h = love.graphics.getHeight()

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

function mouse_in_area(obj)
    local mouse_x, mouse_y = love.mouse.getPosition()
    return obj.x < mouse_x and mouse_x < obj.x + obj.w and obj.y < mouse_y and mouse_y < obj.y + obj.h
end
