--	Supports Graphics 2.0
--  Duc Luong @2014
---------------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
--physics.setDrawMode( "hybrid" )
local SCREEN_HEIGHT, SCREEN_WIDTH = display.contentHeight, display.contentWidth
local sky = display.newImage( "bkg_clouds.png", SCREEN_WIDTH/2, SCREEN_HEIGHT/2 )
sky:scale(2,2)
local tx=SCREEN_WIDTH/2
local ty = SCREEN_HEIGHT - 50
local textSize = 50
local ground = display.newImage( "ground.png", SCREEN_WIDTH/2, SCREEN_HEIGHT-35 )
ground:scale(2,1)
physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )
local numOfBall = 0
local MAX_BALLS = 26
local popSound = audio.loadStream("pop.wav")
local tadaSound = audio.loadStream("tada.wav")
local wooshSound = audio.loadStream("woosh1.wav")


local function addCage()
    local ceiling = display.newRect(SCREEN_WIDTH/2,-5,SCREEN_WIDTH,5)
    physics.addBody(ceiling, "static", {friction=0,bounce=.3})
    local leftWall = display.newRect(-5,SCREEN_HEIGHT/2,5,SCREEN_HEIGHT)
    physics.addBody(leftWall, "static", {friction=0,bounce=.3})
    local rightWall = display.newRect(SCREEN_WIDTH+5,SCREEN_HEIGHT/2,5,SCREEN_HEIGHT)
    physics.addBody(rightWall, "static", {friction=0,bounce=.3})
end
local popId = 0
local nextId = 0
local StatusText = display.newText("Next balloon: 0",tx,ty, native.systemFontBold, 22)
local balls = {}
local function onBallTouch(event)
if event.phase == "began" then
    if (event.target.name == popId) then
    table.remove(balls,event.target.name)
    event.target:removeSelf()
    numOfBall = numOfBall -1
    popId = popId+1
    audio.play(popSound)
    StatusText:removeSelf()
    StatusText = display.newText("Next balloon: " .. tostring(popId+1) ,tx,ty, native.systemFontBold, 22)
    else
    event.target:applyForce( 100, 100, event.target.x, event.target.y )
    audio.play(wooshSound)
    end
    if (numOfBall == 0)  then
        audio.play(tadaSound)
        StatusText:removeSelf()
        StatusText = display.newText("Congrats! All done." ,tx,ty, native.systemFontBold, 22)
    end
    print (numOfBall)
end
end
local function AddBall(event)
if (numOfBall < MAX_BALLS) then
    local num = math.random(1,6)
    local balloon = display.newImage("balloon-".. tostring(num)  ..".png")
    local text = display.newText(1+nextId,0,0, native.systemFontBold, 50)
    text:setFillColor(0)
    local group = display.newGroup()
    print (nextId)
    group.name = nextId
    nextId = nextId +1
    group:insert(balloon)
    group:insert(text)
    --local ovalShape = {1,65, 25, 100, 67, 125, 100, 123, 115,89, 113,41, 85,7, 43,3, 12, 22}
    local ovalShape = {-30, 41,-56,-10, -46, -46, -14, -65, 28, -56, 52, -28, 56, 17, 43,58, 6, 61}
    --local ovalShape = {-55, -1, -31, 34, 11, 59, 44, 57, 59, 23, 57, -25, 29, -59, -13, -63, -44, -44  }
    physics.addBody( group, { densty=1, friction=-5, bounce=.75,  shape=ovalShape})
    group.x = math.random(60,SCREEN_WIDTH-60)
    group.y = SCREEN_HEIGHT - 140
    group.gravityScale=-1
    group.linearDamping = .5
    group:addEventListener("touch",onBallTouch)
    numOfBall = numOfBall + 1
end
end
local function onGroudTouch( event )
if event.phase == "ended" then
    StatusText:removeSelf()
    StatusText = display.newText("Next balloon: " .. tostring(popId+1) ,tx,ty, native.systemFontBold, 22)
    timer.performWithDelay(50,AddBall,MAX_BALLS)
end
end
timer.performWithDelay(1,AddBall,MAX_BALLS)
ground:addEventListener("touch",onGroudTouch)
addCage()


