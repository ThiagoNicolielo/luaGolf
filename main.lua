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
local ball
local taxaDesaceleracao = 1
display.setStatusBar ( display.HiddenStatusBar)

function constroiCaixa(hasBotao)
    local obCaixa = display.newGroup()
    local parteE1 = display.newRect(obCaixa, 00, 125, 130, 5)
    local parteE2 = display.newRect(obCaixa, 00, 130, 90, 20)
    local parteE3 = display.newRect(obCaixa, 00, 150, 130, 5)
    local parteD1 = display.newRect(obCaixa, 190, 125, 130, 5)
    local parteD2 = display.newRect(obCaixa, 230, 130, 90, 20)
    local parteD3 = display.newRect(obCaixa, 190, 150, 130, 5)
    parteMovel = display.newRect(obCaixa, 90, 130, 140, 20)
    parteMovel:setFillColor(220, 150, 0, 255)
    if (hasBotao) then
        botao = display.newRect(obCaixa, 200, 152, 40, 10)
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

function constroiBancoAreia(x, y)
    local areia = display.newImage("areia.png")
    areia:setReferencePoint(display.TopRightReferencePoint)
    areia.x = x --130
    areia.y = y --240
    ball:toFront()
    local limite1 = display.newRect(35, 250, 15, 70)
    limite1.isVisible = false
    local limite2 = display.newRect(50, 240, 30, 100)
    limite2.isVisible = false
    local limite3 = display.newRect(80, 260, 15, 80)
    limite3.isVisible = false
    local limite4 = display.newRect(95, 280, 15, 55)
    limite4.isVisible = false  
    local limite5 = display.newRect(110, 290, 15, 40)
    limite5.isVisible = false
end

function alteraFriccao()
    xbegin, ybegin, xend, yend = 35, 240, 125, 340
--    local limiteExterno = display.newRect(xbegin, ybegin, xend - xbegin, yend - ybegin)
--    limiteExterno:setFillColor(255, 255, 255, 100)
    -- verifica se a bola esta na area maior (quadrada)
    if (ball.x > xbegin and ball.x < xend and ball.y > ybegin and ball.y < yend) then
        --verifica se a bola esta dentro da area mais aproximada da figura irregular
            xbeginl1, ybeginl1, xendl1, yendl1 = 35, 250, 50, 320
            xbeginl2, ybeginl2, xendl2, yendl2 = 50, 240, 80, 340
            xbeginl3, ybeginl3, xendl3, yendl3 = 80, 260, 95, 340
            xbeginl4, ybeginl4, xendl4, yendl4 = 95, 280, 110, 335
            xbeginl5, ybeginl5, xendl5, yendl5 = 110, 290, 125, 330
        if (ball.x>xbeginl1 and ball.x<xendl1 and ball.y>ybeginl1 and ball.y<yendl1 or 
            ball.x>xbeginl2 and ball.x<xendl2 and ball.y>ybeginl2 and ball.y<yendl2 or 
            ball.x>xbeginl3 and ball.x<xendl3 and ball.y>ybeginl3 and ball.y<yendl3 or 
            ball.x>xbeginl4 and ball.x<xendl4 and ball.y>ybeginl4 and ball.y<yendl4 or 
            ball.x>xbeginl5 and ball.x<xendl5 and ball.y>ybeginl5 and ball.y<yendl5) then
                taxaDesaceleracao = 2
        else
            taxaDesaceleracao = 1
        end
    else
        taxaDesaceleracao = 1
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
ball = display.newCircle (_W/2, 400, 10)
physics.addBody(ball, {density = 1, friction = 1})
physics.setGravity(0,0)
--obstaculo barra
--local ob1 = display.newRect (0, 150, 200, 20)
--physics.addBody (ob1, "static")
--obstaculo caixa
constroiCaixa(true)
--obstaculo areia
constroiBancoAreia(130, 240)


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


        
            newvx=newvx/taxaDesaceleracao
            newvy=newvy/taxaDesaceleracao
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
Runtime:addEventListener("enterFrame", alteraFriccao)




