--- Profile Handler
--
-- The API to the database (profiles.lua)
-- Contains all functionality to interact with the database
--

profileHandler = {}

--- Checks if the file was called from a test file.
-- @return #boolean True or false depending on testing file
function checkTestMode()
  runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
  return underGoingTest
end

if (checkTestMode()) then
  dofile('table.save_stub.lua')
else
  dofile('table.save.lua')
end

--- All games
-- @param #string player Player to update
-- @param #string game Game to update
-- @param #string gameType GameType (eg division, addition etc)
-- @param #number points Number of points
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

--- Gets the players level for a game
-- @param #string player Player
-- @param #string game Game
-- @param #string gameType GameType (eg division, addition etc)
-- @return #number The profile's level in the given game
function profileHandler.getGameLevel(player, game, gameType)
	profiles, err = table.load('profiles.lua')
	return profiles[player][game][gameType]
end

--- Updates the player's userLevel for a game
-- @param #string player Player to update
-- @param #number game Game to update
function profileHandler.updateUserLevel(player, game)
	local gameValue = 1

	for key,value in pairs(profiles[player][game]) do
		if key ~= 'userLevel' then
			gameValue = gameValue*value
			
		end
	end
	
	if (game == 'mathGame') then 
		gameValue = math.sqrt(gameValue)
	end

	gameValue = math.floor(math.log(gameValue))
	profiles[player][game]['userLevel']=gameValue
	assert( table.save( profiles, "profiles.lua" ) == nil )
end

--- Get name
-- @param #string player The player to retrieve the name for
-- @return #string The player's name
function profileHandler.getName(player)
	profiles, err = table.load('profiles.lua')
	player = "player" .. tostring(player)
	return profiles[player]['name']
end

--- New profile
-- @param #string player The number of the new player (1-4)
-- @param #string name The name of the new player
function profileHandler.setName(player, name)
	profiles, err = table.load('profiles.lua')
	player = "player" .. tostring(player)
	profiles[player]['name'] = name
	profiles[player]['isActive'] = 1
	assert( table.save( profiles, "profiles.lua" ) == nil )
end

--- Get level
-- @param #string player The players number
-- @param #string game The game 
-- @return #number The player's userLevel for a game
function profileHandler.getLevel(player, game)
	profiles, err = table.load('profiles.lua')
	player = "player" .. tostring(player)
	return profiles[player][game]['userLevel']
end

return profileHandler