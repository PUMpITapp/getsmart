require "mathGame"


--[[describe('Boundry testing getOperator()', function ( ... )
	
	it('Boundry: 8, level = 9', function ( ... )
		assert.are.same('/',getOperator(9))
	end)

	it('Boundry: 8, level = 8', function ( ... )
		assert.are_not.same('/', getOperator(8))
	end)

	it('Boundry: 8, level = 7', function ( ... )
		assert.are.same('*', getOperator(7))
	end)


	it('Boundry: 4, level = 5', function ( ... )
		assert.are.same('*',getOperator(5))
	end)

	it('Boundry: 4, level = 4', function ( ... )
		assert.are_not.same('*', getOperator(4))
	end)

	it('Boundry: 4, level = 3', function ( ... )
		assert.are.same('-', getOperator(3))
	end)


	it('Boundry: 2, level = 3', function ( ... )
		assert.are.same('-',getOperator(3))
	end)

	it('Boundry: 2, level = 2', function ( ... )
		assert.are_not.same('-', getOperator(2))
	end)

	it('Boundry: 2, level = 1', function ( ... )
		assert.are.same('+', getOperator(1))
	end)


	it('Boundry: 2, level = 0', function ( ... )
		assert.are.same('+', getOperator(0))
	end)

end)]]

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
		checkAnswer(1,1,'red')
		assert.are.same(true, answerIsCorrect)
	end)
	it('Var = 1, Var = 2, expected = Worng', function ( ... )
		checkAnswer(1,2,'red')
		assert.are.same(false, answerIsCorrect)
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
