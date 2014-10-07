gfx = require "gfx"
gfx.screen:clear({255,255,255}) --RGB
gfx.update()

png_circle_width = 160
png_circle_height = 160
png_circles = { game1 = 'images/menu-math.png',
	game2 = 'images/menu-flags.png',
	game3 = 'images/menu-memory.png',
	game4 = 'images/menu-spelling.png',
}
png_logo_width = 447
png_logo = 'images/logo.png'

dir = './'

function printMenuCircles()

	local toScreen = nil
	
	local gameCounter = 1

	-- Prints menu items
	for i = 50, 1000, 250 do
		toScreen = gfx.loadpng(dir..png_circles['game'..gameCounter])
		printCircle(toScreen, i, 450)
		gameCounter = gameCounter + 1
	end
	
	-- Prints logo
	toScreen = gfx.loadpng(dir..png_logo)
	gfx.screen:copyfrom(toScreen, nil, {x=gfx.screen:get_width()/2-(png_logo_width/2), y=100})

	gfx.update()

end

function printCircle(img, xIn, yIn)

	gfx.screen:copyfrom(img, nil, {x=xIn, y=yIn})

end

local function main()

  printMenuCircles()
  


end

main()