

-- TODO: Check environment for testing!
flags = require 'flags'
gfx = require 'gfx'
text = require 'write_text'
profileHandler = require 'profileHandler'

require 'helpers'
local randomSeed = os.time()
local circleDiameter = 80;

local screen = {
  Width = gfx.screen:get_width(),
  Height = gfx.screen:get_height()
}

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
    x = screen.Width / 4 - flagDimensions.w / 2,
    y = screen.Height / 2 - flagDimensions.h / 2,
    w = flagDimensions.w,
    h = flagDimensions.h
  }

  gfx.screen:copyfrom(flagSurface, nil, flagScreenPosition, true)
  gfx.update()
end

function printAnswers(answers)

  local font = {
    face = 'lato',
    color = 'black',
    size = 'large',
    height = text.getFontHeight('lato', 'large')
  }

  local textPosition = {
    x = screen.Width / 2 + circleDiameter * 3 / 2,
    y = screen.Height / 8 - font.height / 2,
    w = screen.Width / 2,
    h = screen.Height / 4
  }

  for i = 1, 4 do
    text.print(gfx.screen, font.face, font.color, font.size, answers[i], textPosition.x, textPosition.y, textPosition.w, textPosition.h)
    textPosition.y = textPosition.y + screen.Height / 4
  end

end

function createColoredCircles()

  -- Positions in the circle sprite.
  local xs = 40  -- x starting coordinate
  local y = xs  -- y position
  local d = 160 -- diameter of circle

  local cutOut = {
    red    = {x = xs,         y = y, w = d, h = d},
    yellow = {x = xs + d,     y = y, w = d, h = d},
    blue   = {x = xs + d * 2, y = y, w = d, h = d},
    green  = {x = xs + d * 3, y = y, w = d, h = d}
  }

  circle = {
    red    = gfx.new_surface(cutOut.red.w, cutOut.red.h),
    green  = gfx.new_surface(cutOut.green.w, cutOut.green.h),
    yellow = gfx.new_surface(cutOut.yellow.w, cutOut.yellow.h),
    blue   = gfx.new_surface(cutOut.blue.w, cutOut.blue.h)
  }

  circle.red:copyfrom(images.Colors, cutOut.red, true)
  circle.green:copyfrom(images.Colors, cutOut.green, true)
  circle.yellow:copyfrom(images.Colors, cutOut.yellow, true)
  circle.blue:copyfrom(images.Colors, cutOut.blue, true)

end

function placeAnswerCircles()

  local circlePosition = {
    x = screen.Width / 2,
    y = screen.Height / 8 - circleDiameter / 2,
    w = circleDiameter,
    h = circleDiameter
  }

  local circleColors = {
    'red',
    'green',
    'yellow',
    'blue'
  }

  for i = 1,4 do
    gfx.screen:copyfrom(circle[circleColors[i]], nil, circlePosition, true)
    circlePosition.y = circlePosition.y + screen.Height / 4
  end

  gfx.update()
end

function generateAnswers(correctCountryId)
  -- Initialize the answers array and populate it with the correct answer
  local answers = {
    flags[correctCountryId].country
  }

  -- Generate random incorrect answers
  while (table.maxn(answers) < 4) do
    local newCountryId = getRandomCountryId()
    local newAnswer = flags[newCountryId].country

    if (not table.contains(answers, newAnswer)) then
        table.insert(answers, newAnswer)
    end
  end

  return shuffle(answers)
end

function checkAnswer(userAnswer, countryId) end

function getRandomCountryId()
  math.randomseed(randomSeed)
  randomSeed = randomSeed + 1
  local randomCountryId = math.random(1, table.maxn(flags))
  return randomCountryId
end

function init()
  -- Set background
  gfx.screen:clear({122,219,228})
  gfx.update()
end

function generateQuestion()
  -- bestäm random land

end

init()
printFlag(5)


printAnswers(generateAnswers(5))

createColoredCircles()
placeAnswerCircles()