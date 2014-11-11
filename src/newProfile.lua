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

--- Chooses either the actual or he dummy gfx.
-- Returns dummy gfx if the file is being tested.
-- Rerunes actual gfx if the file is being run.
function chooseGfx(underGoingTest)
  if not underGoingTest then
    tempGfx = require "gfx"
  elseif underGoingTest then
    tempGfx = require "gfx_stub"
  end
  return tempGfx
end

function chooseText(underGoingTest)
  if not underGoingTest then
    tempText = require "write_text"
  elseif underGoingTest then
    tempText = require "write_text_stub"
  end
  return tempText
end

-- Require the grafics library and setting the background color
gfx = chooseGfx(checkTestMode())
text = chooseText(checkTestMode())

--gfx.screen:clear({255,255,255}) --RGB
local background = gfx.loadpng('./images/background_login.png')
gfx.screen:copyfrom(background,nil)
gfx.update()

-- String which holds what game is to be loaded
local gamePath = ''

-- Requires profiles which is a file containing all profiles and it's related variables and tables
require "profiles"

-- The recieved argument, in this case the player number
local playerNumber = ...

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

-- Gets input from user and executes chosen script
function onKey(key,state)
 if state == 'down' then

  elseif state == 'up' then
	  if(key == 'red') then
        sideMenu = false
        
		local newForm = {
			laststate = "newProfile.lua",
			currentInputField = "name",
			name = "",
			address= "",
			zipCode ="",
			city = "",
			phone="",
			email = ""
			}
			
        assert(loadfile("Keyboard.lua"))(newForm)
        --runGame(gamePath, underGoingTest)
      elseif(key == 'green') then
        sideMenu = false
        gamePath = 'memoryGame.lua'
        --runGame(gamePath, underGoingTest)
      elseif(key == 'yellow') then
        sideMenu = false
        gamePath = 'spellingGame.lua'
        --runGame(gamePath, underGoingTest)
      elseif(key == 'blue') then
        sideMenu = false
        gamePath = 'geographyGame.lua'
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

  --printMenuCircles()  
  --printLogotype()
  --print(profiles.player1['name'])
  

  --print("Player: " .. playerNumber)

end


main()