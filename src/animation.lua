animation = {}

gfx = require "gfx"
--local background = gfx.loadpng('./images/background.png')
--gfx.screen:copyfrom(background,nil)
circle = gfx.loadpng('./images/menu/main-menu_math.png')


--- Zooms a part of the surface
-- Creates a zoom effect
-- @param background The background surface
-- @param surface The surface that is to bee zoomed
-- @param x The horizontal placement on the background where the surface is placed
-- @param y The vertical placement on the background where the surface is placed
-- @param zoom The scale to where the zoom should end, 1 = 100%, 2 = 200%
-- @param speed The amount of seconds from start of animation to end.
function animation.zoom(background, surface, x, y, zoom, speed)
	partBackground = gfx.new_surface(surface:get_width(), surface:get_height())
	partBackground:copyfrom(background, {x=x, y=y,w=surface:get_width(), h=surface:get_height()})
	zoom = math.sqrt(zoom)

	if zoom < 0.01 and speed == 0 then
		finalHeight = 0
		finalWidth = 0
	else			
		finalWidth = surface:get_width() * zoom
		diffWidth = finalWidth - surface:get_width()
		deltaWidth = diffWidth / 100

		finalHeight = surface:get_height() * zoom
		diffHeight = finalHeight -surface:get_height()
		deltaHeight = diffHeight / 100

		proportion = deltaWidth / deltaHeight
	end

	if speed == 0 then
		gfx.screen:copyfrom(partBackground,nil,{x=x, y=y})
		gfx.screen:copyfrom(surface,nil,{x=x - diffWidth/2, y=y - diffHeight/2, w=finalWidth, h= finalHeight}, true)		
	else
		for i = deltaWidth, diffWidth, deltaWidth do
			gfx.screen:copyfrom(partBackground,nil,{x=x, y=y})
			gfx.screen:copyfrom(surface, nil, {x=x - i/2,y=y - i/2, 
				w=surface:get_width() + i, h=surface:get_height() + i/proportion}, true )

			gfx.update()

			sleep(speed*deltaWidth/ diffWidth)
		end
	end
	partBackground:destroy()
end

--- Change the size and position of the circles
-- @param #surface background The background surface
-- @paran #surface surface The surface with the circle
-- @param #integer x current x-position of circle
-- @param #integer y current y-position of circle
-- @param #integer orginX x-position of circle with order 1
-- @param #integer orginY y-position of circle with order 1
-- @param #float scale how much the circle should be scaled
-- @param #integer order the order of separation from order 1
-- @param #string direction up or down, direction from circle with order 1
function animation.changeSize(background, surface, x, y, originX, originY, scale, order, direction)
	partBackground = gfx.new_surface(surface:get_width(), surface:get_height())
	partBackground:copyfrom(background, {x=x, y=y,w=surface:get_width(), h=surface:get_height()})
	
	local scale = math.sqrt(scale)
	local height = surface:get_height()

	local newX = originX + height*(0.5 - 0.5 * scale^(order-1))
	
	local newY = 0
	if direction == 'up' then
		newY = originY - height*((scale^order - scale) / (scale - 1))
	elseif direction == 'down' then
		newY = originY + height *((scale^(order-1) - 1) / (scale - 1))
	end
	
	zoom = scale^(order-1)

	finalWidth = surface:get_width() * zoom
	
	finalHeight = surface:get_height() * zoom
	
	gfx.screen:copyfrom(partBackground,nil,{x=x, y=y})
	gfx.screen:copyfrom(surface,nil,{x= newX, y= newY, w=finalWidth, h= finalHeight}, true)		

	partBackground:destroy()
end

--- dalay function
--@param #float time how long the delay will be
function sleep(time)
  local t0 = os.clock()
  while os.clock() < (t0 +time) do end
end

return animation

