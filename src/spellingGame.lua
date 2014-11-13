text = require "write_text"
gfx = require "gfx"

gfx.screen:clear({122,219,228})

--text.print(gfx.screen, arial, "Spelling Game coming soon!", 70 , 300 )


function init()
  answerTable = {
    {'Yesterday',{{2,3},{6,7}},{{'es','is','ez','oys'},{'rd','d','rp','ld'}}},
    {'Artichoke',{{3,4}},{{'ti','tie','te','to'}}}
  }
  rightAlternatives = {} 
  images = {['colors'] = "images/color_choices.png"} 
end

function main()
  init() 
  wordArray = selectRandomWord()
  question = generateQuestion(wordArray)
  
  printQuestion(question)

  
  

end

--- Genrates a random number between 1 and the size of the table answer table and picks that word in the table. 
function selectRandomWord()
  math.randomseed(os.time())
  math.random()
  math.random()
  local questionPosition = tonumber(math.random(1, #answerTable))
  local question = answerTable[questionPosition]
  return question
end

function shuffleOrder(alternatives)
  local n = #alternatives

  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    alternatives[n], alternatives[k] = alternatives[k], alternatives[n]
    n = n - 1
  end
 
  return alternatives
end

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
    wordParts[#Intervalls+1] = word:sub(previousUpperLimit+1)
  end

  return wordParts
end

function generateQuestion(wordArray)
  for i = 1, #wordArray[3] do
    rightAlternatives[i] = wordArray[3][i][1]
  end

  wordParts = splitIntoWordParts(wordArray[1],wordArray[2])
  local scrambledAlternatives = {}

  for i=1, #wordArray[3] do
    scrambledAlternatives[i] = shuffleOrder(wordArray[3][i])
  end

  question = {wordParts, scrambledAlternatives}

  return question
end

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

----------------------------------------------------
--- create the background and the "circles" for the answers
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



----------------------------------------------------

function printQuestion(question)
  gfx.screen:clear({122,219,228})
  
  local diameter = 125
  local position = {
    x = gfx.screen:get_height() /2 - diameter,
    y = gfx.screen:get_height()/ 2
  }

  for i = 1, #question[1] do

    position.x = position.x + diameter

    text.print(gfx.screen, 'lato', 'black', 'large', question[1][i], position.x ,  position.y)

    position.x = position.x + text.getStringLength('lato', 'large',question[1][i])  

    if  i <= #question[2] then
      printAlternatives(question[2][i],position,'yellow',diameter)
    end

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
      if(key == 'red') then
     --   checkAnswer(correctAnswer, answers[1])
      elseif(key == 'green') then
     --   checkAnswer(correctAnswer, answers[2])
      elseif(key == 'yellow') then
      --  checkAnswer(correctAnswer, answers[3])
      elseif(key == 'blue') then
      --  checkAnswer(correctAnswer, answers[4])
      elseif(key == "M") then
        sideMenu = true
        setMainSrfc()
        printSideMenu()
      end
    end
         
  elseif (state == "repeat") then
  end 
end

main()
