--- GetMathSmart
--
-- A math game to learn and practice the basic arithmetic calculations
-- addition, subtraction, multiplication and division. The user gets a
-- mathimatical problem with four answers to choose from. The difficulty 
-- of the problem is based on what level the user has reached:

-- The answers are displayed in different colors that represent the
-- colored buttons on the remotecontrol. Pressing one of the buttons    
-- will display if the answer is correct or not and take the user onwards
-- to new questions. 

-- Import the number of the player
local currentPlayer = ...

require "runState"

sideMenu = false

--- Checks if the file was called from a test file.
-- @return If called from test file return true (indicating file is being tested) else false  
function checkTestMode()
 --[[ runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
  return underGoingTest --]]
  local underGoingTest = false

  return underGoingTest
end


--- Chooses either the actual or the stubs depending on if a test file started the program.
-- @param underGoingTest undergoing test is true if a test file started the program.
function setRequire(underGoingTest)
  if not underGoingTest then
    if not runsOnSTB then
      gfx = require "gfx"
    end
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

-- Set player
--player = ...

answers = {}
answered = {red = false,
            blue = false,
            yellow = false,
            green = false}

-- Require the table containing all the mascot texts
mascot_text = require 'mascot_text'


-- Printing the numbers on the correct position on the screen
local sw = gfx.screen:get_width()  -- screen width
local sh = gfx.screen:get_height() -- screen height
local fh = text.getFontHeight('lato', 'large') -- font height
local d = 160 -- diameter of circle

position = {termOne   = {x = sw * 0.13, y = sh * 0.37 },
            operator  = {x = sw * 0.23, y = sh * 0.37 },
            termTwo   = {x = sw * 0.33, y = sh * 0.37 },
            equals    = {x = sw * 0.43, y = sh * 0.37 }, 
            red       = {x = sw * 0.47, y = sh * 0.40 , w = d, h = d}, --red answer circle position
            yellow    = {x = sw * 0.62, y = sh * 0.55 , w = d, h = d}, --yellow answer circle position
            blue      = {x = sw * 0.77, y = sh * 0.40 , w = d, h = d}, --blue answer circle position
            green     = {x = sw * 0.62, y = sh * 0.25 , w = d, h = d}} --green answer circle position




-- Directory of artwork 
--dir = './'



-- Main function that runs the program
local function main()
  playerUserLevel = profileHandler.getLevel(currentPlayer, "mathGame")
  setBackground()
  printPlayerName()
  printSpeechBubbleText()

  ------------------------------------------------------------------------
  --  INCOMPLETE! 
  -- level will come from user but at the moment it is a static number. --
  ------------------------------------------------------------------------
  local level = tonumber(1)


  local mathProblem = produceMathProblem(level)
  correctAnswer = solveProblem(mathProblem)
  local answers = produceAnswers(correctAnswer)
  createAnswerBackground()
  placeAnswersOnCircles(answers)
  placeAnswerCircles()
  printProblem(mathProblem)

  gfx.update()
end

--- produces a math problem based on the level of the user.
-- @param level The difficulty level of the problem
function produceMathProblem(level)
 -- level not implemented yet
  local operator = getOperator(playerUserLevel)
  gameType = getOperatorString(operator)
  --print("Game type: "..gameType)
  local gameLevel = getGameLevel(gameType)
  --print("Game level: " ..gameLevel)
  local boundries = getBoundries(gameType, gameLevel)
  --print("Boundries: "..boundries['termOne'][1] .. " - " ..boundries['termOne'][2])


  -- Because of Lua random being semi-random from fixed lists
  -- this solution provides a more random behavior
  math.randomseed(os.time())
  math.random()
  math.random()

  local termOne = nil
  local termTwo = nil
  if gameType == 'division' then
    termOne = tonumber(math.random(boundries['termOne'][1], boundries['termOne'][2]))
    termTwo = tonumber(math.random(boundries['termTwo'][1], boundries['termTwo'][2]))
    termOne = termOne * termTwo
  else
    termOne = tonumber(math.random(boundries['termOne'][1], boundries['termOne'][2]))
    termTwo = tonumber(math.random(boundries['termTwo'][1], boundries['termTwo'][2]))
    
  end
  

  local problem = {}
  problem["termOne"] = termOne
  problem["termTwo"] = termTwo
  problem["operator"] = operator
  return problem
end



