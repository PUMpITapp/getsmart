require ("profileHandler")

describe('Profile Handler - handles profiles', function ( ... )

  it('gets the profile\'s current level for a game', function ( ... )
    local level = profileHandler.getGameLevel('player1', 'mathGame', 'subtractionPoints')

    assert.are.same(level, 1)
  end)

  it('gets the name of a profile', function ( ... )
    local name = profileHandler.getName(1)

    assert.are.same(name, 'Julbin')
  end)

  it('gets the profile\'s userLevel for a game', function ( ... )
    local level = profileHandler.getLevel('1', 'spellingGame')

    assert.are.same(level, 1)
  end)

end)