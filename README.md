Map
===

Map lib for Löve

Function
----

Map:new(mapFile,tilesetFile)
--------------
```lua
myMap = Map:new("map.json","tileset.png") -- create new map
```

Map:draw(x,y)
--------------
```lua
myMap = Map:draw(0,0) -- draw all layer on 0,0
```

Map:drawLayers(x,y,layers)
--------------
```lua
myMap:drawLayers(0,0,{1,2,3}) -- draw layer 1,2,3 on 0,0
```

Map:getTile(x,y)
--------------
```lua
tiles = myMap:getTile(0,0) -- tile = {tileLayer1, tileLayer2, ... , tileLayerN )
```


Map:setTile(x,y,id,map)
--------------
```lua
tiles = myMap:setTile(0,0,10,1) -- change tile on 0,0 to 10 on layers 1
```

Map:reload()
--------------
```lua
myMap:Map:reload()-- reload the map from file
```

Exemple
---------------
```lua
local Map = require 'lib.map.Map'

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
```
