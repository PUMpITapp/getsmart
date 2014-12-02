--- Flag Game
-- 
-- The flag game app for GetSmart
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

  return underGoingTest
end 

local underGoingTest = setRequire(checkTestMode())

-- Requires profiles which is a file containing all profiles and it's related variables and tables
dofile('table.save.lua')
profiles, err = table.load('profiles.lua')

-- Require the table containing flags
flags = require 'flags'

-- Require the table containing all the mascot texts
mascot_text = require 'mascot_text'

-- The id for the correct country
correctCountry = ''

-- Variable which is true if side menu is visible
sideMenu = false

-- Set player number
player = ...

-- The table which holds the alternatives which has been removed
removedAlternatives = {}

local randomSeed = os.time()
local circleDiameter = 80

local screen = {
  width = gfx.screen:get_width(),
  height = gfx.screen:get_height()
}

local images = {
  Colors = gfx.loadpng('images/color_choices.png'),
  Flags = gfx.loadpng('images/flag-sprite.png')
}

--- Check if a table contains a given element
-- @param #table table The table to check in
-- @param element The element to check for
-- @return #boolean True if table contains given element
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

--- Shuffles an array
-- @param #table array Table to shuffle
-- @return #table array The shuffled array
function shuffle(array)
  local n, random, j = #array, math.random
  for i=1, n do
    j,k = random(n), random(n)
    array[j],array[k] = array[k],array[j]
  end
  return array
end

--- Prints flag according to input id
-- @param #number countryId The id of the country
function printFlag(countryId)
  local flag = flags[countryId]
  local flagDimensions = {
    x = 0,
    y = flag.dimensions.positionY,
    w = 400,
    h = flag.dimensions.height
  }

  local flagSurface = gfx.new_surface(flagDimensions.w, flagDimensions.h)
  flagSurface:copyfrom(images.Flags, flagDimensions, true)

  local flagScreenPosition = {
    x = screen.width / 4 - flagDimensions.w / 2,
    y = screen.height / 2 - flagDimensions.h / 2,
    w = flagDimensions.w,
    h = flagDimensions.h
  }

  gfx.screen:copyfrom(flagSurface, nil, flagScreenPosition, true)
  gfx.update()
end

--- Prints the answers on the screen
-- @param #table answers A table containing the answers
function printAnswers(answers)

  local font = {
    face = 'lato',
    color = 'black',
    size = 'large',
    height = text.getFontHeight('lato', 'large')
  }

  local textPosition = {
    x = screen.width / 2 + circleDiameter * 3 / 2,
    y = screen.height / 8 - font.height / 2,
    w = screen.width / 2,
    h = screen.height / 4
  }

  for i = 1, 4 do
    text.print(gfx.screen, font.face, font.color, font.size, answers[i], textPosition.x, textPosition.y, textPosition.w, textPosition.h)
    textPosition.y = textPosition.y + screen.height / 4
  end

end

--- Creates the colored circles
function createColoredCircles()

  -- Positions in the circle sprite.
  local xs = 40  -- x starting coordinate
  local y = xs  -- y position
  local d = 160 -- diameter of circle

  local cutOut = {
    red    = {x = xs,         y = y, w = d, h = d},
    yellow = {x = xs + d,     y = y, w = d, h = d},
    blue   = {x = xs + d * 2, y = y, w = d, h = d},
    green  = {x = xs + d * 3, y = y, w = d, h = d}
  }

  circle = {
    red    = gfx.new_surface(circleDiameter, circleDiameter),
    green  = gfx.new_surface(circleDiameter, circleDiameter),
    yellow = gfx.new_surface(circleDiameter, circleDiameter),
    blue   = gfx.new_surface(circleDiameter, circleDiameter)
  }

  circle.red:copyfrom(images.Colors, cutOut.red, true)
  circle.green:copyfrom(images.Colors, cutOut.green, true)
  circle.yellow:copyfrom(images.Colors, cutOut.yellow, true)
  circle.blue:copyfrom(images.Colors, cutOut.blue, true)

end

--- Places the answer circles in their correct positions
function placeAnswerCircles()

  local circlePosition = {
    x = screen.width / 2,
    y = screen.height / 8 - circleDiameter / 2,
    w = circleDiameter,
    h = circleDiameter
  }

  local circleColors = {
    'red',
    'green',
    'yellow',
    'blue'
  }

  positions = {
    ['red']     = {x =screen.width / 2, y= screen.height / 8 - circleDiameter / 2},
    ['green']   = {x =screen.width / 2, y= screen.height / 8 - circleDiameter / 2 +  screen.height / 4},
    ['yellow']  = {x =screen.width / 2, y= screen.height / 8 - circleDiameter / 2 +2*screen.height / 4},
    ['blue']    = {x =screen.width / 2, y= screen.height / 8 - circleDiameter / 2 +3*screen.height / 4}
}

  for i = 1,4 do
    gfx.screen:copyfrom(circle[circleColors[i]], nil, circlePosition, true)
    circlePosition.y = circlePosition.y + screen.height / 4
  end

  gfx.update()
end

