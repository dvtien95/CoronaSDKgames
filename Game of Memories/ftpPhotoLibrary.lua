-- Tien Dinh --

local composer = require( "composer" )

local scene = composer.newScene()

local numOfPair = composer.getVariable("numOfPair")
local numOfLibraryPhoto = composer.getVariable("numOfLibraryPhoto")

-- Capture screen function --
local function captureDeviceScreen( event )
  local captured_image = display.captureScreen( true )
    captured_image:scale(.5,.5)
    captured_image.alpha = 0
    local alert = native.showAlert( "Success", "Captured Image is Saved to Library", { "OK" } )
end

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local WIDTH = display.contentWidth  -- 480
local HEIGHT = display.contentHeight - 50   -- 320
local cardFlipped = 0
local position1
local position2
local flippedGroup = {}
local cardGroup = {}

local numOfCards = numOfPair * 2
local matchedCards = 0

local heightDivision = math.floor((numOfCards - 2) / 10) + 2
local xPos = (WIDTH / (math.ceil(numOfCards / heightDivision)))/2
local xPosAddition = xPos
local yPos = HEIGHT / (heightDivision*2)
local xSize = xPos * 2
local ySize = ((1 * HEIGHT) / 1) / heightDivision
local textSize = 1 * ySize / 2
local rowNum = math.ceil(numOfCards / heightDivision)
local rowTH = 1

local assignTable = {}
local randomPosTable = {}
local backButton

local function endGame()
  composer.removeScene("menu")
  composer.gotoScene("menu", {time = 200, effect="fade"})
end

local function gotoSelection(event)
  for i = 1, numOfCards, 1 do
    transition.to( cardGroup[i][1], {time = 200, alpha = 0} )
    transition.to( cardGroup[i][2], {time = 200, alpha = 0} )
    transition.to( cardGroup[i][3], {time = 200, alpha = 0} )
    if cardGroup[i] then
      cardGroup[i]:removeEventListener("touch", cardGroup[i])
    end
    cardGroup[i] = nil
  end
  if (numOfLibraryPhoto ~= nil and numOfLibraryPhoto > 0) then
    local destDir = system.DocumentsDirectory
    for i = 1, numOfLibraryPhoto, 1 do
      print("picture"..tostring(i)..".png")
      local result, reason = os.remove( system.pathForFile( "picture"..tostring(i)..".png", destDir ) )
    end
  end
  composer.removeScene("freeToPlaySelection")
  composer.gotoScene("freeToPlaySelection", { time = 500, effect="fade" } )  
end

local function disableFlipCard()
  for i = 1, #cardGroup, 1 do
    if cardGroup[i] then
      cardGroup[i]:removeEventListener("touch", cardGroup[i])
    end
  end
end

local function enableFlipCard()
  for i = 1, #cardGroup, 1 do
    if cardGroup[i] then
      cardGroup[i]:addEventListener("touch", cardGroup[i])
    end
  end
end

local function removeDisplayCard()
  table.insert(flippedGroup, position1)
  table.insert(flippedGroup, position2)
  position1 = nil
  position2 = nil
  cardFlipped = 0
  enableFlipCard()
  for i = 1, #flippedGroup, 1 do
    if flippedGroup[i] then
      if cardGroup[flippedGroup[i]] then
        cardGroup[flippedGroup[i]]:removeEventListener("touch", cardGroup[flippedGroup[i]])
      end
    end
  end
  matchedCards = matchedCards + 2
  if (matchedCards == numOfCards) then
    backButton:removeEventListener("touch", gotoSelection)
    timer.performWithDelay(1000, endGame)
  end
end

local function resetFlippedCard()
  cardFlipped = 0
  position1 = nil
  position2 = nil
  enableFlipCard()
  for i = 1, #flippedGroup, 1 do
    if flippedGroup[i] then
      if cardGroup[flippedGroup[i]] then
        cardGroup[flippedGroup[i]]:removeEventListener("touch", cardGroup[flippedGroup[i]])
      end
    end
  end
end

local successSound = audio.loadSound("success.wav")
local failSound = audio.loadSound("fail.wav")

local function checkTwoCard()
    if cardGroup[position1] and cardGroup[position2] then
      if cardGroup[position1].myName == cardGroup[position2].myName then
        audio.play(successSound)
        transition.to( cardGroup[position1][1], {time = 50, alpha = 0} )
        transition.to( cardGroup[position1][2], {time = 300, alpha = 0} )
        transition.to( cardGroup[position1][3], {time = 300, alpha = 0} )
        transition.to( cardGroup[position2][1], {time = 50, alpha = 0} )
        transition.to( cardGroup[position2][2], {time = 300, alpha = 0} )
        transition.to( cardGroup[position2][3], {time = 300, alpha = 0} )
        timer.performWithDelay(301, removeDisplayCard)
      else
        audio.play(failSound)
        transition.to( cardGroup[position1][2], {time = 300, alpha = 0} )
        transition.to( cardGroup[position2][2], {time = 300, alpha = 0} )
        transition.to( cardGroup[position1][3], {time = 300, alpha = 0} )
        transition.to( cardGroup[position2][3], {time = 300, alpha = 0} )
        timer.performWithDelay(301, resetFlippedCard)
      end
    end
