hs.alert.show('Config loaded')

-- Reload
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'R', function()
    hs.reload()
end)

local function keyStroke(mod, key)
    return function() hs.eventtap.keyStroke(mod, key, 1000) end
end

local function keyStrokes(text)
    return function() hs.eventtap.keyStrokes(text) end
end

local function remap(mod, key, stroke)
    hs.hotkey.bind(mod, key, stroke, nil, stroke)
end

local caps = 'F20'

-- shortcuts
remap({'cmd'}, 'Y', keyStroke({'cmd', 'shift'}, 'Z'))

-- caps lock
remap({}, caps, keyStrokes('_'))
remap({'shift'}, caps, keyStrokes('->'))