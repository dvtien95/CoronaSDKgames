-- Tien Dinh --

local physics = require "physics"
physics.start()

local composer = require( "composer" )
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local background1   local background2   local background3   local background4
local background5   local background6   local background7   local background8

local sandBar   local leftBar    local rightBar   local upBar   local pauseScreenBar

local upButton    local pauseButton   local restartButton
local resumeButton    local leftButton    local rightButton

local runSheetData    local myRunSheet    local runSequenceData

local smallObject     local smallImage    local smallRandom
local bigObject1       local bigObject2   local bigObject3    local bigObject4
local rectangleShape1   local rectangleShape2   local rectangleShape3   local rectangleShape4

local human   local pentagonShape
local isRestart = false
local isPause = false
local isHome = false

local collisionVar = false   local rethrowVar = false

local lives = 3       local livesText
local lives1Image     local lives2Image     local lives3Image
local score = 0       local scoreX = 0      local scoresText
local died = false

local mainMusicTrack
local rollingCanSound
local manGettingHitSound = audio.loadSound("manGettingHit.wav")
local femaleScreamSound = audio.loadSound("femaleScream.wav")
local jumpSound = audio.loadSound("jump.wav")
local runSound = audio.loadSound("runningOnSand.wav")

local function scrollBackground(self, event)
  if self then
    if self.x < -235 then
      self.x = 3592
    else
      self.x = self.x - self.speed
    end
  end
end

local function scrollBigObject(self, event)
  if self.x < -70 then
    if died == false then
      score = score + 1
      scoresText.text = "Scores: " .. score
    end

    if died == false then
        self.x = 2100
        if scoreX > 4 then
          self.speed = 1.95
        elseif scoreX > 8 then
          self.speed = 2
        elseif scoreX > 12 then
          self.speed = 2.05
        elseif scoreX > 16 then
          self.speed = 2.1
        elseif scoreX > 20 then
          self.speed = 2.15
        elseif scoreX > 24 then
          self.speed = 2.2
        end
    else
        scoreX = 0
        bigObject1.x = 1100
        bigObject2.x = 1650
        bigObject3.x = 2200
        bigObject4.x = 2750
        self.speed = 1.9
    end
  else
    self.x = self.x - self.speed
  end
end

local function setBackToRun()
  if (died == false) then
    if (human.isBodyActive == true and isPause == false) then
      human:setSequence("run")
      human:play()
    end
  end
end

local function moveUp(event)
  if (died == false and isRestart == false) then
    if (human.y > 190) then
      human:pause()
      if (human.isBodyActive == true) then
        human:setSequence("jump")
        human:play()
        local playJumpSound = audio.play(jumpSound)
        human:applyForce(0, -15 , human.x, human.y)
      end
      timer.performWithDelay(1300, setBackToRun)
    end
  elseif (died == true) then
    human:pause()
  end
end

local function moveRight(event)
  if (died == false and isRestart == false) then
    if (human.isBodyActive == true) then
      if (isPause == false) then
        human:setSequence("run")
        human:play()
      end
      local playRunSound = audio.play(runSound)
      human:applyForce(6.1, 0.5 , human.x - 5, human.y + 10)
    end
  elseif (died == true) then
    human:pause()
  end
end

local function moveLeft(event)
  if (died == false and isRestart == false) then
    if (human.isBodyActive == true) then
      if (isPause == false) then
        human:setSequence("run")
        human:play()
      end
      local playRunSound = audio.play(runSound)
      human:applyForce(-5.3, 0.5 , human.x + 5, human.y + 10)
    end
  elseif (died == true) then
    human:pause()
  end
end

local function restoreHuman()
  if (isRestart == false) then
    human.isBodyActive = false
    human.x = 100
    human.y = display.contentHeight/2
    human.rotation = 0

    -- Fade in the human
    transition.to( human, { alpha=1, time=2000,
      onComplete = function()
        human.isBodyActive = true
        if (isRestart == false and isHome == false) then
          human:applyForce(5, 0, human.x, human.y)
          upButton:addEventListener("tap", moveUp)
          leftButton:addEventListener("tap", moveLeft)
          rightButton:addEventListener("tap", moveRight)
          setBackToRun()
        end
        died = false
		end
    } )
  end
