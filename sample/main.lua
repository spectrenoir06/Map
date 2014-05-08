local Map		= require 'Map'

function love.load()
	
	maptest = Map:new("map/exemple.json","map/tileset.png")

end

function love.draw()

	maptest:draw(0,0) 												-- draw map
	
	local mouseX = math.floor(love.mouse.getX()/32) 				-- get the mouse coord X in tile coord
	local mouseY = math.floor(love.mouse.getY()/32)					-- get the mouse coord Y in tile coord
	local tiles = maptest:getTile(mouseX,mouseY)					-- get tiles at the mouse coord  = {tile1 , tile2}
	
	love.graphics.print((tile[1]),10, 10) 							-- print id of tile under the mouse
	love.graphics.print((tile[2]),10, 25) 							-- print id of tile under the mouse

end

function love.mousepressed(x,y,button)
	
	local mouseX, mouseY = math.floor(x/32), math.floor(y/32)		-- get the mouse coord in tile coord
	local tiles = maptest:getTile(mouseX,mouseY)					-- get tiles at the mouse coord  = {tile1 , tile2}
	
	if button == 'l' then											-- if mouse click left
		maptest:setTile(mouseX,mouseY,tiles[2]+1,2)					-- increase tile under the mouse
	elseif button == "r" then										-- if mouse click right
		maptest:setTile(mouseX,mouseY,tiles[2]-1,2) 				-- decrease tile under the mouse
	end

end

