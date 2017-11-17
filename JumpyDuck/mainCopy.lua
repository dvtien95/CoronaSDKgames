-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--
local physics = require "physics"
physics.start()

local imageRotation = 0
local image1 = "grassland.png"
local image2 = "city.png"
local image3 = "desert.png"
local image4 = "cave.png"

local background1 = display.newImage(image1) background1.x=240  background1.y=160 background1.speed=1
local background2 = display.newImage(image1) background2.x=720  background2.y=160 background2.speed=1
local background3 = display.newImage(image1) background3.x=1200  background3.y=160 background3.speed=1
local background4 = display.newImage(image1) background4.x=1680  background4.y=160 background4.speed=1

local background5 = display.newImage(image2) background5.x=2160  background5.y=160 background5.speed=1
local background6 = display.newImage(image2) background6.x=2640  background6.y=160 background6.speed=1
local background7 = display.newImage(image2) background7.x=3120  background7.y=160 background7.speed=1
local background8 = display.newImage(image2) background8.x=3600  background8.y=160 background8.speed=1

local background9=display.newImage(image3) background9.x=4080 background9.y=160 background9.speed=1
local background10=display.newImage(image3) background10.x=4560 background10.y=160 background10.speed=1
local background11=display.newImage(image3) background11.x=5040 background11.y=160 background11.speed=1
local background12=display.newImage(image3) background12.x=5520 background12.y=160 background12.speed=1

local background13=display.newImage(image4) background13.x=6000 background13.y=160 background13.speed=1
local background14=display.newImage(image4) background14.x=6480 background14.y=160 background14.speed=1
local background15=display.newImage(image4) background15.x=6960 background15.y=160 background15.speed=1
local background16=display.newImage(image4) background16.x=7440 background16.y=160 background16.speed=1

local function scrollBackground(self, event)
  if self.x < -235 then
    self.x = 7440
  else
    self.x = self.x - self.speed
  end
end

background1.enterFrame = scrollBackground background2.enterFrame = scrollBackground
background3.enterFrame = scrollBackground background4.enterFrame = scrollBackground
background5.enterFrame = scrollBackground background6.enterFrame = scrollBackground
background7.enterFrame = scrollBackground background8.enterFrame = scrollBackground
background9.enterFrame = scrollBackground background10.enterFrame = scrollBackground
background11.enterFrame = scrollBackground background12.enterFrame = scrollBackground
background13.enterFrame = scrollBackground background14.enterFrame = scrollBackground
background15.enterFrame = scrollBackground background16.enterFrame = scrollBackground

Runtime:addEventListener("enterFrame", background1) Runtime:addEventListener("enterFrame", background2)
Runtime:addEventListener("enterFrame", background3) Runtime:addEventListener("enterFrame", background4)
Runtime:addEventListener("enterFrame", background5) Runtime:addEventListener("enterFrame", background6)
Runtime:addEventListener("enterFrame", background7) Runtime:addEventListener("enterFrame", background8)
Runtime:addEventListener("enterFrame", background9) Runtime:addEventListener("enterFrame", background10)
Runtime:addEventListener("enterFrame", background11) Runtime:addEventListener("enterFrame",background12)
Runtime:addEventListener("enterFrame", background13) Runtime:addEventListener("enterFrame",background14)
Runtime:addEventListener("enterFrame", background15) Runtime:addEventListener("enterFrame",background16)

local duck = display.newImage("duck.png")
duck.x = 60
duck.y = 250
physics.addBody( duck, "dynamic", { radius = 16, bounce = 0.15 } )

local treeCount = 0
local myText = display.newText( treeCount, 240, 50, native.systemFont, 16 )
myText:setFillColor( 1,0,0 )

local tree1 = display.newImage("tree1.png") tree1.x = 480 tree1.y = 275 tree1.speed = 2.4
physics.addBody( tree1, "static", {density = 1, radius = 20})
local tree2 = display.newImage("tree2.png") tree2.x = 960 tree2.y = 275 tree2.speed = 2.4
physics.addBody( tree2, "static", {density = 1, radius = 20})
local tree3 = display.newImage("tree3.png") tree3.x = 1440 tree3.y = 275  tree3.speed = 2.4
physics.addBody( tree3, "static", {density = 1, radius = 20})

local function scrollTree(self, event)
  if self.x < -20 then
    if duck.x > -20 and duck.x < 490 then
      treeCount = treeCount + 1
    end
    myText.text = treeCount
    self.x = 1440
  else
    self.x = self.x - self.speed
  end
end

tree1.enterFrame = scrollTree Runtime:addEventListener("enterFrame", tree1)
tree2.enterFrame = scrollTree Runtime:addEventListener("enterFrame", tree2)
tree3.enterFrame = scrollTree Runtime:addEventListener("enterFrame", tree3)

grassBar = display.newImage("grassBar.png")
grassBar.x = 240
grassBar.y = 310
physics.addBody( grassBar, "static")

local sound = audio.loadStream("duckQuack.wav")

local function duckJump(event)
  if event.phase == "ended" then
    if duck.y > 240 then
      duck:applyForce(0,-3, duck.x, duck.y)
      local playSound = audio.play (sound)
    end
  end
end

Runtime:addEventListener("touch", duckJump)