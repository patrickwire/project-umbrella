local loadModule={}

function loadModule.loadLargeImage(path)
  local backgroundData,maxsize,height,width,tiles
  backgroundData = love.image.newImageData( path )

  --maxsize = love.graphics.getSystemLimit("texturesize")
  maxsize = 512
  height = backgroundData:getHeight()
  width = backgroundData:getWidth()

  tiles={}
  --print("height "..height)
  --print("width "..width)

  for x = 0, width/maxsize do
    for y = 0, height/maxsize do
      --print ("insert with x: "..x.." y: "..y)
      local tile = love.image.newImageData( maxsize,maxsize )
      tile:paste(backgroundData,0,0,x*maxsize,y*maxsize,maxsize,maxsize)
      table.insert(tiles,{image=love.graphics.newImage(tile),x=x,y=y,size=maxsize})
    end
  end
  --print ("anzahl tiles: "..#tiles)

  function tiles:getWidth()
    return width
  end

  function tiles:getHeight()
    return height
  end

  -- rotation wird ignoriert
  function tiles:draw(posx,posy,rorate,scalex,scaley)
    for i,v in ipairs(self) do
      --print("draw "..i)
      love.graphics.draw(v.image, posx+(v.x*(v.size*scalex)), posy+(v.y*(v.size*scaley)), 0 , scalex, scaley)
    end
  end

  return tiles
end

return loadModule
