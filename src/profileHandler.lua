--- Profile Handler
--
-- The API to the database (profiles.lua)
-- Contains all functionality to interact with the database
--

-- The array which contains all functions
profileHandler = {}

require "runState"

--- Checks if the file was called from a test file.
-- @return True or false depending on testing file
function checkTestMode()
 --[[ runFile = debug.getinfo(2, "S").source:sub(2,3)
  if (runFile ~= './' ) then
    underGoingTest = false
  elseif (runFile == './') then
    underGoingTest = true
  end
  return underGoingTest --]]
  underGoingTest = false
end

if (checkTestMode()) then
  dofile('table.save_stub.lua')
else
	if not runsOnSTB then
		dir = ""
  		dofile('table.save.lua')
  	else 
  		-- Directory of artwork 
		dir = sys.root_path()
		dofile(dir .. 'table.save.lua')
  	end	
end

--- Updates points for wanted player in wanted game and gametype
-- @param player Player to update
-- @param game Game to update
-- @param gameType GameType (eg division, addition etc)
-- @param points Number of points
function profileHandler.update(player, game, gameType, points)
	profiles, err = table.load(dir .. 'profiles.lua')
	player = "player" .. player

	if game == 'mathGame' then
		profiles[player][game][gameType..'Points'] = profiles[player][game][gameType..'Points'] + points
		assert( table.save( profiles, dir .. "profiles.lua" ) == nil )
	else
		profiles[player][game]['points'] = profiles[player][game]['points']+ points
		assert( table.save( profiles, dir .. "profiles.lua" ) == nil )
    end

	profileHandler.updateUserLevel(player, game)

end

--- Gets the players level for a game
-- @param player Player
-- @param game Game
-- @param gameType GameType (eg division, addition etc)
-- @return The profile's level in the given game
function profileHandler.getGameLevel(player, game, gameType)
	profiles, err = table.load(dir .. 'profiles.lua')
	return profiles[player][game][gameType]
end

--- Updates the player's userLevel for a game
-- @param player Player to update
-- @param game Game to update
function profileHandler.updateUserLevel(player, game)
	local gameValue = 0
	local gameConstant = 0.5
	local userLevelToAdd = 0

	for key,value in pairs(profiles[player][game]) do
		if key ~= 'userLevel' then
			gameValue = gameValue+value
		end
	end
	
	if (game == 'mathGame') then 
		gameValue = math.floor(math.sqrt(gameValue)*gameConstant)+1
		profiles[player][game]['userLevel'] = gameValue
	elseif (game == 'spellingGame') then
		if (gameValue % 5 == 0 and gameValue <= 25) then
			userLevelToAdd = 1
			profiles[player][game]['userLevel'] = profiles[player][game]['userLevel'] + userLevelToAdd
        end
    elseif (game == 'flagGame') then
        if (gameValue % 5 == 0 and gameValue <= 10) then
            userLevelToAdd = 1
            profiles[player][game]['userLevel'] = profiles[player][game]['userLevel'] + userLevelToAdd
        end
	end

	assert( table.save( profiles, dir .. "profiles.lua" ) == nil )
end

--- Gets the name of the player
-- @param player The player to retrieve the name for
-- @return The player's name
function profileHandler.getName(player)
	profiles, err = table.load(dir .. 'profiles.lua')
	player = "player" .. tostring(player)
	return profiles[player]['name']
end

--- Sets name for new player
-- @param player The number of the new player (1-4)
-- @param name The name of the new player
function profileHandler.setName(player, name)
	profiles, err = table.load(dir ..'profiles.lua')
	player = "player" .. tostring(player)
	profiles[player]['name'] = name
	profiles[player]['isActive'] = 1
	assert( table.save( profiles, dir .."profiles.lua" ) == nil )
end

--- Gets level for wanted player
-- @param player The players number
-- @param game The game 
-- @return The player's userLevel for a game
function profileHandler.getLevel(player, game)
	profiles, err = table.load(dir .. 'profiles.lua')
	player = "player" .. tostring(player)
	return profiles[player][game]['userLevel']
end

return profileHandler