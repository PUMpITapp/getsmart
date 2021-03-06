--- Menu
-- 
-- The start- and side menu for the application GetSmart
--

require "runState"
--- Checks if the file was called from a test file.
-- Returs true if it was, 
--   - which would mean that the file is being tested.
-- Returns false if it was not,
--   - which wold mean that the file was being used.  
function checkTestMode()
 --[[ runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
  return underGoingTest --]]
  underGoingTest = false
end

--- Chooses either the actual or the stubs depending on if a test file started the program.
-- @param underGoingTest undergoing test is true if a test file started the program.
function setRequire(underGoingTest)
  if not underGoingTest then
  	if not runsOnSTB then
    	gfx = require "gfx"
    end
    text = require "write_text"
--  animation = require "animation"
    profileHandler = require "profileHandler"
  elseif underGoingTest then 
    gfx = require "gfx_stub"
    text = require "write_text_stub"
    animation = require "animation_stub"
    profileHandler = require "profileHandler_stub"
  end
end 

setRequire(checkTestMode())

-- Imports and sets background
local background = gfx.loadpng('images/background.png')
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
background:destroy()


--gfx.update()

--gfx.screen:clear({122,219,228})
--gfx.update()

--[[if not runsOnSTB then
  dir = "" 
else
  dir = sys.root_path()
end--]]
-- Boolean controlling if side menu is showing
sideMenu = false

-- String which holds what game is to be loaded
gamePath = ''

-- The number of the playing user
currentPlayer = ...

-- Create a new surface with 33% width and 100% height of the screen
--local sideMenuSrfc = gfx.new_surface(gfx.screen:get_width() / 3, gfx.screen:get_height())
--local transparentSrfc = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
--local mainSrfc = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())

-- All main menu items as .png pictures as transparent background with width and height variables
local png_menu_circle_width = 149
local png_menu_circle_height = 147
local imgDir = 'images/menu/'
local png_menu_circles = {
  game1 = imgDir..'main-menu_math.png',
  game2 = imgDir..'main-menu_memory.png',
  game3 = imgDir..'main-menu_spelling.png',
  game4 = imgDir..'main-menu_geography.png'
}

-- All side menu items as .png pictures as transparent background with width and height variables
local png_side_menu_circle_width = 115
local png_circle_height = 112
--[[local png_side_menu_circles = {
  game1 = 'side-menu-math.png',
  game2 = 'side-menu-memory.png',
  game3 = 'side-menu-spelling.png',
  game4 = 'side-menu-geography.png',
  game5 = 'side-menu-users.png'
}]]

-- Logotype as .png pictuere with transparent background with width variable
local png_logo_width = 447
local png_logo = 'images/logo.png'
local png_school_logo = 'images/liu.png'

-- Directory of images
--local dir = './'

function printPlayerName()
	
	 playerName = profileHandler.getName(currentPlayer)


	local fw = text.getStringLength('lato', 'medium', "Welcome " .. playerName)
	local fh = text.getFontHeight('lato', 'medium')
	local position = 0.02

	text.print(gfx.screen, 'lato', 'black', 'medium', "Welcome " .. playerName, gfx.screen:get_width()*position, gfx.screen:get_height()*position, fw, fh)

end


--[[
-- Prints the side menu
function printSideMenu()

-- Prints the side menu
local function printsideMenuSurface()

	local toScreen = nil
	local gameCounter = 1

	sideMenuSrfc:clear() -- Initializes sideMenuSrfc

	sideMenuSrfc:fill({100, 100, 100}) --RGB

	gfx.screen:copyfrom(sideMenuSrfc, nil, {x=0, y=0}, true) -- Prints sideMenuSrfc
	sideMenuSrfc:destroy()

	-- Prints menu items
	for i = 35, 650, 145 do
		toScreen = gfx.loadpng(png_side_menu_circles['game'..gameCounter])
		toScreen:premultiply()
		printCircle(toScreen, (gfx.screen:get_width()/3)/2-(png_side_menu_circle_width/2), i)
		gameCounter = gameCounter+1
	end

end

-- Prints the transparent surface above the gfx.screen
local function printTransparentSurface()

	transparentSrfc:clear() -- Initializes transparentSrfc
	transparentSrfc:fill({0, 0, 0, 127}) --RGBA -- should be 50% transparent
	gfx.screen:copyfrom(transparentSrfc, nil, {x=0, y=0}, true) -- Prints transparentSrfc
	transparentSrfc:destroy()

end

	--printTransparentSurface()
	--printsideMenuSurface()
	
	--gfx.update()
	
end
--]]

-- Prints main menu
function printMenuCircles()

	-- Prints circle according to img, x and y values
	function printCircle(img, xIn, yIn)
		local scale = 0.5
		gfx.screen:copyfrom(img, nil, {x=xIn, y=yIn, w=img:get_width()*scale, h=img:get_height()*scale}, true)
		img:destroy()
	end

	local toScreen = nil
	local gameCounter = 1
	local verticalGrid = gfx.screen:get_width()/5

	-- Prints menu items
	for i = 1, 4, 1 do
		toScreen = gfx.loadpng(png_menu_circles['game'..gameCounter])
		toScreen:premultiply()
		printCircle(toScreen, verticalGrid*i-(png_menu_circle_width/2), 450)
		gameCounter = gameCounter+1
	end
		
	gfx.update()

end

-- Prints logotype in the middle of the screen
function printLogotype()
	
	local toScreen = nil
	
	toScreen = gfx.loadpng(png_logo)
	toScreen:premultiply()
	scale = 0.5
	gfx.screen:copyfrom(toScreen, nil, {x=gfx.screen:get_width()/2-(toScreen:get_width()/2 *scale), y=100 ,w =toScreen:get_width() *scale , h= toScreen:get_height() *scale},true)
	toScreen:destroy()
	gfx.update()


end

-- Copys graphics from main surface (in this case main menu) to the surface mainSrfc
function setMainSrfc()

--	mainSrfc:clear()
--	mainSrfc:copyfrom(gfx.screen, nil, {x=0, y=0})
	

end

-- Changes from active surface to mainSrfc (which can be seen as the previous "state")
function changeSrfc()

--	gfx.screen:copyfrom(mainSrfc, nil, {x=0, y=0})
--	mainSrfc:destroy()
--	gfx.update()

end


--- Gets input from user and re-directs according to input
-- @param key The key that has been pressed
-- @param state The state of the key-press
function onKey(key,state)
 if state == 'down' then
 		return
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
        gamePath = 'flagGame.lua'
        runGame(gamePath, underGoingTest)
	  elseif(key == 'left') then
        sideMenu = false
        gamePath = 'login.lua'
        runGame(gamePath, underGoingTest)
	  end	  
  end
end

--- Runs chosen game (file) if testing mode is off
-- @param path The path to the game to be loaded
-- @param testingModeOn If testing mode is on
function runGame(path, testingModeOn)
	if(not testingModeOn) then
		assert(loadfile(dir .. path))(currentPlayer)
	end
end

function printSchoolLogo()
  local toScreen = nil
  toScreen = gfx.loadpng(png_school_logo)
  scale = 0.1
  toScreen:premultiply()
  gfx.screen:copyfrom(toScreen, nil, {x = gfx.screen:get_width() - toScreen:get_width() * scale - 50 , y=20 ,w =toScreen:get_width() *scale + 50, h= toScreen:get_height() *scale + 40}, true)
  toScreen:destroy()
  gfx.update()
end

-- Main function that runs the program
local function main()

	printPlayerName()
 	printMenuCircles()  
 	printLogotype()
 	printSchoolLogo()
end


main()	  
