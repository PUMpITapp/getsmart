--- GetMathSmart
--
-- A math game to learn and practice the basic arithmetic calculations
-- addition, subtraction, multiplication and division. The user gets a
-- mathimatical problem with four answers to choose from. The difficulty 
-- of the problem is based on what level the user has reached:
-- level 1: addition 0-9
-- level 2: addition 10-99
-- level 3: subtraction 0-9
-- level 4: subtraction 10-99
-- level 5: multiplication 0-3 * 1-5
-- level 6: multiplication 0-3 * 1-9
-- level 7: multiplication 0-5 * 1-9
-- level 8: multiplication 2-9 * 2-9
--
-- The answers are displayed in different colors that represent the
-- colored buttons on the remotecontrol. Pressing one of the buttons 
-- will display if the answer is correct or not and take the user onwards
-- to new questions. 

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
gfx.update()

answers = {}

-- Directory of artwork 
dir = './'

-- All images in the game are placed in this table
images ={['colors'] = "images/color_choices.png"}
 

-- Main function that runs the program
local function main()

  gfx.screen:clear({122,219,228})

  ------------------------------------------------------------------------
  --  INCOMPLETE! 
  -- level will come from user but at the moment it is a static number. --
  ------------------------------------------------------------------------
  local level = tonumber(3)


  local mathProblem = produceMathProblem(level)
  correctAnswer = solveProblem(mathProblem)
  local answers = produceAnswers(correctAnswer)
  placeAnswerBackground()
  printProblem(mathProblem, answers)

end

--- produces a math problem based on the level of the user.
-- @param level The difficulty level of the problem
function produceMathProblem(level)
 -- level not implemented yet
  local operator = getOperator(level)
  local lowerBound = tonumber(getLowerBound(level))
  local upperBound = tonumber(getUpperBound(level))

  -- Because of Lua random being semi-random from fixed lists
  -- this solution provides a more random behavior
  math.randomseed(os.time())
  math.random()
  math.random()
  local termOne = tonumber(math.random(lowerBound, upperBound))
  local termTwo = tonumber(math.random(lowerBound, upperBound))

  local problem = {}
  problem["termOne"] = termOne
  problem["termTwo"] = termTwo
  problem["operator"] = operator
  return problem
end

--- Solves a math problem
-- Gets a table with the first and second term and the operator.
-- Solves the problem based on the operator.
-- Returns the correct answer
-- @param The math problem to be solved
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
-- @param level The difficulty level of the math problem.
-- @return Returns the operator for a math problem.
function getOperator(level)
  local operator = nil

  if(level > 8) then      operator = '/'
  elseif(level > 4) then  operator = '*'
  elseif(level > 2) then  operator = '-'
  else                    operator = '+'
  end

  return operator
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


function placeAnswerBackground()


  

 --gfx.screen:copyfrom(colorsImg, cutOut.red, position.red)
 --gfx.screen:copyfrom(colorsImg, cutOut.green, position.green)
 --gfx.screen:copyfrom(colorsImg, cutOut.blue, position.blue)
 --gfx.screen:copyfrom(colorsImg, cutOut.yellow, position.yellow)


end


--- Displays the problem and the answers on the screen by invoking write_text.lua.
-- @param mathProblem The problem to be displayed on the screen.
-- @param answers The possible answers for the problem.
function printProblem(mathProblem, answers)

---------------------------------------------------------------
----- TEMPORARY CODE -----------------------------------------
----- Placeing the colored circles----------------------------
----- the rest is ok. ----------------------------------------
---------------------------------------------------------
colorsImg = gfx.loadpng(images.colors)

