profileHandler = {}
dofile('table.save.lua')

function profileHandler.update(player, game, gameType, points)
	profiles, err = table.load('profiles.lua')
	print("In profileUpdater")
	player = "player" .. player
	profiles[player][game][gameType] = profiles[player][game][gameType] + points
	assert( table.save( profiles, "profiles.lua" ) == nil )
	--profileUpdater.printToFile(profiles)
end

function profileHandler.setName(player, name)
	profiles, err = table.load('profiles.lua')
	player = "player" .. tostring(player)
	print("Profilehandler: " ..player)
	profiles[player]['name'] = name
	profiles[player]['isActive'] = 1
	assert( table.save( profiles, "profiles.lua" ) == nil )
	--profileHandler.printToFile(profiles)
end

function profileHandler.getName(player)
	profiles, err = table.load('profiles.lua')
	player = "player" .. tostring(player)
	print("Profilehandler: " ..player)
	return profiles[player]['name']
end

function profileHandler.printToFile(profiles)
	--local file = io.open("profiles.lua", 'w')
	--file:write(profile)

end

return profileHandler