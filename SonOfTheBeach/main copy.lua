-- Tien Dinh --

local physics = require "physics"
physics.start()

-- Seed the random number generator
math.randomseed( os.time() )

local lives = 3
local died = false

local function scrollBackground(self, event)
  if self.x < -235 then
    self.x = 3592
  else
    self.x = self.x - self.speed
  end
end

local function scrollPoop(self, event)
  if self.x < -10 then
    if died == false then
      self.speed = math.random(2, 5)
      self.x = 490
    else
      self.speed = 2
      self.x = 900
    end
  else
    self.x = self.x - self.speed
  end
end

local background1 = display.newImageRect("beach1.jpg", 480, 360)
background1.x = 240
background1.y = 180
background1.speed = 1

local background2 = display.newImageRect("beach1.jpg", 480, 360)
background2.x = 718
background2.y = 180
background2.speed = 1

local background3 = display.newImageRect("beach2.jpg", 480, 490)
background3.x = 1197
background3.y = 125
background3.speed = 1

local background4 = display.newImageRect("beach2.jpg", 480, 490)
background4.x = 1676
background4.y = 125
background4.speed = 1

local background5 = display.newImageRect("desert1.jpg", 480, 432)
background5.x = 2155
background5.y = 174.5
background5.speed = 1

local background6 = display.newImageRect("desert1.jpg", 480, 432)
background6.x = 2634
background6.y = 174.5
background6.speed = 1

local background7 = display.newImageRect("desert2.jpg", 480, 380)
background7.x = 3113
background7.y = 172.6
background7.speed = 1

local background8 = display.newImageRect("desert2.jpg", 480, 380)
background8.x = 3592
background8.y = 172.6
background8.speed = 1

background1.enterFrame = scrollBackground background2.enterFrame = scrollBackground
background3.enterFrame = scrollBackground background4.enterFrame = scrollBackground
background5.enterFrame = scrollBackground background6.enterFrame = scrollBackground
background7.enterFrame = scrollBackground background8.enterFrame = scrollBackground

local sandBar = display.newImageRect("sandBeachBar.jpg", 490, 120)
sandBar.x = 240
sandBar.y = 305
physics.addBody(sandBar, "static", {friction = 1})

local leftBar = display.newImageRect("sideBar.png", 10, 600)
leftBar.x = -8
leftBar.y = 180
leftBar.alpha = 0.6
physics.addBody(leftBar, "static", {friction = 1, bounce = 0.7} )

local rightBar = display.newImageRect("sideBar.png", 10, 600)
rightBar.x = 488
rightBar.y = 180
rightBar.alpha = 0.6
physics.addBody(rightBar, "static", {friction = 1, bounce = 0.7} )

local upButton = display.newImageRect("up.png", 40, 40)
upButton.x = 33
upButton.y = 290

local pauseButton = display.newImageRect("pause.png", 40, 40)
pauseButton.x = 180
pauseButton.y = 290

local restartButton = display.newImageRect("restart.png", 40, 40)
restartButton.x = 240
restartButton.y = 290

local resumeButton = display.newImageRect("resume.png", 40, 40)
resumeButton.x = 300
resumeButton.y = 290

local leftButton = display.newImageRect("left.png", 40, 40)
leftButton.x = 390
leftButton.y = 290

local rightButton = display.newImageRect("right.png", 40, 40)
rightButton.x = 450
rightButton.y = 290


local runSheetData = {
  width = 82,
  height = 120,
  numFrames = 18,
  sheetContentWidth = 1476,
  sheetContentHeight = 120
}

local myRunSheet = graphics.newImageSheet ("movementSprite.png",runSheetData )

local runSequenceData = {
  { name = "run", start = 1, count = 6, time = 1000, loopCount = 0 },
  { name = "jump", frames = {7,8,9,10,11,12,1}, time = 1600, loopCount = 1 },
  { name = "fall", start = 13, count = 6, time = 1500, loopCount = 1 }
}

local human = display.newSprite(myRunSheet, runSequenceData)
human.myName = "human"
human.x = 100
human.y = display.contentHeight/2 - 10
human.rotation = 0

local pentagonShape = { 0,-63, 25,36, 25,45, -25,45, -25,36 }
physics.addBody(human, "dynamic",{shape = pentagonShape,  density = 0})
human:applyForce(2, 0, human.x, human.y)
human:play()

local poop1 = display.newImageRect("poop1.png", 25, 25)
poop1.x = 490
poop1.y = 236
poop1.myName = "poop"
physics.addBody(poop1, "static", {radius = 6, friction = 0.5})
poop1.speed = 2
poop1.enterFrame = scrollPoop

local function moveUp(event)
  if (human.y > 180 and died == false) then
    human:setSequence("jump")
    human:play()
    human:applyForce(0, -15 , human.x, human.y)
  elseif (human.y > 180 and died == true) then
    human:pause()
  end
end

local function moveRight(event)
  if (died == false) then
    human:setSequence("run")
    human:play()
    human:applyForce(7, 0 , human.x, human.y)
  elseif (human.y > 180 and died == true) then
    human:pause()
  end
end

local function moveLeft(event)
  if (died == false) then
    human:setSequence("run")
    human:play()
    human:applyForce(-7, 0 , human.x, human.y)
  elseif (human.y > 180 and died == true) then
    human:pause()
  end
end

local function restoreHuman()
  human.isBodyActive = false
  human:setSequence("run")
  human.x = 100
  human.y = display.contentHeight/2
  human.rotation = 0


	-- Fade in the human
	transition.to( human, { alpha=1, time=2000,
		onComplete = function()
			human.isBodyActive = true
      human:applyForce(3, 0, human.x, human.y)
      upButton:addEventListener("tap", moveUp)
      leftButton:addEventListener("tap", moveLeft)
      rightButton:addEventListener("tap", moveRight)
      human:play()
			died = false
		end
	} )
end

local function humanAlpha()
  human.alpha = 0
end

local function onCollision( event )
  if (event.phase == "ended") then
    local obj1 = event.object1
		local obj2 = event.object2
  
		if ( ( obj1.myName == "human" and obj2.myName == "poop" ) or
				 ( obj1.myName == "poop" and obj2.myName == "human" ) )
		then
      if ( died == false) then
        died = true
        human:setSequence("fall")
        human:play()
        
        upButton:removeEventListener("tap", moveUp)
        leftButton:removeEventListener("tap", moveLeft)
        rightButton:removeEventListener("tap", moveRight)
        
        lives = lives - 1
        
        timer.performWithDelay( 2000, humanAlpha )
        timer.performWithDelay( 2000, restoreHuman )
      end
    end
  end
end

Runtime:addEventListener("enterFrame", background1)
Runtime:addEventListener("enterFrame", background2)
Runtime:addEventListener("enterFrame", background3)
Runtime:addEventListener("enterFrame", background4)
Runtime:addEventListener("enterFrame", background5)
Runtime:addEventListener("enterFrame", background6)
Runtime:addEventListener("enterFrame", background7)
Runtime:addEventListener("enterFrame", background8)

Runtime:addEventListener("enterFrame", poop1)

upButton:addEventListener("tap", moveUp)
leftButton:addEventListener("tap", moveLeft)
rightButton:addEventListener("tap", moveRight)
--restartButton:addEventListener("tap", restart)
--pauseButton:addEventListener("tap", pause)
--resumeButton:addEventListener("tap", resume)

Runtime:addEventListener( "collision", onCollision )
