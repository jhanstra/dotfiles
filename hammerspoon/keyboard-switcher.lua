-- Switch between Karabiner-Elements profiles by keyboard

function switchKarabinerElementsProfile(name)
  hs.execute(knu.utils.shelljoin(
      "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli",
      "--select-profile",
      name
  ))
end

knu.usb.onChange(function (device)
  local name = device.productName
  print(name)
  if device.eventType == "added" then
    if name == "Planck" then
      switchKarabinerElementsProfile("KB68")
    elseif name == "KB68" then
      switchKarabinerElementsProfile("KB68")
    else
      switchKarabinerElementsProfile("Apple Keyboards")
    end
  end
  if device.eventType == "removed" then
    if name == "Planck" or name == "KB68" then
      switchKarabinerElementsProfile("Apple Keyboards")
    end
  end
end)