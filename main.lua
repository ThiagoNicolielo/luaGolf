-----------------------------------------------------------------------------------------
--
-- main.lua
-- 
-----------------------------------------------------------------------------------------

-- Your code here
-- 17/08/2013

local _W = display.contentWidth
local _H = display.contentHeight
local physics = require("physics")
local gameUI = require("gameUI")
display.setStatusBar ( display.HiddenStatusBar)

function constroiCaixa(hasBotao)
    local obCaixa = display.newGroup()
    local parteE1 = display.newRect(obCaixa, 00, 195, 130, 5)
    local parteE2 = display.newRect(obCaixa, 00, 200, 90, 20)
    local parteE3 = display.newRect(obCaixa, 00, 220, 130, 5)
    local parteD1 = display.newRect(obCaixa, 190, 195, 130, 5)
    local parteD2 = display.newRect(obCaixa, 230, 200, 90, 20)
    local parteD3 = display.newRect(obCaixa, 190, 220, 130, 5)
    parteMovel = display.newRect(obCaixa, 90, 200, 140, 20)
    parteMovel:setFillColor(255, 100, 0, 150)
    if (hasBotao) then
        botao = display.newRect(obCaixa, 200, 222, 40, 10)
        botao:setFillColor(255, 0, 0, 255)
        botao.isOpen = false
    end
    physics.addBody(parteE1, "static")
    physics.addBody(parteE2, "static")
    physics.addBody(parteE3, "static")
    physics.addBody(parteD1, "static")
    physics.addBody(parteD2, "static")
    physics.addBody(parteD3, "static")
    physics.addBody(parteMovel, "static")
    physics.addBody(botao, "static")
    physics.addBody(obCaixa, "static")
end


local function abrePorta()
    parteMovel:setReferencePoint(display.CenterLeftReferencePoint)
    while (not isOpen) do
        transition.to(parteMovel, {time=1500, x=190})
        isOpen = true
    end
        

end


physics.start()
local bg = display.newImage ("grassbg.png", true)
--physics.addBody(bg)
bg.x = display.contentCenterX
bg.y = display.contentCenterY
--buraco
local hole = display.newCircle (_W/2, 100, 17)
hole:setFillColor(0,0,0)
--bola
local ball = display.newCircle (_W/2, 400, 10)
physics.addBody(ball, {density = 1, friction = 1})
physics.setGravity(0,0)
--obstaculo barra
--local ob1 = display.newRect (0, 150, 200, 20)
--physics.addBody (ob1, "static")
--obstaculo caixa
constroiCaixa(true)

system.activate( "multitouch" )
local function dragBody( event )
	return gameUI.dragBody( event )
	
	-- Substitute one of these lines for the line above to see what happens!
	--gameUI.dragBody( event, { maxForce=400, frequency=5, dampingRatio=0.2 } ) -- slow, elastic dragging
	--gameUI.dragBody( event, { maxForce=20000, frequency=1000, dampingRatio=1.0, center=true } ) -- very tight dragging, snaps to object center
end
function ballFriction()
	ball.angularVelocity=0
	local vx, vy=ball:getLinearVelocity()
	if (vx ~=0 or vy ~=0)then

	    local newvx=vx*(1 - (10000)/((vx*vx)+(vy*vy)))
	    local newvy=vy*(1 - (10000)/((vx*vx)+(vy*vy)))
	    if ((newvy/vy)<0 or (newvx/vx)<0)then
	    	newvy=0
	    	newvx=0
	    end
	    if (ball.x > display.contentWidth - 10 or ball.x < 10) then
                newvx = newvx * -1;
        end
        if (ball.y > display.contentHeight - 10 or ball.y < 10) then
                newvy = newvy * -1;
        end




	    ball:setLinearVelocity(newvx,newvy)
	end
	
end

function ballEnteredHole()
	if (math.abs(hole.x-ball.x)<12 and math.abs(hole.y-ball.y)<17)then
		ball.alpha=0
		goodOne = display.newText ("You Win!", _W/2-20, _H/2)
	end
end
        
function botaoApertado()
    botao:setReferencePoint(display.BottomCenterReferencePoint)
    if (math.abs(botao.x - ball.x) < 20 and math.abs(botao.y - ball.y) < 30) then
                abrePorta()
    end

end
ball:addEventListener( "touch", dragBody )
Runtime:addEventListener( "enterFrame", ballFriction)
Runtime:addEventListener( "enterFrame", ballEnteredHole)
Runtime:addEventListener("enterFrame", botaoApertado)




