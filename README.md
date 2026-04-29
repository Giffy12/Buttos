## BUTTOS, A SIMPLE BUTTON LIBRARY FOR LÖVE ANDROID

Buttos is a simple and quick library to create a Buttons / Label in android development using LOVE2D Game Framework.

## Quick Start:
```lua
local buttos = require 'path-to-buttos'

function love.load()
Text = "Not clicked"
end

function love.update(dt)
  if buttos.Button("Hello World!",0,0,120,50) then
    text = "Clicked!"
  end
end

function love.draw()
buttos.draw()
love.graphics.print(text,120,50*2)
end

function love.touchpressed(id,x,y) buttos.pressed(id,x,y) end

function love.touchmoved(id,x,y) buttos.moved(id,x,y) snd

function love.touchreleased(id,x,y) buttos.released(id,x,y) end

```

## DOCUMENTATION

### MAIN
> Button (str,x,y,w,h):
- x = set the x value
- y = set the y value
- w = set the width value
- h = set the height value

- Return: true

> setBox (x,y,row,column,w,h,func):
- x = set the x value
- y = set the y value
- row = set the row of ui value
- column = set the column of ui value
- w = set the box width value
- h = set the box height value
- func = the button code in this function

- return = None
Example code (see main.lua)

```lua
function box()
  local screenx,screeny = love.graphics.getDimensions()
  local w,h = 200,50
  local x,y = (screenx-w)/2,(screeny-h)/2
    
  buttos.SetBox(x,y,2,1,w,h,function(content)
    content("I'm a Label!", 1,1, {label=true})
    if content("Continue", 2,1) then
      error("Im clicked!")
    end
  end)
end
```

### SET
- setPush (int): Set how much y button will go when the button is pressed.
- setPad (int): Set padding value for box buttons.
- setSound (string): Path to a sounds when button is clicked.
- setVolume (int): Set a global volume for button sound effect.
