--- Menu
-- 
-- The menu for the application GetSmart
--
-- !! Contains main menu functions and variables until side menu is fully functional and tested !!

-- Require the grafics library and setting the background color
local gfx = require "gfx"
--gfx.screen
-- -- :clear({255,255,255}) --RGB
local background = gfx.loadpng('./images/background.png')
gfx.screen:copyfrom(background, nil)

gfx.update()

-- set boolean controlling if side menu is showing to false
sideMenu = false

-- Create a new surface with 33% width and 100% height of the screen
local sideMenuSrfc = gfx.new_surface(gfx.screen:get_width() / 3, gfx.screen:get_height())
local transparentSrfc = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
local mainSrfc = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())

-- All main menu items as .png pictures as transparent background with width and height variables
local png_menu_circle_width = 149
local png_menu_circle_height = 147
local png_menu_circles = {
  game1 = 'images/menu/main-menu_math.png',
  game2 = 'images/menu/main-menu_memory.png',
  game3 = 'images/menu/main-menu_spelling.png',
  game4 = 'images/menu/main-menu_geography.png'
}

-- All side menu items as .png pictures as transparent background with width and height variables
local png_side_menu_circle_width = 115
local png_circle_height = 112
local png_side_menu_circles = {
  game1 = 'images/side-menu/side-menu-math.png',
  game2 = 'images/side-menu/side-menu-memory.png',
  game3 = 'images/side-menu/side-menu-spelling.png',
  game4 = 'images/side-menu/side-menu-geography.png',
  game5 = 'images/side-menu/side-menu-users.png'
}

-- Logotype as .png pictuere with transparent background with width variable
local png_logo_width = 447
local png_logo = 'images/logo.png'

-- Directory of images
local dir = './'

function printSideMenu()

	local function printTransparentSurface()

		transparentSrfc:clear() -- Initializes transparentSrfc
		transparentSrfc:fill({0, 0, 0, 127}) --RGBA -- should be 50% transparent
		gfx.screen:copyfrom(transparentSrfc, nil, {x=0, y=0}) -- Prints transparentSrfc

	end
	
	local function printsideMenuSurface()

		local toScreen = nil
		local gameCounter = 1
	
		sideMenuSrfc:clear() -- Initializes sideMenuSrfc
	
		sideMenuSrfc:fill({100, 100, 100}) --RGB
	
		gfx.screen:copyfrom(sideMenuSrfc, nil, {x=0, y=0}) -- Prints sideMenuSrfc
	
		-- Prints menu items
		for i = 35, 650, 145 do
			toScreen = gfx.loadpng(dir..png_side_menu_circles['game'..gameCounter])
			printCircle(toScreen, (gfx.screen:get_width()/3)/2-(png_side_menu_circle_width/2), i)
			gameCounter = gameCounter+1
		end
	end

	printTransparentSurface()
	printsideMenuSurface()
	
	gfx.update()
	
end

-- Prints main menu
function printMenuCircles()

	-- Prints circle according to img, x and y values
	function printCircle(img, xIn, yIn)
		local scale = 0.5
		gfx.screen:copyfrom(img, nil, {x=xIn, y=yIn, w=img:get_width()*scale, h=img:get_height()*scale})
	end

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

-- Prints logotype in the middle of the screen
function printLogotype()
	
	local toScreen = nil
	
	toScreen = gfx.loadpng(dir..png_logo)
	scale = 0.5
	gfx.screen:copyfrom(toScreen, nil, {x=gfx.screen:get_width()/2-(toScreen:get_width()/2 *scale), y=100 ,w =toScreen:get_width() *scale , h= toScreen:get_height() *scale})
	gfx.update()

end

-- Copys graphics from main surface (in this case main menu) to the surface mainSrfc
function setMainSrfc()

	mainSrfc:clear()
	mainSrfc:copyfrom(gfx.screen, nil, {x=0, y=0})

end

-- Changes from active surface to mainSrfc (which can be seen as the previous "state")
function changeSrfc()

	gfx.screen:copyfrom(mainSrfc, nil, {x=0, y=0})
	gfx.update()

end

-- Gets input from user and executes chosen script
function onKey(key,state)
 if state == 'down' then

  elseif state == 'up' then
	  if(key == 'red') then
        sideMenu = false
        dofile('mathGame.lua')
      elseif(key == 'green') then
        sideMenu = false
        dofile('memoryGame.lua')
      elseif(key == 'yellow') then
        sideMenu = false
        dofile('spellingGame.lua')
      elseif(key == 'blue') then
        sideMenu = false
        dofile('geographyGame.lua')
	  elseif(key=='M') then
	  	if(not sideMenu) then
	  		sideMenu = true
	  		setMainSrfc()
	  		printSideMenu()
	  	else
	  		sideMenu = false
	  		changeSrfc()
	  	end
	  end
  end
end

-- Main function that runs the program
local function main()

  printMenuCircles()  
  printLogotype()

end


main()