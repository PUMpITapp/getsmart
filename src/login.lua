--- Login
-- 
-- The login function for the app GetSmart
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
  end
end 

setRequire(checkTestMode())

--gfx.screen:clear({255,255,255}) --RGB
local background = gfx.loadpng('./images/background_login.png')
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

-- Prints main menu
function printMenuCircles()

	-- Prints circle according to img, x and y values
	function printCircle(img, xIn, yIn)
		local scale = 0.5
		gfx.screen:copyfrom(img, nil, {x=xIn, y=yIn, w=img:get_width()*scale, h=img:get_height()*scale})
	end

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
		
		toScreen = gfx.loadpng(dir..png_profile_circles['profile'..gameCounter.."_"..status])
		printCircle(toScreen, verticalGrid*i-(png_profile_circle_width/2), gfx.screen:get_height()*0.6)
		
		if(status == 'active') then
			local fw = text.getStringLength('lato', textSize, profiles['player'..gameCounter]['name'])
			text.print(gfx.screen, 'lato', 'black', textSize, profiles['player'..gameCounter]['name'], verticalGrid*i-(fw/2), gfx.screen:get_height()*0.8, fw, fh)
		end
		
		gameCounter = gameCounter+1
	end


	--[[
	-- Prints menu items
	for i = 50, 1000, 250 do

		-- Checks if the user is active
		if(profiles['player'..gameCounter]['isActive'] == 1) then
			status = 'active'
		else
			status = 'inactive'
		end
		
		toScreen = gfx.loadpng(dir..png_profile_circles['profile'..gameCounter.."_"..status])
		printCircle(toScreen, i, 450)
		
		if(status == 'active') then
			local fw = text.getStringLength('lato', textSize, profiles['player'..gameCounter]['name'])
			text.print(gfx.screen, 'lato', 'black', textSize, profiles['player'..gameCounter]['name'], i+35, 450+140, fw, fh)
		end
		
		gameCounter = gameCounter+1
	end
	]]
		
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

-- Gets input from user and executes chosen script
function onKey(key,state)
 if state == 'down' then

  elseif state == 'up' then
	  if(key == 'red') then
        gamePath = 'mathGame.lua'
        chosenPlayer = 1
        runGame(gamePath, underGoingTest, chosenPlayer)
      elseif(key == 'green') then
        gamePath = 'memoryGame.lua'
		chosenPlayer = 2
        runGame(gamePath, underGoingTest, chosenPlayer)
      elseif(key == 'yellow') then
        gamePath = 'spellingGame.lua'
        chosenPlayer = 3
        runGame(gamePath, underGoingTest, chosenPlayer)
      elseif(key == 'blue') then
        gamePath = 'geographyGame.lua'
        chosenPlayer = 4
        runGame(gamePath, underGoingTest, chosenPlayer)
	  end
  end
end

-- Table to be sent to newProfile or menu containing information about the user
--login_player = 0

-- Runs chosen game (file) if testing mode is off 
function runGame(path, testingModeOn, chosenPlayer)
	if(not testingModeOn and profiles['player'..chosenPlayer]['isActive'] == 1) then -- If player exists (is active) then go to game menu
		assert(loadfile("menu.lua"))(chosenPlayer)
	elseif(not testingModeOn and profiles['player'..chosenPlayer]['isActive'] == 0) then -- If player does not exist (is not active) go and create new profile
		assert(loadfile("newProfile.lua"))(chosenPlayer)
	end
end


-- Main function that runs the program
local function main()

  printMenuCircles()  
  printLogotype()

end


main()