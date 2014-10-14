require "mathGame"


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