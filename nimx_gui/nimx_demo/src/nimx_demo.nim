import nimx/window
import nimx/text_field
import osproc
import re
import strutils
from sequtils import filter
from sugar import `=>`
import strformat
import os

type
  Display = object
    name: string
    gamma: string
    brightness: float
    description: string

proc getBrightness(display: Display) : float =
  let (res, rc) = execCmdEx("xrandr --current --verbose")
  let resLines = res.split('\n')
  var i = 0

  var line = resLines[0]
  while not line.contains(display.name) and i < len(resLines):
    i += 1
    line = resLines[i]

  while not line.contains("Brightness:") and i < len(resLines):
    i += 1
    line = resLines[i]

  if line.contains("Brightness"):
    let brightness = line.split(" ")
    return parseFloat(brightness[^1])

  return 0.0

proc getGamma(display: Display) : string =
  let (res, rc) = execCmdEx("xrandr --current --verbose")
  let resLines = res.split('\n')
  var i = 0

  var line = resLines[0]
  while not line.contains(display.name) and i < len(resLines):
    i += 1
    line = resLines[i]

  while not line.contains("Gamma:") and i < len(resLines):
    i += 1
    line = resLines[i]

  if line.contains("Gamma"):
    let gamma = line.split(" ")
    return gamma[^1]

  return "1:1:1"

proc setBrightness(display: Display, brightness: float) =
  let cmd = fmt"xrandr --output {display.name} --gamma {display.gamma} --brightness {brightness}"
  echo cmd
  let (res, rc) = execCmdEx(cmd)

proc getDisplays() : seq[Display] =
  let (res, rc) = execCmdEx("xrandr")
  let connected = res.split('\n').filter(line => line.contains(re" connected"))

  var
    display: Display
    gamma: string
    brightness: float

  for line in connected:
    let connectLine = line.split(" connected ")
    echo connectLine
    if connectLine.len() == 2:
      display = Display(
                  name: connectLine[0],
                  gamma: "1:1:1",
                  brightness: 1.0,
                  description: connectLine[1]
                )
      gamma = display.getGamma()
      brightness = display.getBrightness()
      display.gamma = gamma
      display.brightness = brightness
      result.add(display)


proc startApp() =
    # First create a window. Window is the root of view hierarchy.
    var wnd = newWindow(newRect(40, 40, 800, 600))

    # Create a static text field and add it to view hierarchy
    let label = newLabel(newRect(20, 20, 150, 20))
    label.text = "Hello, world!"
    wnd.addSubview(label)


when isMainModule:
    let displays = getDisplays()
    echo "Displays found: ", len(displays)
    var brightness = 0.50
    for display in displays:
      echo display
      brightness = display.getBrightness()
      sleep 1000
      display.setBrightness(0.75)
      sleep 1000
      display.setBrightness(brightness)
      sleep 1000

    # Run the app
    # runApplication:
        # startApp()
