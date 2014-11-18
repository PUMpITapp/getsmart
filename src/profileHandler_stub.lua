profileHandler = {}
--dofile('table.save.lua')

function profileHandler.update(player, game, gameType, points)
	
end

function profileHandler.updateUserLevel(player, game)

end

function profileHandler.getGameLevel(player, game, gameType)
	return 1
end


function profileHandler.getLevel(player, game)
	return 1
end

function profileHandler.getName(player)
	return 'TestPlayer'
end

--- New profile
function profileHandler.setName(player, name)
end

return profileHandler