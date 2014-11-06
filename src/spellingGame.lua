text = require "write_text"
gfx = require "gfx"

gfx.screen:clear({122,219,228})

text.print(gfx.screen, arial, "Spelling Game coming soon!", 70 , 300 )

answerTable = {
  {'across',{5,6},{'ss','s','cs','x'}}
}

function main() {
    question = generateQuestion()
    printQuestion(question)
}

function generateQuestion()
  math.randomseed(os.time())
  math.random()
  math.random()
  local questionPosition = tonumber(math.random(1, #answerTable))
  local question = answerTable[questionPosition]
end

function printQuestion(question)
  
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