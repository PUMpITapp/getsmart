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

local background = gfx.loadpng('./images/background.png')
gfx.screen:copyfrom(background,nil)
gfx.update()

-- Requires profiles which is a file containing all profiles and it's related variables and tables
dofile('table.save.lua')
profiles, err = table.load('profiles.lua')

-- Require the table containing flags
flags = require 'flags'

-- Variable containing the correct answer
--correctCountry = ""
--answers = {}

-- The user's chosen answer
chosenAnswer = 0

corrId = 0

local randomSeed = os.time()
local circleDiameter = 80;

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
    red    = gfx.new_surface(cutOut.red.w, cutOut.red.h),
    green  = gfx.new_surface(cutOut.green.w, cutOut.green.h),
    yellow = gfx.new_surface(cutOut.yellow.w, cutOut.yellow.h),
    blue   = gfx.new_surface(cutOut.blue.w, cutOut.blue.h)
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

function checkAnswer(userAnswer)
  answerState = nil
  if (answers[userAnswer] == correctCountry) then
    print("correct")
    print(correctCountry)
    print(answers[userAnswer])
    --addScoreToUser()

    printQuestionAndAnswers()
    answerState = true
  else
    print("incorrect")
    removeAnswer(userAnswer)
    answerState = false

  end
end

--- Generates a random country id
-- @return #number randomCountryId A random country id
function getRandomCountryId()
  math.randomseed(randomSeed)
  randomSeed = randomSeed + 1
  local randomCountryId = math.random(1, table.maxn(flags))
  return randomCountryId
end

--- Prints the questions and answers
function printQuestionAndAnswers()
	gfx.screen:clear({122,219,228})
	gfx.update()
	generateQuestion()
	createColoredCircles()
	placeAnswerCircles()
end

--- Generates question with random country and random answers
function generateQuestion()
	local correctCountryId = getRandomCountryId()

    correctCountry = flags[correctCountryId].country
    answers = generateAnswers(correctCountryId)

    -- Print on screen
	printFlag(correctCountryId)
	printAnswers(answers)
end

--- Remove an answer in a stylish way
-- @param #integer answerToRemove The answer to remove (1,2,3,4)
--
function removeAnswer(answerToRemove)
  
end

--- Gets input from user and re-directs according to input
-- @param key The key that has been pressed
-- @param state The state of the key-press
function onKey(key,state)
  if state == 'up' then
      if (key == 'red') then
        userAnswer = 1
        checkAnswer(userAnswer)
      elseif (key == 'green') then
        userAnswer = 2
		checkAnswer(userAnswer)
      elseif (key == 'yellow') then
        userAnswer = 3
		checkAnswer(userAnswer)
      elseif (key == 'blue') then
        userAnswer = 4
        checkAnswer(userAnswer)
      end
  end
end

local function main()
	printQuestionAndAnswers()
end

main()