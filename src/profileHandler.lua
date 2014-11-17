profileHandler = {}
dofile('table.save.lua')

function profileHandler.update(player, game, gameType, points)
	profiles, err = table.load('profiles.lua')
	player = "player" .. player

	if game == 'mathGame' then
		profiles[player][game][gameType] = profiles[player][game][gameType] + points
		assert( table.save( profiles, "profiles.lua" ) == nil )
		profileHandler.updateUserLevel(player, game)
	else
		profiles[player][game] = profiles[player][game]+ points
		assert( table.save( profiles, "profiles.lua" ) == nil )
	end
	
	
end

function profileHandler.updateUserLevel(player, game)
	local gameValue = 1
	--print("update level")

	for key,value in pairs(profiles[player][game]) do
		if key ~= 'userLevel' then
			gameValue = gameValue*value
			
		end
	end
	gameValue = math.floor(math.log(gameValue))
	--print(gameValue)
	profiles[player][game]['userLevel']=gameValue
	assert( table.save( profiles, "profiles.lua" ) == nil )
end

function profileHandler.getGameLevel(player, game, gameType)
	profiles, err = table.load('profiles.lua')
	return profiles[player][game][gameType]
end

return profileHandler