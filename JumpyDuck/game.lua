-- Tien Dinh --

local composer = require( "composer" )

local scene = composer.newScene()

local physics = require "physics"
physics.start()

local duck
local lives = 1
local treeCount = 0
local grassBar

local tree1
local tree2
local tree3

local myText
local image1
local image2
local image3
local image4

local background1   local background2   local background3   local background4
local background5   local background6   local background7   local background8
local background9   local background10   local background11   local background12
local background13   local background14   local background15   local background16

local musicTrack
local deadSound
local quackSound

local pauseButton
local isPause = true

local backGroup
local mainGroup
local uiGroup

quackSound = audio.loadStream("duckQuack.wav")

local function scrollBackground(self, event)
  if self.x < -235 then
    self.x = 7440
  else
    self.x = self.x - self.speed
  end
end

local function endGame()
  local playSound = audio.play (deadSound)
	composer.setVariable( "finalScore", treeCount )
  composer.removeScene("highScores")
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

local function scrollTree(self, event)
  if self.x < -20 then
    if duck.x > -20 and duck.x < 490 then
      treeCount = treeCount + 1
    else
      lives = 0
    end
    if lives == 0 then
      endGame()
    end
    myText.text = treeCount
    self.x = 1440
  else
    self.x = self.x - self.speed
  end
end

local function duckJump(event)
  if event.phase == "ended" then
    if duck.y > 240 then
      duck:applyForce(0,-3, duck.x, duck.y)
      local playSound = audio.play (quackSound)
    end
  end
end

