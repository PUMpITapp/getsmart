profileHandler = {}
dofile('table.save.lua')

--- All games
function profileHandler.update(player, game, gameType, points)
	profiles, err = table.load('profiles.lua')
	player = "player" .. player

	if game == 'mathGame' then
		profiles[player][game][gameType] = profiles[player][game][gameType] + points
		assert( table.save( profiles, "profiles.lua" ) == nil )
	else
		profiles[player][game]['points'] = profiles[player][game]['points']+ points
		assert( table.save( profiles, "profiles.lua" ) == nil )
	end
	profileHandler.updateUserLevel(player, game)
	
	
end

function profileHandler.getGameLevel(player, game, gameType)
	profiles, err = table.load('profiles.lua')
	return profiles[player][game][gameType]
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

function profileHandler.getName(player)
	profiles, err = table.load('profiles.lua')
	player = "player" .. tostring(player)
	--print("Profilehandler: " ..player)
	return profiles[player]['name']
end

--- New profile
function profileHandler.setName(player, name)
	profiles, err = table.load('profiles.lua')
	player = "player" .. tostring(player)
	--print("Profilehandler: " ..player)
	profiles[player]['name'] = name
	profiles[player]['isActive'] = 1
	assert( table.save( profiles, "profiles.lua" ) == nil )
	--profileHandler.printToFile(profiles)
end

function profileHandler.getLevel(player, game)
	profiles, err = table.load('profiles.lua')
	player = "player" .. tostring(player)
	
	return profiles[player][game]['userLevel']
end

return profileHandler