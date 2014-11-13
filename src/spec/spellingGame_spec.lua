require "spellingGame"

describe('Testing init: ', function ()	
	-- The following test checks that the words in the answer table has the 
	-- same number of intervalls as alternative sets. 
	-- It loops through answer table
	init() -- Accuires answerTable
	for i=1, #answerTable do
		local message = 'Comparing number of intervalls and alternative sets in the word '..answerTable[i][1]
		it(message, function ()
			numberOfIntervals = #answerTable[i][2]
			numberOfAlternativeSets = #answerTable[i][3]
			assert.are.same(numberOfIntervals, numberOfAlternativeSets)
		end)
	end

	-- The following test checks that the first alterantives in the 
	-- alterantive sets is the right one.
	-- It loops through answer table.
	for i=1, #answerTable do
		for j=1, #answerTable[i][2] do
			local message = 'Testing the word '..answerTable[i][1]..'. Comparing '..i..'st alternative of the '..i..'st intervall. Expecting correct.'	
			it(message, function ()
				expected = answerTable[i][1]:sub(answerTable[i][2][j][1],answerTable[i][2][j][2])
				got = answerTable[i][3][j][1]
				assert.are.same(expected,got)
			end)
		end			
	end

	it('Checks that images is not nil', function ()
		notExpected = nil
		got = images.colors
		assert.are_not.same(notExpected,got)
	end)
end)

--[[
	it('', function ()
		expected = 
		got = 
		assert.are.equals(expected, got)
	end)
]]

describe('Testing generateQuestion: ', function ()
	init() 
  	wordArray = selectRandomWord()
  	question = generateQuestion(wordArray)

	it('Checks that 4 alterantives are provided to the user for all intervalls',function ()
		expected = #question[2]
		got = 0
		for i=1, #question[2] do
			if #question[2][1] == 4 then
				got = got + 1
			end
		end
		assert.are.equals(expected, got)
	end)

end)

describe('Testing splitIntoWordParts: ', function ()
	it('Splitting the word: Test, intervall = [3,4]. Expecting 1 word part', function ()
		expected = 1
		got = #splitIntoWordParts('test',{{3,4}})
		assert.are.equals(expected, got)
	end)

	it('Splitting the word: Test, intervall = [2,3]. Expecting 2 word parts', function ()
		expected = 2
		got = #splitIntoWordParts('test',{{2,3}})
		assert.are.equals(expected, got)
	end)

	it('Splitting the word: Test, intervall = [1,2]. Expecting 1 word part', function ()
		expected = 1
		got = #splitIntoWordParts('test',{{1,2}})
		assert.are.equals(expected, got)
	end)	

end)