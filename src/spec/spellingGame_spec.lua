require "spellingGame"


describe('Testing init: ', function ()	
	-- The following test checks that the words in the answer table has the 
	-- same number of intervalls as alternative sets. 
	-- It loops through answer table
	init() -- Accuires answerTable
	for i=1, #answerTable do
<<<<<<< HEAD
		local message = 'Comparing number of intervalls and alternative sets in the word '.. answerTable[i][1]
=======
		local message = 'Comparing number of intervalls and alternative sets in the word '..answerTable[1][i][1]
>>>>>>> c47f520b7ca4263042f68c7957f732c2706cae61
		it(message, function ()
			numberOfIntervals = #answerTable[1][i][2]
			numberOfAlternativeSets = #answerTable[1][i][3]
			assert.are.same(numberOfIntervals, numberOfAlternativeSets)
		end)
	end

	-- The following test checks that the first alterantives in the 
	-- alterantive sets is the right one.
	-- It loops through answer table.
	for i=1, #answerTable do
		for j=1, #answerTable[1][i][2] do
			local message = 'Testing the word '..answerTable[1][i][1]..'. Comparing '..i..'st alternative of the '..i..'st intervall. Expecting correct.'	
			it(message, function ()
				expected = answerTable[1][i][1]:sub(answerTable[1][i][2][j][1],answerTable[1][i][2][j][2])
				got = answerTable[1][i][3][j][1]
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

	local testWord = {'question',{{1,2},{4,5},{7,8}},{{'qu','qw','er','ty'},{'st','qw','er','ty'},{'on','qw','er','ty'}}}
	local testQuestion = generateQuestion(testWord)
	for i=1, #testQuestion[2] do
		local message = 'Checks that the '..i..'st alternative set contains the correct alternative'
		it('message', function ()
			local found = true 
			for j=1, #testQuestion[2][i] do
				if testQuestion[2][i][j] == testWord[3][i][1] then
				 	found = true
				end
			end
			assert.is_true(found)
		end)
	end

end)

describe('Testing shuffleOrder: ', function ()
	it('Calculating sum of the shuffled set {1,2,3,4}, expecting 10', function ()
		local expected = shuffleOrder()
		local got = 0
		for i=1, #expected do
			got = got + expected[i]
		end
		expected = 10
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

describe('Testing checkAnswer: ', function ()
	testAlternatives = {{'qw','er','ty','ui'}}
	rightAnswer = {'qw'}
	it('Right answar is red, chosen is red. Expecting inFocus = nil', function () 
		checkAnswer('red',testAlternatives,rightAnswer)
		local expected = nil
		local got = inFocus
		assert.are.same(expected, got)
	end)

	it('Right answar is red, chosen is green . Expecting false', function () 
		local got = checkAnswer('green',testAlternatives,rightAnswer)
		assert.is_false(got)
	end)

	it('Right answar is red, chosen is yellow. Expecting false', function () 
		local got = checkAnswer('yellow',testAlternatives,rightAnswer)
		assert.is_false(got)
	end)

	it('Right answar is red, chosen is blue. Expecting false', function () 
		local got = checkAnswer('blue',testAlternatives,rightAnswer)
		assert.is_false(got)
	end)

end)

describe('Testing printWord: ', function ()
	it('Running printWord expecting the string printed in return', function ()
		local testWord = {'question',{{1,2},{4,5},{7,8}},{{'qu','qw','er','ty'},{'st','qw','er','ty'},{'on','qw','er','ty'}}}
		local testQuestion = generateQuestion(testWord)

		local expected = 'printed' 
		local got = printWord(testQuestion[1], getQuestionPosition(testQuestion)[1])
		assert.are.equals(expected, got)
	end)	
end)

describe('Testing selectRandomWord: ', function()
	it('Testing that questionPosition is a position in answerTable', function()
		local unexpected = nil
		local got = selectRandomWord()
		assert.are_not.same(unexpected, got)
	end)
end)

describe('Testing reorderAlternatives: ', function()
	it('Testing that reorderAlternativs returns the alternatives in the order defined by order', function()
		local orderTest = {2,3,4,1}
		local alternativesTest = {'a','b','c','d'}
		local shuffleAlternatives = reorderAlternatives(alternativesTest, orderTest)
		for i=1, #orderTest do
			if i == 4 then
				k = 1
			else
				k = i + 1	
			end
			local expected = alternativesTest[i]
			local got = shuffleAlternatives[k]
			assert.are.same(expected, got)
		end
	end)
end)

describe('Testing questionLength: ', function()
	it('Testing if questionLength returns the length of the question', function()
		local testQuestion = {{'Ar', 'choke'}, {'ti'}}
		local testDiameter = 140
		local expected = 456
		local got = questionLength(testQuestion, testDiameter)
		assert.are.equals(expected,got)
	end)
end)

describe('Testing if user is correct on the first guess', function()
	it("Should be the user's first try", function()
		local alts = {
						{'ig'}
						}
		
		local correctAnswer = {
								'ig'
								}
		
		checkAnswer('red',alts,correctAnswer)
		
		assert.truthy(isFirstTry)		
	end)
	
	it("Should not be the user's first try", function()
		local alts = {
						{'ig'},
						{'rg'}
						}
		
		local correctAnswer = {
								'ig'
								}
		
		checkAnswer('blue',alts,correctAnswer)
		checkAnswer('green',alts,correctAnswer)
		
		assert.is_not_true(isFirstTry)
	end)
end)