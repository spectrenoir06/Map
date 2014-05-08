Map	= require 'Map'

function love.load()
	maptest = Map:new("map/exemple.json","map/tileset.png")
end

function love.draw()
	maptest:draw(0,0)
end

function love.update(dt)

end

function love.keypressed(key, code)
  
end

function love.keyreleased(key, code)
  
end

function love.mousepressed(x,y,button)
  
end

function love.mousereleased(x,y,button)
  
end

function love.quit()
	
end

