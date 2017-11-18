-- Tien Dinh - DuLu --

local composer = require( "composer" )
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity(0,0)

--physics.setDrawMode( "hybrid" )

local backHGroup   local mainHGroup   local uiHGroup
local SCREEN_HEIGHT, SCREEN_WIDTH = display.contentHeight, display.contentWidth
local sky   local tx    local ty
local textSize
local ground
local numOfBall   local MAX_BALLS

local nextId = math.random(0, 66)
local popId = nextId
local StatusText
local balls = {}

local balloon   local group   local text    local num

local popSound = audio.loadStream("pop.wav")
local tadaSound = audio.loadStream("tada.wav")
local wooshSound = audio.loadStream("woosh1.wav")

local startTime   local endTime   local scoreH

local ceiling   local leftWall    local rightWall

local function addCage()
    ceiling = display.newRect(backHGroup, SCREEN_WIDTH/2,-5,SCREEN_WIDTH,5)
    physics.addBody(ceiling, "static", {friction=0.2,bounce=1.35})
    leftWall = display.newRect(backHGroup, -5,SCREEN_HEIGHT/2,5,SCREEN_HEIGHT)
    physics.addBody(leftWall, "static", {friction=0.2,bounce=1.35})
    rightWall = display.newRect(backHGroup, SCREEN_WIDTH+5,SCREEN_HEIGHT/2,5,SCREEN_HEIGHT)
    physics.addBody(rightWall, "static", {friction=0.2,bounce=1.35})
end

local function endGame()
    --print(score)
    composer.removeScene("highScores")
    composer.setVariable( "hardScore", scoreH )
    composer.gotoScene( "highscores", { time = 500, effect = "flipFadeOutIn" } )
end

local function onBallTouch(event)
  if event.phase == "began" then
      
      if (event.target.name == popId) then
        table.remove(balls,event.target.name)
        event.target:removeSelf()
        numOfBall = numOfBall -1
        popId = popId+1
        audio.play(popSound)
        StatusText:removeSelf()
        StatusText = display.newText(backHGroup, "Next balloon: " .. tostring(popId+1) ,tx,ty, native.systemFontBold, 22)
      else
        event.target:applyForce( 100, 100, event.target.x, event.target.y )
        audio.play(wooshSound)
      end
        
      if (numOfBall == 0)  then
          audio.play(tadaSound)
          StatusText:removeSelf()
          endTime = system.getTimer()
          scoreH = (math.round((endTime - startTime) / 100)) / 10
          StatusText = display.newText(backHGroup, "You finished in: ".. tostring(scoreH).." seconds" ,tx,ty, native.systemFontBold, 22)
          endGame()
      end
    --print (numOfBall)
  end
end

local function AddBall(event)
  startTime = system.getTimer()
  if (numOfBall < MAX_BALLS) then
      num = math.random(1,6)
      balloon = display.newImageRect(mainHGroup, "balloon-".. tostring(num)  ..".png", 54, 54)
      text = display.newText(mainHGroup, 1+nextId,0,0, native.systemFontBold, 24)
      text:setFillColor(0)
      group = display.newGroup()
    -- print (nextId)
      group.name = nextId
      nextId = nextId +1
      group:insert(balloon)
      group:insert(text)
      --local ovalShape = {1,65, 25, 100, 67, 125, 100, 123, 115,89, 113,41, 85,7, 43,3, 12, 22}
      --local ovalShape = {-30, 41,-56,-10, -46, -46, -14, -65, 28, -56, 52, -28, 56, 17, 43,58, 6, 61}
      --local ovalShape = {-55, -1, -31, 34, 11, 59, 44, 57, 59, 23, 57, -25, 29, -59, -13, -63, -44, -44  }
      physics.addBody( group, { densty=1, friction=-0.4, bounce=0.8,  radius = 27})
      group.x = math.random(60,SCREEN_WIDTH-60)
      group.y = SCREEN_HEIGHT - 140
      group.gravityScale= -1
      group.linearDamping = .5
      group:addEventListener("touch",onBallTouch)
      numOfBall = numOfBall + 1
      
      local randomForceX = math.random(10, 15)
      local randomForceY = math.random(10, 15)
      local randomPosX = math.random(0, 20)
      local randomPosY = math.random(10, 25)
      
      if group then
        group:applyForce(randomForceX, randomForceY, randomPosX, randomPosY)
      end
  end
end

local function onGroudTouch( event )
  if event.phase == "ended" then
      --StatusText:removeSelf()
      --StatusText = display.newText(uiGroup,"Next balloon: " .. tostring(popId+1) ,tx,ty, native.systemFontBold, 22)
      --timer.performWithDelay(50,AddBall,MAX_BALLS)
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  backHGroup = display.newGroup()
  sceneGroup:insert(backHGroup)
  
  mainHGroup = display.newGroup()
  sceneGroup:insert(mainHGroup)
  
  uiHGroup = display.newGroup()
  sceneGroup:insert(uiHGroup)
  
  sky = display.newImageRect(backHGroup, "bkg_clouds.png", SCREEN_WIDTH, SCREEN_HEIGHT )
  sky.x = SCREEN_WIDTH/2
  sky.y = SCREEN_HEIGHT/2
  tx = SCREEN_WIDTH/2
  ty = SCREEN_HEIGHT - 50
  textSize = 50
  
  ground = display.newImageRect(backHGroup, "ground.png", SCREEN_WIDTH, SCREEN_HEIGHT/9 )
  ground.x = SCREEN_WIDTH/2
  ground.y = SCREEN_HEIGHT - 30
  physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )
  
  numOfBall = 0
  MAX_BALLS = math.random(28,33)
  nextID = nextId
  StatusText = display.newText(uiHGroup, "Next balloon: "..nextId + 1,tx,ty, native.systemFontBold, 22)
  
  addCage()
  timer.performWithDelay(1,AddBall,MAX_BALLS)
  ground:addEventListener("touch",onGroudTouch)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

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
    physics.pause()
    composer.removeScene("gameHard")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
