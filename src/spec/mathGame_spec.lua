require "mathGame"



describe('Boundry testing getLowerBound()', function ( ... )
	
	it('Boundry: 8, level = 9', function ( ... )
		assert.are.same(9,getLowerBound(9))
	end)
	it('Boundry: 8, level = 8', function ( ... )
		assert.are_not.same(9,getLowerBound(8))
	end)
	it('Boundry: 8, level = 7', function ( ... )
		assert.are_not.same(9,getLowerBound(7))
	end)


	it('Boundry: 7, level = 7', function ( ... )
		assert.are.same(5,getLowerBound(7))
	end)
	it('Boundry: 7, level = 6', function ( ... )
		assert.are_not.same(5,getLowerBound(6))
	end)


	it('Boundry: 6, level = 7', function ( ... )
		assert.are_not.same(3,getLowerBound(7))
	end)
	it('Boundry: 6, level = 6', function ( ... )
		assert.are.same(3,getLowerBound(6))
	end)


	it('Boundry: 5, level = 5', function ( ... )
		assert.are.same(3,getLowerBound(5))
	end)
	it('Boundry: 5, level = 4', function ( ... )
		assert.are_not.same(3,getLowerBound(4))
	end)


	it('Boundry: 4, level = 4', function ( ... )
		assert.are.same(10,getLowerBound(4))
	end)
	it('Boundry: 4, level = 3', function ( ... )
		assert.are_not.same(10,getLowerBound(3))
	end)


	it('Boundry: 3, level = 3', function ( ... )
		assert.are.same(0,getLowerBound(3))
	end)
	it('Boundry: 3, level = 2', function ( ... )
		assert.are_not.same(0,getLowerBound(2))
	end)


	it('Boundry: 2, level = 2', function ( ... )
		assert.are.same(10,getLowerBound(2))
	end)
	it('Boundry: 2, level = 4', function ( ... )
		assert.are_not.same(10,getLowerBound(1))
	end)


	it('Boundry: else, level = 8', function ( ... )
		assert.are.same(0,getLowerBound(8))
	end)
	it('Boundry: else, level = 1', function ( ... )
		assert.are.same(0,getLowerBound(1))
	end)
	it('Boundry: else, level = 0', function ( ... )
		assert.are.same(0,getLowerBound(0))
	end)
	it('Boundry: 5, level = 4', function ( ... )
		assert.are.same(0,getLowerBound(-1))
	end)

end)

describe('Boundry testing getUpperBound()', function ( ... )
	
	it('Boundry: 8, level = 9', function ( ... )
		assert.are.same(9,getUpperBound(9))
	end)

	it('Boundry: 7, level = 7', function ( ... )
		assert.are.same(9,getUpperBound(7))
	end)


	it('Boundry: 6, level = 5', function ( ... )
		assert.are_not.same(9,getUpperBound(5))
	end)
	it('Boundry: 6, level = 6', function ( ... )
		assert.are.same(9,getUpperBound(6))
	end)


	it('Boundry: 5, level = 5', function ( ... )
		assert.are.same(5,getUpperBound(5))
	end)
	it('Boundry: 5, level = 4', function ( ... )
		assert.are_not.same(5,getUpperBound(4))
	end)


	it('Boundry: 4, level = 4', function ( ... )
		assert.are.same(99,getUpperBound(4))
	end)
	it('Boundry: 4, level = 3', function ( ... )
		assert.are_not.same(99,getUpperBound(3))
	end)


	it('Boundry: 3, level = 3', function ( ... )
		assert.are.same(9,getUpperBound(3))
	end)
	it('Boundry: 3, level = 2', function ( ... )
		assert.are_not.same(9,getUpperBound(2))
	end)


	it('Boundry: 2, level = 2', function ( ... )
		assert.are.same(99,getUpperBound(2))
	end)
	it('Boundry: 2, level = 4', function ( ... )
		assert.are_not.same(99,getUpperBound(1))
	end)


	it('Boundry: else, level = 8', function ( ... )
		assert.are.same(9,getUpperBound(8))
	end)
	it('Boundry: else, level = 1', function ( ... )
		assert.are.same(9,getUpperBound(1))
	end)
	it('Boundry: else, level = 0', function ( ... )
		assert.are.same(9,getUpperBound(0))
	end)
	it('Boundry: 5, level = 4', function ( ... )
		assert.are.same(9,getUpperBound(-1))
	end)

end)

describe('Testing produceAnswers()', function ( ... )
	it('Checking that the answer 5 is present in produceAnswers',function ( ... )	
		local correctAnswearTest = 5
		local answerCandidatesTest = produceAnswers(correctAnswearTest,4)
		function checkAnswearTest(candidates, right)
			for i = 1, #candidates do
				if (candidates[i] == right) then
					return true
				end
			end
			return false
		end
		assert.is_true(checkAnswearTest(answerCandidatesTest,correctAnswearTest))
	end)
end)

