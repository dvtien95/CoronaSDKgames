math.randomseed( os.time() )

local physics = require("physics")
physics.start()
physics.setGravity(0,0)

local background
local ball1
local ball2
local mainBall
local ballGroup = {}
local ceilng
local leftWall
local rightWall
local floor

local SCREEN_HEIGHT, SCREEN_WIDTH = display.contentHeight, display.contentWidth

local function addCage()
    ceiling = display.newRect(SCREEN_WIDTH/2,-5,SCREEN_WIDTH,5)
    physics.addBody(ceiling, "static", {friction=0,bounce=0.5})
    ceiling.myName = "ceiling"
    leftWall = display.newRect(-5,SCREEN_HEIGHT/2,5,SCREEN_HEIGHT)
    physics.addBody(leftWall, "static", {friction=0,bounce=0.5})
    leftWall.myName = "leftWall"
    rightWall = display.newRect(SCREEN_WIDTH+5,SCREEN_HEIGHT/2,5,SCREEN_HEIGHT)
    physics.addBody(rightWall, "static", {friction=0,bounce=0.5})
    rightWall.myName = "rightWall"
    floor = display.newRect(SCREEN_WIDTH/2,SCREEN_HEIGHT+5,SCREEN_WIDTH,5)
    physics.addBody(floor, "static", {friction=0,bounce=0.5})
    floor.myName = "floor"
end

addCage()

local function addColor(ball)
  local tmpColor = math.random(1,3)
  local tmp1    local tmp2    local tmp3
  if tmpColor == 1 then
    tmp1 = 1    tmp2 = 0    tmp3 = 0
    ball.color = "red"
  elseif tmpColor == 2 then
    tmp1 = 0    tmp2 = 1    tmp3 = 0
    ball.color = "green"
  elseif tmpColor == 3 then
    tmp1 = 0    tmp2 = 0    tmp3 = 1
    ball.color = "blue"
  elseif tmpColor == 4 then
    tmp1 = 1    tmp2 = 0    tmp3 = 1
    ball.color = "pink"
  elseif tmpColor == 5 then
    tmp1 = 0    tmp2 = 0    tmp3 = 0
    ball.color = "black"
  elseif tmpColor == 6 then
    tmp1 = 0    tmp2 = 1    tmp3 = 1
    ball.color = "teal"
  else
    tmp1 = 1    tmp2 = 1    tmp3 = 0
    ball.color = "yellow"
  end
  
  ball:setFillColor(tmp1,tmp2,tmp3)
end

local function tapBall(event)
  if event.phase == "ended" then
    mainBall:applyForce( (event.x - 160) * 7.5 / (430 - event.y), -7.5 , mainBall.x, mainBall.y)
  end
end

local function doneTransition()
  addColor(mainBall)
  mainBall.alpha = 1
  mainBall.bodyType = "dynamic"
end

local function transitionBall()
  mainBall.bodyType = "static"
  mainBall.color = "null"
  mainBall.alpha = 0
  transition.to(mainBall, {x = 160, y = 430, time = 300})
  timer.performWithDelay(301, doneTransition)
end

local function checkBallAround(tmpIndex)
  local ballAroundTable = {}
  
  if (math.floor(tmpIndex / 10)) % 2 == 1 and tmpIndex % 10 ~= 0 then
    if ballGroup[tmpIndex - 10] and ballGroup[tmpIndex].color == ballGroup[tmpIndex - 10].color then
      table.insert(ballAroundTable, tmpIndex - 10)
    end
    
    if ballGroup[tmpIndex - 9] and ballGroup[tmpIndex].color == ballGroup[tmpIndex - 9].color then
      table.insert(ballAroundTable, tmpIndex - 9)
    end
    
    if tmpIndex % 10 ~= 1 and ballGroup[tmpIndex - 1] and ballGroup[tmpIndex].color == ballGroup[tmpIndex - 1].color then
      table.insert(ballAroundTable, tmpIndex - 1)
    end
    
    if tmpIndex % 10 ~= 9 and ballGroup[tmpIndex + 1] and ballGroup[tmpIndex].color == ballGroup[tmpIndex + 1].color then
      table.insert(ballAroundTable, tmpIndex + 1)
    end

    if ballGroup[tmpIndex + 10] and ballGroup[tmpIndex].color == ballGroup[tmpIndex + 10].color then
      table.insert(ballAroundTable, tmpIndex + 10)
    end

    if ballGroup[tmpIndex + 11] and ballGroup[tmpIndex].color == ballGroup[tmpIndex + 11].color then
      table.insert(ballAroundTable, tmpIndex + 11)
    end
  end
  
  if (math.floor(tmpIndex / 10)) % 2 == 0 or tmpIndex % 10 == 0 then
    if tmpIndex % 10 ~= 0 and ballGroup[tmpIndex - 10] and ballGroup[tmpIndex].color == ballGroup[tmpIndex - 10].color then
      table.insert(ballAroundTable, tmpIndex - 10)
    end
    
    if tmpIndex % 10 ~= 1 and ballGroup[tmpIndex - 11] and ballGroup[tmpIndex].color == ballGroup[tmpIndex - 11].color then
      table.insert(ballAroundTable, tmpIndex - 11)
    end
    
    if tmpIndex % 10 ~= 1 and ballGroup[tmpIndex - 1] and ballGroup[tmpIndex].color == ballGroup[tmpIndex - 1].color then
      table.insert(ballAroundTable, tmpIndex - 1)
    end
    
    if tmpIndex % 10 ~= 0 and ballGroup[tmpIndex + 1] and ballGroup[tmpIndex].color == ballGroup[tmpIndex + 1].color then
      table.insert(ballAroundTable, tmpIndex + 1)
    end

    if tmpIndex % 10 ~= 1 and ballGroup[tmpIndex + 9] and ballGroup[tmpIndex].color == ballGroup[tmpIndex + 9].color then
      table.insert(ballAroundTable, tmpIndex + 9)
    end

    if tmpIndex % 10 ~= 0 and ballGroup[tmpIndex + 10] and ballGroup[tmpIndex].color == ballGroup[tmpIndex + 10].color then
      table.insert(ballAroundTable, tmpIndex + 10)
    end
    
  end

  return ballAroundTable
