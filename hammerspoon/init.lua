local log = hs.logger.new('init.lua', 'debug')
knu = require('knu')
guard = knu.runtime.guard
knu.runtime.autorestart(true)
-- Use Control+` to reload Hammerspoon config
hs.hotkey.bind({'ctrl'}, '`', nil, function()
  hs.reload()
end)

keyUpDown = function(modifiers, key)
  -- Un-comment & reload config to log each keystroke that we're triggering
  -- log.d('Sending keystroke:', hs.inspect(modifiers), key)

  hs.eventtap.keyStroke(modifiers, key, 0)
end

-- Subscribe to the necessary events on the given window filter such that the
-- given hotkey is enabled for windows that match the window filter and disabled
-- for windows that don't match the window filter.
--
-- windowFilter - An hs.window.filter object describing the windows for which
--                the hotkey should be enabled.
-- hotkey       - The hs.hotkey object to enable/disable.
--
-- Returns nothing.
enableHotkeyForWindowsMatchingFilter = function(windowFilter, hotkey)
  windowFilter:subscribe(hs.window.filter.windowFocused, function()
    hotkey:enable()
  end)

  windowFilter:subscribe(hs.window.filter.windowUnfocused, function()
    hotkey:disable()
  end)
end


-- these all came from Jason's keyboard package but I'm not sure I need them
-- require('keyboard.control-escape')
-- require('keyboard.delete-words')
-- require('keyboard.hyper')
-- require('keyboard.markdown')
-- require('keyboard.microphone')
-- require('keyboard.panes')
require('super')
require('keyboard-switcher')
-- require('input-emoji')
-- require('keyboard.windows')
hs.loadSpoon("Emojis")

spoon.Emojis:bindHotkeys({
  toggle = {{"leftshift", "rightshift"}, "e" }
})
hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()