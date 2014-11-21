require "flagGame"

describe('testing checkAnswer(userAnswer) ', function ( ... )
	it('comparing userAnswer to correctAnswer, correct', function ( ... )
		correctCountry = 1
		checkAnswer(1)
		assert.are.same(true, answerState)
	end)
	it('comparing userAnswer to correctAnswer, incorrect', function ( ... )
		correctAnswer = 2
		checkAnswer(1)
		assert.are.same(false, answerState)
	end)
end)