--- Solves a math problem
-- Gets a table with the first and second term and the operator.
-- Solves the problem based on the operator.
-- @returns the correct answer
-- @param The math problem to be solved, conatining two numbers and operator
function solveProblem(mathProblem)
  if(mathProblem['operator'] == "+") then
    answer = tonumber(mathProblem['termOne'] + mathProblem['termTwo'])
  end
  
  if(mathProblem['operator'] == "-") then
    answer = tonumber(mathProblem['termOne'] - mathProblem['termTwo'])
  end

  if(mathProblem['operator'] == "*") then
    answer = tonumber(mathProblem['termOne'] * mathProblem['termTwo'])
  end

  if(mathProblem['operator'] == "/") then
    answer = tonumber(mathProblem['termOne'] / mathProblem['termTwo'])
  end
  
  return answer
end

--- Get the operator for a math problem given its difficulty level.
-- The mathematical operation of a given problem depends on its difficulty level.
-- @param playerUserLevel the level of the user
-- @return Returns the operator for a math problem.
function getOperator(playerUserLevel)
  local operator = {'+'} 
  if (playerUserLevel > 2) then
    operator = {'+','-'} 
  end
  if (playerUserLevel > 4) then
    operator = {'+','-','*'}  
  end
  if(playerUserLevel > 6) then
    operator = {'+','-','*','/'} 
  end
  operator = operator[math.random(#operator)]
  return operator
end
-- comverts the opperator into stringOperator
-- @param operator The operator in form: +/-/*//
-- @return stringOperator
function getOperatorString(operator)
  stringOperator = nil
  if(operator == '+') then
    stringOperator = 'addition'
    elseif(operator == '-') then
    stringOperator = 'subtraction'
  elseif(operator == '*') then
    stringOperator = 'multiplication'
  elseif(operator == '/') then
    stringOperator = 'division'
  end
  return stringOperator 
end

function getGameLevel(gameType)

  return profileHandler.getGameLevel('player'..currentPlayer,'mathGame',gameType..'Points')
end


--- 
function getBoundries(gameType, level)
  difficulties = require "mathGameDifficulties"

  if(tonumber(level) > #difficulties[gameType]) then 
    level = #difficulties[gameType]
  end
 
  return difficulties[gameType][level]
end

--- The lowest number that a term within a math problem should have.
-- @param level The difficulty level of the math problem.
-- @return Returns the lower numerical bound for terms within a problem.
function getLowerBound(level)
  local lowerBound = nil
  if(level > 8) then       lowerBound = 9
  elseif(level == 7) then  lowerBound = 5
  elseif(level == 6) then  lowerBound = 3
  elseif(level == 5) then  lowerBound = 3
  elseif(level == 4) then  lowerBound = 10
  elseif(level == 3) then  lowerBound = 0    
  elseif(level == 2) then  lowerBound = 10
  else                     lowerBound = 0
  end

  return lowerBound
end

--- The highest number that a term within a math problem should have.
-- @param level The difficulty level of the math problem.
-- @return Returns the upper numerical bound for terms within a problem.
function getUpperBound(level)
  local lowerBound = nil
  if(level > 8) then       upperBound = 9
  elseif(level == 7) then  upperBound = 9
  elseif(level == 6) then  upperBound = 9
  elseif(level == 5) then  upperBound = 5
  elseif(level == 4) then  upperBound = 99
  elseif(level == 3) then  upperBound = 9   
  elseif(level == 2) then  upperBound = 99
  else                     upperBound = 9
  end

  return upperBound
end

--- Given the correct answer and difficulty level of a problem, create three other incorrect answers
-- @param correctAnswer The correct answer to the problem.
-- @param level The difficulty level of the problem.
-- @return Incorrect answer choices to a problem.
function produceAnswers(correctAnswer, level)
  --answers ={}
  offset = math.random(4)-1
  answers[1] = correctAnswer - offset
  answers[2] = correctAnswer - offset +1
  answers[3] = correctAnswer - offset +2
  answers[4] = correctAnswer - offset +3
 
  return answers
end
--- create the background and the "circles" for the answers
function createAnswerBackground()
  -- All images in the game are placed in this table
  --images ={['colors'] = "color_choices.png"}
  colorsImg = gfx.loadpng("images/color_choices.png")

  colorsImg:premultiply()

  -- Positions in the circle sprite.
  local xs =40  -- x starting coordinate
  local y = xs  -- y position
  local d = 160 -- diameter of circle
  local cutOut ={  red    = {x= xs      , y = y, w = d, h = d},
                   yellow = {x= xs + d  , y = y, w = d, h = d},
                   blue   = {x= xs + d*2, y = y, w = d, h = d},
                   green  = {x= xs + d*3, y = y, w = d, h = d}}

  if not (circle == nil) then
      destroyCircles()
  end


  circle = {
  red = gfx.new_surface(cutOut.red.w, cutOut.red.h),
  green = gfx.new_surface(cutOut.green.w, cutOut.green.h),
  yellow = gfx.new_surface(cutOut.yellow.w, cutOut.yellow.h),
  blue = gfx.new_surface(cutOut.blue.w, cutOut.blue.h)}

  circle.red:copyfrom(colorsImg, cutOut.red, nil)
  circle.green:copyfrom(colorsImg, cutOut.green, nil)
  circle.yellow:copyfrom(colorsImg, cutOut.yellow, nil)
  circle.blue:copyfrom(colorsImg, cutOut.blue, nil)
  colorsImg:destroy()

end
--- place the answers to the right position in their circle
--@param answers The answer options that is given to the user 
function placeAnswersOnCircles(answers)
-- Printing the answers
  local fh = text.getFontHeight('lato', 'large') -- font height
  local yOffset = fh /2

  local xOffset = text.getStringLength('lato', 'large', tostring(answers[1])) / 2
  text.print(circle.red, 'lato', 'black', 'large', tostring(answers[1]), circle.red:get_width() /2 - xOffset, circle.red:get_height() /2 - yOffset, xOffset*2, fh)
 
  xOffset = text.getStringLength('lato', 'large', tostring(answers[2])) / 2
  text.print(circle.green, 'lato', 'black', 'large', tostring(answers[2]), circle.green:get_width() /2 - xOffset, circle.green:get_height() /2 - yOffset, xOffset*2, fh)
  
  xOffset = text.getStringLength('lato', 'large', tostring(answers[3])) / 2
  text.print(circle.yellow, 'lato', 'black', 'large', tostring(answers[3]), circle.yellow:get_width() /2 - xOffset, circle.yellow:get_height() /2 - yOffset, xOffset*2, fh)
  
  xOffset = text.getStringLength('lato', 'large', tostring(answers[4])) / 2
  text.print(circle.blue, 'lato', 'black', 'large', tostring(answers[4]), circle.blue:get_width() /2 - xOffset, circle.blue:get_height() /2 - yOffset, xOffset*2, fh)
end


--- Places the colored answer circles on their positions
function placeAnswerCircles()
  gfx.screen:copyfrom(circle.red, nil, position.red, true)
  gfx.screen:copyfrom(circle.green, nil, position.green, true)
  gfx.screen:copyfrom(circle.blue, nil, position.blue, true)
  gfx.screen:copyfrom(circle.yellow, nil, position.yellow, true)

   --destroyCircles()
end

function destroyCircles()
  if circle ~= nil then
    circle.red:destroy()
    circle.blue:destroy()
    circle.yellow:destroy()
    circle.green:destroy()
  end
end


--- Displays the problem and the answers on the screen by invoking write_text.lua.
-- @param mathProblem The problem to be displayed on the screen.
function printProblem(mathProblem)

  local xOffset = 0     -- the horizontal offset to center the text over the position, half the strings width
  local yOffset = fh/2  -- the vertical offset to venter the text over the position, half the font height
  xOffset = text.getStringLength('lato', 'large', tostring(mathProblem.termOne)) / 2
  text.print(gfx.screen, 'lato', 'black', 'large', tostring(mathProblem['termOne']), position.termOne.x - xOffset ,position.termOne.y + yOffset, xOffset*2, fh)

  xOffset = text.getStringLength('lato', 'large', tostring(mathProblem.operator)) / 2
  text.print(gfx.screen, 'lato', 'black', 'large', tostring(mathProblem['operator']), position.operator.x - xOffset, position.operator.y + yOffset, xOffset*2, fh)

  xOffset = text.getStringLength('lato', 'large', tostring(mathProblem.termTwo)) / 2
  text.print(gfx.screen, 'lato', 'black', 'large', tostring(mathProblem['termTwo']), position.termTwo.x -xOffset, position.termTwo.y + yOffset, xOffset*2, fh)


  xOffset = text.getStringLength('lato', 'large', "=") / 2
  text.print(gfx.screen, 'lato', 'black', 'large', "=", position.equals.x - xOffset, position.equals.y + yOffset, xOffset*2, fh)

end


--- Checks if the given answer is correct and provides feedback to the user.
-- @param correctAnswer The correct answer to the problem.
-- @param userAnswer The answer given by the user.
-- @param key The button pressed
function handleAnswer(correctAnswer, userAnswer, key)
-- local gameType = getGameType()
 local isCorrectAnswer = checkAnswer( correctAnswer, userAnswer, key )
 local givePoints = checkGivePoints(answered)
 local points = 1

 answered[key] = true
 if isCorrectAnswer then
    --zoomOutIncorrectAnswers()
    resetAnswered(answered)
    foo = 0
    g = gameType
    p = points
    zoomAnswered(isCorrectAnswer, key)
    foo = 1
    if (givePoints) then
	foo = 2
      profileHandler.update(currentPlayer, 'mathGame', gameType, points)
    	foo = 2.5
    end
   foo = 3
    main()

  else
    zoomAnswered(isCorrectAnswer, key)
 end  

end
-- @param correctAnswer the correct answer to a question
-- @param userAnswer The answe given by the user
-- @param key The button pressed (red, blue, yellow or green)
-- @return True if the user answered correctly False in user answered incorrectly
function checkAnswer( correctAnswer, userAnswer, key )
  if (correctAnswer == userAnswer) then 
    return true
  else return false
  end
end
-- Decides if the user should get point for its answer or not
-- Point is given if the user answers the question correctly on the first try
-- @param answered The state (true/false) of the key entered
-- @return True if the user answered the question correctly on the first try 
-- @return False if the user did not answer the question on the first try
function checkGivePoints (answered)
  local giveAnswerPoints = false
   for key,val in pairs(answered) do
    giveAnswerPoints = giveAnswerPoints or answered[key]
  end
  return not giveAnswerPoints
end

-- Zooms out the incorrect answers
function zoomOutIncorrectAnswers()
  for key,val in pairs(answered) do
    if (not val) then
     answerIsCorrect = animation.zoom(nil, circle[key], position[key].x, position[key].y, 0.0001, 0.005)
    end
  end
end

-- Zooms in the correct answer
-- @param isCorrectAnswer checks if the given answer is correct
-- @param key The answered option
function zoomAnswered(isCorrectAnswer, key)
  local zoom = 0.0001
  if (isCorrectAnswer) then
    zoom = 1.5
  end
  answerIsCorrect= animation.zoom(nil, circle[key], position[key].x, position[key].y, zoom, 0.005)
  --circle[key]:destroy()
  --sleep(1)
end

-- Sets the answered to false
-- @param answered The state of the keys
function resetAnswered(answered)
   for key,val in pairs(answered) do
    answered[key] = false

  end
end


--- Gets input from user and checks answer or controls side-menu
-- @param key The key that has been pressed
-- @param state The state of thed key-press
function onKey(key, state)
  if state == 'down' then
    return
  elseif state == 'repeat' then
    return
  elseif state == 'up' then

      if(key == 'red' and not answered[key]) then
        handleAnswer(correctAnswer, answers[1], key)
       
      elseif(key == 'green' and not answered[key]) then
        handleAnswer(correctAnswer, answers[2], key)
       
      elseif(key == 'yellow' and not answered[key]) then
        handleAnswer(correctAnswer, answers[3], key)
      
      elseif(key == 'blue' and not answered[key]) then
        handleAnswer(correctAnswer, answers[4], key)
       
      elseif(key == "right") then
         destroyCircles()
         --background:destroy()
         assert(loadfile(dir ..'menu.lua'))(currentPlayer)
         --sideMenu = true
        --setMainSrfc()
        --printSideMenu()
      elseif(key == "left") then
        destroyCircles()                        
        --background:destroy()
        dofile(dir ..'login.lua')
      end
  end 
end

--- Runs chosen game (file) if testing mode is off
-- @param path The path to the game to be loaded
-- @param testingModeOn If testing mode is on
function runGame(path, testingModeOn)
  if(not testingModeOn) then
    assert(loadfile(dir .. path))(currentPlayer)
  end
end

--- Sets the background of the screen
function setBackground()
    background = gfx.loadpng('./images/background-game.png')
    gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
    background:destroy()
  return 
end


-- Prints the text in the mascot's speech bubble
function printSpeechBubbleText()

  local mascotText = nil
  local randomInt = nil
  math.randomseed(os.time())
  math.random()
  randomInt = tonumber(math.random(#mascot_text['mathGame']))

  mascotText = mascot_text['mathGame'][randomInt]

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


--- Prints the players name in the top of the screen
function printPlayerName()
  
  local playerName = profileHandler.getName(currentPlayer)
  local playerUserLevel = profileHandler.getLevel(currentPlayer, "mathGame")


    local fw_name = text.getStringLength('lato', 'medium', playerName)
    local fw_level = text.getStringLength('lato', 'medium', "Level " .. playerUserLevel)
    local fh = text.getFontHeight('lato', 'medium')


    text.print(gfx.screen, 'lato', 'black', 'medium', playerName, gfx.screen:get_width()/2 - text.getStringLength('lato', 'medium', playerName)-20, 20, fw_name, fh)
    text.print(gfx.screen, 'lato', 'black', 'medium', "Level " .. playerUserLevel,  gfx.screen:get_width()/2  + 20, 20, fw_level, fh)

end

--- Pauses the system for a period of time
-- @param time The amount of seconds (decimal) the system should sleep
--[[
function 
  sleep(time)
  local t0 = os.clock()
  while os.clock() < (t0 +time) do end
end
--]]


main()
return math









