require "login"

describe('Login unit testing', function()

	it('should load first player (which is active)', function ( ... )
		dofile("profiles_init.lua") -- Init profiles table
		-- Input variables
		local chosenPlayer = 1
		local testingMode = underGoingTest
		-- Expected variables
		local expectedPath = "menu.lua"
		local expectedProfileStatus = 1
		
		runGame(testingMode, chosenPlayer)
		
		-- Actual variables
		local actualPath = path
		local actualProfileStatus = profileStatus

		assert.is.same(expectedPath, actualPath)
		--assert.is.same(expectedProfileStatus, actualProfileStatus)
	end)
	
	it('should load new profile', function ( ... )
		dofile("profiles_init.lua") -- Init profiles table
		-- Input variables
		local chosenPlayer = 2
		local testingMode = underGoingTest
		-- Expected variables
		local expectedPath = "newProfile.lua"
		local expectedProfileStatus = 0
		
		runGame(testingMode, chosenPlayer)
		
		-- Actual variables
		local actualPath = path
		local actualProfileStatus = profileStatus

		assert.is.same(expectedPath, actualPath)
		--assert.is.same(expectedProfileStatus, actualProfileStatus)
	end)

end)