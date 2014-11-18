--- This file is only to set up the structure of the table for players.
-- It should only be used once to set the structure for the profiles.lua file
-- Then never again!!

dofile('table.save.lua')

profiles = {
			['player1'] = {
						name = 'Julbin',
						isActive = 1,
						mathGame = {
									userLevel = 1,
									additionPoints = 1,
									subtractionPoints = 1,
									multiplicationPoints = 1,
									divisionPoints = 1
									},
						geographyGame = 1,
						spellingGame = 1,
						memoryGame = 1
						},
			['player2'] = {
						name = '',
						isActive = 0,
						mathGame = {
									userLevel = 1,
									additionPoints = 1,
									subtractionPoints = 1,
									multiplicationPoints = 1,
									divisionPoints = 1
									},
						geographyGame = 1,
						spellingGame = 1,
						memoryGame = 1
						},						
			['player3'] = {
						name = 'Artrik',
						isActive = 1,
						mathGame = {
									userLevel = 1,
									additionPoints = 1,
									subtractionPoints = 1,
									multiplicationPoints = 1,
									divisionPoints = 1
									},
						geographyGame = 1,
						spellingGame = 1,
						memoryGame = 1
						},
			['player4'] = {
						name = 'Jachael',
						isActive = 1,
						mathGame = {
									userLevel = 1,
									additionPoints = 1,
									subtractionPoints = 1,
									multiplicationPoints = 1,
									divisionPoints = 1
									},
						geographyGame = 1,
						spellingGame = 1,
						memoryGame = 1
						}
			}

	assert( table.save( profiles, "profiles.lua" ) == nil )	