--- Generates random answers
-- @param #number correctCountryId The ID of the country which is the correct alternative
-- @return #table answers The table of answers shuffled
function generateAnswers(correctCountryId)

  -- Initialize the answers array and populate it with the correct answer
  local answers = {
    flags[correctCountryId].country
  }
  
  -- Generate random incorrect answers
  while (table.maxn(answers) < 4) do
    local newCountryId = getRandomCountryId()
    local newAnswer = flags[newCountryId].country

    if (not table.contains(answers, newAnswer)) then
      table.insert(answers, newAnswer)
    end
  end

  return shuffle(answers)
end

--- Checks if the user's guess is correct
-- @param #string userAnswer The country guessed
-- @param #table answersLocal The table containing all answers 
-- @param #number correctCountryLocal The id of the correct answer
function checkAnswer(userAnswer, answersLocal, correctCountryLocal)
  answerState = nil
  if (answersLocal[userAnswer] == correctCountryLocal) then
    addScoreToUser()
    zoomAnswer(userAnswer)
    answerState = true
    main()
    removedAlternatives = {}
  else
    removeAnswer(userAnswer)
    answerState = false
  end
end

--- Add one score to the user
function addScoreToUser()
  profileHandler.update(player, 'flagGame', nil, 1)
end

--- Generates a random country id
-- @return #number randomCountryId A random country id
function getRandomCountryId()
  math.randomseed(randomSeed)
  randomSeed = randomSeed + math.random(os.time())

  local randomCountryId = math.random(1, table.maxn(flags))
  return randomCountryId
end

--- Prints the questions and answers
function printQuestionAndAnswers()
	generateQuestion()
	createColoredCircles()
	placeAnswerCircles()
    printSpeechBubbleText()
end

--- Generates question with random country and random answers
function generateQuestion()
    local userLevel = profileHandler.getLevel(player, 'flagGame')

    correctCountryId = {}
    local countryDifficulty = {}
    
    repeat
      correctCountryId = getRandomCountryId()
      countryDifficulty = flags[correctCountryId].difficulty
    until countryDifficulty == userLevel

    correctCountry = flags[correctCountryId].country
    answers = generateAnswers(correctCountryId)

    -- Print on screen
    printFlag(correctCountryId)
    printAnswers(answers)
end

--- Remove an answer in a stylish way (if user's guess is incorrect)
-- @param #integer answerToRemove The answer to remove (1,2,3,4)
function removeAnswer(answerToRemove)
  local zoom = 0.000001 
  local isRemoved = false
  tempColor = { [1] = 'red', [2] = 'green', [3] = 'yellow', [4] = 'blue'}
  key = tempColor[answerToRemove]
  for i=1, #removedAlternatives, 1 do
  	if(removedAlternatives[i] == key) then
  		isRemoved = true
  	end
  end
  if(not isRemoved) then
	  answerIsCorrect= animation.zoom(background, circle[key], positions[key].x, positions[key].y, zoom, 0.5)
	  sleep(1)
  end
  table.insert(removedAlternatives, key)
end

--- Zoom in on an answer if correct guess
-- @param #integer answer The answer to remove (1,2,3,4)
function zoomAnswer(answer)
 local zoom = 2.5
  tempColor = { [1] = 'red', [2] = 'green', [3] = 'yellow', [4] = 'blue'}
  key = tempColor[answer]
  answerIsCorrect= animation.zoom(background, circle[key], positions[key].x, positions[key].y, zoom, 0.3)
  sleep(1)

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
        gamePath = 'memoryGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == 'yellow') then
        sideMenu = false
        gamePath = 'spellingGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == 'blue') then
        sideMenu = false
        changeSrfc()
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

--- Runs chosen game (file) if testing mode is off
-- @param #string path The path to the game to be loaded
-- @param #boolean testingModeOn If testing mode is on
function runGame(path, testingModeOn)
	if(not testingModeOn) then
		assert(loadfile(path))(player)
	end
end

--- Prints the players name in the top of the screen
function printPlayerName()
	
	local playerName = profileHandler.getName(player)
	local playerUserLevel = profileHandler.getLevel(player, "flagGame")

	local fw_name = text.getStringLength('lato', 'medium', playerName)
    local fw_level = text.getStringLength('lato', 'medium', "Level " .. playerUserLevel)
	local fh = text.getFontHeight('lato', 'medium')

	text.print(gfx.screen, 'lato', 'black', 'medium', playerName, 20, 70, fw_name, fh)
	
	text.print(gfx.screen, 'lato', 'black', 'medium', "Level " .. playerUserLevel, 20, 90 + fh, fw_level, fh)

    gfx.update()
end

-- Prints the text in the mascot's speech bubble
function printSpeechBubbleText()

  local mascotText = nil
  local randomInt = nil
  math.randomseed(os.time())
  math.random()
  randomInt = tonumber(math.random(#mascot_text['flagGame']))

  mascotText = mascot_text['flagGame'][randomInt]

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
    --background = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
    --background:clear({122,219,228})
    gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  return 
end

function main()
  setBackground()
  printPlayerName()
  printQuestionAndAnswers()
end

main()