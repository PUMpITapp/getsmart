text = require "write_text"
gfx = require "gfx"

gfx.screen:clear({122,219,228})

player = ...

sideMenu = false

function main()
	printInformationText()
	gfx.update()
end

--- Prints the information text in the center of the screen
function printInformationText()
	if(not tonumber(profilePlayer == nil)) then
		local fh = text.getFontHeight('lato', 'medium')
		local fw = text.getStringLength('lato', 'medium', "Memory game will not be implemented!")
		text.print(gfx.screen, 'lato', 'black', 'medium', "Memory game will not be implemented!", (gfx.screen:get_width()/2 - (fw/2)), (gfx.screen:get_height()/2 - (fh/2)), fw, fh)
	end
end

--- Runs chosen game (file) if testing mode is off
-- @param #string path The path to the game to be loaded
-- @param #boolean testingModeOn If testing mode is on
function runGame(path, testingModeOn)
	if(not testingModeOn) then
		assert(loadfile(path))(player)
	end
end

--- Gets input from user and checks answer or controls side-menu
-- @param key The key that has been pressed
-- @param state The state of thed key-press
function onKey(key, state)
  if state == 'down' then return
  elseif state == 'repeat' then return
  elseif state == 'up' then
  
    --if side menu is up
    if(sideMenu) then 
	  if(key == 'red') then
        sideMenu = false
        gamePath = 'mathGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == 'green') then
        sideMenu = false
        changeSrfc()
      elseif(key == 'yellow') then
        sideMenu = false
        gamePath = 'spellingGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == 'blue') then
        sideMenu = false
        gamePath = 'flagGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == "right") then
        sideMenu = false
        changeSrfc()
      elseif(key == 'up') then
      	dofile("login.lua")
      end
      
      -- In-game control when side menu is down, controls that a button can only be pressed once
    elseif(not sideMenu) then
	  if state == 'up' then
	      if (key == 'red') then
	        userAnswer = 1
	        checkAnswer(userAnswer, answers, correctCountry)
	      elseif (key == 'green') then
	        userAnswer = 2
			checkAnswer(userAnswer, answers, correctCountry)
	      elseif (key == 'yellow') then
	        userAnswer = 3
			checkAnswer(userAnswer, answers, correctCountry)
	      elseif (key == 'blue') then
	        userAnswer = 4
	        checkAnswer(userAnswer, answers, correctCountry)
	      elseif(key == "right") then
	        sideMenu = true
	        setMainSrfc()
	        printSideMenu()
	      end
	  end
    end
  end
end

main()