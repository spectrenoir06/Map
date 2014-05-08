	-- Dependencies
	local _PATH = (...):gsub('%.Map$','')
	require (_PATH .. '.json')

local Map = {}
Map.__index = Map


local function map_read(tab)
	
	local layers = {}
	
	for k,v in pairs(tab.layers) do
		layers[k] 			= {}
		layers[k].width 	= tab.layers[k].width
		layers[k].height 	= tab.layers[k].height
		layers[k].name 		= tab.layers[k].name	 
		layers[k].data 		= {}
				
		for i=0,tab.layers[k].width-1 do -- creation layers
			layers[k].data[i]={}
		end
		
		for y=0, tab.layers[k].height-1 do
			for x=0, tab.layers[k].width-1 do
				layers[k].data[x][y] = tab.layers[k].data[(y*tab.width)+x+1]-1
			end
		end
	end
	return layers
end
    
function Map:new(fichier,texture) --cree une map
    
	local a={}
    a.fichier 	= 	fichier
    a.json 			= 	json.decode(love.filesystem.read( fichier, nil ))
    a.layers 		= 	map_read(a.json)
	if texture==nil then texture = a.json.tilesets[1].image end
	
    a.LX			=	a.json.width
    a.LY			=	a.json.height
    a.tileset		=	love.graphics.newImage(texture)
    a.tileLX		=	a.json.tilewidth
    a.tileLY		=	a.json.tileheight
	a.tilesetLX		=	a.tileset:getWidth()
    a.tilesetLY		=	a.tileset:getHeight()
    
	a.tiles			=	{}
    for y=0,(a.tilesetLY/a.tileLY)-1 do
        for x=0,(a.tilesetLX/a.tileLX)-1 do
            a.tiles[x+(y*a.tilesetLX/a.tileLX)] = love.graphics.newQuad(x*a.tileLX,y*a.tileLY, a.tileLX, a.tileLY ,a.tilesetLX, a.tilesetLY)
        end
    end
	
	a.spriteBatchs = {}
	
	for k,v in pairs(a.layers) do
		a.spriteBatchs[k] = love.graphics.newSpriteBatch( a.tileset, a.LX*a.LY )
		a.spriteBatchs[k]:clear()
		
		for x=0,(a.LX)-1 do
			for y=0,(a.LY)-1 do
				local id = v.data[x][y]
				if id < 0 then print("error tile < 0 on "..v.name.." at ("..x..";"..y) id = 0 end   
				a.spriteBatchs[k]:add(a.tiles[id], x*a.tileLX, y*a.tileLY)
			end
        end
    end

    return setmetatable(a, Map)
end
    
    
    
function Map:update(nb)
    if nb then
        self.spriteBatchs[nb]:clear()
        for x=0,(self.LX)-1 do
            for y=0,(self.LY)-1 do
                local id = self.layers[nb].data[x][y]
				self.spriteBatchs[nb]:add(self.tiles[id], x*self.tileLX, y*self.tileLY)
			end
		end
    else
		for k,v in ipairs(self.spriteBatchs) do
			v:clear()
			for x=0,(self.LX)-1 do
				for y=0,(self.LY)-1 do
					local id = self.layers[nb].data[x][y]
					v:add(self.tiles[id], x*self.tileLX, y*self.tileLY)
				end
			end
		end
	end
end

function Map:draw(x,y)
	for k,v in pairs(self.spriteBatchs) do
		love.graphics.draw(v,math.floor(x),math.floor(y))
	end
end

function Map:drawLayers(x,y,layers)
	for k1,v2 in pairs(layers) do
		love.graphics.draw(self.spriteBatchs[v],math.floor(x),math.floor(y))
	end
end

function Map:getTile(x,y)
    if x<0 or y<0 or x>=self.LX or y>=self.LY then
        return nil
    else
		tile = {}
		for k,v in ipairs(self.layers) do
			tile[k] = v.data[x][y]
		end
        return tile
    end
end

function Map:setTile(x,y,id,map)
	if id >= 0 and id <= #self.tiles then
		if x<0 or y<0 or x>=self.LX or y>=self.LY then
			print("error x or y out of map")
			return nil
		end
		
		if map then
			self.layers[map].data[x][y]	=	id
			self:update(map)
		else
			self.layers[1].data[x][y]	=	id
			self:update(1)
		end
		
		return self:getTile(x,y,map)
	else
		print("error id")
		return nil
	end
end

function Map:reload()
	
	self.layers 	= nil
    self.layers 	= map_read(self.json)
    self:update() 

end

------------------

function Map:getLX()
    return self.LX
end

function Map:getLY()
    return self.LY
end

return Map