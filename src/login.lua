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

-- 
local chosenPlayer = 0

-- Requires profiles which is a file containing all profiles and it's related variables and tables
require "profiles"

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

	-- Prints menu items
	for i = 50, 1000, 250 do

		-- Checks if the user is active
		if(profiles['player'..gameCounter]['isActive']) then
			status = 'active'
		else
			status = 'inactive'
		end
		
		toScreen = gfx.loadpng(dir..png_profile_circles['profile'..gameCounter.."_"..status])
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

-- Runs chosen game (file) if testing mode is off 
function runGame(path, testingModeOn, chosenPlayer)
	if(not testingModeOn and profiles['player'..chosenPlayer]['isActive']) then
		assert(loadfile("menu.lua"))(chosenPlayer)
	elseif(not testingModeOn and not profiles['player'..chosenPlayer]['isActive']) then
		assert(loadfile("newProfile.lua"))(chosenPlayer)
	end
end


-- Main function that runs the program
local function main()

  printMenuCircles()  
  --printLogotype()

end


main()