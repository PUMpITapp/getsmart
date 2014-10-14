require "testingTests"

describe('Testing greet()',function ( ... )
	
-- 	2.
	it('Trying to produce dissimilar outputs',function ( ... )
		local not_expected = "abcd"
		local got = stuff()

		assert.are.same(not_expected, got)
	end)

end)

describe('testing correctAnswer', function ( ... )
	it('testing if correctAnswer = 0', function ( ... )
		assert.are.same(0,correctAnswer)
	end)
end)