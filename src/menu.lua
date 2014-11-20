--- Menu
-- 
-- The start- and side menu for the application GetSmart
--

--- Checks if the file was called from a test file.
-- @return #boolean True or false depending on testing file  
function checkTestMode()
  runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
  return underGoingTest
end

--- Chooses either the actual or the stubs depending on if a test file started the program.
-- @param #Boolean underGoingTest undergoing test is true if a test file started the program.
function setRequire(underGoingTest)
  if not underGoingTest then
    gfx = require "gfx"
    text = require "write_text"
    animation = require "animation"
    profileHandler = require "profileHandler"
  elseif underGoingTest then 
    gfx = require "gfx_stub"
    text = require "write_text_stub"
    animation = require "animation_stub"
    profileHandler = require "profileHandler_stub"
  end
end 

local underGoingTest = setRequire(checkTestMode())

-- Imports and sets background
local background = gfx.loadpng('./images/background.png')
gfx.screen:copyfrom(background, nil)
gfx.update()

-- Boolean controlling if side menu is showing
sideMenu = false

-- String which holds what game is to be loaded
gamePath = ''

-- The number of the playing user
currentPlayer = ...

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

--- Prints the current player name in the top left corner
function printPlayerName()
	
	local playerName = profileHandler.getName(currentPlayer)

	local fw = text.getStringLength('lato', 'medium', "Logged in as: " .. playerName)
	local fh = text.getFontHeight('lato', 'medium')
	local position = 0.02

	text.print(gfx.screen, 'lato', 'black', 'medium', "Logged in as: " .. playerName, gfx.screen:get_width()*position, gfx.screen:get_height()*position, fw, fh)

end

--- Prints the side menu surface
function printsideMenuSurface()

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

--- Prints the transparent surface on top of gfx.screen
function printTransparentSurface()

	transparentSrfc:clear() -- Initializes transparentSrfc
	transparentSrfc:fill({0, 0, 0, 127}) --RGBA -- should be 50% transparent
	gfx.screen:copyfrom(transparentSrfc, nil, {x=0, y=0}) -- Prints transparentSrfc

end

--- Prints the side menu
function printSideMenu()

	printTransparentSurface()
	printsideMenuSurface()
	
	gfx.update()
	
end

--- Prints circle according to input
-- @param surface img The surface to be printed on
-- @param #number x The x-coordiante
-- @param #number y The y-coordinate
function printCircle(img, xIn, yIn)
	local scale = 0.5
	gfx.screen:copyfrom(img, nil, {x=xIn, y=yIn, w=img:get_width()*scale, h=img:get_height()*scale})
end

--- Prints the circles for the main menu
function printMenuCircles()

	local toScreen = nil
	local gameCounter = 1
	local verticalGrid = gfx.screen:get_width()/5

	-- Prints menu items
	for i = 1, 4, 1 do
		toScreen = gfx.loadpng(dir..png_menu_circles['game'..gameCounter])
		printCircle(toScreen, verticalGrid*i-(png_menu_circle_width/2), 450)
		gameCounter = gameCounter+1
	end
		
	gfx.update()

end

--- Prints the logotype in the middle of the screen
function printLogotype()
	
	local toScreen = nil
	
	toScreen = gfx.loadpng(dir..png_logo)
	scale = 0.5
	gfx.screen:copyfrom(toScreen, nil, {x=gfx.screen:get_width()/2-(toScreen:get_width()/2 *scale), y=100 ,w =toScreen:get_width() *scale , h= toScreen:get_height() *scale})
	gfx.update()

end

--- Copys graphics from main surface (in this case main menu) to the surface mainSrfc
function setMainSrfc()

	mainSrfc:clear()
	mainSrfc:copyfrom(gfx.screen, nil, {x=0, y=0})

end

--- Changes from active surface to mainSrfc (which can be seen as the previous "state")
function changeSrfc()

	gfx.screen:copyfrom(mainSrfc, nil, {x=0, y=0})
	gfx.update()

end
--- Gets input from user and re-directs according to input
-- @param key The key that has been pressed
-- @param state The state of the key-press
function onKey(key,state)
 if state == 'down' then

  elseif state == 'up' then
	  if(key == 'red') then
        sideMenu = false
        gamePath = 'mathGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == 'green') then
        sideMenu = false
        gamePath = 'memoryGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == 'yellow') then
        sideMenu = false
        gamePath = 'spellingGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == 'blue') then
        sideMenu = false
        gamePath = 'geographyGame.lua'
        runGame(gamePath, underGoingTest)
		end	  
  end
end

--- Runs chosen game (file) if testing mode is off
-- @param #string path The path to the game to be loaded
-- @param #boolean testingModeOn If testing mode is on
function runGame(path, testingModeOn)
	if(not testingModeOn) then
		assert(loadfile(path))(currentPlayer)
	end
end

-- Main function that runs the program
local function main()

	printPlayerName()
 	printMenuCircles()  
 	printLogotype()
end


main()