describe('Testing checkAnswer()',function ( ... )
	it('Var = 1, Var = 1, expected = true', function ( ... )

		assert.are.same(true, checkAnswer(1,1,'red'))
	end)
	it('Var = 1, Var = 2, expected = Worng', function ( ... )

		assert.are.same(false, checkAnswer(1,2,'red'))
	end)
end)

describe('Testing checkGivePoints()',function ( ... )
	it('checks if question is answered correctly at first try', function ( ... )
		assert.are.same(true, checkGivePoints({red = false, blue = false,yellow = false, green = false}))
	end)
	it('checks if question is answered correctly at not(first try)', function ( ... )
		assert.are.same(false, checkGivePoints({red = true, blue = false,yellow = false, green = false}))
	end)
	it('checks if question is answered correctly at last try', function ( ... )
		assert.are.same(false, checkGivePoints({red = true, blue = true,yellow = true, green = true}))
	end)

end)

describe('Testing resetAnswered()', function ( ... )
	it('checks if answered[red] is reset to false after answering question correctly',function ( ... )
		resetAnswered({red = true, blue = false,yellow = false, green = false})
		assert.are.same(false, answered['red'])
	end)
	it('checks if answered[blue] is reset to false after answering question correctly',function ( ... )
		resetAnswered({red = false, blue = true,yellow = false, green = false})
		assert.are.same(false, answered['blue'])
	end)
	it('checks if answered[yellow] is reset to false after answering question correctly',function ( ... )
		resetAnswered({red = false, blue = true,yellow = true, green = false})
		assert.are.same(false, answered['yellow'])
	end)
	it('checks if answered[green] is reset to false after answering question correctly',function ( ... )
		resetAnswered({red = false, blue = true,yellow = false, green = true})
		assert.are.same(false, answered['green'])
	end)
end)

describe('testing getOperator()', function ( ... )
	it('checks that level one gets operator "+"', function ( ... )
		playerUserLevel = 1
		local operator = getOperator(playerUserLevel)
		assert.are.same('+',operator)
	end)
	it('checks that level one does not get "-"', function ( ... )
		playerUserLevel = 1
		local operator = getOperator(playerUserLevel)
		assert.are_not.same('-',operator)
	end)
	it('checks that level 2 gets operator "+" or "-"', function ( ... )
		playerUserLevel = 2
		local operator = getOperator(playerUserLevel)
		local checkOperator = {'-','*','/'}
		local resultOperator = false
		for i=1, table.maxn(checkOperator), 1 do
			if(checkOperator[i]==operator) then
				resultOperator = true
			end
		end
		assert.are_not.same(true,resultOperator) 
	end)
		it('checks that level 5 gets operator "+","-" or "*"', function ( ... )
		playerUserLevel = 5
		local operator = getOperator(playerUserLevel)
		local checkOperator = {'/'}
		local resultOperator = false
		for i=1, table.maxn(checkOperator), 1 do
			if(checkOperator[i]==operator) then
				resultOperator = true
			end
		end
		assert.are_not.same(true,resultOperator) 
	end)
				it('checks that level 5 gets operator "+","-" or "*""/"', function ( ... )
		playerUserLevel = 10
		local operator = getOperator(playerUserLevel)
		local checkOperator = {'+','-','*','/'}
		local resultOperator = false
		for i=1, table.maxn(checkOperator), 1 do
			if(checkOperator[i]==operator) then
				resultOperator = true
			end
		end
		assert.are.same(true,resultOperator) 
	end)
end)

describe('Testing solveProblem()',function ( ... )
	local testMathProblem = {}
	testMathProblem["termOne"] = 2
	testMathProblem["termTwo"] = 2



	it('checking 2 + 2, expected: 4',function ( ... )
		testMathProblem["operator"] = "+"
		assert.are.same(4, solveProblem(testMathProblem))
	end)
	it('checking 2 + 2, not_expected: 13',function ( ... )
		assert.are_not.same(13, solveProblem(testMathProblem))
	end)


	it('checking 2 - 2, expected: 0',function ( ... )
		testMathProblem["operator"] = "-"
		assert.are.same(0, solveProblem(testMathProblem))
	end)
	it('checking 2 - 2, not_expected: 13',function ( ... )
		assert.are_not.same(13, solveProblem(testMathProblem))
	end)


	it('checking 2 * 2, expected: 4',function ( ... )
		testMathProblem["operator"] = "*"
		assert.are.same(4, solveProblem(testMathProblem))
	end)
	it('checking 2 * 2, not_expected: 13',function ( ... )
		assert.are_not.same(13, solveProblem(testMathProblem))
	end)


	it('checking 2 / 2, expected: 1',function ( ... )
		testMathProblem["operator"] = "/"
		assert.are.same(1, solveProblem(testMathProblem))
	end)
	it('checking 2 / 2, not_expected: 13',function ( ... )
		assert.are_not.same(13, solveProblem(testMathProblem))
	end)

end)
