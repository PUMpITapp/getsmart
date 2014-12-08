--- Login
-- 
-- The login function for the app GetSmart
--

-- Set as true if running on the STB
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
 -- animation = require "animation"
    profileHandler = require "profileHandler"
  elseif underGoingTest then 
    gfx = require "gfx_stub"
    text = require "write_text_stub"
    animation = require "animation_stub"
    profileHandler = require "profileHandler_stub"
  end

  return underGoingTest
end 
--local underGoingTest = setRequire(checkTestMode())
local underGoingTest = setRequire(checkTestMode())

-- Requires profiles which is a file containing all profiles and it's related variables and tables
if not runsOnSTB then
	dofile('table.save.lua')
	profiles, err = table.load('profiles.lua')
	dir = "" 
else
	--package.path = package.path .. ';' .. sys.root_path() .. 'images/?.png'
	--package.path = package.path .. ';' .. sys.root_path() .. 'images/profile/?.png'
	--package.path = package.path .. ';' .. sys.root_path() .. '?.png'
	dir = sys.root_path()
	dofile(dir .. 'table.save.lua')
	profiles, err = table.load(dir .. 'profiles.lua') 
end

-- Imports and sets background
local background = gfx.loadpng('images/background.png')
gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
background:destroy()


-- Init profileStatus, will be set to 0 or 1 later
profileStatus = nil

-- All main menu items as .png pictures as transparent background with width and height variables
local png_profile_circle_width = 149
local png_profile_circle_height = 147
local png_profile_circles = { 	profile1_inactive = 'red-inactive.png',
								profile1_active = 'red-active.png',
								profile2_inactive = 'green-inactive.png',
								profile2_active = 'green-active.png',
								profile3_inactive = 'yellow-inactive.png',
								profile3_active = 'yellow-active.png',
								profile4_inactive = 'blue-inactive.png',
								profile4_active = 'blue-active.png'
}

-- Logotype as .png pictuere with transparent background with width variable
local png_logo_width = 447
local png_logo = 'logo.png'


--- Prints circle according to input
-- @param surface img The surface to be printed on
-- @param x The x-coordiante
-- @param y The y-coordinate
function printCircle(img, xIn, yIn)
	local scale = 0.5
		gfx.screen:copyfrom(img, nil, {x = xIn, y = yIn, w = img:get_width() * scale, h = img:get_height() * scale}, true)
end


-- Prints main menu
function printMenuCircles()

--[[	-- Prints circle according to img, x and y values
	function printCircle(img, xIn, yIn)
		local scale = 0.5
		gfx.screen:copyfrom(img, nil, {x=xIn, y=yIn, w=img:get_width()*scale, h=img:get_height()*scale}, true)
		img:destroy()
	end]]

	local toScreen = nil
	local gameCounter = 1
	local status = ''
	local textSize = 'medium'
	local fh = text.getFontHeight('lato', textSize)
	local verticalGrid = gfx.screen:get_width()/5
	
	-- Prints menu items
	for i = 1, 4, 1 do

		-- Checks if the user is active
		if(profiles['player'..gameCounter]['isActive'] == 1) then
			status = 'active'
		else
			status = 'inactive'
		end
		
		toScreen = gfx.loadpng('images/profile/' .. png_profile_circles['profile'..gameCounter.."_"..status])
		toScreen:premultiply()
		printCircle(toScreen, verticalGrid*i-(png_profile_circle_width/2), gfx.screen:get_height()*0.6)
		
		if(status == 'active') then
			local fw = text.getStringLength('lato', textSize, profiles['player'..gameCounter]['name'])
			text.print(gfx.screen, 'lato', 'black', textSize, profiles['player'..gameCounter]['name'], verticalGrid*i-(fw/2), gfx.screen:get_height()*0.8, fw, fh)
		end
		
		gameCounter = gameCounter+1
	end

		
	gfx.update()
	
end

-- Prints logotype in the middle of the screen
function printLogotype()
	
	local toScreen = nil
	
	toScreen = gfx.loadpng('images/' .. png_logo)
	toScreen:premultiply()
	scale = 0.5
	gfx.screen:copyfrom(toScreen, nil, {x=gfx.screen:get_width()/2-(toScreen:get_width()/2 *scale), y=100 ,w =toScreen:get_width() *scale , h= toScreen:get_height() *scale}, true)
	toScreen:destroy()
	gfx.update()

end

-- Gets input from user and executes chosen script
function onKey(key,state)
  if state == 'down' then
  	return

  elseif state == 'up' then
  	
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

-- Runs chosen game (file) if testing mode is off 
function runGame(testingModeOn, chosenPlayer)

	profileStatus = profiles['player'..chosenPlayer]['isActive'] -- Get the player status (active or not active/1 or 0)
	
	if(not testingModeOn and profileStatus == 1) then -- If player exists (is active) then go to game menu
		path = "menu.lua"
	--	gfx.screen:destroy()
		assert(loadfile(dir .. path))(chosenPlayer)
	elseif(not testingModeOn and profileStatus == 0) then -- If player does not exist (is not active) go and create new profile
		print(chosenPlayer)
		path =  "newProfile.lua"
		assert(loadfile(dir .. path))(chosenPlayer)
	elseif (testingModeOn and profileStatus == 1) then -- If player does not exist and testning mode on go and create new profile
		path = "menu.lua"
	elseif(testingModeOn and profileStatus == 0) then -- If player does not exist and testing mode on go and create new profile
		path = "newProfile.lua"
	end

	
end


-- Main function that runs the program
local function main()

  printMenuCircles()  
  printLogotype()

end


main()