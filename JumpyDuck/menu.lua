-- Tien Dinh --

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local musicTrack

local function gotoGame()
  composer.removeScene("game")
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoHighScores()
  composer.removeScene("highscores")
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

-- create()
function scene:create( event )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImage( sceneGroup, "menuBG.png")
	background.x = display.contentCenterX
	background.y = display.contentCenterY
  
  local tienDinh = display.newImageRect(sceneGroup, "by-Tien-Dinh.png", 75, 10)
  tienDinh.x = 345
  tienDinh.y = 130

	local title = display.newImage( sceneGroup, "title.png")
	title.x = display.contentCenterX
	title.y = 100

	local playButton = display.newImage( sceneGroup, "Play.png")
	playButton.x = display.contentCenterX
  playButton.y = 170

	local highScoresButton = display.newImage( sceneGroup, "High Scores.png")
	highScoresButton.x = display.contentCenterX
  highScoresButton.y = 230

	playButton:addEventListener( "tap", gotoGame )
	highScoresButton:addEventListener( "tap", gotoHighScores )
  
  musicTrack = audio.loadStream( "menu.wav" )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

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
  --audio.dispose( musicTrack )
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