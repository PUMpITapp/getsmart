

-- TODO: Check environment for testing!
flags = require 'flags'
gfx = require 'gfx'
text = require 'write_text'
profileHandler = require 'profileHandler'

require 'helpers'
local randomSeed = os.time()

local images = {
  Colors = gfx.loadpng('images/color_choices.png'),
  Flags = gfx.loadpng('images/flag-sprite.png')
}

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
    x = gfx.screen:get_width() / 4 - flagDimensions.w / 2,
    y = gfx.screen:get_height() / 2 - flagDimensions.h / 2,
    w = flagDimensions.w,
    h = flagDimensions.h
  }

  gfx.screen:copyfrom(flagSurface, nil, flagScreenPosition, true)
  gfx.update()
end

function printAnswers(countryId)
  local answers = {
    flags[countryId].country
  }

  while (table.maxn(answers) < 4) do
    newCountryId = getRandomCountryId()

    if (not table.contains(answers, newCountryId)) then
        table.insert(answers, newCountryId)
        print(tostring(newCountryId) .. ' was inserted!')
    end
  end

  for i = 1,4 do
    print(answers[i])
  end


end

function checkAnswer(userAnswer, countryId) end

function getRandomCountryId()
  math.randomseed(randomSeed)
  randomSeed = randomSeed + 1
  local randomCountryId = math.random(1, table.maxn(flags))
  return randomCountryId
end

printFlag(6)
--for i = 1,10 do
--  print(getRandomCountryId())
--end

printAnswers(1)