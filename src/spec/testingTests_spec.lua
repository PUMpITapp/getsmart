require "testingTests"


describe('Boundry testing getOperator()', function ( ... )
	
	it('Boundry: 8, level = 9', function ( ... )
		assert.are.same('divide',getOperator(9))
	end)

	it('Boundry: 8, level = 8', function ( ... )
		assert.are_not.same('divide', getOperator(8))
	end)

	it('Boundry: 8, level = 7', function ( ... )
		assert.are.same('multiply', getOperator(7))
	end)


	it('Boundry: 4, level = 5', function ( ... )
		assert.are.same('multiply',getOperator(5))
	end)

	it('Boundry: 4, level = 4', function ( ... )
		assert.are_not.same('multiply', getOperator(4))
	end)

	it('Boundry: 4, level = 3', function ( ... )
		assert.are.same('minus', getOperator(3))
	end)


	it('Boundry: 2, level = 3', function ( ... )
		assert.are.same('minus',getOperator(3))
	end)

	it('Boundry: 2, level = 2', function ( ... )
		assert.are_not.same('minus', getOperator(2))
	end)

	it('Boundry: 2, level = 1', function ( ... )
		assert.are.same('plus', getOperator(1))
	end)


	it('Boundry: 2, level = 0', function ( ... )
		assert.are.same('plus', getOperator(0))
	end)

end)