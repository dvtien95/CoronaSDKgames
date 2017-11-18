-- Tien Dinh --

local composer = require( "composer" )
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local background    local skipButton    local nextButton    local previousButton    local skipText

local function goToMenu( event )
  composer.removeScene("menu")
  composer.gotoScene("menu", { time=500, effect="fade" } )
end

local function goToNextTutorial( event )
  composer.removeScene("tutorial3")
  composer.gotoScene("tutorial3", { time=400, effect="fromRight" } )
end

local function goToPreviousTutorial( event )
  composer.removeScene("tutorial1")
  composer.gotoScene("tutorial1", { time=400, effect="fromLeft" } )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  
  background = display.newImageRect(sceneGroup, "tutorial2.jpg", 480, 270)
  background.x = 240
  background.y = 180
  
	skipText = display.newText(sceneGroup, ">> Skip" , 444, 91, native.systemFontBold, 12 )
  skipText:setFillColor(1,0,0)  
  
  skipButton = display.newImageRect(sceneGroup, "skipIcon.jpeg" , 40, 40)
  skipButton.x = 450
  skipButton.y = 71
  
  nextButton = display.newImageRect(sceneGroup, "nextIcon.jpeg" , 40, 40)
  nextButton.x = 450
  nextButton.y = 170
  
  previousButton = display.newImageRect(sceneGroup, "previousIcon.jpeg" , 40, 40)
  previousButton.x = 30
  previousButton.y = 170
  
  skipButton:addEventListener("tap", goToMenu)
  nextButton:addEventListener("tap", goToNextTutorial)
  previousButton:addEventListener("tap", goToPreviousTutorial)
  
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
    skipButton:removeEventListener("tap", goToMenu)
    nextButton:removeEventListener("tap", goToNextTutorial)
    previousButton:removeEventListener("tap", goToPreviousTutorial)
    
    composer.removeScene( "tutorial2" )

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