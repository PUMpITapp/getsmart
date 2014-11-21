require "menu"

describe('Menu unit testing', function( ... )

	it('should fail to load math game', function ( ... )
		local expected = ''
		onKey('red','down')
		local actual = gamePath
		assert.is.same(expected, actual)
	end)

	it('should load math game', function ( ... )
		local expected = 'mathGame.lua'
		onKey('red','up')
		local actual = gamePath
		assert.is.same(expected, actual)
	end)
	
	it('should load memory game', function ( ... )
		local expected = 'memoryGame.lua'
		onKey('green','up')
		local actual = gamePath
		assert.is.same(expected, actual)
	end)
	
	it('should load spelling game', function ( ... )
		local expected = 'spellingGame.lua'
		onKey('yellow','up')
		local actual = gamePath
		assert.is.same(expected, actual)
	end)
	
	it('should load geography game', function ( ... )
		local expected = 'flagGame.lua'
		onKey('blue','up')
		local actual = gamePath
		assert.is.same(expected, actual)
	end)	
end)