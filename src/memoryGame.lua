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

player = ...

sideMenu = false

-- Require the table containing all the mascot texts
mascot_text = require 'mascot_text'

function main()
	setBackground()

	printInformationText()
	gfx.update()
    printSpeechBubbleText()
end

-- Prints the text in the mascot's speech bubble
function printSpeechBubbleText()

    local mascotText = nil
    local randomInt = nil
    math.randomseed(os.time())
    math.random()

    randomInt = 1

    mascotText = mascot_text['memoryGame'][randomInt]

    local boxWidth = gfx.screen:get_width()/7.1
    local boxHeight = gfx.screen:get_height()/4.388
    local boxHeightOffset = gfx.screen:get_height()/34



    local fh = text.getFontHeight('lato', 'small')
    local fw = text.getStringLength('lato', 'small', mascotText)
    local actualFh = fh

    local j = 1
    for i = 1, fw, 1 do
        j = j+1
        if j > boxWidth then
            actualFh = actualFh + fh
            j=1
        end
    end

    text.print(gfx.screen, 'lato', 'black', 'small', mascotText, gfx.screen:get_width()/5.85, (gfx.screen:get_height()-boxHeightOffset-boxHeight/2-actualFh/2), boxWidth, boxWidth)

    gfx.update()
end

--- Sets the background of the screen
function setBackground()
    background = gfx.loadpng('./images/background-game.png')
    gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
    background:destroy()
  return 
end

--- Prints the information text in the center of the screen
function printInformationText()
	if(not tonumber(profilePlayer == nil)) then
		local fh = text.getFontHeight('lato', 'medium')
		local fw = text.getStringLength('lato', 'medium', "Memory game coming soon!")
		text.print(gfx.screen, 'lato', 'black', 'medium', "Memory game coming soon!", (gfx.screen:get_width()/2 - (fw/2)), (gfx.screen:get_height()/2 - (fh/2)), fw, fh)
	end
end

--- Runs chosen game (file) if testing mode is off
-- @param path The path to the game to be loaded
-- @param testingModeOn If testing mode is on
function runGame(path, testingModeOn)
	if(not testingModeOn) then
		assert(loadfile(dir .. path))(player)
	end
end

--- Gets input from user and re-directs according to input
-- @param key The key that has been pressed
-- @param state The state of the key-press
function onKey(key,state)
 if state == 'down' then
 		return
  elseif state == 'up' then
	  if(key == 'right') then
        sideMenu = false
        gamePath = 'menu.lua'
        runGame(gamePath, underGoingTest)
      --[[elseif(key == 'green') then
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
        runGame(gamePath, underGoingTest)--]]
	  elseif(key == 'left') then
        sideMenu = false
        gamePath = 'login.lua'
        runGame(gamePath, underGoingTest)
	  end	  
  end
end

main()