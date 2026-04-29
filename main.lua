buttos = require 'buttos'; 
buttos.setSound("clicked.wav")
buttos.setPush(3)
_G.getOS = love.system.getOS()

local function mainConf(d)
  if d.getOS == "Android" then
    love.window.setFullscreen(true)
  end
  love.window.setTitle("Buttos example on "..d.getOS)
  screenx,screeny = love.graphics.getDimensions()
end

--//
local bucket = {index=1}
bucket[1] = function()
  local w,h = 120,50
  local x,y = (screenx-w)/2,(screeny-h)/2
  local btn = buttos.Button("Click Me!",x,y,w,h)
    
  return btn
end
bucket[2] = function() local b = false
  local w,h = 200,50
  local x,y = (screenx-w)/2,(screeny-h)/2
    
  buttos.SetBox(x,y,2,1,w,h,function(content)
    
    content("I'm a Label!", 1,1, {label=true})
    if content("Continue", 2,1) then
      b = true
    end
  end)
  return b
end

bucket[3] = function() local b = false
  local w,h = 200,100
  local x,y = (screenx-w)/2,(screeny-h)/2
  buttos.SetBox(x,y,3,3,w,h,function(content)
    content("I can streech like this",{{1,1}, {1,3}},0,{label=true})
    content("Hi", {{2,1},{3,1}},0,{label=true})
    if content("Click me:)", {{2,2}, {3,3}},0) then
      bucket.index = 1
    end
  end)
end

function love.load()
  mainConf(_G)
end

function love.update(dt)
  local click = bucket[bucket.index]()
  
  if click then
    bucket.index = bucket.index + 1
  end
end

function love.draw()
  buttos.draw()
end

function love.touchpressed(...)
  buttos.pressed(...)
end

function love.touchmoved(...)
  buttos.moved(...)
end

function love.touchreleased(...)
  buttos.released(...)
end