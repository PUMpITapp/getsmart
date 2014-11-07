text = require "write_text"
gfx = require "gfx"

gfx.screen:clear({122,219,228})

text.print(gfx.screen, arial, "Spelling Game coming soon!", 70 , 300 )


function init()
  answerTable = {
    {'across',{{5,6}},{{'ss','s','cs','x'}}}
  }
  rightAlternatives = {}  
end

function main()
  init() 
  wordArray = selectRandomWord()
  question = generateQuestion(wordArray)
  --printQuestion(question)
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

function scrambleOrder(alternatives)
  
end

function generateQuestion(wordArray)
  for i = 1, #wordArray[3] do
    rightAlternatives[i] = wordArray[3][i][1]
  end

  local numberOfWordParts = 5

  if wordArray[1]:len() == wordArray[2][#wordArray[2]][2] then
    numberOfWordParts = #wordArray[2]
  elseif wordArray[1]:len() > wordArray[2][#wordArray[2]][2] then
    numberOfWordParts = #wordArray[2] + 1
  end

end

function printQuestion(question)
  gfx.screen:clear({122,219,228})
  wordLeftSide = question[1]:sub(1,question[2][1][1]-1)
  text.print(gfx.screen, arial, wordLeftSide, gfx.screen:get_height() /2 ,  gfx.screen:get_height() /2 -100)

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