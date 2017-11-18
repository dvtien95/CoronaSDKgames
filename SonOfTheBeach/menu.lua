-- Tien Dinh --

local composer = require( "composer" )

local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local musicTrack
local human
local runSheetData
local myRunSheet
local runSequenceData

local playButton    local highScoresButton    local tutorialButton

local function gotoGame()
  composer.removeScene("game")
	composer.gotoScene( "game", { time=500, effect="crossFade" } )
end

local function gotoHighScores()
  composer.removeScene("highscores")
	composer.gotoScene( "highscores", { time=500, effect="crossFade" } )
end

local function gotoTutorial1()
  composer.removeScene("tutorial1")
  composer.gotoScene("tutorial1", { time=500, effect="fade" })
end

local function scrollHuman(self, event)
  if self.x > 485 then
    self.x = -5
  else
    self.x = self.x + self.speed
  end
end

-- create()
function scene:create( event )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "menuBG.jpg", 480, 360)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
  
  local tienDinh = display.newImageRect(sceneGroup, "by-Tien-Dinh.png", 75, 10)
  tienDinh.x = 360
  tienDinh.y = 140
  
  local title = display.newImageRect( sceneGroup, "gameTitle.png", 350, 50)
	title.x = display.contentCenterX
	title.y = 110
  
  tutorialButton = display.newImageRect( sceneGroup, "tutorialTitle.png", 100, 25)
  tutorialButton.x = 89
  tutorialButton.y = display.contentCenterY + 20

	playButton = display.newImageRect( sceneGroup, "playTitle.png", 70, 25)
	playButton.x = display.contentCenterX
  playButton.y = display.contentCenterY + 20

	highScoresButton = display.newImageRect( sceneGroup, "highscoresTitle.png", 100, 25)
	highScoresButton.x = 391
  highScoresButton.y = display.contentCenterY + 20
  
  runSheetData = {
    width = 55,
    height = 80,
    numFrames = 17,
    sheetContentWidth = 984,
    sheetContentHeight = 80
  }
  
  myRunSheet = graphics.newImageSheet ("smallMovementSprite.png",runSheetData )

  runSequenceData = {
    { name = "run", start = 1, count = 6, time = 1000, loopCount = 0 },
  }

  human = display.newSprite(sceneGroup ,myRunSheet, runSequenceData)
  human.myName = "human"
  human.x = 315
  human.y = 280
  human.speed = 1
  human:play()
  
  human.enterFrame = scrollHuman

	playButton:addEventListener( "tap", gotoGame )
	highScoresButton:addEventListener( "tap", gotoHighScores )
  tutorialButton:addEventListener( "tap", gotoTutorial1 )
  
  musicTrack = audio.loadStream( "jump-and-run-tropics.mp3" )
end

-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
    human.alpha = 1
    Runtime:addEventListener("enterFrame", human)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
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
    human.alpha = 0
    Runtime:removeEventListener("enterFrame", human)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		-- Stop the music!
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