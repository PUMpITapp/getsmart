--- Login
-- 
-- The login function for the app GetSmart
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
-- @param #boolean underGoingTest Undergoing test is true if a test file started the program.
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

  return underGoingTest
end 

local underGoingTest = setRequire(checkTestMode())

-- Imports and sets background
local background = gfx.loadpng('./images/background.png')
gfx.screen:copyfrom(background,nil)
gfx.update()

-- Requires profiles which is a file containing all profiles and it's related variables and tables
dofile('table.save.lua')
profiles, err = table.load('profiles.lua')

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

-- Logotype as .png pictuere with transparent background with width variable
local png_logo_width = 447
local png_logo = 'images/logo.png'

-- Directory of images
local dir = './'

--- Prints circle according to input
-- @param surface img The surface to be printed on
-- @param #number x The x-coordiante
-- @param #number y The y-coordinate
function printCircle(img, xIn, yIn)
	local scale = 0.5
	gfx.screen:copyfrom(img, nil, {x=xIn, y=yIn, w=img:get_width()*scale, h=img:get_height()*scale})
end

--- Prints main menu circles and updates screen
function printMenuCircles()

	local toScreen = nil
	local profileCounter = 1
	local status = ''
	local textSize = 'medium'
	local fh = text.getFontHeight('lato', textSize)
	local verticalGrid = gfx.screen:get_width()/5

	-- Prints menu items
	for i = 1, 4, 1 do

		-- Checks if the user is active
		if(profiles['player'..profileCounter]['isActive'] == 1) then
			status = 'active'
		else
			status = 'inactive'
		end
		
		toScreen = gfx.loadpng(dir..png_profile_circles['profile'..profileCounter.."_"..status])
		printCircle(toScreen, verticalGrid*i-(png_profile_circle_width/2), gfx.screen:get_height()*0.6)
		
		if(status == 'active') then
			local fw = text.getStringLength('lato', textSize, profiles['player'..profileCounter]['name'])
			text.print(gfx.screen, 'lato', 'black', textSize, profiles['player'..profileCounter]['name'], verticalGrid*i-(fw/2), gfx.screen:get_height()*0.8, fw, fh)
		end
		
		profileCounter = profileCounter+1
	end
		
	gfx.update()

end

--- Prints logotype in the middle of the screen
function printLogotype()
	
	local toScreen = nil
	
	toScreen = gfx.loadpng(dir..png_logo)
	local scale = 0.5
	gfx.screen:copyfrom(toScreen, nil, {x=gfx.screen:get_width()/2-(toScreen:get_width()/2 *scale), y=100 ,w =toScreen:get_width() *scale , h= toScreen:get_height() *scale})
	gfx.update()

end

--- Gets input from user and re-directs according to input
-- @param key The key that has been pressed
-- @param state The state of the key-press
function onKey(key,state)

  if state == 'up' then
      if (key == 'red') then
        chosenPlayer = 1
        runGame(underGoingTest, chosenPlayer)
      elseif (key == 'green') then
        chosenPlayer = 2
        runGame(underGoingTest, chosenPlayer)
      elseif (key == 'yellow') then
        chosenPlayer = 3
        runGame(underGoingTest, chosenPlayer)
      elseif (key == 'blue') then
        chosenPlayer = 4
        runGame(underGoingTest, chosenPlayer)
      end
  end
end

--- Runs chosen game (file) if testing mode is off 
-- @param #boolean testingModeOn If testing mode is on
-- @param #number chosenPlayer The number of the chosen player (1-4)
function runGame(testingModeOn, chosenPlayer)

	profileStatus = profiles['player'..chosenPlayer]['isActive'] -- Get the player status (active or not active/1 or 0)
	
	if(profileStatus == 1) then -- If player exists (is active) then go to game menu
		path = "menu.lua"
	elseif(profileStatus == 0) then -- If player does not exist (is not active) go and create new profile
		path = "newProfile.lua"
	end

    if(not testingModeOn) then
      assert(loadfile(path))(chosenPlayer)
    end
end

-- Main function that runs the program
local function main()

  printMenuCircles()  
  printLogotype()

end
main()