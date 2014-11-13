--- Checks if the file was called from a test file.
-- @return #boolean If called from test file return true (indicating file is being tested) else false  
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
    --animation = require "animation"
  elseif underGoingTest then 
    gfx = require "gfx_stub"
    text = require "write_text_stub"
    --animation = require "animation_stub"
  end
end 
setRequire(checkTestMode())

gfx.screen:clear({122,219,228})

---Initiating all global variables
function init()
  answerTable = {
    {'Yesterday',{{2,3},{6,7}},{{'es','is','ez','oys'},{'rd','d','rp','ld'}}},
    {'Artichoke',{{3,4}},{{'ti','tie','te','to'}}},
    {'Scrummaster',{{2,3},{5,6}},{{'cr','ckr','kr','crr'},{'mm','m','me','mme'}}}
  }
  rightAlternatives = {} 
  images = {['colors'] = "images/color_choices.png"} 
  key = 'yellow'
  keyState = nil
  alternatives = {}
end

--- Main function that runs the program
function main()
  init() 
  wordArray = selectRandomWord()
  question = generateQuestion(wordArray)
  printQuestion(question,key)
end


--- Genrates a random number between 1 and the size of the table answer table and picks that word in the table
-- @return #table question a table with a word, its intervalls and the different spelling options
function selectRandomWord()
  math.randomseed(os.time())
  math.random()
  math.random()
  local questionPosition = tonumber(math.random(#answerTable))
  local question = answerTable[questionPosition]
  return question
end

--- Shuffles the order of answer alternatives
-- @param #table alternatives A table with possible answer alternatives
-- @return #table alternatives Same table but in different order
--[[function shuffleOrder(alternatives)
  local n = #alternatives

  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    alternatives[n], alternatives[k] = alternatives[k], alternatives[n]
    n = n - 1
  end
 
  return alternatives
end]]

function shuffleOrder()
  local order = {1,2,3,4}
  local n = #order

  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    order[n], order[k] = order[k], order[n]
    n = n - 1
  end
 
  return order
end

function reorderAlternatives(alternatives, order)
  local shuffleAlternatives = {}
  for i = 1, #order do
    shuffleAlternatives[order[i]]=alternatives[i]
  end
  return shuffleAlternatives
end

---Slitting the word into parts so the system know which parts to give altenatives to
-- @param #string word the word that will be split
-- @param #table Intervalls the intervalls the word will be split into
-- @renurn #table wordParts a teble of the parts of the word
function splitIntoWordParts(word,Intervalls)
  local wordParts = {}

  local previousUpperLimit = 0

  for i = 1, #Intervalls do
    if Intervalls[i][1] > 1 then
      wordParts[i] = word:sub(previousUpperLimit + 1, Intervalls[i][1] - 1)
    end

    previousUpperLimit = Intervalls[i][2]
  end

  if Intervalls[#Intervalls][2] < word:len() then
    if Intervalls[#Intervalls][1] == 1 then
      wordParts[1] = word:sub(Intervalls[#Intervalls][2])
    else
      wordParts[#Intervalls+1] = word:sub(previousUpperLimit+1)
    end
  end
  return wordParts
end

--- Generates a word with some parts taken out and instead given alternatives to that part
-- @param #table wordArray a table with a word split up in parts
-- @return #table question a Table with the word in parts plus the altenatives to the parts with alternatives
function generateQuestion(wordArray)
  for i = 1, #wordArray[3] do
    rightAlternatives[i] = wordArray[3][i][1]
  end

  wordParts = splitIntoWordParts(wordArray[1],wordArray[2])
  order = shuffleOrder()
  local scrambledAlternatives = {}

  for i=1, #wordArray[3] do
    scrambledAlternatives[i] = reorderAlternatives(wordArray[3][i],order)
  end

  question = {wordParts, scrambledAlternatives}

  return question
end

--- Printing the alternatives on the screen in circles with different colors
-- @param #table alternatives the diffrent answer alternatives to be printed in circles on the screen
-- @param #table position a table with a position x and a position y
-- @param #string selected a string with the answer selected by the user, options: red, green, yellow, blue
-- @param #number diameter a number with the diameter of the circles
function printAlternatives(alternatives, position, selected, diameter)
  if selected == 'red' then
    selected = 0
  elseif selected == 'green' then
    selected = 1
  elseif selected == 'yellow' then
    selected = 2
  elseif selected == 'blue' then
    selected = 3
  end

  local d = diameter
  local sh = gfx.screen:get_height()

  local startY = position.y - selected * d

  circlePositions = {
            red     = {x = position.x, y = startY , w = d, h = d}, --red answer circle position
            green   = {x = position.x, y = startY + d , w = d, h = d}, --yellow answer circle position
            yellow  = {x = position.x, y = startY + 2*d, w = d, h = d}, --blue answer circle position
            blue    = {x = position.x, y = startY + 3*d, w = d, h = d}} --green answer circle position

  createAnswerBackground()
  placeAnswersOnCircles(alternatives)
  placeAnswerCircles(circlePositions)
  gfx.update()

end

--- create the background and the circles for the answers
function createAnswerBackground()
  colorsImg = gfx.loadpng(images.colors)

  -- Positions in the circle sprite.
  local xs =40  -- x starting coordinate
  local y = xs  -- y position
  local d = 160 -- diameter of circle
  local cutOut ={  red    = {x= xs      , y = y, w = d, h = d},
                   yellow = {x= xs + d  , y = y, w = d, h = d},
                   blue   = {x= xs + d*2, y = y, w = d, h = d},
                   green  = {x= xs + d*3, y = y, w = d, h = d}}


  circle = {
    red = gfx.new_surface(cutOut.red.w, cutOut.red.h),
    green = gfx.new_surface(cutOut.green.w, cutOut.green.h),
    yellow = gfx.new_surface(cutOut.yellow.w, cutOut.yellow.h),
    blue = gfx.new_surface(cutOut.blue.w, cutOut.blue.h)
  }

  circle.red:copyfrom(colorsImg, cutOut.red, true)
  circle.green:copyfrom(colorsImg, cutOut.green, true)
  circle.yellow:copyfrom(colorsImg, cutOut.yellow, true)
  circle.blue:copyfrom(colorsImg, cutOut.blue, true)

end

--- Places the colored answer circles on their positions
-- @param #table circlePosition a table with the positions of the positions of the four circles
function placeAnswerCircles(circlePosition)
  local fh = text.getFontHeight('lato', 'large') -- font height

  local position = circlePosition

  gfx.screen:copyfrom(circle.red, nil, position.red, true)
  gfx.screen:copyfrom(circle.green, nil, position.green, true)
  gfx.screen:copyfrom(circle.blue, nil, position.blue, true)
  gfx.screen:copyfrom(circle.yellow, nil, position.yellow, true)

end

--- place the answers to the right position in their circle
--@param #number answers The answer options that is given to the user 
function placeAnswersOnCircles(answers)
  local fh = text.getFontHeight('lato', 'large') -- font height
  local yOffset = fh /2

  local xOffset = text.getStringLength('lato', 'large', tostring(answers[1])) / 2

  text.print(circle.red, 'lato', 'black', 'large', tostring(answers[1]), circle.red:get_width() /2 - xOffset, circle.red:get_height() /2 - yOffset, xOffset*2, fh)
 
  xOffset = text.getStringLength('lato', 'large', tostring(answers[2])) / 2

  text.print(circle.green, 'lato', 'black', 'large', tostring(answers[2]), circle.green:get_width() /2 - xOffset, circle.green:get_height() /2 - yOffset, math.ceil(xOffset*2), fh)
  
  xOffset = text.getStringLength('lato', 'large', tostring(answers[3])) / 2

  text.print(circle.yellow, 'lato', 'black', 'large', tostring(answers[3]), circle.yellow:get_width() /2 - xOffset, circle.yellow:get_height() /2 - yOffset, xOffset*2, fh)
  
  xOffset = text.getStringLength('lato', 'large', tostring(answers[4])) / 2

  text.print(circle.blue, 'lato', 'black', 'large', tostring(answers[4]), circle.blue:get_width() /2 - xOffset, circle.blue:get_height() /2 - yOffset, xOffset*2, fh)
end

--- Printing the enitre question on the screen
-- @param #table question a table with a word, its intervalls and spelling options
-- @param #string key the choise made by the user
function printQuestion(question, key)

  gfx.screen:clear({122,219,228})
  
  local diameter = 125

  local questionLength = questionLength(question, diameter)

  local position = {
    x = gfx.screen:get_width()/2 - questionLength/2 - diameter,
    y = gfx.screen:get_height()/ 2
  }

  for i = 1, #question[1] do

    position.x = position.x + diameter

    text_testValue = text.print(gfx.screen, 'lato', 'black', 'large', question[1][i], position.x ,  position.y)

    position.x = position.x + text.getStringLength('lato', 'large',question[1][i])  

    if  i <= #question[2] then
      printAlternatives(question[2][i],position,key,diameter)
    end

  end

end

--- Determines the length of the question
-- @Param #table question The question consisting of the word parts and alternatives
-- @Param #number diameter The diameter of the colored circles
-- @return #number questionLength The pixel length of the question to be printed on the screen.
function questionLength(question, diameter)
  local questionLength = diameter * #question[2]
  for i=1, #question[1] do
    questionLength = questionLength + text.getStringLength('lato','large',question[1][i])
  end
  return questionLength
end

---Check if the answer is correct
-- @param #string key the button the user choose, options: red, green, yellow, blue
-- @param #table alternatives All answer options in a specific order
-- @param #string rightanswer The correct answer
-- @return #boolean correct returns true if the answer is correct

function checkAnswer(key,alternatives,rightanswer)
  local userChoice = 0
  --local alternatives = alternatives
  if (key=='red') then
    userChoice = 1
  elseif(key=='green') then
    userChoice = 2
  elseif(key== 'yellow') then
    userChoice = 3
  elseif (key=='blue') then
    userChoice = 4
  end
  --checks which 
  --has to check how many answers the question has and if which of them to check
  local choosenAlternative = alternatives[1][userChoice]
  local correctAnswer = rightanswer[1]
  if (choosenAlternative==correctAnswer) then
    return true
  else
    return false
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
      sideMenu = false
      if(key == 'red') then
        dofile('mathGame.lua')
      elseif(key == 'green') then
        dofile('memoryGame.lua')
      elseif(key == 'yellow') then
        dofile('spellingGame.lua')
      elseif(key == 'blue') then
        dofile('geographyGame.lua')
      elseif(key == "M") then
         changeSrfc()
      end

      -- In-game control when side menu is down
    elseif(not sideMenu) then
      --give answer
      if(key == 'red') then
        if(key==keyState) then --if you have highlighted an answer and choose it as answer
          if (checkAnswer(key,question[2],rightAlternatives)==true) then -- checking if answer is true
            main()
          else
            print('wrong')
          end
        else
         printQuestion(question,key)
        end
      elseif(key == 'green') then
        if(key==keyState) then 
          if (checkAnswer(key,question[2],rightAlternatives)==true) then 
            main()
          else
            print('wrong')
          end
        else
          printQuestion(question,key)
       end
      elseif(key == 'yellow') then
        if(key==keyState) then
          if (checkAnswer(key,question[2],rightAlternatives)==true) then
            main()
          else
            print('wrong')
          end
        else
          printQuestion(question,key)
        end
      elseif(key == 'blue') then
        if(key==keyState) then
          if (checkAnswer(key,question[2],rightAlternatives)==true) then
          main()
          else
            print('wrong')
          end
        else
          printQuestion(question,key)
        end
      elseif(key == "M") then
        sideMenu = true
        setMainSrfc()
        printSideMenu()
      end
      keyState = key
    end
         
  elseif (state == "repeat") then
  end 
end

main()
