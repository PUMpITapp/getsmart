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

function profileHandler.printToFile(profiles)
--	local file = io.open("profiles.lua", 'w')
--	file:write(profiles)

end

return profileHandler