-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- requires
local physics = require "physics"
physics.start()


--backGround
  local screenGroup = self.view
  local background = display.newImage("bg.png")
  background.x = 240
  background.y = 160 

  city1 = display.newImage("city1.png")
  city1.x = 240
  city1.y = 160 + 50
  city1.speed = 1
  city2 = display.newImage("city1.png")
  city2.x = 720
  city2.y = 160 + 50
  city2.speed = 1

  city3 = display.newImage("city2.png")
  city3.x = 240
  city3.y = 160 + 110
  city3.speed = 2
  city4 = display.newImage("city2.png")
  city4.x = 720
  city4.y = 160 + 110
  city4.speed = 2
  
  jet = display.newImage("redJet.png")
  jet.x = 20
  jet.y = 30
  physics.addBody(jet, "dynamic", {density=0.1, bounce =.1, friction=.2, radius = 12})
  
  city1.enterFrame = scrollCity
  Runtime:addEventListener("enterFrame", city1)

  city2.enterFrame = scrollCity
  Runtime:addEventListener("enterFrame", city2)

  city3.enterFrame = scrollCity
  Runtime:addEventListener("enterFrame", city3)

  city4.enterFrame = scrollCity
  Runtime:addEventListener("enterFrame", city4)
  
  Runtime:addEventListener("touch", touchScreen)


function scrollCity(self, event)
  if self.x < -235 then
    self.x = 720
  else 
    self.x = self.x - self.speed
  end
end

function activateJets(self, event)
  self:applyForce(0, -1.5, self.x, self.y)
end

function touchScreen(event)
  if event.phase == "began" then
    jet.enterFrame = activateJets
    Runtime:addEventListener("enterFrame",jet)
  end
  
  if event.phase == "ended" then
    Runtime:removeEventListener("enterFrame",jet)
  end
end

  
  city1.enterFrame = scrollCity
  Runtime:addEventListener("enterFrame", city1)

  city2.enterFrame = scrollCity
  Runtime:addEventListener("enterFrame", city2)

  city3.enterFrame = scrollCity
  Runtime:addEventListener("enterFrame", city3)

  city4.enterFrame = scrollCity
  Runtime:addEventListener("enterFrame", city4)
  
  Runtime:addEventListener("touch", touchScreen)
  