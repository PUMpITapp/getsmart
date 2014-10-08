--- Side menu
-- 
-- The side menu for the application GetSmart
--
-- !! Contains main menu functions and variables until side menu is fully functional and tested !!


-- Require the grafics library and setting the background color
gfx = require "gfx"
gfx.screen:clear({255,255,255}) --RGB
gfx.update()

-- Create a new surface with the width of 1/3 of the screen
sideMenu = gfx.new_surface(gfx.screen:get_width()/3, gfx.screen:get_height())


-- All main menu items as .png pictures as transparent background with width and height variables
png_menu_circle_width = 149
png_menu_circle_height = 147
png_menu_circles = { game1 = 'images/menu/menu-math.png',
	game2 = 'images/menu/menu-flags.png',
	game3 = 'images/menu/menu-memory.png',
	game4 = 'images/menu/menu-spelling.png',
	game5 = 'images/menu/menu-user.png',
}

-- All side menu items as .png pictures as transparent background with width and height variables
png_side_menu_circle_width = 115
png_circle_height = 112
png_side_menu_circles = { game1 = 'images/side-menu/side-menu-math.png',
	game2 = 'images/side-menu/side-menu-flags.png',
	game3 = 'images/side-menu/side-menu-memory.png',
	game4 = 'images/side-menu/side-menu-spelling.png',
	game5 = 'images/side-menu/side-menu-user.png',
}

-- Logotype as .png pictuere with transparent background with width variable
png_logo_width = 447
png_logo = 'images/logo.png'


-- Directory of artwork
dir = './'


function printSideMenuBox()

	local toScreen = nil
	local gameCounter = 1
	
	sideMenu:clear() -- Initializes sideMenu
	
	sideMenu:fill({100, 100, 100}) --RGB
	
	gfx.screen:copyfrom(sideMenu, nil, {x=0, y=0}) -- Prints sideMenu
	
	-- Prints menu items
	for i = 35, 650, 145 do
		toScreen = gfx.loadpng(dir..png_side_menu_circles['game'..gameCounter])
		printCircle(toScreen, (gfx.screen:get_width()/3)/2-(png_side_menu_circle_width/2), i)
		gameCounter = gameCounter+1
	end
	
	gfx.update()
	
end

function hideSideMenu()

	--sideMenu:destroy()

	gfx.update()

end

-- Prints main menu
function printMenuCircles()

	local toScreen = nil
	local gameCounter = 1

	-- Prints menu items
	for i = 50, 1000, 250 do
		toScreen = gfx.loadpng(dir..png_menu_circles['game'..gameCounter])
		printCircle(toScreen, i, 450)
		gameCounter = gameCounter+1
	end
		
	gfx.update()

end

-- Prints circle according to img, x and y values
function printCircle(img, xIn, yIn)

	gfx.screen:copyfrom(img, nil, {x=xIn, y=yIn})

end

-- Prints logotype in the middle of the screen
function printLogotype()
	
	local toScreen = nil
	
	toScreen = gfx.loadpng(dir..png_logo)
	gfx.screen:copyfrom(toScreen, nil, {x=gfx.screen:get_width()/2-(png_logo_width/2), y=100})
	gfx.update()

end

-- Gets input from user and executes chosen script
function onKey(key,state)

  if(key == 'red') then
  	printSideMenuBox()
  elseif(key == 'green') then
  hideSideMenu()
--	dofile('flags.lua')  
  elseif(key == 'yellow') then
	dofile('memory.lua')
  elseif(key == 'blue') then
	dofile('spelling.lua')
  end
end

-- Main function that runs the program
local function main()

  printMenuCircles()  
  printLogotype()
    
end

main()