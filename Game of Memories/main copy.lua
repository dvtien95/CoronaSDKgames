math.randomseed( os.time() )

local WIDTH = display.contentWidth  -- 480
local HEIGHT = display.contentHeight   -- 320
local cardFlipped = 0
local position1
local position2
local cardGroup = {}
local flippedGroup = {}

local function disableFlipCard()
  for i = 1, #cardGroup, 1 do
    cardGroup[i]:removeEventListener("touch", cardGroup[i])
  end
end

local function enableFlipCard()
  for i = 1, #cardGroup, 1 do
    cardGroup[i]:addEventListener("touch", cardGroup[i])
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
    cardGroup[flippedGroup[i]]:removeEventListener("touch", cardGroup[flippedGroup[i]])
  end
end

local function resetFlippedCard()
  cardFlipped = 0
  position1 = nil
  position2 = nil
  enableFlipCard()
  for i = 1, #flippedGroup, 1 do
    cardGroup[flippedGroup[i]]:removeEventListener("touch", cardGroup[flippedGroup[i]])
  end
end

local function checkTwoCard()
      if cardGroup[position1].myName == cardGroup[position2].myName then
        transition.to( cardGroup[position1][1], {time = 50, alpha = 0} )
        transition.to( cardGroup[position1][2], {time = 300, alpha = 0} )
        transition.to( cardGroup[position2][1], {time = 50, alpha = 0} )
        transition.to( cardGroup[position2][2], {time = 300, alpha = 0} )
        timer.performWithDelay(301, removeDisplayCard)
      else
        transition.to( cardGroup[position1][2], {time = 300, alpha = 0} )
        transition.to( cardGroup[position2][2], {time = 300, alpha = 0} )
        timer.performWithDelay(301, resetFlippedCard)
      end
end

local function flipCard( self, event )
  if (event.phase == "began") then
    print(self.position, self.myName)
    if (cardFlipped == 0) then
      position1 = self.position
      transition.to( cardGroup[position1][2], {time = 300, alpha = 1} )
      cardFlipped = cardFlipped + 1
      cardGroup[position1]:removeEventListener("touch", cardGroup[position1])
      
    elseif (cardFlipped == 1) then
      position2 = self.position
      transition.to( cardGroup[position2][2], {time = 300, alpha = 1} )
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

local sheetOption = 
{
  frames = 
  {
    { -- 1) back
      x = 0,
      y = 0,
      width = 200,
      height = 250
    },
    { -- 2) front
      x = 200,
      y = 0,
      width = 200,
      height = 250
    },
    { -- 3) front
      x = 400,
      y = 0,
      width = 200,
      height = 250
    },
    { -- 4) front
      x = 600,
      y = 0,
      width = 200,
      height = 250
    },
    { -- 5) front
      x = 800,
      y = 0,
      width = 200,
      height = 250
    },
  },
}
 
local cardSheet = graphics.newImageSheet("cardSprite.jpg", sheetOption)

local numOfCards = 100
local heightDivision = math.floor((numOfCards - 2) / 10) + 2

local xPos = (WIDTH / (math.ceil(numOfCards / heightDivision)))/2
local xPosAddition = xPos
local yPos = HEIGHT / (heightDivision*2)
local xSize = xPos * 1.5
local ySize = ((7 * HEIGHT) / 8) / heightDivision
local rowNum = math.ceil(numOfCards / heightDivision)
local rowTH = 1

local assignTable = {}
local randomPosTable = {}

for i = 1, numOfCards, 1 do
  assignTable[i] = nil
  randomPosTable[i] = i
end

local function removeThatValue(aTable, aValue)
  for a = 1, #aTable, 1 do
    if aTable[a] == aValue then
      table.remove(aTable, a)
      return
    end
  end
  return
end

for i = 1, numOfCards, 1 do
  local tmp1 = math.random(2,5)
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
  local aCardFront = display.newImageRect( cardSheet, assignTable[i], xSize, ySize)
  local aCardBack = display.newImageRect( cardSheet, 1, xSize, ySize)
  
  cardGroup[i]:insert(aCardBack)
  cardGroup[i]:insert(aCardFront)
  cardGroup[i][2].alpha = 0
  cardGroup[i].position = i
  
  if (assignTable[i] == 2) then
    cardGroup[i].myName = "Heart"
  elseif (assignTable[i] == 3) then
    cardGroup[i].myName = "Diamond"
  elseif (assignTable[i] == 4) then
    cardGroup[i].myName = "Spade"
  else
    cardGroup[i].myName = "Club"
  end
  
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
  table.remove(assignTable, i)
end

