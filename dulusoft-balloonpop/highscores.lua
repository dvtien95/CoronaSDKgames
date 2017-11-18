-- TienDinh - DuLu --

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require("json")

local easyScoresTable = {}
local mediumScoresTable = {}
local hardScoresTable = {}

local musicTrack

local filePath1 = system.pathForFile("easyScores.json", system.DocumentsDirectory)
local filePath2 = system.pathForFile("mediumScores.json", system.DocumentsDirectory)
local filePath3 = system.pathForFile("hardScores.json", system.DocumentsDirectory)

local function loadScores()

	local file1 = io.open( filePath1, "r" )
  local file2 = io.open( filePath2, "r" )
  local file3 = io.open( filePath3, "r" )

	if file1 then
		local contents = file1:read( "*a" )
		io.close( file1 )
		easyScoresTable = json.decode( contents )
	end
  
  if file2 then
		local contents = file2:read( "*a" )
		io.close( file2 )
		mediumScoresTable = json.decode( contents )
	end
  
  if file3 then
		local contents = file3:read( "*a" )
		io.close( file3 )
		hardScoresTable = json.decode( contents )
	end

	if ( easyScoresTable == nil or #easyScoresTable == 0 ) then
		easyScoresTable = {  999999999,  999999999,  999999999,  999999999,  999999999}
  end
  
  if ( mediumScoresTable == nil or #mediumScoresTable == 0 ) then
		mediumScoresTable = {  999999999,  999999999,  999999999,  999999999,  999999999}
  end
  
  if ( hardScoresTable == nil or #hardScoresTable == 0 ) then
		hardScoresTable = {  999999999,  999999999,  999999999,  999999999,  999999999}
  end
end

local function saveScores()

	for i = #easyScoresTable, 11, -1 do
		table.remove( easyScoresTable, i )
	end
  
  for i = #mediumScoresTable, 11, -1 do
		table.remove( mediumScoresTable, i )
	end
  
  for i = #hardScoresTable, 11, -1 do
		table.remove( hardScoresTable, i )
	end

	local file1 = io.open( filePath1, "w" )
  local file2 = io.open( filePath2, "w" )
  local file3 = io.open( filePath3, "w" )

	if file1 then
		file1:write( json.encode( easyScoresTable ) )
		io.close( file1 )
	end
  
  if file2 then
		file2:write( json.encode( mediumScoresTable ) )
		io.close( file2 )
	end
  
  if file3 then
		file3:write( json.encode( hardScoresTable ) )
		io.close( file3 )
	end
end

local function playMusic()
  audio.play( musicTrack, { channel=1, loops=-1 } )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function gotoMenu(event)
  composer.removeScene("menu")
  composer.gotoScene("menu", { time=500, effect="fade" })
end

local function gotoGame(event)
  composer.removeScene("gameSelection")
  composer.gotoScene("gameSelection", { time=500, effect="fade" })
end

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-- Load the previous scores
  
	loadScores()
  local tmp1 = composer.getVariable("easyScore")
  local tmp2 = composer.getVariable("mediumScore")
  local tmp3 = composer.getVariable("hardScore")
  --print(tmp1, " ", tmp2 , " ", tmp3, " ")
  
  local tmpScore
  if (tmp1==nil or tmp1==999999999) and (tmp2==nil or tmp2==999999999) and (tmp3==nil or tmp3==999999999) then
    tmpScore = ":  .."
  elseif tmp1 ~= nil and (tmp2==nil or tmp2==999999999) and (tmp3==nil or tmp3==999999999) then
    tmpScore = "(EASY):  " .. tmp1
  elseif (tmp1==nil or tmp1==999999999) and tmp2 ~= nil and (tmp3==nil or tmp3==999999999) then
    tmpScore = "(MEDIUM):  " .. tmp2
  elseif (tmp1==nil or tmp1==999999999) and (tmp2==nil or tmp2==999999999) and tmp3 ~= nil then
    tmpScore = "(HARD):  " .. tmp3
  end
    
  --print(tmpScore)
	-- Insert the saved score from the last game into the table
	table.insert( easyScoresTable, composer.getVariable( "easyScore" ) )
	composer.setVariable( "easyScore", 999999999 )
  
  table.insert( mediumScoresTable, composer.getVariable( "mediumScore" ) )
	composer.setVariable( "mediumScore", 999999999 )
  
  table.insert( hardScoresTable, composer.getVariable( "hardScore" ) )
	composer.setVariable( "hardScore", 999999999 )

	-- Sort the table entries from highest to lowest
	local function compare( a, b )
		return a < b
	end
	table.sort( easyScoresTable, compare )
  table.sort( mediumScoresTable, compare )
  table.sort( hardScoresTable, compare )
  
	-- Save the scores
	saveScores()
  
  local background = display.newImageRect(sceneGroup, "night.jpg", display.contentWidth, display.contentHeight)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  
  local timeText = display.newText( sceneGroup, "Last score " .. tmpScore .. "s", display.contentCenterX, display.contentCenterY + 108, native.systemFontBold, 22)
  timeText:setFillColor(1,1,1)
  
  local highScoreHeader = display.newImageRect(sceneGroup, "highScoreTitle.png", 300, 90)
  highScoreHeader.x = display.contentCenterX
  highScoreHeader.y = display.contentCenterY - 210
  
  local easyText = display.newText( sceneGroup, "EASY", 50, 180, native.systemFontBold, 24)
  easyText:setFillColor(1,1,1)
  local mediumText = display.newText( sceneGroup, "MEDIUM", 180, 180, native.systemFontBold, 24)
  mediumText:setFillColor(1,1,1)
  local hardText = display.newText( sceneGroup, "HARD", 310, 180, native.systemFontBold, 24)
  hardText:setFillColor(1,1,1)
  
  for j = 1,3 do
    local scoresTable   local xPos
    if j == 1 then
      scoresTable = easyScoresTable
      xPos = 70
    elseif j == 2 then
      scoresTable = mediumScoresTable
      xPos = 206
    else
      scoresTable = hardScoresTable
      xPos = 336
    end
    
    for i = 1, 5 do
      if (scoresTable[i]) then
        local yPos = 188 + (i * 38)
        
        local thisScore
        if scoresTable[i] == 999999999 then
          thisScore = display.newText(sceneGroup, "..", xPos, yPos, "GillSans-Bold", 25)
        else
          thisScore = display.newText(sceneGroup, scoresTable[i], xPos , yPos, "GillSans-Bold", 25)
        end
        thisScore:setFillColor(1,1,1)
        thisScore.anchorX = 1
      end
    end
  end
  
  local menuButton = display.newImageRect(sceneGroup, "MENU.png", 115, 32)
  menuButton.x = 64
  menuButton.y = display.contentCenterY + 170
  menuButton:addEventListener("tap", gotoMenu)
  
  local playButton = display.newImageRect(sceneGroup, "PLAY.png", 115, 32)
  playButton.x = display.contentWidth - 64 
  playButton.y = display.contentCenterY + 170
  playButton:addEventListener("tap", gotoGame)
  
  musicTrack = audio.loadStream( "highscoreMusic.wav" )
  
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
  audio.dispose(musicTrack)

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
