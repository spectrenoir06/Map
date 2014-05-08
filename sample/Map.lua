local json = require "json"
local inspect = require "inspect"

local Map = {}
Map.__index = Map


local function map_read(tab)
	
	local layers = {}
	
	--print(tab)
	
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
		--print(inspect(a.layers))
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
	
   -- for k,v in pairs(a.tab.layers[4]) do
	--	print(k,v)
	--end
	
	--[[
	
    a.data = a.json.layers[4].objects
    a["pnj"] = {}
    a["obj"] = {}
    
    for k,v in ipairs(a.data) do
        if v.type=="pnj" then
            table.insert(a.pnj,{ data = data.pnj[tonumber(v.properties.id)] , x=v.x/64 , y=v.y/64 } )
        elseif v.type=="obj" then
            table.insert(a.obj,{ data = data.obj[tonumber(v.properties.id)] , x=v.x/64 , y=v.y/64 } )
        end
    end
    
    for k,v in ipairs(a.pnj) do
        v.sprite = sprite_new("textures/"..resolution.."/"..v.data.skin,resolution,resolution)
    end
	
	--]]

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
	for k,v in ipairs(self.spriteBatchs) do
		love.graphics.draw(v,math.floor(x),math.floor(y))
	end
    
    -- for k,v in ipairs(self.pnj) do
        -- v.sprite:drawframe((v.x*resolution),(v.y*resolution),1)
    -- end
	
	-- for x=1,self.LX do
		-- for y=1,self.LY do
			-- --print(self.map_col[x][y])
			-- love.graphics.print(self.map_col[y][x],(x-1)*64+32,(y-1)*64+32)
			-- --love.graphics.rectangle( "line", (x)*64, (y)*64, 64, 64 )
		-- end
	-- end
	
end

function Map:drawdeco(x,y)
    love.graphics.draw(self.spriteBatch_deco,math.floor(x),math.floor(y))
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
    self.map_sol=nil
    self.map_block=nil
    self.map_sol=map_read(map_sol.file)
    self.map_block=map_read(map.file)
    self:update() 
end

------------------

function Map:getLX()
    return self.LX
end

function Map:getLY()
    return self.LY
end

------PNJ------
--[[
function map:getPnj(tileX,tileY)
    if tileX<0 or tileY<0 or tileX>=self.LX or tileY>=self.LY then
        return nil
    else
        for k,v in ipairs(self.pnj) do
            if v.x==tileX and v.y==tileY then
                return v
            end
        end
    end
end

-----Obj-----

function map:getObj(tileX,tileY)
    if tileX<0 or tileY<0 or tileX>=self.LX or tileY>=self.LY then
        return false
    else
        for k,v in ipairs(self.obj) do
            if v.x==tileX and v.y==tileY then
                return v
            end
        end
    end
end

function map:scancol(tilex,tiley) -- return true si colision
	local block = self:getblock(tilex,tiley)
	local blockDataSol = data.tab[block.idsol]
	local blockDataBlock = data.tab[block.idblock]
	if block.idblock==nil or block.idsol==nil then
		return false
	else
		return not blockDataSol.pass or not blockDataBlock.pass or block.pnj
	end
end

function map:getblock(tilex,tiley)

        local idsol, idblock, iddeco = self:gettile(tilex,tiley)
        local pnj = self:getPnj(tilex,tiley)
        local obj = self:getObj(tilex,tiley)
		local tab =
		{pnj=pnj,
		 idsol = idsol,
		 idblock = idblock,
		 iddeco = iddeco,
		 obj = obj,
		 pnj = pnj,
		 tilex=tilex,
		 tiley=tiley,
		}
        return tab
end

function map:createMapCol()

	self.map_col = {}
	for y=0,self.LY-1 do
		self.map_col[y] = {}
		for x=0,self.LX-1 do
			if self:scancol(x,y) then
				self.map_col[y][x] = 1 
			else
				self.map_col[y][x] = 0
			end
		end
	end
	
	self.grid = Grid(self.map_col)
	self.pathfinder = Pathfinder(self.grid, 'JPS',0)
	self.pathfinder:setMode('ORTHOGONAL')
	self.pathfinder:setHeuristic('CARDINTCARD')
	
end


]]--

return Map