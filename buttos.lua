local bts = {queue={},conf={
  Push=2,
  Pad=3,
  Sound=nil, Volume = .4,
  license = {
    AUTHOR = "GIFFYCAT",
    VERSIONS = "1.0",
    LICENSE = [[
    MIT License

Copyright (c) [2026] [GIFFYCAT]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
    ]]
    }
}} local btnTemp = {}

local schache = nil
local function sounds(t)
  if not schache then
  schache = love.audio.newSource(bts.conf.Sound, "static")
  end
  local s = schache:clone()
  if t then
    s:setPitch(t or 1)
  end
  s:setVolume(bts.conf.Volume)
  s:play()
end

local function touchBox(x,y,box)
  return x >= box.x and x <= box.x + box.w
  and
  y >= box.y and y <= box.y + box.h
end

local function getFont(str)
  local f = love.graphics.getFont()
  local fw,fh = f:getWidth(str),f:getHeight(str)
  return fw,fh
end

local function update() local dt = love.timer.getDelta()
  for k in pairs(bts.queue) do local btn = bts.queue[k]
    if btn.hover then
      btn.cancelTime = btn.cancelTime + dt * 1
    else
      btn.cancelTime = 0
    end
  end
end

local activeID = nil
function bts.pressed(id,x,y)
  if activeID == nil then activeID = id
  local flag = false; local muted = false
  for k in pairs(bts.queue) do local btn = bts.queue[k]
    
    if touchBox(x,y,btn) and not btn.label then
      btn.hover = true
      btn.ypush = bts.conf.Push
      flag = true
      btn.isHold = true
    end
  end
--  if flag then sounds() end
  end
end

function bts.moved(id,x,y)
  if activeID ~= id then return end
  for k in pairs(bts.queue) do local btn = bts.queue[k]
    
    if not touchBox(x,y,btn) and not btn.label then
      btn.hover = false
      btn.ypush = 0
      btn.cancelTime = 0
      btn.isHold = false
    end
  end
end

function bts.released(id,x,y)
  if activeID ~= id then return end
  for k in pairs(bts.queue) do local btn = bts.queue[k]
    
    if touchBox(x,y,btn) and btn.hover then
      if btn.cancelTime <= .3 then
        btn.clicked = true
      end
      btn.hover = false
      btn.cancelTime = 0
      btn.ypush = 0
      btn.isHold = false
    end
  end
  activeID = nil
end

function bts.draw()
  if btnTemp.draw then btnTemp.draw() end
  update()
  for kqueue in pairs(bts.queue) do
    for k,kv in pairs(bts.queue[kqueue]) do
      if k == "draw" then
        kv()
      end
    end
  end
end

function bts.Button(str,x,y,w,h,t)
  t = t or {}
  t.bgColor = t.bgColor or {1,1,1,1}
  t.textColor = t.textColor or {0,0,0,1}
  t.round = t.round or 3; if type(t.round) == "string" and t.round:lower() == "circle" then t.round = w+h end
  t.label = t.label or false
  local B = {
      x = x,
      y = y, ypush=0,
      w = w, 
      h = h,
      --
      isHold = false,
      cancelTime = 0,
      label = t.label,
      clicked = false,
      bgColor = t.bgColor,
      textColor = t.textColor,
      round = t.round
    }
    B.draw = function()
      local self = B
      local fw,fh = getFont(str)
      local fontsx,fontsy = self.w/fw,self.h/fh
      local fs = math.min(fontsx,fontsy) * .7
      
      love.graphics.setColor(t.bgColor)
      love.graphics.rectangle("fill",self.x,self.y+bts.conf.Push,self.w,self.h,self.round)
      love.graphics.setColor(0,0,0,.2)
      love.graphics.rectangle("fill",self.x,self.y+bts.conf.Push,self.w,self.h,self.round)
      
      love.graphics.push()
      love.graphics.translate(self.x,self.y+self.ypush)
      
      love.graphics.setColor(t.bgColor)
      love.graphics.rectangle("fill",0,0,self.w,self.h,self.round)
      if B.isHold then
        love.graphics.setColor(0,0,0,.1)
        love.graphics.rectangle("fill",0,0,self.w,self.h,self.round)
      end
      love.graphics.setColor(t.textColor)
      love.graphics.print(str,(self.w-fw*fs)/2,(self.h-fh*fs)/2,0,fs,fs)
      love.graphics.setColor(1,1,1,1)
      love.graphics.pop()
    end
  
  if not bts.queue[str] then
    bts.queue[str] = B
    btnTemp = {}
  end
  
  
  if bts.queue[str].clicked then
    if not bts.queue[str].label then
    bts.queue[str].clicked = false
      sounds()
    end
    btnTemp = B
    bts.queue = {}
    return true
  else return false
  end
end

function bts.SetBox(x,y,a,b,w,h,fun)
  bts.queue[fun] = {
    x = x, y = y,
    w = w, h = h,
    draw = function()
      love.graphics.rectangle('line',x,y,w,h)
    end
  }
  local row,col = a,b
  local padding = bts.conf.Pad
  local cellw = (w-padding*(col+1))/col
  local cellh = (h-padding*(row+1))/row
  
  
  local function GetCell(a,b)
    if type(a) == "number" then
      local cx = (b-1)*(cellw+padding)
      local cy = (a-1)*(cellh+padding)
      local px = x+padding+cx
      local py = y+padding+cy
      return px,py,cellw,cellh
    elseif type(a) == "table" then
      local minr,maxr = math.huge,-math.huge
      local minc,maxc = math.huge,-math.huge
      
      for _, v in ipairs(a) do
        minr = math.min(minr,v[1])
        maxr = math.max(maxr,v[1])
        minc = math.min(minc,v[2])
        maxc = math.max(maxc,v[2])
      end
      local c = maxc-minc+1
      local r = maxr-minr+1
      local totalw = c*cellw+(c-1)*padding
      local totalh = r*cellh+(r-1)*padding
      local px,py = GetCell(minr,minc)
      return px,py,totalw,totalh
    end
  end
  
  local function Buttons(str,a,b,t)
    local x,y,w,h = GetCell(a,b)
    return bts.Button(str,x,y,w,h,t)
  end
  fun(Buttons)
end

-- Function

-- Params, Function
-- @Push: Integer => How much button move to down when pressed
-- @Pad: Integer => Padding value, this is a global padding variable
-- @Sound: String => Used to sounds path to be used
--++ @Volume: Integer => Volume value for sounds


function bts.setPush(int)
  bts.conf["Push"] = int
end

function bts.setPad(int)
  bts.conf["Pad"] = int
end

function bts.setSound(str)
  bts.conf["Sound"] = str
end

function bts.setVolume(int)
  bts.conf['Volume'] = int
end

function bts.set(t)
  for k in pairs(bts.conf) do
    bts.conf[k] = t[k]
  end
end

return bts