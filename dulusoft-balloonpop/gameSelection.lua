-- Tien Dinh - DuLu --

local composer = require( "composer" )
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()

--physics.setDrawMode( "hybrid" )
local SCREEN_HEIGHT, SCREEN_WIDTH = display.contentHeight, display.contentWidth
local sky   local ground    local tx    local ty
local textSize
local easyMode    local mediumMode    local hardMode    local backMode

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function gotoEasy( event )
  composer.removeScene("gameEasy")
  composer.gotoScene("gameEasy", { time = 200} )
end

local function gotoMedium( event )
  composer.removeScene("gameMedium")
  composer.gotoScene("gameMedium", { time = 200} )
end

local function gotoHard( event )
  composer.removeScene("gameHard")
  composer.gotoScene("gameHard", { time = 200} )
end

local function gotoMenu( event )
  composer.removeScene("menu")
  composer.gotoScene("menu", { time=500, effect="fade" })
end

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  
  sky = display.newImageRect(sceneGroup, "bkg_clouds.png", SCREEN_WIDTH, SCREEN_HEIGHT )
  sky.x = SCREEN_WIDTH/2
  sky.y = SCREEN_HEIGHT/2
  tx = SCREEN_WIDTH/2
  ty = SCREEN_HEIGHT - 50
  textSize = 50
  
  ground = display.newImageRect(sceneGroup, "ground.png", SCREEN_WIDTH, SCREEN_HEIGHT/9 )
  ground.x = SCREEN_WIDTH/2
  ground.y = SCREEN_HEIGHT - 30
  physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )
  
  easyMode = display.newImageRect(sceneGroup, "easyMode.png", 175, 43)
  easyMode.x = display.contentCenterX
  easyMode.y = display.contentCenterY - 190
  
  mediumMode = display.newImageRect(sceneGroup, "mediumMode.png", 200, 58)
  mediumMode.x = display.contentCenterX
  mediumMode.y = display.contentCenterY - 65
  
  hardMode = display.newImageRect(sceneGroup, "hardMode.png", 240, 75)
  hardMode.x = display.contentCenterX
  hardMode.y = display.contentCenterY + 70
  
  backMode = display.newImageRect(sceneGroup, "backMode.png", 140, 50)
  backMode.x = display.contentCenterX
  backMode.y = display.contentCenterY + 200
  
  easyMode:addEventListener("touch", gotoEasy)
  mediumMode:addEventListener("touch", gotoMedium)
  hardMode:addEventListener("touch", gotoHard)
  backMode:addEventListener("touch", gotoMenu)

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
    composer.removeScene("gameSelection")
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