end

local function humanAlpha()
  human.alpha = 0
end

local function endGame()
  if isRestart == false then
    composer.removeScene("highScores")
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time = 800, effect = "flipFadeOutIn" } )
  end
end

local function gotoHome()
  isHome = true
  composer.gotoScene( "menu", { time = 800, effect = "flipFadeOutIn" } )
end

local function disableObject()
  if smallObject then
    smallObject.isBodyActive = false
  end
end

local function enableObject()
  if smallObject then
    smallObject.isBodyActive = true
  end
end

local function rethrowObject()
  local xForce = -1
  local yForce = math.random(1, 5) - 3
  
  smallObject.alpha = 1
  enableObject()
  if (smallObject and lives > 0 and isPause == false and isRestart == false and smallObject.isBodyActive == true and rethrowVar == true and collisionVar == true and died == false and isHome == false) then
-- Dong duoi co the sai, gg lul
    if (smallObject) then
      smallObject:applyForce(xForce, yForce, smallObject.x, smallObject.y)
    else
      smallObject:removeSelf()
    end
    rethrowVar = false
    collisionVar = false
  end
end

local function resetObject()
  local randomPos = math.random(1, 5)
  
  if randomPos == 1 then  xPos = 485  yPos = -10
  elseif randomPos == 2 then  xPos = 250  yPos = -10
  elseif randomPos == 3 then  xPos = 485  yPos = 150
  elseif randomPos == 4 then  xPos = 360  yPos = -10
  else  xPos = 485  yPos = 100  end

  smallObject.alpha = 0
  disableObject()
  transition.to(smallObject, {x = xPos, y = yPos, time = 0} )

  if rethrowVar == false then
    rethrowVar = true
    timer.performWithDelay(8000, rethrowObject)
  end
end

local function onCollisionSmallObject( event )
  if (event.phase == "ended" and isRestart == false) then
    local obj1 = event.object1
		local obj2 = event.object2
  
		if ( ( obj1.myName == "human" and obj2.myName == "smallObject" ) or
				 ( obj1.myName == "smallObject" and obj2.myName == "human" ) )
		then
        rollingCanSound = audio.loadSound("rollingCan.wav")
        audio.play( rollingCanSound, { duration=3000, channel=2, loops=1 } )

        if human.isBodyActive == true then
          human:setSequence("hit")
          human:play()
        end
        
        if collisionVar == false then
          collisionVar = true
          smallImage = smallImageBep
          timer.performWithDelay(4000, resetObject)
        end
        
        timer.performWithDelay(1300, setBackToRun)
    end
  end
end

