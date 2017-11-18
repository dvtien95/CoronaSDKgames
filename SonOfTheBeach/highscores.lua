-- Tien Dinh --

local composer = require( "composer" )
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require("json")
local scoresTable = {}
local musicTrack1   local musicTrack2
local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

local function loadScores()
	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoresTable = json.decode( contents )
	end

	if ( scoresTable == nil or #scoresTable == 0 ) then
		scoresTable = { 0, 0, 0, 0, 0 ,0 ,0, 0, 0, 0}
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

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function gotoMenu()
  composer.gotoScene("menu", { time=500, effect="flipFadeOutIn" })
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
  
  local background = display.newImage(sceneGroup, "highscoresBG.jpg")
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  
  local highScoreHeader = display.newImageRect( sceneGroup, "highscoresHS.png", 195, 35)
  highScoreHeader.x = 106
  highScoreHeader.y = 90
  
  for i = 1, 10 do
    if (scoresTable[i]) then
      local yPos
      local xPos
      
      if (i < 6) then
        xPos = 47
        yPos = 95 + (i*30)
      else
        xPos = 159
        yPos = 95 + ( (i - 5) * 30 )
      end
      
      local rankNum = display.newText(sceneGroup, i .. ") ", xPos, yPos, "GillSans-Bold", 24)
      rankNum:setFillColor(black)
      rankNum.anchorX = 1
      
      local thisScore = display.newText(sceneGroup, scoresTable[i], xPos + 20, yPos, "GillSans-Bold", 25)
      thisScore:setFillColor(black)
      thisScore.anchorX = 1
    end
  end
  
  local menuButton = display.newImageRect(sceneGroup, "menuHS.png", 150, 20)
  menuButton.x = 95
  menuButton.y = 287
  menuButton:addEventListener("tap", gotoMenu )
  
  musicTrack1 = audio.loadStream( "beachSound.mp3" )
  musicTrack2 = audio.loadStream( "windSound.mp3" )
  
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    audio.play( musicTrack1, { channel=1, loops=-1 } )
    audio.play( musicTrack2, { channel=2, loops=-1 } )
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
    audio.stop(2)

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  audio.dispose(musicTrack1)
  audio.dispose(musicTrack2)

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