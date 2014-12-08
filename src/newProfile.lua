--- NewProfile
-- 
-- The new profile function for the app GetSmart
--
require "runState"
--- Checks if the file was called from a test file.
-- @return True or false depending on testing file
function checkTestMode()
  --[[runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
	--]]
	underGoingTest = false
  return underGoingTest
end

--- Chooses either the actual or the stubs depending on if a test file started the program.
-- @param underGoingTest Undergoing test is true if a test file started the program.
function setRequire(underGoingTest)
  if not underGoingTest then
    if not runsOnSTB then
    	gfx = require "gfx"
    end
    text = require "write_text"
    animation = require "animation"
    profileHandler = require "profileHandler"
  elseif underGoingTest then 
    gfx = require "gfx_stub"
    text = require "write_text_stub"
    animation = require "animation_stub"
    profileHandler = require "profileHandler_stub"
  end

  return underGoingTest
end 

local underGoingTest = setRequire(checkTestMode())

--[[if not runsOnSTB then                                                                                                         
  dir = ""                                                                                                                     
else                                                                                                                                                     
  dir = sys.root_path()                                                                              
end --]]

-- Imports and sets background
--local background = gfx.loadpng('./images/background.png')
--gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
--gfx.screen:clear({122,219,228})

local background = gfx.loadpng('images/background.png')
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
background:destroy()
--gfx.update()

-- Requires profiles which is a file containing all profiles and it's related variables and tables
require "profiles"

profilePlayer = ...

-- Test stub to make testing possible
function testGoingToMenu(goingToMenu)
	if(underGoingTest and goingToMenu) then
		profilePlayer = 'player,1'
	elseif(underGoingTest and not goingToMenu) then
		profilePlayer = 1
	end
end

-- Player variables
name = ''
number = ''

-- All main menu items as .png pictures as transparent background with width and height variables
local png_profile_circle_width = 149
local png_profile_circle_height = 147
local png_profile_circles = { 	profile1_inactive = 'images/profile/red-inactive.png',
								profile1_active = 'images/profile/red-active.png',
								profile2_inactive = 'images/profile/green-inactive.png',
								profile2_active = 'images/profile/green-active.png',
								profile3_inactive = 'images/profile/yellow-inactive.png',
								profile3_active = 'images/profile/yellow-active.png',
								profile4_inactive = 'images/profile/blue-inactive.png',
								profile4_active = 'images/profile/blue-active.png'
							}

-- Logotype as .png picture with transparent background with width variable
local png_logo_width = 447
local png_logo = 'images/logo.png'

if not runsOnSTB then
  dir = "" 
else
  dir = sys.root_path()
end

--- Decides if player is sent to keyboard or menu
-- @return If it's a new player (coming from keyboard) return true
function isNewPlayer()
	if(tonumber(profilePlayer) == nil) then							-- If name (coming from Keyboard)	
		name, number = profilePlayer:match("([^,]+),([^,]+)")		-- Split string into two variables
		if(not underGoingTest) then
			profileHandler.setName(tonumber(number), tostring(name))
			assert(loadfile(dir .. 'menu.lua'))(number)
		end
	else															-- If number (coming from Login)
		return true
	end
end

--- Prints the number of the player at center of screen
function printPlayerNumber()
	if(not tonumber(profilePlayer == nil)) then
		local fh = text.getFontHeight('lato', 'large')
		local fw = text.getStringLength('lato', 'large', tostring('Player '..profilePlayer))
		text.print(gfx.screen, 'lato', 'black', 'large', tostring("Player "..profilePlayer), (gfx.screen:get_width()/2 - (fw/2)), (gfx.screen:get_height()*0.05), fw, fh)
	end
end

--- Gets input from user, must be included for input to work
-- @param key The key that has been pressed
-- @param state The state of the key-press
function onKey(key, state)
 if state == 'down' then

  elseif state == 'up' then
	  if(key == 'red') then
	  -- Do nothing
      elseif(key == 'green') then
	  -- Do nothing
      elseif(key == 'yellow') then
	  -- Do nothing
      elseif(key == 'blue') then
	  -- Do nothing
	  end
  end
end

-- Main function that runs the program
local function main()

	if(isNewPlayer()) then
		printPlayerNumber()
		--printNavigationButtons()
		gfx.update()
		if(not underGoingTest) then
			foo = 0
			assert(loadfile(dir .. 'keyboard.lua'))(profilePlayer)
		end
		
	end
end

main()
