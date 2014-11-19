require "newProfile"

describe('NewProfile unit testing', function( ... )

	it('should go to menu', function ( ... )
		testGoingToMenu(true)
		isNewPlayer()
		local expectedName = 'player'
		local expectedNumber = '1'
		local actualName = name
		local actualNumber = number
		
		assert.is.same(expectedName, actualName)
		assert.is.same(expectedNumber, actualNumber)
	end)
	
	it('should go to keyboard', function ( ... )
		testGoingToMenu(false)
		isNewPlayer()
		local expectedNumber = 1
		local actualNumber = profilePlayer
		
		assert.is.same(expectedNumber, actualNumber)
	end)
	
	it('should not go to menu', function ( ... )
		testGoingToMenu(true)
		isNewPlayer()
		local expectedName = 'randomString'
		local expectedNumber = '09'
		local actualName = name
		local actualNumber = number
		
		assert.is.not_same(expectedName, actualName)
		assert.is.not_same(expectedNumber, actualNumber)
	end)
	
	it('should not go to keyboard', function ( ... )
		testGoingToMenu(false)
		isNewPlayer()
		local expectedNumber = 0
		local actualNumber = profilePlayer
		
		assert.is.not_same(expectedNumber, actualNumber)
	end)

end)