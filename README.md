## BUTTOS, A SIMPLE BUTTON LIBRARY FOR LÖVE ANDROID

Buttos is a simple and quick library to create a Buttons / Label in android development using LOVE2D Game Framework.

======================================
Quick Start:

local buttos = require 'path-to-buttos'

function love.load()
Text = "Not clicked"
end

function love.update(dt)
if buttos.Button("Hello World!", 0,0,120,50) then
  text = "Clicked!"
end
end

function love.draw()
buttos.draw()
love.graphics.print(text,120,50*2)
end

function love.touchpressed(id,x,y) buttos.pressed(i,x,y) end

function love.touchmoved(id,x,y) buttos.moved(id,x,y) snd

function love.touchreleased(id,x,y) buttos.released(id,x,y) end
