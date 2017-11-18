-- TienDinh --

local composer = require( "composer" )

local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require( "physics" )

local background    local standard    local scenario    local freeToPlay
local standardButton    local scenarioButton    local freeToPlayButton
local musicTrack    local tienDinh

-- Capture screen function --
local function captureDeviceScreen( event )
  local captured_image = display.captureScreen( true )
    captured_image:scale(.5,.5)
    captured_image.alpha = 0
    local alert = native.showAlert( "Success", "Captured Image is Saved to Library", { "OK" } )
end

local function gotoStandard(event)
  composer.removeScene("standardSelection")
  composer.gotoScene("standardSelection", { time = 500, effect = "fade" } )
end

--[[
local function gotoScenario(event)
  composer.removeScene("scenarioSelection")
  composer.gotoScene("scenarioSelection", { time = 500, effect = "fade" } )
end
]]--

local function gotoFreeToPlay(event)
  composer.removeScene("freeToPlaySelection")
  composer.gotoScene("freeToPlaySelection", { time = 500, effect = "fade" } )
end


-- create()
function scene:create( event )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	background = display.newImageRect( sceneGroup, "background.jpg", 480, 320)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
  
  title = display.newImageRect( sceneGroup, "title.png", 400, 50)
	title.x = display.contentCenterX
	title.y = display.contentCenterY - 80
  
  tienDinh = display.newImageRect(sceneGroup, "by-Tien-Dinh.png", 80, 12)
  tienDinh.x = 393
  tienDinh.y = 113
  
  --[[
  scenarioButton = display.newImageRect ( sceneGroup, "scenario.png", 123, 29)
  scenarioButton.x = display.contentCenterX - 128
  scenarioButton.y = display.contentCenterY + 52
  ]]--
  
  standardButton = display.newImageRect ( sceneGroup, "standard.png", 117, 27)
  standardButton.x = display.contentCenterX - 105
  standardButton.y = display.contentCenterY + 30
  
  freeToPlayButton = display.newImageRect ( sceneGroup, "freeToPlay.png", 117, 27)
  freeToPlayButton.x = display.contentCenterX + 105
  freeToPlayButton.y = display.contentCenterY + 30
  
  standardButton:addEventListener("touch", gotoStandard)
  --scenarioButton:addEventListener("touch", gotoScenario)
  freeToPlayButton:addEventListener("touch", gotoFreeToPlay)
  
  musicTrack = audio.loadStream( "menuBG.mp3" )
end

-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
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