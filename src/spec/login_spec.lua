require "login"

describe('Login unit testing', function()

	it('should load first player (which is active)', function ( ... )
		dofile("profiles_init.lua") -- Init profiles table
		-- Input variables
		local chosenPlayer = 1
		local testingMode = underGoingTest
		-- Expected variables
		local expectedValues = {
								"menu.lua",
								1
								}
								
		-- Setting the actual variables
		runGame(testingMode, chosenPlayer)
		
		-- Actual variables
		local actualValues = {
								path,
								profileStatus
								}

		assert.is.same(expectedValues, actualValues)
	end)
	
	it('should load new profile', function ( ... )
		dofile("profiles_init.lua") -- Init profiles table
		-- Input variables
		local chosenPlayer = 2
		local testingMode = underGoingTest
		-- Expected variables
		local expectedValues = {
								"newProfile.lua",
								0
								}
		
		runGame(testingMode, chosenPlayer)
		
		-- Actual variables
		local actualValues = {
								path,
								profileStatus
								}

		assert.is.same(expectedValues, actualValues)
	end)

end)