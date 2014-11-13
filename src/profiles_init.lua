--- This file is only to set up the structure of the table for players.
-- It should only be used once to set the structure for the profiles.lua file
-- Then never again!!

dofile('table.save.lua')

profiles = {
			['player1'] = {
						name = 'Per',
						isActive = 1,
						mathGame = {
									userLevel = 1,
									additionPoints = 0,
									subtractionPoints = 0,
									multiplicationPoints = 0,
									divisionPoints = 0
									},
						geographyGame = 1,
						spellingGame = 1,
						memoryGame = 1
						},
			['player2'] = {
						name = 'Frida',
						isActive = 1,
						mathGame = {
									userLevel = 1,
									additionPoints = 0,
									subtractionPoints = 0,
									multiplicationPoints = 0,
									divisionPoints = 0
									},
						geographyGame = 1,
						spellingGame = 1,
						memoryGame = 1
						},						
			['player3'] = {
						name = '',
						isActive = 0,
						mathGame = {
									userLevel = 1,
									additionPoints = 0,
									subtractionPoints = 0,
									multiplicationPoints = 0,
									divisionPoints = 0
									},
						geographyGame = 1,
						spellingGame = 1,
						memoryGame = 1
						},
			['player4'] = {
						name = '',
						isActive = 0,
						mathGame = {
									userLevel = 1,
									additionPoints = 0,
									subtractionPoints = 0,
									multiplicationPoints = 0,
									divisionPoints = 0
									},
						geographyGame = 1,
						spellingGame = 1,
						memoryGame = 1
						}
			}

	assert( table.save( profiles, "profiles.lua" ) == nil )	