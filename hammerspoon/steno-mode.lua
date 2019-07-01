-- use this file as a reference to implement steno mode for typing!

-- F18 toggles IM between Japanese <-> Roman
do
  local eisu = hs.hotkey.new({}, "f18", function ()
      hs.eventtap.keyStroke({}, "eisu", 0)
  end)
  local kana = hs.hotkey.new({}, "f18", function ()
      hs.eventtap.keyStroke({}, "kana", 0)
  end)

  knu.keyboard.onChange(function ()
      knu.keyboard.showCurrentInputMode()
      if knu.keyboard.isJapaneseMode() then
        kana:disable()
        eisu:enable()
      else
        kana:enable()
        eisu:disable()
      end
  end)
end
