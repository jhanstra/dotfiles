hs.loadSpoon("Emojis")

spoon.Emojis:bindHotkeys({
  toggle = {{"cmd", "ctrl", "alt"}, "o"}
})
-- figure out how to trigger it with this chord instead
-- guard(knu.chord.bind({}, {"z", "x", "c"}, inputEmoji))
