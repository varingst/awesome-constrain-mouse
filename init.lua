-- init -- {{{1
-- luacheck: globals mouse
local mouse = mouse
local root = client
local naughty = require('naughty')

local state = {
    client = nil,
    signals = {}
}

local function notify(msg, keep) -- {{{1
    local timeout = 5
    if keep then timeout = 0 end

    naughty.notify({ text = msg, timeout = timeout })
end

local function set_bounds() -- {{{1
    local c = state.client
    state.x_min = c.x + 2
    state.x_max = c.x + c.width - 3
    state.y_min = c.y + 2
    state.y_max = c.y + c.height - 3
end

local function reposition() -- {{{1
    local pos = mouse.coords()
    local new_pos = {}

    if pos.x > state.x_max then
        new_pos.x = state.x_max
    elseif pos.x < state.x_min then
        new_pos.x = state.x_min
    else
        new_pos.x = pos.x
    end

    if pos.y > state.y_max then
        new_pos.y = state.y_max
    elseif pos.y < state.y_min then
        new_pos.y = state.y_min
    else
        new_pos.y = pos.y
    end

    mouse.coords(new_pos, true)
end

local function connect(signal, func) -- {{{1
    state.client:connect_signal(signal, func)
    state.signals[signal] = func
end

local function disconnect() -- {{{1
    for signal, func in pairs(state.signals) do
        state.client:disconnect_signal(signal, func)
        state.signals[signal] = nil
    end
end

local function release() -- {{{1
    disconnect()

    root.disconnect_signal("mouse::move", reposition)

    notify("Mouse released")

    state.client = nil
end

local function constrain(c) -- {{{1
    state.client = c or mouse.current_client

    if state.client == nil then return end

    set_bounds()

    notify("Constrainging mouse to " .. state.client.name)

    root.connect_signal("mouse::move", reposition)

    connect("property::size", set_bounds)
    connect("property::position", set_bounds)
    connect("unmanage", release)
end

-- public interface -- {{{1
return {
    constrain = constrain,
    release = release,
    toggle = function()
        if state.client then
            release()
        else
            constrain()
        end
    end
}
