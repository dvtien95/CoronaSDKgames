-- Tien Dinh --

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require("widget")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local numOfPair   local isLibraryPhoto = false    local numOfLibraryPhoto = 0   local imageSet = 1
local numOfLibraryPhotoText1
local numOfLibraryPhotoText2
local pairText
local photoText
local pickOneText
local segmentedControl
local segmentedControl2
local segmentedControl3
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

local function gotoGame( event )
  if (event.phase == "ended") then
    if (numOfPair ~= nil and isLibraryPhoto == false and imageSet ~= nil) then
      pairText.alpha = 0
      
      composer.setVariable("numOfPair", numOfPair)
      composer.setVariable("imageSet", imageSet)
      
      composer.removeScene("ftpStandard")
      composer.gotoScene("ftpStandard", { time = 500, effect="fade" } )
      
    elseif (numOfPair ~= nil and isLibraryPhoto == true and numOfLibraryPhoto > 0) then  
      pairText.alpha = 0
      
      composer.setVariable("numOfPair", numOfPair)
      composer.setVariable("numOfLibraryPhoto", numOfLibraryPhoto)
      
      composer.removeScene("ftpPhotoLibrary")
      composer.gotoScene("ftpPhotoLibrary", { time = 500, effect="fade" } )
    end
  end
end

local function gotoMenu( event )
  pairText.alpha = 0
  if (numOfLibraryPhoto ~= nil and numOfLibraryPhoto > 0) then
    local destDir = system.DocumentsDirectory
    for i = 1, numOfLibraryPhoto, 1 do
      print("picture"..tostring(i)..".png")
      local result, reason = os.remove( system.pathForFile( "picture"..tostring(i)..".png", destDir ) )
    end
  end
  composer.removeScene("menu")
  composer.gotoScene("menu", { time = 500, effect="fade" })
end

local function textListener(event)
  if (event.phase == "ended" or event.phase == "submitted") then
    if (tonumber(event.target.text) ~= nil) then
        numOfPair = tonumber(event.target.text)
        if numOfPair > 500 then
          numOfPair = 500
        end
    else
        numOfPair = nil
    end
    
    print("numOfPair", numOfPair)
  end
end

local function onComplete( event )
  if (event.completed) then
    display.save(event.target, {filename = "picture"..tostring(numOfLibraryPhoto)..".png", baseDir = system.DocumentsDirectory, captureOffscreenArea = true} )
  else
    numOfLibraryPhoto = numOfLibraryPhoto - 1
  end
  
  if event.target then
    event.target:removeSelf()
  end
end

local function onSegmentPress3(event)
  if (event.target.segmentLabel == "+") then
    if media.hasSource( media.PhotoLibrary ) then
        numOfLibraryPhoto = numOfLibraryPhoto + 1
        media.selectPhoto( { mediaSource=media.PhotoLibrary, listener=onComplete } )
    else
        native.showAlert( "Corona", "This device does not have a photo library.", { "OK" } )
    end
  end
  print("numOfLibraryPhoto", numOfLibraryPhoto)
end

local function onSegmentPress2(event)
  local target = event.target
  --"Fruit", "Animal", "Object", "Food"
  if (target.segmentLabel == "Animal") then
    imageSet = 1
  elseif (target.segmentLabel == "Food") then
    imageSet = 2
  elseif (target.segmentLabel == "Fruit") then
    imageSet = 3
  else
    imageSet = 4
  end
  print("imageSet", imageSet)
end

local function onSegmentPress(event)
  local target = event.target

  if (target.segmentLabel == "Yes") then
    isLibraryPhoto = true
    
    pickOneText.alpha = 0
    segmentedControl2.alpha = 0
    
    numOfLibraryPhotoText1.alpha = 1
    numOfLibraryPhotoText2.alpha = 1
    segmentedControl3.alpha = 1
    
  else
    
    if (numOfLibraryPhoto ~= nil and numOfLibraryPhoto > 0) then
      local destDir = system.DocumentsDirectory
      for i = 1, numOfLibraryPhoto, 1 do
        print("picture"..tostring(i)..".png")
        local result, reason = os.remove( system.pathForFile( "picture"..tostring(i)..".png", destDir ) )
      end
    end
    
    isLibraryPhoto = false
    
    pickOneText.alpha = 1
    segmentedControl2.alpha = 1
    
    numOfLibraryPhotoText1.alpha = 0
    numOfLibraryPhotoText2.alpha = 0
    segmentedControl3.alpha = 0
  end
  print(isLibraryPhoto)