local function pauseGame(event)
  --print(isPause)
  if isPause == true then
    isPause = false
    physics.pause()
    Runtime:removeEventListener("enterFrame", background1) Runtime:removeEventListener("enterFrame", background2)
    Runtime:removeEventListener("enterFrame", background3) Runtime:removeEventListener("enterFrame", background4)
    Runtime:removeEventListener("enterFrame", background5) Runtime:removeEventListener("enterFrame", background6)
    Runtime:removeEventListener("enterFrame", background7) Runtime:removeEventListener("enterFrame", background8)
    Runtime:removeEventListener("enterFrame", background9) Runtime:removeEventListener("enterFrame", background10)
    Runtime:removeEventListener("enterFrame",background11) Runtime:removeEventListener("enterFrame",background12)
    Runtime:removeEventListener("enterFrame",background13) Runtime:removeEventListener("enterFrame",background14)
    Runtime:removeEventListener("enterFrame",background15) Runtime:removeEventListener("enterFrame",background16)
        
    Runtime:removeEventListener("enterFrame", tree1)
    Runtime:removeEventListener("enterFrame", tree2)
    Runtime:removeEventListener("enterFrame", tree3)
    Runtime:removeEventListener("touch", duckJump)
    
    audio.stop(1)
  else
    isPause = true
    physics.start()
    Runtime:addEventListener("enterFrame", background1) Runtime:addEventListener("enterFrame", background2)
    Runtime:addEventListener("enterFrame", background3) Runtime:addEventListener("enterFrame", background4)
    Runtime:addEventListener("enterFrame", background5) Runtime:addEventListener("enterFrame", background6)
    Runtime:addEventListener("enterFrame", background7) Runtime:addEventListener("enterFrame", background8)
    Runtime:addEventListener("enterFrame", background9) Runtime:addEventListener("enterFrame", background10)
    Runtime:addEventListener("enterFrame", background11) Runtime:addEventListener("enterFrame",background12)
    Runtime:addEventListener("enterFrame", background13) Runtime:addEventListener("enterFrame",background14)
    Runtime:addEventListener("enterFrame", background15) Runtime:addEventListener("enterFrame",background16)
        
    Runtime:addEventListener("enterFrame", tree1)
    Runtime:addEventListener("enterFrame", tree2)
    Runtime:addEventListener("enterFrame", tree3)
    Runtime:addEventListener("touch", duckJump)
    
    audio.play( musicTrack, { channel=1, loops=-1 } )
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  physics.pause()
  
  backGroup = display.newGroup()
  sceneGroup:insert(backGroup)
  
  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)
  
  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)
  
  image1 = "grassland.png"
  image2 = "city.png"
  image3 = "desert.png"
  image4 = "cave.png"

  background1 = display.newImage(backGroup, image1) background1.x=240  background1.y=160 background1.speed=1
  background2 = display.newImage(backGroup, image1) background2.x=720  background2.y=160 background2.speed=1
  background3 = display.newImage(backGroup, image1) background3.x=1200  background3.y=160 background3.speed=1
  background4 = display.newImage(backGroup, image1) background4.x=1680  background4.y=160 background4.speed=1

  background5 = display.newImage(backGroup, image2) background5.x=2160  background5.y=160 background5.speed=1
  background6 = display.newImage(backGroup, image2) background6.x=2640  background6.y=160 background6.speed=1
  background7 = display.newImage(backGroup, image2) background7.x=3120  background7.y=160 background7.speed=1
  background8 = display.newImage(backGroup, image2) background8.x=3600  background8.y=160 background8.speed=1

  background9=display.newImage(backGroup, image3) background9.x=4080 background9.y=160 background9.speed=1
  background10=display.newImage(backGroup, image3) background10.x=4560 background10.y=160 background10.speed=1
  background11=display.newImage(backGroup, image3) background11.x=5040 background11.y=160 background11.speed=1
  background12=display.newImage(backGroup, image3) background12.x=5520 background12.y=160 background12.speed=1

  background13=display.newImage(backGroup, image4) background13.x=6000 background13.y=160 background13.speed=1
  background14=display.newImage(backGroup, image4) background14.x=6480 background14.y=160 background14.speed=1
  background15=display.newImage(backGroup, image4) background15.x=6960 background15.y=160 background15.speed=1
  background16=display.newImage(backGroup, image4) background16.x=7440 background16.y=160 background16.speed=1
  
  background1.enterFrame = scrollBackground background2.enterFrame = scrollBackground
  background3.enterFrame = scrollBackground background4.enterFrame = scrollBackground
  background5.enterFrame = scrollBackground background6.enterFrame = scrollBackground
  background7.enterFrame = scrollBackground background8.enterFrame = scrollBackground
  background9.enterFrame = scrollBackground background10.enterFrame = scrollBackground
  background11.enterFrame = scrollBackground background12.enterFrame = scrollBackground
  background13.enterFrame = scrollBackground background14.enterFrame = scrollBackground
  background15.enterFrame = scrollBackground background16.enterFrame = scrollBackground
  
  pauseButton = display.newImage(backGroup, "pause.png")
	pauseButton.x = 415
  pauseButton.y = 55
  
  duck = display.newImage(mainGroup, "duck.png")
  duck.x = 175
  duck.y = 230
  physics.addBody( duck, "dynamic", { radius = 16, bounce = 0.2 } )
  
  myText = display.newText(uiGroup, treeCount, 240, 85, native.SystemFontBold, 31 )
  myText:setFillColor( 1,0,0.2 )

  tree1 = display.newImage(uiGroup, "tree1.png") tree1.x = 480 tree1.y = 257 tree1.speed = 3
  physics.addBody( tree1, "static", {density = 1, radius = 20})
  tree2 = display.newImage(uiGroup, "tree2.png") tree2.x = 960 tree2.y = 257 tree2.speed = 3
  physics.addBody( tree2, "static", {density = 1, radius = 20})
  tree3 = display.newImage(uiGroup, "tree3.png") tree3.x = 1440 tree3.y = 257  tree3.speed = 3
  physics.addBody( tree3, "static", {density = 1, radius = 20})
  
  tree1.enterFrame = scrollTree
  tree2.enterFrame = scrollTree
  tree3.enterFrame = scrollTree
  
  grassBar = display.newImage(uiGroup, "grassBar.png")
  grassBar.x = 240
  grassBar.y = 308
  physics.addBody( grassBar, "static")
  
  grassBarBehind = display.newImage(uiGroup, "grassBar.png")
  grassBarBehind.x = -240
  grassBarBehind.y = 308
  physics.addBody( grassBarBehind, "static")

  pauseButton:addEventListener("tap", pauseGame)
  
  musicTrack = audio.loadStream( "game.mp3" )
  deadSound = audio.loadSound( "endGameSound.wav" )
  quackSound = audio.loadSound("duckQuack.wav")
  
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
      physics.start()
      Runtime:addEventListener("enterFrame", background1) Runtime:addEventListener("enterFrame", background2)
      Runtime:addEventListener("enterFrame", background3) Runtime:addEventListener("enterFrame", background4)
      Runtime:addEventListener("enterFrame", background5) Runtime:addEventListener("enterFrame", background6)
      Runtime:addEventListener("enterFrame", background7) Runtime:addEventListener("enterFrame", background8)
      Runtime:addEventListener("enterFrame", background9) Runtime:addEventListener("enterFrame", background10)
      Runtime:addEventListener("enterFrame", background11) Runtime:addEventListener("enterFrame",background12)
      Runtime:addEventListener("enterFrame", background13) Runtime:addEventListener("enterFrame",background14)
      Runtime:addEventListener("enterFrame", background15) Runtime:addEventListener("enterFrame",background16)
      
      Runtime:addEventListener("enterFrame", tree1)
      Runtime:addEventListener("enterFrame", tree2)
      Runtime:addEventListener("enterFrame", tree3)
      
      Runtime:addEventListener("touch", duckJump)
      
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
      Runtime:removeEventListener("enterFrame", background1) Runtime:removeEventListener("enterFrame", background2)
      Runtime:removeEventListener("enterFrame", background3) Runtime:removeEventListener("enterFrame", background4)
      Runtime:removeEventListener("enterFrame", background5) Runtime:removeEventListener("enterFrame", background6)
      Runtime:removeEventListener("enterFrame", background7) Runtime:removeEventListener("enterFrame", background8)
      Runtime:removeEventListener("enterFrame", background9) Runtime:removeEventListener("enterFrame", background10)
      Runtime:removeEventListener("enterFrame", background11) Runtime:removeEventListener("enterFrame",background12)
      Runtime:removeEventListener("enterFrame", background13) Runtime:removeEventListener("enterFrame",background14)
      Runtime:removeEventListener("enterFrame", background15) Runtime:removeEventListener("enterFrame",background16)
    
      Runtime:removeEventListener("enterFrame", tree1)
      Runtime:removeEventListener("enterFrame", tree2)
      Runtime:removeEventListener("enterFrame", tree3)
    
      Runtime:removeEventListener("touch", duckJump)
      physics.pause()
      
      composer.removeScene("game")
      audio.stop( 1 )

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  --audio.dispose( musicTrack )
  --audio.dispose( deadSound )
  --audio.dispose( quackSound )
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