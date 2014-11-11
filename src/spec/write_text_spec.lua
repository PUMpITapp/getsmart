text = require "write_text"

describe('Asserting correct values for text.getFontHeight()', function ( ... )

  it('Lora small should return 32', function ( ... )
    assert.are.same(32, text.getFontHeight('lora', 'small'))
  end)

  it('Lora medium should return 46', function ( ... )
    assert.are.same(46, text.getFontHeight('lora', 'medium'))
  end)

  it('Lora large should return 109', function ( ... )
    assert.are.same(109, text.getFontHeight('lora', 'large'))
  end)

  it('Lato small should return 21', function ( ... )
    assert.are.same(21, text.getFontHeight('lato', 'small'))
  end)

  it('Lato medium should return 43', function ( ... )
    assert.are.same(43, text.getFontHeight('lato', 'medium'))
  end)

  it('Lato large should return 102', function ( ... )
    assert.are.same(102, text.getFontHeight('lato', 'large'))
  end)

end)

describe('Asserting correct values for text.getStringLength()', function ( ... )

  it('Lora small should return 83 px for \'testing\'', function ( ... )
    assert.are.same(83, text.getStringLength('lora', 'small', 'testing'))
  end)

  it('Lato medium should return 108 px for \'testing\'', function ( ... )
    assert.are.same(108, text.getStringLength('lato', 'medium', 'testing'))
  end)

end)
