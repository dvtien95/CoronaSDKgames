-- Tien Dinh --

local composer = require( "composer" )
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local easyButton    local mediumButton    local hardButton    local backButton
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- Capture screen function --
local function captureDeviceScreen( event )
  local captured_image = display.captureScreen( true )
    captured_image:scale(.5,.5)
    captured_image.alpha = 0
    local alert = native.showAlert( "Success", "Captured Image is Saved to Library", { "OK" } )
end

local function gotoEasy( event )
  composer.removeScene("standardEasy")
  composer.gotoScene("standardEasy", { time = 200, effect="fade" } )
end

local function gotoMedium( event )
  composer.removeScene("standardMedium")
  composer.gotoScene("standardMedium", { time = 200, effect="fade" } )
end

local function gotoHard( event )
  composer.removeScene("standardHard")
  composer.gotoScene("standardHard", { time = 200, effect="fade" } )
end

local function gotoMenu( event )
  composer.removeScene("menu")
  composer.gotoScene("menu", { time=500, effect="fade" })
end

local function scrollButton(self, event)
  if (self.name == "easy") then
    if (self.y > 155) then
      self.speed = -0.5
    elseif (self.y < 125) then
      self.speed = 0.5
    end
    self.y = self.y + self.speed
  elseif (self.name == "medium") then
    if (self.y > 170) then
      self.speed = -1
    elseif (self.y < 110) then
      self.speed = 1
    end
    self.y = self.y + self.speed
  elseif (self.name == "hard") then
    if (self.y > 180) then
      self.speed = -1.5
    elseif (self.y < 100) then
      self.speed = 1.5
    end
    self.y = self.y + self.speed
  end
end

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  
  local background = display.newImageRect(sceneGroup, "standardSelectionBG.jpg", 480, 320 )
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  
  easyButton = display.newImageRect(sceneGroup, "easyButton.png", 75, 75)
  easyButton.x = display.contentCenterX - 145
  easyButton.y = display.contentCenterY - 20
  easyButton.name = "easy"
  easyButton.speed = 0.5
  
  mediumButton = display.newImageRect(sceneGroup, "mediumButton.png", 75, 75)
  mediumButton.x = display.contentCenterX
  mediumButton.y = display.contentCenterY - 20
  mediumButton.name = "medium"
  mediumButton.speed = -1
  
  hardButton = display.newImageRect(sceneGroup, "hardButton.png", 75, 75)
  hardButton.x = display.contentCenterX + 145
  hardButton.y = display.contentCenterY - 20
  hardButton.name = "hard"
  hardButton.speed = 1.5
  
  backButton = display.newImageRect(sceneGroup, "backButton.png", 110, 30)
  backButton.x = display.contentCenterX
  backButton.y = display.contentCenterY + 120
  
  easyButton.enterFrame = scrollButton
  mediumButton.enterFrame = scrollButton
  hardButton.enterFrame = scrollButton
  easyButton:addEventListener("touch", gotoEasy)
  mediumButton:addEventListener("touch", gotoMedium)
  hardButton:addEventListener("touch", gotoHard)
  
  backButton:addEventListener("touch", gotoMenu)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    Runtime:addEventListener("enterFrame", easyButton)
    Runtime:addEventListener("enterFrame", mediumButton)
    Runtime:addEventListener("enterFrame", hardButton)
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
    Runtime:removeEventListener("enterFrame", easyButton)
    Runtime:removeEventListener("enterFrame", mediumButton)
    Runtime:removeEventListener("enterFrame", hardButton)
    composer.removeScene("standardSelection")
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
