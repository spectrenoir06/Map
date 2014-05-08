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
