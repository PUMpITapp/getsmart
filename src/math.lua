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


-- Require the grafics library and setting the background color
gfx = require "gfx"
gfx.screen:clear({255,0,0})
gfx.update()
correctAnswer = 0
answers = {}

-- Directory of artwork 
dir = './'

-- All the numbers as .png pictures with transparent background 
-- with size: 
png_math_width = 140 
png_math_height = 160 
png_math = {
  num1 = 'images/1.png',
  num2 = 'images/2.png',
  num3 = 'images/3.png',
  num4 = 'images/4.png',
  num5 = 'images/5.png',
  num6 = 'images/6.png',
  num7 = 'images/7.png',
  num8 = 'images/8.png',
  num9 = 'images/9.png',
  num0 = 'images/0.png',
  plus = 'images/plus.png',
  minus = 'images/minus.png',
  divide = 'images/divide.png',
  multiply = 'images/multiply.png',
  equals = 'images/equals.png',
  question = 'images/question.png',
}

-- Main function that runs the program
local function main()

  ------------------------------------------------------------------------
  --  INCOMPLETE! 
  -- level will come from user but at the moment it is a static number. --
  ------------------------------------------------------------------------
  local level = tonumber(3)


  local mathProblem = produceMathProblem(level)
  correctAnswer = solveProblem(mathProblem)
  answers = produceAnswers(correctAnswer)
  printProblem(mathProblem, answers)

  checkAnswer(correctAnswer ,userAnswer)
 
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
  if(mathProblem['operator'] == "plus") then
    answer = tonumber(mathProblem['termOne'] + mathProblem['termTwo'])
  end
  
  if(mathProblem['operator'] == "minus") then
    answer = tonumber(mathProblem['termOne'] - mathProblem['termTwo'])
  end

  if(mathProblem['operator'] == "multiply") then
    answer = tonumber(mathProblem['termOne'] * mathProblem['termTwo'])
  end

  if(mathProblem['operator'] == "divide") then
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

  if(level > 8) then      operator = 'divide'
  elseif(level > 4) then  operator = 'multiply'
  elseif(level > 2) then  operator = 'minus'
  else                    operator = 'plus'
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
  offset = math.random(3)
  answers[1] = correctAnswer - offset
  answers[2] = correctAnswer - offset +1
  answers[3] = correctAnswer - offset +2
  answers[4] = correctAnswer - offset +3
 
  return answers
end


--- Displays the problem and the answers on the screen.
-- @param mathProblem The problem to be displayed on the screen.
-- @param answers The possible answers for the problem.
--
------------------------------------------------------------------
-- NOT FINISHED!! Making the spacing more generic still missing --
------------------------------------------------------------------
--
function printProblem(mathProblem, answers)

  -- Printing the numbers on the correct position on the screen
  local position = {}
  position['x'] = gfx.screen:get_width() / 8
  position['y'] = gfx.screen:get_height() / 2 - png_math_height / 2

  -- Printing the problem
  printNumber(tonumber(mathProblem['termOne']), position)

  position['x'] = position['x'] + png_math_width
  printOperator(tostring(mathProblem['operator']), position)

  position['x'] = position['x'] + png_math_width / 4
  printNumber(tonumber(mathProblem['termTwo']), position)

  position['x'] = position['x'] + png_math_width
  printOperator('equals', position)

  -- Printing the answers
  position['x'] = position['x'] + png_math_width / 3
  printNumber(answers[1],position)

  position['x'] = position['x'] + png_math_width
  position['y'] = position['y'] - png_math_height / 2
  printNumber(answers[2],position)

  position['y'] = position['y'] + png_math_height
  printNumber(answers[3],position)

  position['x'] = position['x'] + png_math_width
  position['y'] = position['y'] - png_math_height / 2
  printNumber(answers[4],position)

  gfx.update()

end

--- Displays a number on the screen on the desired position.
-- @param number The number to be displayed.
-- @param position The position coordinates where the number should be displayed.
function printNumber(number, position)
  -- Boolean to set if the number is larger than 100
  local large = false
  local toScreen = nil

  if(number < 0) then
    number = math.abs(number) 
    local minusPos = {}
    minusPos['x'] = position['x'] + (png_math_width / 4) * (2 - tostring(number):len())
    minusPos['y'] = position['y']
    printOperator('minus', minusPos)
  end

 if(number > 99) then
    large = true
    toScreen = gfx.loadpng(dir .. png_math['num' .. math.floor(number / 100)])
    gfx.screen:copyfrom(toScreen, nil, { x = position['x'], y = position['y'] })
    number = number - math.floor(number / 100) * 100
  end
  if(number > 9 or large) then
    large = false
    toScreen = gfx.loadpng(dir..png_math['num' .. math.floor(number / 10)])
    gfx.screen:copyfrom(toScreen, nil,  { x = position['x'] + png_math_width / 4, y = position['y'] })
  end

  toScreen = gfx.loadpng(dir .. png_math['num' .. number % 10])
  gfx.screen:copyfrom(toScreen, nil,  { x = position['x'] + png_math_width / 2, y = position['y'] })
 
  toScreen:destroy()

end

--- Dsiplays the operator on the screen on the desired position.
-- @param operator The operator to be displayed.
-- @param position The position coordinates where the number should be displayed.
function printOperator(operator ,position)

  local toScreen = nil
  toScreen = gfx.loadpng(dir..png_math[operator])
  gfx.screen:copyfrom(toScreen, nil, { x = position['x'], y = position['y'] })
 
  toScreen:destroy()
end

function checkAnswer(correctAnswer, userAnswer)
  if (correctAnswer == userAnswer) then
    -- Something cool happens
    gfx.screen:clear({246,255,0})
    gfx.update()
  end
end

--- Gets input from user and checks answer
-- @param key The key that has been pressed
-- @param state
function onKey(key, state)

  if(key == 'red') then
    checkAnswer(correctAnswer, answers[1])
  elseif(key == 'green') then
    checkAnswer(correctAnswer, answers[2])
  elseif(key == 'yellow') then
    checkAnswer(correctAnswer, answers[3])
  elseif(key == 'blue') then
    checkAnswer(correctAnswer, answers[4])
  end
end

main()