local xs =40  -- x starting coordinate
local y = xs  -- y position
local d = 160 -- diameter of circle
local cutOut ={  red    = {x = xs     , y = y, w = d, h = d},
                 yellow = {x= xs + d  , y = y, w = d, h = d},
                 blue   = {x= xs + d*2, y = y, w = d, h = d},
                 green  = {x= xs + d*3, y = y, w = d, h = d}}


  -- Printing the numbers on the correct position on the screen
  local sw = gfx.screen:get_width()  -- screen width
  local sh = gfx.screen:get_height() -- screen height
  local fh = text.getFontHeight(arial) -- font height

  position = {termOne   = {x = sw * 0.13, y = sh * 0.4},
                    operator  = {x = sw * 0.23, y = sh * 0.4},
                    termTwo   = {x = sw * 0.33, y = sh * 0.4},
                    equals    = {x = sw * 0.43, y = sh * 0.4},
                    red       = {x = sw * 0.55, y = sh * 0.40 , w = 200, h = 200},
                    yellow    = {x = sw * 0.70, y = sh * 0.55 , w = 200, h = 200},
                    blue      = {x = sw * 0.85, y = sh * 0.40 , w = 200, h = 200},
                    green     = {x = sw * 0.70, y = sh * 0.25 , w = 200, h = 200},
                    redC      = {x = sw * 0.55 - d/2, y = sh * 0.40, w = d, h = d},
                    yellowC   = {x = sw * 0.70 - d/2, y = sh * 0.55, w = d, h = d},
                    blueC     = {x = sw * 0.85 - d/2, y = sh * 0.40, w = d, h = d},
                    greenC    = {x = sw * 0.70 - d/2, y = sh * 0.25, w = d, h = d}}

 gfx.screen:copyfrom(colorsImg, cutOut.red, position.redC)
 gfx.screen:copyfrom(colorsImg, cutOut.green, position.greenC)
 gfx.screen:copyfrom(colorsImg, cutOut.blue, position.blueC)
 gfx.screen:copyfrom(colorsImg, cutOut.yellow, position.yellowC)

  local xOffset = 0     -- the horizontal offset to center the text over the position, half the strings width
  local yOffset = fh/2  -- the vertical offset to venter the text over the position, half the font height
  xOffset = text.getStringLength(arial, tostring(mathProblem.termOne)) / 2
  text.print(gfx.screen, arial, tostring(mathProblem['termOne']), position.termOne.x - xOffset ,position.termOne.y + yOffset, xOffset*2, fh)

  xOffset = text.getStringLength(arial, tostring(mathProblem.operator)) / 2
  text.print(gfx.screen, arial, tostring(mathProblem['operator']), position.operator.x - xOffset, position.operator.y + yOffset, xOffset*2, fh)

  xOffset = text.getStringLength(arial, tostring(mathProblem.termTwo)) / 2
  text.print(gfx.screen, arial, tostring(mathProblem['termTwo']), position.termTwo.x -xOffset, position.termTwo.y + yOffset, xOffset*2, fh)

  xOffset = text.getStringLength(arial, "=") / 2
  text.print(gfx.screen, arial, "=", position.equals.x - xOffset, position.equals.y + yOffset, xOffset*2, fh)

  -- Printing the answers
 
  xOffset = text.getStringLength(arial, tostring(answers[1])) / 2
  text.print(gfx.screen, arial, tostring(answers[1]), position.red.x - xOffset, position.red.y + yOffset, xOffset*2, fh)

  xOffset = text.getStringLength(arial, tostring(answers[2])) / 2
  text.print(gfx.screen, arial, tostring(answers[2]), position.green.x - xOffset, position.green.y + yOffset, xOffset*2, fh)

  xOffset = text.getStringLength(arial, tostring(answers[3])) / 2
  text.print(gfx.screen, arial, tostring(answers[3]), position.yellow.x - xOffset, position.yellow.y + yOffset, xOffset*2, fh)

  xOffset = text.getStringLength(arial, tostring(answers[4])) / 2  
  text.print(gfx.screen, arial, tostring(answers[4]), position.blue.x - xOffset, position.blue.y + yOffset, xOffset*2, fh)


end


--- Checks if the given answer is correct and provides feedback to the user.
-- @param correctAnswer The correct answer to the problem.
-- @param userAnswer The answer given by the user.
function checkAnswer(correctAnswer, userAnswer)

  if (correctAnswer == userAnswer) then
   gfx.screen:clear({0,255,0})
   message = text.print(gfx.screen, arial, "Correct", gfx.screen:get_height() /2 ,  gfx.screen:get_height() /2 -100)
  else 
   gfx.screen:clear({255,0,0})
   message = text.print(gfx.screen, arial, "Wrong", gfx.screen:get_height() /2 ,  gfx.screen:get_height() /2 - 100)  
  end
end

--- Gets input from user and checks answer
-- @param key The key that has been pressed
-- @param state
function onKey(key, state)
  if state == 'down' then

  elseif state == 'up' then

    --if side menu is up
    if(sideMenu) then
      
      if(key == 'red') then
        sideMenu = false
        dofile('mathGame.lua')
      elseif(key == 'green') then
        sideMenu = false
        dofile('memoryGame.lua')
      elseif(key == 'yellow') then
        sideMenu = false
        dofile('spellingGame.lua')
      elseif(key == 'blue') then
        sideMenu = false
        dofile('geographyGame.lua')
      elseif(key == "M") then
        sideMenu = false
         changeSrfc()
      end
      
      -- In-game control when side menu is down
    elseif(not sideMenu) then
      if(key == 'red') then
        checkAnswer(correctAnswer, answers[1])
        sleep(1)
        main()
      elseif(key == 'green') then
        checkAnswer(correctAnswer, answers[2])
        sleep(1)
        main()
      elseif(key == 'yellow') then
        checkAnswer(correctAnswer, answers[3])
        sleep(1)
        main()
      elseif(key == 'blue') then
        checkAnswer(correctAnswer, answers[4])
        sleep(1)
        main()
      elseif(key == "M") then
        sideMenu = true
        setMainSrfc()
        printSideMenu()
      end

    end
         
  elseif (state == "repeat") then
  end 
end



--- Pauses the system for a period of time
-- @param time The amount of seconds the system should sleep
function sleep(time)
  local t0 = os.clock()
  while os.clock() < (t0 +time) do end
end

main()
return math