end

local flipCardSound = audio.loadSound("flipCard.wav")

local function flipCard( self, event )
  audio.play(flipCardSound)
  if (event.phase == "began") then
    print(self.position, self.myName)
    if (cardFlipped == 0) then
      position1 = self.position
      transition.to( cardGroup[position1][2], {time = 300, alpha = 1} )
      transition.to( cardGroup[position1][3], {time = 300, alpha = 1} )
      cardFlipped = cardFlipped + 1
      cardGroup[position1]:removeEventListener("touch", cardGroup[position1])
      
    elseif (cardFlipped == 1) then
      position2 = self.position
      transition.to( cardGroup[position2][2], {time = 300, alpha = 1} )
      transition.to( cardGroup[position2][3], {time = 300, alpha = 1} )
      disableFlipCard()
      
      timer.performWithDelay(700, checkTwoCard)
      
    end
  end
end

--[[
local function flipCard( self, event )
  if (event.phase == "began") then
      if (self[2].alpha == 0) then
        transition.to( self[2], {time = 500, alpha = 1} )
      elseif (self[2].alpha == 1) then
        transition.to( self[2], {time = 300, alpha = 0} )
      end
    end
  end
end
--]]

local function removeThatValue(aTable, aValue)
  for a = 1, #aTable, 1 do
    if aTable[a] == aValue then
      table.remove(aTable, a)
      return
    end
  end
  return
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  display.setStatusBar( display.HiddenStatusBar )
  
  local background = display.newImageRect(sceneGroup, "flashBG.jpg", 480, 320)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  for i = 1, numOfCards, 1 do
    assignTable[i] = nil
    randomPosTable[i] = i
  end
  
  for i = 1, numOfCards, 1 do
    local tmp1 = math.random(1,numOfLibraryPhoto)
    if (assignTable[i] == nil and #randomPosTable > 0) then
      removeThatValue(randomPosTable, i)
      local tmp2 = randomPosTable[math.random(1, #randomPosTable)]
      assignTable[i] = tmp1
      assignTable[tmp2] = tmp1
      removeThatValue(randomPosTable, tmp2)
    end
  end
  
  for i = 1, numOfCards, 1 do
    local tmp = display.newGroup()
    table.insert(cardGroup, tmp)
    
    cardGroup[i].x = xPos
    cardGroup[i].y = yPos
    local aCardBack = display.newImageRect(sceneGroup, "blackWhite.png", xSize, ySize)
    local tmpImage = display.newImageRect(sceneGroup, "picture"..tostring(assignTable[i])..".png",system.DocumentsDirectory, xSize * 17/20, ySize * 17/20)
    local sizeOfThis
    if (numOfCards == 2) then
      sizeOfThis = xSize / 10
    else
      sizeOfThis = xSize / 7
    end
    local tmpText = display.newText(sceneGroup, assignTable[i], 0, 0, native.systemFont, sizeOfThis)
    tmpText:setFillColor(1,0,0)
    
    cardGroup[i]:insert(aCardBack)
    cardGroup[i]:insert(tmpImage)
    cardGroup[i]:insert(tmpText)
    if (numOfCards == 2) then
      xSizeOfThis = xSize * 12/30
      ySizeOfThis = ySize * 8/30
    else
      xSizeOfThis = xSize * 11/30
      ySizeOfThis = ySize * 9/30
    end
    cardGroup[i][3].x = xSizeOfThis
    cardGroup[i][3].y = ySizeOfThis
    cardGroup[i][2].alpha = 0
    cardGroup[i][3].alpha = 0
    cardGroup[i].position = i
    cardGroup[i].myName = tostring(assignTable[i])
    
    cardGroup[i].touch = flipCard
    cardGroup[i]:addEventListener("touch", cardGroup[i])
    
    xPos = xPos + 2*xPosAddition
    
    if (i >= (rowNum * rowTH)) then
      xPos = (WIDTH / (math.ceil(numOfCards / heightDivision)))/2
      yPos = yPos + (HEIGHT / heightDivision)
      rowTH = rowTH + 1
    end
  end

  for i = 1, #assignTable, 1 do
    assignTable[i] = nil
  end
  
  backButton = display.newImageRect(sceneGroup, "backButton.png", 90, 28)
  backButton.x = 69
  backButton.y = 293
  
  backButton:addEventListener("touch", gotoSelection)
  
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
    display.setStatusBar( display.DefaultStatusBar )
    composer.removeScene("freeToPlayGame")
    audio.stop()
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


