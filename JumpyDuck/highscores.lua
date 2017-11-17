-- Tien Dinh --

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require("json")

local scoresTable = {}

local musicTrack

local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

local function loadScores()

	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoresTable = json.decode( contents )
	end

	if ( scoresTable == nil or #scoresTable == 0 ) then
		scoresTable = { 0, 0, 0, 0, 0 }
	end
end

local function saveScores()

	for i = #scoresTable, 11, -1 do
		table.remove( scoresTable, i )
	end

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( scoresTable ) )
		io.close( file )
	end
end

local function playMusic()
  audio.play( musicTrack, { channel=1, loops=-1 } )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function gotoMenu()
  composer.gotoScene("menu", { time=800, effect="crossFade" })
end

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-- Load the previous scores
	loadScores()

	-- Insert the saved score from the last game into the table
	table.insert( scoresTable, composer.getVariable( "finalScore" ) )
	composer.setVariable( "finalScore", 0 )

	-- Sort the table entries from highest to lowest
	local function compare( a, b )
		return a > b
	end
	table.sort( scoresTable, compare )

	-- Save the scores
	saveScores()
  
  local background = display.newImage(sceneGroup, "highscores.png")
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  
  local highScoreHeader = display.newImage( sceneGroup, "highscoresHS.png")
  highScoreHeader.x = display.contentCenterX
  highScoreHeader.y = 67
  
  for i = 1, 5 do
    if (scoresTable[i]) then
      local yPos = 83 + (i * 26)
      
      local rankNum = display.newText(sceneGroup, i .. ") ", display.contentCenterX - 10, yPos, "GillSans-Bold", 24)
      rankNum:setFillColor(black)
      rankNum.anchorX = 1
      
      local thisScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX + 20, yPos, "GillSans-Bold", 25)
      thisScore:setFillColor(black)
      thisScore.anchorX = 1
    end
  end
  
  local menuButton = display.newImage(sceneGroup, "menuHS.png")
  menuButton.x = display.contentCenterX - 5
  menuButton.y = 258
  menuButton:addEventListener("tap", gotoMenu)
  
  musicTrack = audio.loadStream( "highscores.mp3" )
  
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
  timer.performWithDelay( 0, playMusic )
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
    composer.removeScene( "highscores" )
    audio.stop(1)

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  --audio.dispose(musicTrack)

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
