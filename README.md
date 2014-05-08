Map
===

Map lib for Löve

Function
----

Map:new(mapFile,tilesetFile)
--------------
```sh
myMap = Map:new("map.json","tileset.png") -- create new map
```

Map:draw(x,y)
--------------
```sh
myMap = Map:draw(0,0) -- draw all layer on 0,0
```

Map:drawLayers(x,y,layers)
--------------
```sh
myMap:drawLayers(0,0,{1,2,3}) -- draw layer 1,2,3 on 0,0
```

Map:getTile(x,y)
--------------
```sh
tiles = myMap:getTile(0,0) -- tile = {tileLayer1, tileLayer2, ... , tileLayerN )
```


Map:setTile(x,y,id,map)
--------------
```sh
tiles = myMap:setTile(0,0,10,1) -- change tile on 0,0 to 10 on layers 1
```

Map:reload()
--------------
```sh
myMap:Map:reload()-- reload the map from file
```
