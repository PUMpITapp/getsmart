--- New Profile
-- 
-- This file handles the creation of a new user
--

--- Checks if the file was called from a test file.
-- Returs true if it was, 
--   - which would mean that the file is being tested.
-- Returns false if it was not,
--   - which wold mean that the file was being used.  
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

setRequire(checkTestMode())

local background = gfx.loadpng('./images/background_new_player.png')
gfx.screen:copyfrom(background, nil)
gfx.update()

-- String which holds what game is to be loaded
local gamePath = ''

-- Requires profiles which is a file containing all profiles and it's related variables and tables
require "profiles"

-- The current user, either a number (coming from login) or a string (coming from keyboard)
profilePlayer = ...

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

-- Directory of images
local dir = './'

function isNewPlayer()

	if(tonumber(profilePlayer) == nil) then		-- If name (coming from Keyboard)	
		name, number = profilePlayer:match("([^,]+),([^,]+)")
		profileHandler.setName(tonumber(number), tostring(name))
		assert(loadfile('menu.lua'))(number)
	else										-- If number (coming from Keyboard)
		return true
	end
end

-- Prints the number of the player at center of screen !!! FOR DEVELOPMENT ONLY !!!
local function printPlayerNumber()
	if(not playerNumber == nil) then
		local fh = text.getFontHeight('lato', 'large')
		local fw = text.getStringLength('lato', 'large', tostring('Player'..playerNumber))
		text.print(gfx.screen, 'lato', 'black', 'large', tostring("Player"..playerNumber), (gfx.screen:get_width()/2 - (fw/2)), (gfx.screen:get_height()*0.05), fw, fh)
	end
end

-- Prints save- and back buttons in the corners of the image
local function printNavigationButtons()

	local backButton = gfx.loadpng(dir .. 'images/profile/profile-go-back.png')
	local saveButton = gfx.loadpng(dir .. 'images/profile/profile-go-forward.png')
	local toScreen = nil
	local scale = 0.4
    local buttonMargin =  20
	
    gfx.screen:copyfrom(backButton, nil, {
      x = buttonMargin,
      y = buttonMargin,
      w = backButton:get_width() * scale,
      h = backButton:get_height() * scale
    })

    gfx.screen:copyfrom(saveButton, nil, {
      x = gfx.screen:get_width() - saveButton:get_width() * scale - buttonMargin,
      y = buttonMargin,
      w = saveButton:get_width() * scale,
      h = saveButton:get_height() * scale
    })

end

-- Gets input from user and executes chosen script
function onKey(key, state)
 if state == 'down' then

  elseif state == 'up' then
	  if(key == 'red') then
        --runGame(gamePath, underGoingTest)
      elseif(key == 'green') then
        --runGame(gamePath, underGoingTest)
      elseif(key == 'yellow') then
        --runGame(gamePath, underGoingTest)
      elseif(key == 'blue') then
        --runGame(gamePath, underGoingTest)
	  end
  end
end

-- Runs chosen game (file) if testing mode is off
function runGame(path, testingModeOn)
	if(not testingModeOn) then
		dofile(path)
	end
end

-- Main function that runs the program
local function main()

	if(isNewPlayer()) then
		printPlayerNumber()
		printNavigationButtons()
		assert(loadfile('keyboard.lua'))(profilePlayer)
	end	

end
main()