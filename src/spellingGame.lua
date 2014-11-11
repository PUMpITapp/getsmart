text = require "write_text"
gfx = require "gfx"

gfx.screen:clear({122,219,228})

text.print(gfx.screen, arial, "Spelling Game coming soon!", 70 , 300 )


function init()
  answerTable = {
    {'Yesterday',{{2,3},{6,7}},{{'es','is','ez','oys'},{'rd','d','rp','ld'}}}
  }
  rightAlternatives = {} 
  imagers = {['colors'] = "images/color_choices.png"} 
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

  for i = 1, #alternatives do
    text.print(gfx.screen, arial, alternatives[i], position.x, position.y - diameter*selected + diameter*(i-1))
  end

end

function printQuestion(question)
  gfx.screen:clear({122,219,228})
  -- wordLeftSide = question[1]:sub(1,question[2][1][1]-1)
  local diameter = 120
  local position = {
    x = gfx.screen:get_height() /2 - diameter,
    y = gfx.screen:get_height()/ 2 - 100
  }

  colorsImg = gfx.loadpng(images.colors)

  for i = 1, #question[1] do

    position.x = position.x + diameter

    text.print(gfx.screen, arial, question[1][i], position.x ,  position.y)

    position.x = position.x + text.getStringLength(arial,question[1][i])  

    if  i <= #question[2] then
      printAlternatives(question[2][i],position,'yellow',diameter)
    end

  end

  --[[for i=1, #question[2][1] do
    text.print(gfx.screen, arial, question[2][1][i], gfx.screen:get_height() /2 + 150,  gfx.screen:get_height() /2 - 50*(i-1))    
  end]]
  --text.print(gfx.screen, arial, w, gfx.screen:get_height() /2 ,  gfx.screen:get_height() /2 -100)
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