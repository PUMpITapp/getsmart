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
    profileHandler = require "profileHandler"
    animation = require "animation"
  elseif underGoingTest then 
    gfx = require "gfx_stub"
    text = require "write_text_stub"
    profileHandler = require "profileHandler_stub"
    animation = require "animation_stub"
  end
end 
setRequire(checkTestMode())

-- Set player number
player = ...

-- Imports the table with all data
answerTable = require 'answerTable'

-- Require the table containing all the mascot texts
mascot_text = require 'mascot_text'

---Initiating all global variables
function init()
  rightAlternatives = {} 
  images = {['colors'] = "images/color_choices.png"} 
  inFocus = nil
  alternatives = {}
  allCircles = {}
  allCirclePositions = {}
  answered = {  
    red = false,
    blue = false,
    yellow = false,
    green = false
  }
  isFirstTry = true
end

--- Main function that runs the program
function main()

  init() 
  setBackground()
  wordArray = selectRandomWord()
  question = generateQuestion(wordArray)
  questionPosition = getQuestionPosition(question)
  printWord(question[1], questionPosition[1])
  printQuestionAlternatives(question[2],questionPosition[2])
  printPlayerName()
  printSpeechBubbleText()
end

--- Prints the players name in the top of the screen
function printPlayerName()
	
	local playerName = profileHandler.getName(player)
	local playerUserLevel = profileHandler.getLevel(player, "spellingGame")

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
  randomInt = tonumber(math.random(#mascot_text['spellingGame']))

  mascotText = mascot_text['spellingGame'][randomInt]

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

--- Genrates a random number between 1 and the size of the table answerTable and picks that word in the table
-- @return #table question a table with a word, its intervalls and the different spelling options
function selectRandomWord()
  math.randomseed(os.time())
  math.random()
  math.random()
  local playerUserLevel = profileHandler.getLevel(player, "spellingGame")
  if(playerUserLevel == 0) then
  	playerUserLevel = 1
  end
  local questionPosition = tonumber(math.random(#answerTable[playerUserLevel]))
  local question = answerTable[playerUserLevel][questionPosition]  
  return question
end

--- Shuffles the set {1,2,3,4}
-- @return #table order A random order
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

--- Reorders all sets of alternatives according to a new order
-- @param #table alternatives a table containing all sets of alternatives to the current question
-- @param #table order a table with a given order
-- @return #table shuffleAlternatives a table with all the input alternatives, reordered twith the given order
function reorderAlternatives(alternatives, order)
  local shuffleAlternatives = {}
  for i = 1, #order do
    shuffleAlternatives[order[i]]=alternatives[i]
  end
  return shuffleAlternatives
end

--- Slitting the word into parts so the system know which parts to give altenatives to
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

--- Calculates which position on screen a set of four alternatives will be palced
-- @param #table alternatives the diffrent answer alternatives to be printed in circles on the screen
-- @param #table position a table with a position x and a position y
-- @param #string selected a string with the answer selected by the user, options: red, green, yellow, blue
-- @param #number diameter a number with the diameter of the circles
function printAlternatives(alternatives, position, selected, diameter)
  local d = {
    red = diameter,
    green = diameter,
    yellow  = diameter,
    blue = diameter
  }

  if selected == 'red' then
    selected = 0
  elseif selected == 'green' then
    selected = 1
  elseif selected == 'yellow' then
    selected = 2
  elseif selected == 'blue' then
    selected = 3
  elseif selected == 'start' then
    selected = 1.5
  end 

  local sh = gfx.screen:get_height()

  local startY = position.y - 10 - selected * diameter

  local circlePositions = {
            red     = {x = position.x, y = startY , w = d.red, h = d.red}, --red answer circle position
            green   = {x = position.x, y = startY + diameter , w = d.green, h = d.green}, --yellow answer circle position
            yellow  = {x = position.x, y = startY + 2*diameter, w = d.yellow, h = d.yellow}, --blue answer circle position
            blue    = {x = position.x, y = startY + 3*diameter, w = d.blue, h = d.blue}, --green answer circle position
            previousSelected = selected
  }

  allCirclePositions[#allCirclePositions + 1] = circlePositions

  createAnswerBackground()
end

--- Moves already printed alterantives vertcally based on which key was pressed
-- @param #table alterantives a table with all sets of alternatives for the question
-- @Param #table alternativePositions
-- @param #string key a string with the answer selected by the user, options: red, green, yellow, blue
function moveAlternatives(alternatives, key)
    
  for i=1, #allCircles do
      animation.zoom(background, allCircles[i].red, allCirclePositions[i].red.x, allCirclePositions[i].red.y, 0.00001, 0)
      animation.zoom(background, allCircles[i].green, allCirclePositions[i].green.x, allCirclePositions[i].green.y, 0.00001, 0)
      animation.zoom(background, allCircles[i].yellow, allCirclePositions[i].yellow.x, allCirclePositions[i].yellow.y, 0.00001, 0)
      animation.zoom(background, allCircles[i].blue, allCirclePositions[i].blue.x, allCirclePositions[i].blue.y, 0.00001, 0)
  end
  local selected = 1.5
  if key == 'red' then
    selected = 0
  elseif key == 'green' then
    selected = 1
  elseif key == 'yellow' then
    selected = 2
  elseif key == 'blue' then
    selected = 3
  end 

  previousSelected = allCirclePositions[1].previousSelected
  diameter = allCirclePositions[1].red.w
  newStartY = allCirclePositions[1].red.y + diameter * (previousSelected - selected)
  for i=1, #allCirclePositions do
    allCirclePositions[i].red.y = newStartY
    allCirclePositions[i].green.y = newStartY + diameter
    allCirclePositions[i].yellow.y = newStartY + 2*diameter 
    allCirclePositions[i].blue.y = newStartY + 3*diameter
    allCirclePositions[i].previousSelected = selected
  end
  placeAlternativesOnScreen(alternatives, key)
  return
end

--- Places the alternatives and their respective color circles on the screen
-- @Param #table alterantives a table with all sets of alternatives for the question
-- @param #string selected a string with the answer selected by the user, options: red, green, yellow, blue
function placeAlternativesOnScreen(alternatives, selected)
  for i=1, #allCircles do
    placeAnswersOnCircles(alternatives[i], allCircles[i],allCirclePositions[i])
    placeAnswerCircles(allCirclePositions[i], allCircles[i])
    adjustCircleSize(selected, allCircles[i], allCirclePositions[i])
  end
  gfx.update()
  return
end

--- create the background and the circles for the answers
function createAnswerBackground()

  colorsImg = gfx.loadpng(images.colors)
  diameter = 140

  -- Positions in the circle sprite.
  local xs =40  -- x starting coordinate
  local y = xs  -- y position
  local d = 160 -- diameter of circle
  cutOut ={  red    = {x= xs      , y = y, w = d, h = d},
                   yellow = {x= xs + d  , y = y, w = d, h = d},
                   blue   = {x= xs + d*2, y = y, w = d, h = d},
                   green  = {x= xs + d*3, y = y, w = d, h = d}}


  local circle = {
    red = gfx.new_surface(diameter, diameter),
    green = gfx.new_surface(diameter, diameter),
    yellow = gfx.new_surface(diameter, diameter),
    blue = gfx.new_surface(diameter, diameter)
  }

  circle.red:copyfrom(colorsImg, cutOut.red, true)
  circle.green:copyfrom(colorsImg, cutOut.green, true)
  circle.yellow:copyfrom(colorsImg, cutOut.yellow, true)
  circle.blue:copyfrom(colorsImg, cutOut.blue, true)

  allCircles[#allCircles + 1] = circle
end

--- Places the colored answer circles on their positions
-- @param #table circlePosition a table with the positions of the positions of the four circles
-- @param #table circle A table with four surfaces with circles
function placeAnswerCircles(circlePosition, circle)
  local fh = text.getFontHeight('lato', 'large') -- font height

  local position = circlePosition

  gfx.screen:copyfrom(circle.red, nil, position.red, true)
  gfx.screen:copyfrom(circle.green, nil, position.green, true)
  gfx.screen:copyfrom(circle.blue, nil, position.blue, true)
  gfx.screen:copyfrom(circle.yellow, nil, position.yellow, true)
end

--- place the answers to the right position in their circle
-- @param #table answers a table with the answer alternatives
-- @param #table circle a table of all the circles that the answers will be placed on
-- @param #circlePosition a table with the positions of the positions of the four circles
function placeAnswersOnCircles(answers, circle, circlePosition)

  local fh = text.getFontHeight('lato', 'large') -- font height
  local yOffset = fh /2 + 10
  local xOffset = 0
  local colorCircles = {'red','green','yellow','blue'}

  for i=1, #answers do
    xOffset = text.getStringLength('lato', 'large', tostring(answers[i])) / 2
    if xOffset == 0 then
      circle[colorCircles[i]]:copyfrom(colorsImg, cutOut[colorCircles[i]], true)
    else
      text.print(circle[colorCircles[i]], 'lato', 'black', 'large', tostring(answers[i]), circle[colorCircles[i]]:get_width() /2 - xOffset, circle[colorCircles[i]]:get_height() /2 - yOffset, xOffset*2, fh)
    end
  end
end

function setScale(diameter)
  height = gfx.screen:get_height()
  local scale = (height - diameter) / (7.5 * diameter)
  return scale
end

--- Downsizes the cirlces that are not selected
-- @param #string selected a string representing the selected circle. possible alternatives: 'start', 'red', 'green', 'yellow', 'blue'
-- @param #table circle a table of all the circles that all can be downsized
-- @param #table circlePositions a table of the positions of the circles 
function adjustCircleSize(selected, circle, circlePositions)
  scale = setScale(140)
  if selected == 'start' then
    animation.zoom(background, circle['red'], circlePositions['red'].x, circlePositions['red'].y, scale, 0)
    animation.zoom(background, circle['blue'], circlePositions['blue'].x, circlePositions['blue'].y, scale, 0)
  elseif selected == 'red' then
    animation.changeSize(background, circle['green'], circlePositions['green'].x, circlePositions['green'].y, circlePositions['red'].x, circlePositions['red'].y, scale, 2, 'down')
    animation.changeSize(background, circle['yellow'], circlePositions['yellow'].x, circlePositions['yellow'].y, circlePositions['red'].x, circlePositions['red'].y, scale, 3, 'down')
    animation.changeSize(background, circle['blue'], circlePositions['blue'].x, circlePositions['blue'].y, circlePositions['red'].x, circlePositions['red'].y, scale, 4, 'down')
  elseif selected == 'green' then
    animation.changeSize(background, circle['red'], circlePositions['red'].x, circlePositions['red'].y, circlePositions['green'].x, circlePositions['green'].y, scale, 2, 'up')
    animation.changeSize(background, circle['yellow'], circlePositions['yellow'].x, circlePositions['yellow'].y, circlePositions['green'].x, circlePositions['green'].y, scale, 2, 'down')
    animation.changeSize(background, circle['blue'], circlePositions['blue'].x, circlePositions['blue'].y, circlePositions['green'].x, circlePositions['green'].y, scale, 3, 'down')
  elseif selected == 'yellow' then
    animation.changeSize(background, circle['green'], circlePositions['green'].x, circlePositions['green'].y, circlePositions['yellow'].x, circlePositions['yellow'].y, scale, 2, 'up')
    animation.changeSize(background, circle['red'], circlePositions['red'].x, circlePositions['red'].y, circlePositions['yellow'].x, circlePositions['yellow'].y, scale, 3, 'up')
    animation.changeSize(background, circle['blue'], circlePositions['blue'].x, circlePositions['blue'].y, circlePositions['yellow'].x, circlePositions['yellow'].y, scale, 2, 'down')
  elseif selected == 'blue' then
    animation.changeSize(background, circle['yellow'], circlePositions['yellow'].x, circlePositions['yellow'].y,circlePositions['blue'].x, circlePositions['blue'].y, scale, 2, 'up')  
    animation.changeSize(background, circle['green'], circlePositions['green'].x, circlePositions['green'].y,circlePositions['blue'].x, circlePositions['blue'].y, scale, 3, 'up')
    animation.changeSize(background, circle['red'], circlePositions['red'].x, circlePositions['red'].y,circlePositions['blue'].x, circlePositions['blue'].y, scale, 4, 'up')
  end
end

--- Calculates where the word parts and alternative sets should be printed.
-- @param #table question a table of ward parts and alternative sets
-- @return #table questionPosition a table of coordinates indicating where the questions word parts and alternative sets should be printed form.
function getQuestionPosition(question)
  local fh = text.getFontHeight('lato', 'large')
  local wordPartPositions = {}
  local alternativePositions = {}
  local diameter = 140
  local questionLength = questionLength(question, diameter)

  local startPosition = {
    x = gfx.screen:get_width()/2 - questionLength/2 - diameter,
    y = gfx.screen:get_height()/ 2 - fh/2
  }
  
  for i = 1, #question[1] do
    startPosition.x = startPosition.x + diameter
    wordPartPositions[i] = {
      x = startPosition.x,
      y = startPosition.y
    }
    startPosition.x = startPosition.x + text.getStringLength('lato', 'large',question[1][i])

    if i <= #question[2] then
      alternativePositions[i] = {
        x = startPosition.x,
        y = startPosition.y
      }
    end
  end
  return {wordPartPositions, alternativePositions}
end

--- Prints the word parts of the current question to the screen
-- @param #table wordParts a table containgin the current questions word parts 
-- @param #table wordPartsPosition a table containing the coordinated at which the word parts will be placed 
function printWord(wordParts, wordPartPosition)
  --gfx.screen:clear({122,219,228})
  
  for i=1, #wordParts do
    text_testValue = text.print(gfx.screen, 'lato', 'black', 'large', wordParts[i], wordPartPosition[i].x ,  wordPartPosition[i].y)    
  end

  return "printed"
end

--- Prints the sets of alternatives in their designated posittons based on which alternative is selected
-- @param #table alterantives a table containing the sets of alterantives
-- @param #table alternativePositions a table containing the desiganted positions of the alternatives
-- @param #string key a string reprenting the selected alternative
function printQuestionAlternatives(alternatives, alternativePositions, key)
  key = key or 'start'
  diameter = 140
  if key ~= 'start' then
    moveAlternatives(alternatives, key)
  else
    for i=1, #alternatives do
      printAlternatives(alternatives[i],alternativePositions[i],key,diameter)
    end
    placeAlternativesOnScreen(alternatives, key) 
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
-- Remover the selcted option
-- @param #number userChoice the number labled to the selcted buttom
-- @param #string key the button the user choose, options: red, green, yellow, blue
function removeAlternative(userChoice, key)
  for i=1, #question[2] do
    question[2][i][userChoice] = ''
  end
  printQuestionAlternatives(question[2],questionPosition[2],key)
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
  	if(isFirstTry) then
	    profileHandler.update(player,'spellingGame', nil, 1)
    end
    inFocus = nil
    main()
  else
    removeAlternative(userChoice, key)
    isFirstTry = false
    return false
  end
end

--- Sets the background of the screen
function setBackground()
    background = gfx.loadpng('./images/background-game.png')
    --background = gfx.new_surface(gfx.screen:get_width(), gfx.screen:get_height())
    --background:clear({122,219,228})
    gfx.screen:copyfrom(background, nil, {x=0 , y=0, w=gfx.screen:get_width(), h=gfx.screen:get_height()})
  return 
end

--- Runs chosen game (file) if testing mode is off
-- @param #string path The path to the game to be loaded
-- @param #boolean testingModeOn If testing mode is on
function runGame(path, testingModeOn)
	if(not testingModeOn) then
		assert(loadfile(path))(player)
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
        sideMenu = false
        gamePath = 'mathGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == 'green') then
        sideMenu = false
        gamePath = 'memoryGame.lua'
        runGame(gamePath, underGoingTest)
      elseif(key == 'yellow') then
        sideMenu = false
        changeSrfc()
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

      -- In-game control when side menu is down
    elseif(not sideMenu) then
      --give answer     
      if(key == 'red') then
        if(key==inFocus) then --if you have highlighted an answer and choose it as answer
          checkAnswer(key,question[2],rightAlternatives)
        else
          inFocus = key
          printQuestionAlternatives(question[2],questionPosition[2],key)
        end
      elseif(key == 'green') then
        if(key==inFocus) then
          checkAnswer(key,question[2],rightAlternatives) 
        else
          inFocus = key
          printQuestionAlternatives(question[2],questionPosition[2],key)
       end
      elseif(key == 'yellow') then
        if(key==inFocus) then
          checkAnswer(key,question[2],rightAlternatives)
        else
          inFocus = key
          printQuestionAlternatives(question[2],questionPosition[2],key)
        end
      elseif(key == 'blue') then
        if(key==inFocus) then
          checkAnswer(key,question[2],rightAlternatives)
        else
          inFocus = key
          printQuestionAlternatives(question[2],questionPosition[2],key)
        end
      elseif(key == "right") then
        sideMenu = true
        setMainSrfc()
        printSideMenu()
      end
    end
         
  elseif (state == "repeat") then
  end 
end

main()
