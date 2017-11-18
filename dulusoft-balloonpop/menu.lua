-- TienDinh - DuLu --

local composer = require( "composer" )

local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require( "physics" )
physics.start()

local background    local playButton    local title
local balloonSheetData = {}   local balloonSequenceData = {}
local balloon   local balloonSheet

local function playGame(event)
  composer.removeScene("gameSelection")
  composer.gotoScene("gameSelection", { time = 500, effect = "fade" } )
end

local function highscoreGame(event)
  composer.removeScene("highscores")
  composer.gotoScene("highscores", { time = 500, effect = "fade" } )
end


local function scrollBalloon(self, event)
  if self then
      if self.y < -30 then
        self.y = 660
      else
        self.y = self.y - self.speed
      end
  end
end

local balloonPopSound = audio.loadSound("balloonPopSound.wav")

local function popBalloon(event)
  local xPos = math.random(100, 260)
  transition.to(balloon, {x = xPos, y = 680, time = 0} )
  audio.play(balloonPopSound)
end

-- create()
function scene:create( event )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	background = display.newImageRect( sceneGroup, "skyBG.jpg", 360, 640)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
  
  title = display.newImageRect( sceneGroup, "Balloon-Pop.png", 320, 65)
	title.x = display.contentCenterX
	title.y = display.contentCenterY - 180
  
  playButton = display.newImageRect ( sceneGroup, "playMenu.png", 90, 45)
  playButton.x = display.contentCenterX
  playButton.y = display.contentCenterY - 30
  
  menuButton = display.newImageRect ( sceneGroup, "highScoresMenu.png", 150, 60)
  menuButton.x = display.contentCenterX
  menuButton.y = display.contentCenterY + 80
  
  playButton:addEventListener("touch", playGame)
  menuButton:addEventListener("touch", highscoreGame)
  
  local balloonSheetData = {
    width = 120,
    height = 120,
    numFrames = 7,
    sheetContentWidth = 840,
    sheetContentHeight = 120
  }
  
  local balloonSequenceData = {
    { name = "run", start = 1, count = 7, time = 7000, loopCount = 0 },
  }
  
  balloonSheet = graphics.newImageSheet("balloonSprite.png", balloonSheetData)

  balloon = display.newSprite(sceneGroup ,balloonSheet, balloonSequenceData)
  balloon:scale( 0.5, 0.5 )
  balloon.x = 315
  balloon.y = 340
  balloon.speed = 2
  balloon:play()
  physics.addBody( balloon, "static" )
  
  balloon.enterFrame = scrollBalloon
  balloon:addEventListener("tap", popBalloon)

  musicTrack = audio.loadStream( "menuMusic.wav" )
end

-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    Runtime:addEventListener("enterFrame", balloon)
    --Runtime:addEventListener("tap", balloon)
		-- Start the music!
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
    Runtime:removeEventListener("enterFrame", balloon)
    --Runtime:removeEventListener("tap", balloon)
		-- Stop the music!
    composer.removeScene("menu")
    audio.stop( 1 )
	end
end

-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
    audio.dispose( musicTrack )
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