local function onCollisionBigObject( event )
  if (event.phase == "ended" and isRestart == false) then
    local obj1 = event.object1
		local obj2 = event.object2
  
		if ( ( obj1.myName == "human" and obj2.myName == "bigObject" ) or
				 ( obj1.myName == "bigObject" and obj2.myName == "human" ) )
		then
      local playManGettingHitSound = audio.play(manGettingHitSound)
      local playFemaleScreamSound = audio.play(femaleScreamSound)
      upButton:removeEventListener("tap", moveUp)
      leftButton:removeEventListener("tap", moveLeft)
      rightButton:removeEventListener("tap", moveRight)
      if ( died == false) then
        died = true
        
        -- Update lives
				lives = lives - 1
				if (lives == 2) then
          lives3Image:removeSelf()
        elseif (lives == 1) then
          lives2Image:removeSelf()
        else
          lives1Image:removeSelf()
        end
        
        human:setSequence("fall")
        human:play()
        
        if ( lives == 0 ) then
          timer.performWithDelay( 2000, humanAlpha )
          timer.performWithDelay( 2000, endGame )
        else
          timer.performWithDelay( 2000, humanAlpha )
          timer.performWithDelay( 2000, restoreHuman )
        end
      end
    end
    
    --if (
  end
end

local function pauseGame(event)
  if isPause == false then
    isPause = true
    
    pauseScreenBar.alpha = 0.4
    
    Runtime:removeEventListener("enterFrame", background1)
    Runtime:removeEventListener("enterFrame", background2)
    Runtime:removeEventListener("enterFrame", background3)
    Runtime:removeEventListener("enterFrame", background4)
    Runtime:removeEventListener("enterFrame", background5)
    Runtime:removeEventListener("enterFrame", background6)
    Runtime:removeEventListener("enterFrame", background7)
    Runtime:removeEventListener("enterFrame", background8)

    Runtime:removeEventListener("enterFrame", bigObject)
    
    upButton:removeEventListener("tap", moveUp)
    leftButton:removeEventListener("tap", moveLeft)
    rightButton:removeEventListener("tap", moveRight)
    
    Runtime:removeEventListener("enterFrame", bigObject1)
    Runtime:removeEventListener("enterFrame", bigObject2)
    Runtime:removeEventListener("enterFrame", bigObject3)
    Runtime:removeEventListener("enterFrame", bigObject4)
    
    Runtime:removeEventListener( "collision", onCollisionBigObject )
    Runtime:removeEventListener( "collision", onCollisionSmallObject )
    
    physics.pause()
    human:pause()
    
    audio.stop(1)
  end
end

local function resumeGame(event)
  if isPause == true then
    isPause = false
    physics.start()
    setBackToRun()
    
    Runtime:addEventListener("enterFrame", background1)
    Runtime:addEventListener("enterFrame", background2)
    Runtime:addEventListener("enterFrame", background3)
    Runtime:addEventListener("enterFrame", background4)
    Runtime:addEventListener("enterFrame", background5)
    Runtime:addEventListener("enterFrame", background6)
    Runtime:addEventListener("enterFrame", background7)
    Runtime:addEventListener("enterFrame", background8)
    
    upButton:addEventListener("tap", moveUp)
    leftButton:addEventListener("tap", moveLeft)
    rightButton:addEventListener("tap", moveRight)
    
    Runtime:addEventListener("enterFrame", bigObject1)
    Runtime:addEventListener("enterFrame", bigObject2)
    Runtime:addEventListener("enterFrame", bigObject3)
    Runtime:addEventListener("enterFrame", bigObject4)

    Runtime:addEventListener( "collision", onCollisionBigObject )
    Runtime:addEventListener( "collision", onCollisionSmallObject )
    
    pauseScreenBar.alpha = 0

    audio.play( musicTrack, { channel=1, loops=-1 } )
  end
end

local function restartGame(event)
    isRestart = true
  
    Runtime:removeEventListener("enterFrame", background1)
    Runtime:removeEventListener("enterFrame", background2)
    Runtime:removeEventListener("enterFrame", background3)
    Runtime:removeEventListener("enterFrame", background4)
    Runtime:removeEventListener("enterFrame", background5)
    Runtime:removeEventListener("enterFrame", background6)
    Runtime:removeEventListener("enterFrame", background7)
    Runtime:removeEventListener("enterFrame", background8)

    upButton:removeEventListener("tap", moveUp)
    leftButton:removeEventListener("tap", moveLeft)
    rightButton:removeEventListener("tap", moveRight)
    pauseButton:removeEventListener("tap", pauseGame)
    resumeButton:removeEventListener("tap", resumeGame)
    restartButton:removeEventListener("tap", restartGame)
    homeButton:removeEventListener("tap", gotoHome)
    
    Runtime:removeEventListener("enterFrame", bigObject1)
    Runtime:removeEventListener("enterFrame", bigObject2)
    Runtime:removeEventListener("enterFrame", bigObject3)
    Runtime:removeEventListener("enterFrame", bigObject4)
    
    Runtime:removeEventListener( "collision", onCollisionBigObject )
    Runtime:removeEventListener( "collision", onCollisionSmallObject )
    
    composer.gotoScene("tryagain")
end

local function onSystemEvent( event )
  if (event.tpye == "applicationSuspend" or event.type == "applicationExit") then
    pauseGame()
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  backGroup = display.newGroup()
  sceneGroup:insert(backGroup)
  
  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)
  
  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)
  
  background1 = display.newImageRect(backGroup, "beach1.jpg", 480, 360)
  background1.x = 240
  background1.y = 180
  background1.speed = 1

  background2 = display.newImageRect(backGroup, "beach1.jpg", 482, 360)
  background2.x = 718
  background2.y = 180
  background2.speed = 1

  background3 = display.newImageRect(backGroup, "beach2.jpg", 482, 490)
  background3.x = 1197
  background3.y = 125
  background3.speed = 1

  background4 = display.newImageRect(backGroup, "beach2.jpg", 482, 490)
  background4.x = 1676
  background4.y = 125
  background4.speed = 1

  background5 = display.newImageRect(backGroup, "desert1.jpg", 482, 432)
  background5.x = 2155
  background5.y = 174.5
  background5.speed = 1

  background6 = display.newImageRect(backGroup, "desert1.jpg", 482, 432)
  background6.x = 2634
  background6.y = 174.5
  background6.speed = 1

  background7 = display.newImageRect(backGroup, "desert2.jpg", 482, 380)
  background7.x = 3113
  background7.y = 172.6
  background7.speed = 1

  background8 = display.newImageRect(backGroup, "desert2.jpg", 482, 380)
  background8.x = 3592
  background8.y = 172.6
  background8.speed = 1

  background1.enterFrame = scrollBackground background2.enterFrame = scrollBackground
  background3.enterFrame = scrollBackground background4.enterFrame = scrollBackground
  background5.enterFrame = scrollBackground background6.enterFrame = scrollBackground
  background7.enterFrame = scrollBackground background8.enterFrame = scrollBackground
  
  sandBar = display.newImageRect(backGroup, "sandBeachBar.jpg", 520, 120)
  sandBar.x = 240
  sandBar.y = 305
  physics.addBody(sandBar, "static", {friction = 0})

  leftBar = display.newImageRect(backGroup, "sideBar.png", 10, 500)
  leftBar.x = -20
  leftBar.y = 180
  leftBar.alpha = 0.1
  physics.addBody(leftBar, "static", {friction = 1, bounce = 0.9} )

  rightBar = display.newImageRect(backGroup, "sideBar.png", 10, 500)
  rightBar.x = 500
  rightBar.y = 180
  rightBar.alpha = 0.1
  physics.addBody(rightBar, "static", {friction = 1, bounce = 0.9} )
  
  upBar = display.newImageRect(backGroup, "upBar.png", 520, 10)
  upBar.x = 240
  upBar.y = -50
  upBar.alpha = 0.1
  physics.addBody(upBar, "static", {friction = 1, bounce = 0.5} )
  
  pauseScreenBar = display.newImageRect(backGroup, "upBar.png", 480, 360)
  pauseScreenBar.x = 240
  pauseScreenBar.y = 180
  pauseScreenBar.alpha = 0
  
  upButton = display.newImageRect(uiGroup, "up.png", 41, 41)
  upButton.x = 38
  upButton.y = 284

  pauseButton = display.newImageRect(uiGroup, "pause.png", 40, 40)
  pauseButton.x = 150
  pauseButton.y = 288
  
  homeButton = display.newImageRect(uiGroup, "home.png", 40, 40)
  homeButton.x = 200
  homeButton.y = 288

  restartButton = display.newImageRect(uiGroup, "restart.png", 40, 40)
  restartButton.x = 250
  restartButton.y = 288

  resumeButton = display.newImageRect(uiGroup, "resume.png", 40, 40)
  resumeButton.x = 300
  resumeButton.y = 288

  leftButton = display.newImageRect(uiGroup, "left.png", 41, 41)
  leftButton.x = 382
  leftButton.y = 284

  rightButton = display.newImageRect(uiGroup, "right.png", 41, 41)
  rightButton.x = 442
  rightButton.y = 284
  
  homeButton:addEventListener("tap", gotoHome)
  upButton:addEventListener("tap", moveUp)
  leftButton:addEventListener("tap", moveLeft)
  rightButton:addEventListener("tap", moveRight)
  restartButton:addEventListener("tap", restartGame)
  pauseButton:addEventListener("tap", pauseGame)
  resumeButton:addEventListener("tap", resumeGame)
  
  -- Display lives and score
	livesText = display.newText( uiGroup, "Lives: " , 75, 70, native.systemFontBold, 16 )
  livesText:setFillColor(black)
  
  lives1Image = display.newImageRect( uiGroup, "heartIcon.png", 18, 18)
  lives1Image.x = 112
  lives1Image.y = 72
  
  lives2Image = display.newImageRect( uiGroup, "heartIcon.png", 18, 18)
  lives2Image.x = 132
  lives2Image.y = 72
  
  lives3Image = display.newImageRect( uiGroup, "heartIcon.png", 18, 18)
  lives3Image.x = 152
  lives3Image.y = 72

	scoresText = display.newText( uiGroup, "Score: " .. score, 395, 70, native.systemFontBold, 16 )
  scoresText:setFillColor(black)
  
  runSheetData = {
    width = 82,
    height = 120,
    numFrames = 18,
    sheetContentWidth = 1476,
    sheetContentHeight = 120
  }

  myRunSheet = graphics.newImageSheet ("movementSprite.png",runSheetData )

  runSequenceData = {
    { name = "run", start = 1, count = 6, time = 1000, loopCount = 0 },
    { name = "jump", frames = {7,8,9,10,11,12,1}, time = 1400, loopCount = 1 },
    { name = "fall", start = 13, count = 6, time = 1500, loopCount = 1 },
    { name = "hit", start = 13, count = 4, time = 600, loopCount = 1 }
  }

  human = display.newSprite(mainGroup, myRunSheet, runSequenceData)
  human.myName = "human"
  human.x = 80
  human.y = display.contentHeight/2 - 20
  human.rotation = 0
  pentagonShape = { 0,-55, 30,36, 30,45, -30,45, -30,36 }
  physics.addBody(human, "dynamic",{shape = pentagonShape,  density = 0})
  human:applyForce(5, 2, human.x, human.y)
  human:play()

  bigObject1 = display.newImageRect(mainGroup, "bikini1_clipped.png", 90, 85)
  bigObject1.x = 550
  bigObject1.y = 240
  bigObject1.myName = "bigObject"
  rectangleShape1 = { -5,-5 , 0,5 , 20,20 , -20,-20 }
  physics.addBody(bigObject1, "static", {shape = rectangleShape1, friction = 0.5, density = 0.2})
  bigObject1.speed = 1.9
  
  bigObject2 = display.newImageRect(mainGroup, "bikini2_clipped.png", 180, 80)
  bigObject2.x = 1100
  bigObject2.y = 230
  bigObject2.myName = "bigObject"
  rectangleShape2 = { -70,-15 , -10,-25 , 10,25 , -60,-25 }
  physics.addBody(bigObject2, "static", {shape = rectangleShape2, friction = 0.5, density = 0.2})
  bigObject2.speed = 1.9  
  
  bigObject3 = display.newImageRect(mainGroup, "bikini3_clipped.png", 180, 120)
  bigObject3.x = 1650
  bigObject3.y = 225
  bigObject3.myName = "bigObject"
  rectangleShape3 = { -60,13 , 50,13 , 60,50 , -50,50 }
  physics.addBody(bigObject3, "static", {shape = rectangleShape3, friction = 0.5, density = 0.2})
  bigObject3.speed = 1.9  
  
  bigObject4 = display.newImageRect(mainGroup, "bikini4_clipped.png", 130, 100)
  bigObject4.x = 2200
  bigObject4.y = 240
  bigObject4.myName = "bigObject"
  rectangleShape4 = { -12,-40 , 55,-18 , 55,30 , -35,-7 }
  physics.addBody(bigObject4, "static", {shape = rectangleShape4, friction = 0.5, density = 0.2})
  bigObject4.speed = 1.9  
  
  bigObject1.enterFrame = scrollBigObject
  bigObject2.enterFrame = scrollBigObject
  bigObject3.enterFrame = scrollBigObject
  bigObject4.enterFrame = scrollBigObject
  
  smallRandom = math.random(1,5)
  if (smallRandom == 1) then
    smallImage = "fanta.png"
  elseif (smallRandom == 2) then
    smallImage = "sprite.png"
  else
    smallImage = "coke.png"
  end
  smallObject = display.newImageRect(mainGroup, smallImage, 15, 15)
  physics.addBody(smallObject, "dynamic", {radius = 4, bounce = 0.7})
  smallObject.x = 485
  smallObject.y = 30
  smallObject.myName = "smallObject"
  if (smallObject.isBodyActive == true) then
    smallObject:applyForce(-1, 0, smallObject.x, smallObject.y)
  end
  
  musicTrack = audio.loadStream("I_Wear_Speedos-Mikey-DESPACITO_PARODY-Luis_Fonsi_ft.Daddy_Yankee.mp3" )
  
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
    
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    Runtime:addEventListener("enterFrame", background1)
    Runtime:addEventListener("enterFrame", background2)
    Runtime:addEventListener("enterFrame", background3)
    Runtime:addEventListener("enterFrame", background4)
    Runtime:addEventListener("enterFrame", background5)
    Runtime:addEventListener("enterFrame", background6)
    Runtime:addEventListener("enterFrame", background7)
    Runtime:addEventListener("enterFrame", background8)

    Runtime:addEventListener("enterFrame", bigObject1)
    Runtime:addEventListener("enterFrame", bigObject2)
    Runtime:addEventListener("enterFrame", bigObject3)
    Runtime:addEventListener("enterFrame", bigObject4)
    
    Runtime:addEventListener( "system", onSystemEvent )
    Runtime:addEventListener( "collision", onCollisionBigObject )
    Runtime:addEventListener( "collision", onCollisionSmallObject )
    
    audio.play( musicTrack, { channel=1, loops=-1 } )

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
    Runtime:removeEventListener("enterFrame", background1)
    Runtime:removeEventListener("enterFrame", background2)
    Runtime:removeEventListener("enterFrame", background3)
    Runtime:removeEventListener("enterFrame", background4)
    Runtime:removeEventListener("enterFrame", background5)
    Runtime:removeEventListener("enterFrame", background6)
    Runtime:removeEventListener("enterFrame", background7)
    Runtime:removeEventListener("enterFrame", background8)

    Runtime:removeEventListener("enterFrame", bigObject1)
    Runtime:removeEventListener("enterFrame", bigObject2)
    Runtime:removeEventListener("enterFrame", bigObject3)
    Runtime:removeEventListener("enterFrame", bigObject4)
    
    upButton:removeEventListener("tap", moveUp)
    leftButton:removeEventListener("tap", moveLeft)
    rightButton:removeEventListener("tap", moveRight)
    pauseButton:removeEventListener("tap", pauseGame)
    resumeButton:removeEventListener("tap", resumeGame)
    restartButton:removeEventListener("tap", restartGame)
    homeButton:removeEventListener("tap", gotoHome)
    
    Runtime:removeEventListener( "system", onSystemEvent )
    Runtime:removeEventListener( "collision", onCollisionBigObject )
    Runtime:removeEventListener( "collision", onCollisionSmallObject )
    
    physics.pause()
    composer.removeScene("game")
    
    audio.stop(1)

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  audio.dispose(mainMusicTrack)
  audio.dispose(rollingCanSound)
  audio.dispose(manGettingHitSound)
  audio.dispose(femaleScreamSound)
  audio.dispose(jumpSound)
  audio.dispose(runSound)
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
return scene