end

local function hideKeyBoard(event)
  native.setKeyboardFocus( nil )
  return true
end

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local background = display.newRect(sceneGroup, 0, 0, display.viewableContentWidth, display.viewableContentHeight)
  background:setFillColor(0, 0, 0)
  background:addEventListener("tap", hideKeyBoard)

  local numOfPairText = display.newText(sceneGroup, "Enter number of pairs: ", display.contentCenterX - 65, 35, native.systemFont, 25)
  local recommendedText = display.newText(sceneGroup, "(Recommended: 1-50)", display.contentCenterX - 68, 67, native.systemFont, 19)
  numOfPairText:addEventListener("tap", hideKeyBoard)
  recommendedText:addEventListener("tap", hideKeyBoard)
  
  pairText = native.newTextField(display.contentCenterX + 135, 56, 115, 45)
  pairText.inputType = "number"
  pairText.size = 35
  pairText.name = "pairText"
  pairText:addEventListener("userInput", textListener)
  sceneGroup:insert(pairText)
  
  local isLibraryPhotoText1 = display.newText(sceneGroup, "Do you want to use", display.contentCenterX - 138, 137, native.systemFont, 20)
  local isLibraryPhotoText2 = display.newText(sceneGroup, "Library Photo?", display.contentCenterX - 138, 165, native.systemFont, 18)
  isLibraryPhotoText1:addEventListener("tap", hideKeyBoard)
  isLibraryPhotoText2:addEventListener("tap", hideKeyBoard)
  
  local segmentedControl = widget.newSegmentedControl
  {
    left = 30,
    top = 190,
    segmentWidth = 70,
    segments = { "No", "Yes" },
    defaultSegment = 1,
    onPress = onSegmentPress
  }
  sceneGroup:insert(segmentedControl)
  
  -- No one --
  pickOneText = display.newText(sceneGroup, "Choose one set: ", display.contentCenterX + 110, 160, native.systemFont, 25)
  pickOneText:addEventListener("tap", hideKeyBoard)
      
  segmentedControl2 = widget.newSegmentedControl
  {
    left = 235,
    top = 190,
    segmentWidth = 55,
    segments = { "Animal", "Food", "Fruit", "Object" },
    defaultSegment = 1,
    onPress = onSegmentPress2
  }
  sceneGroup:insert(segmentedControl2)

  -- Yes one --
  numOfLibraryPhotoText1 = display.newText(sceneGroup, "Press + to add 1 photo at the time", display.contentCenterX+115, 140, native.systemFont, 17)
  numOfLibraryPhotoText2 = display.newText(sceneGroup, "(Please select different photos)", display.contentCenterX+115, 168, native.systemFont, 15)
  numOfLibraryPhotoText1:addEventListener("tap", hideKeyBoard)
  numOfLibraryPhotoText2:addEventListener("tap", hideKeyBoard)
  
  segmentedControl3 = widget.newSegmentedControl
  {
    left = 325,
    top = 190,
    segmentWidth = 55,
    segments = { "+" },
    defaultSegment = 1,
    onPress = onSegmentPress3
  }
  sceneGroup:insert(segmentedControl3)
  
  numOfLibraryPhotoText1.alpha = 0
  numOfLibraryPhotoText2.alpha = 0
  segmentedControl3.alpha = 0

  local backButton = display.newImageRect(sceneGroup, "backButton.png", 110, 30)
  backButton.x = 75
  backButton.y = 285

  local playButton = display.newImageRect(sceneGroup, "playButton.png", 110, 30)
  playButton.x = 405
  playButton.y = 285
  
  backButton:addEventListener("touch", gotoMenu)
  playButton:addEventListener("touch", gotoGame)
  
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
    if (numOfLibraryPhoto ~= nil and numOfLibraryPhoto > 0) then
      local destDir = system.DocumentsDirectory
      for i = 1, numOfLibraryPhoto, 1 do
        print("picture"..tostring(i)..".png")
        local result, reason = os.remove( system.pathForFile( "picture"..tostring(i)..".png", destDir ) )
      end
    end
    composer.removeScene("freeToPlaySelection")
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