end

local function onCollision(self, event)
  if (event.phase == "began") then
    if (event.other.myName ~= "ceiling" and event.other.myName ~= "floor" 
      and event.other.myName ~= "leftWall" and event.other.myName ~= "rightWall") then
      
      local tmpShit
      for i = 1, #ballGroup, 1 do
        if ballGroup[i] == event.other then
          tmpShit = i
          break
        end
      end
      
      print(tmpShit)
      
      timer.performWithDelay(0, transitionBall)
      
      local tmpIndex
      
      if (self.color == event.other.color) then
        for i = 1, #ballGroup, 1 do
          if ballGroup[i] == event.other then
            tmpIndex = i
            break
          end
        end
        
        local ballAroundTable = {}
        ballAroundTable = checkBallAround(tmpIndex)
        
        local queueTable = {}
        local processedTable = {}
        
        if #ballAroundTable > 0 then
          table.insert(processedTable, tmpIndex)
          
          for j = 1, #ballAroundTable, 1 do
            table.insert(queueTable, ballAroundTable[j])
            table.insert(processedTable, ballAroundTable[j])
          end
          
          while #queueTable > 0 do
            local tmpQueueTable = checkBallAround(queueTable[1])
            for k = 1, #tmpQueueTable, 1 do
              local found = false
              
              for l = 1, #processedTable, 1 do
                if (tmpQueueTable[k] == processedTable[l]) then
                  found = true
                  break
                end
              end
              
              if (found == false) then
                table.insert(queueTable, tmpQueueTable[k])
                table.insert(processedTable, tmpQueueTable[k])
              end
            end
            
            table.remove(queueTable, 1)
          end
        end
        
        for i = 1, #processedTable, 1 do
          --print(processedTable[i])
          ballGroup[processedTable[i]]:removeSelf()
        end
        
      end
    end
  end
end

background = display.newImageRect("menuBG.jpg", 320, 480)
background.x = display.contentCenterX
background.y = display.contentCenterY

mainBall = display.newCircle(160,430, 16)
addColor(mainBall)
physics.addBody(mainBall, "dynamic", {friction = 0.5, bounce = 0, radius = 16} )

mainBall.collision = onCollision
mainBall:addEventListener("collision")

local xPos = 16
local yPos = 16
local startIndex = 1
local endIndex = 10

for i = 1, 7 do
  if i % 2 == 1 then
    for j = startIndex, endIndex do
      local ball = display.newCircle(xPos, yPos, 16)
      addColor(ball)
      
      ballGroup[j] = ball
      
      physics.addBody(ball, "static", {friction = 0.5, bounce = 0, radius = 16} )
      xPos = xPos + 32
    end
    
    startIndex = endIndex + 1
    endIndex = endIndex + 9
    
    xPos = 32
    yPos = yPos + 28
  else
    for j = startIndex, endIndex do
      local ball = display.newCircle(xPos, yPos, 16)
      addColor(ball)
      
      ballGroup[j] = ball
      
      physics.addBody(ball, "static", {friction = 0.5, bounce = 0, radius = 16} )
      xPos = xPos + 32
    end
    
    startIndex = endIndex + 2
    endIndex = endIndex + 11
    
    xPos = 16
    yPos = yPos + 28
  end
end

Runtime:addEventListener("touch", tapBall)