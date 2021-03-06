--- This file is only to set up the structure of the table for players.
-- It should only be used once to set the structure for the profiles.lua file
-- Then never again!!
require "runState"

if not runsOnSTB then
  dir = "" 
else
  dir = sys.root_path()
end

dofile(dir .. 'table.save.lua')

profiles = {
			['player1'] = {
						name = 'Julbin',
						isActive = 1,
						mathGame = {
									userLevel = 1,
									additionPoints = 0,
									subtractionPoints = 0,
									multiplicationPoints = 0,
									divisionPoints = 0
									},
						flagGame = {
									userLevel = 1,
									points = 0
									},
						spellingGame = {
									userLevel = 1,
									points = 0
									},
						memoryGame  = {
									userLevel = 1,
									points = 0
									}
						},
			['player2'] = {
						name = '',
						isActive = 0,
						mathGame = {
									userLevel = 1,
									additionPoints = 0,
									subtractionPoints = 0,
									multiplicationPoints = 0,
									divisionPoints = 0
									},
						flagGame = {
									userLevel = 1,
									points = 0
									},
						spellingGame = {
									userLevel = 1,
									points = 0
									},
						memoryGame  = {
									userLevel = 1,
									points = 0
									}
						},					
			['player3'] = {
						name = 'Artrik',
						isActive = 1,
						mathGame = {
									userLevel = 1,
									additionPoints = 0,
									subtractionPoints = 0,
									multiplicationPoints = 0,
									divisionPoints = 0
									},
						flagGame = {
									userLevel = 1,
									points = 0
									},
						spellingGame = {
									userLevel = 1,
									points = 0
									},
						memoryGame  = {
									userLevel = 1,
									points = 0
									}
						},
			['player4'] = {
						name = 'Jachael',
						isActive = 1,
						mathGame = {
									userLevel = 1,
									additionPoints = 0,
									subtractionPoints = 0,
									multiplicationPoints = 0,
									divisionPoints = 0
									},
						flagGame = {
									userLevel = 1,
									points = 0
									},
						spellingGame = {
									userLevel = 1,
									points = 0
									},
						memoryGame  = {
									userLevel = 1,
									points = 0
									}
						},
			}

	assert( table.save( profiles, dir .. "profiles.lua" ) == nil )	