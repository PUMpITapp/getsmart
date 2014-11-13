animation = {}

--gfx = require "gfx"
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
	if zoom > 1 then
		return true
	else 
		return false
	end
end

function sleep(time)
  local t0 = os.clock()
  while os.clock() < (t0 +time) do end
end

return animation