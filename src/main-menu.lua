--- Main menu
-- 
-- The main menu for the application GetSmart


-- Require the grafics library and setting the background color
gfx = require "gfx"
gfx.screen:clear({255,255,255}) --RGB
gfx.update()


-- All menu items as .png pictures as transparent background
png_circles = { game1 = 'images/menu-math.png',
	game2 = 'images/menu-flags.png',
	game3 = 'images/menu-memory.png',
	game4 = 'images/menu-spelling.png',
}

-- Logotype as .png pictuere with transparent background with width
png_logo_width = 447
png_logo = 'images/logo.png'


-- Directory of artwork
dir = './'

-- Prints main menu
function printMenuCircles()

	local toScreen = nil
	local gameCounter = 1

	-- Prints menu items
	for i = 50, 1000, 250 do
		toScreen = gfx.loadpng(dir..png_circles['game'..gameCounter])
		printCircle(toScreen, i, 450)
		gameCounter = gameCounter+1
	end
	
	-- Prints logo
	toScreen = gfx.loadpng(dir..png_logo)
	gfx.screen:copyfrom(toScreen, nil, {x=gfx.screen:get_width()/2-(png_logo_width/2), y=100})

	gfx.update()

end

-- Print circle according to img, x and y values
function printCircle(img, xIn, yIn)

	gfx.screen:copyfrom(img, nil, {x=xIn, y=yIn})

end

-- Gets input from user and executes chosen script
function onKey(key,state)

  if(key == 'red') then
  	dofile('math.lua')
  elseif(key == 'green') then
	dofile('flags.lua')  
  elseif(key == 'yellow') then
	dofile('memory.lua')
  elseif(key == 'blue') then
	dofile('spelling.lua')
  end
end

-- Main function that runs the program
local function main()

  printMenuCircles()
  
end

main()