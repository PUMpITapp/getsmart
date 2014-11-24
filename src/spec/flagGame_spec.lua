require "flagGame"

describe('testing checkAnswer(userAnswer) ', function ( ... )
	it('comparing userAnswer to correctAnswer, correct', function ( ... )
		local userAnswer = 1
		local correctCountry = 'Sweden'
		local answers = {
			'Sweden',
			'Denmark',
			'Germany',
			'Mexico',
			}
		checkAnswer(userAnswer, answers, correctCountry)
		assert.truthy(answerState)
	end)
	it('comparing userAnswer to correctAnswer, incorrect', function ( ... )
		local userAnswer = 2
		local correctCountry = 'Sweden'
		local answers = {
			'Sweden',
			'Denmark',
			'Germany',
			'Mexico',
			}
		checkAnswer(userAnswer, answers, correctCountry)
		assert.is_not_true(answerState)
	end)
	
	it('see if answer table only contains one correct country', function ( ... )
		local answersLocal = generateAnswers(1) -- Fetch the generated table of answers

		local isDuplicate = false
		local tempTable = {}
		
		for i,v in pairs(answersLocal) do		-- Check for duplicates
		    if(tempTable[v] ~= nil) then
				isDuplicate = true
		    end
		    tempTable[v] = i
		end

		assert.is_not_true(isDuplicate)
	end)
	
	it('see if answer table only contains one correct country, should contain two', function ( ... )
		local answersLocal = generateAnswers(1) -- Fetch the generated table of answers
		table.insert(answersLocal, 'Sweden')	-- Input two countries that are the same
		table.insert(answersLocal, 'Sweden')

		local isDuplicate = false
		local tempTable = {}
		
		for i,v in pairs(answersLocal) do		-- Check for duplicates
		    if(tempTable[v] ~= nil) then
				isDuplicate = true
		    end
		    tempTable[v] = i
		end

		assert.truthy(isDuplicate)
	end)
end)