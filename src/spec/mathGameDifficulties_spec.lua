testDifficulties = require 'mathGameDifficulties'
--mathGame.main()
describe('Testing the addition levels', function ()
	local message = 'Nothing'
	local didIncrese = true
	for i = 1, #testDifficulties['addition'] do
		if i > 1 then
			if testDifficulties['addition'][i-1]['termOne'][2] < testDifficulties['addition'][i-2]['termOne'][2] then
				didIncrese = false
				message = 'Testing that the interavalls of addition numbers increase as the user level increases. Now testing addition level ' .. i-1 .. " against level " .. i-2
			end
			if testDifficulties['addition'][i-1]['termTwo'][2] < testDifficulties['addition'][i-2]['termTwo'][2] then
				didIncrese = false
				message = 'Testing that the interavalls of addition numbers increase as the user level increases. Now testing addition level ' .. i-1 .. " against level " .. i-2
			end
		end
		it(message, function ()
			assert.is_true(didIncrese)
		end)
	end  
end)

describe('Testing the subtraction levels', function ()
	local message = 'Nothing'
	local didIncrese = false
	for i = 1, # testDifficulties['subtraction'] do
		didIncrese = true
		if i > 1 then
			if testDifficulties['subtraction'][i-1]['termOne'][2] < testDifficulties['subtraction'][i-2]['termOne'][2] then
				didIncrese = false
				message = 'Testing that the interavalls of subtraction numbers increase as the user level increases. Now testing subtraction level ' .. i-1 .. " against level " .. i-2
			end
			if testDifficulties['subtraction'][i-1]['termTwo'][2] < testDifficulties['subtraction'][i-2]['termTwo'][2] then
				didIncrese = false
				message = 'Testing that the interavalls of subtraction numbers increase as the user level increases. Now testing subtraction level ' .. i-1 .. " against level " .. i-2
			end
		end
		it(message, function ()
			assert.is_true(didIncrese)
		end)
	end  
end)

describe('Testing the multiplication levels', function ()
	local message = 'Nothing'
	local didIncrese = true
	for i = 1, #testDifficulties['multiplication'] do
		if i > 1 then
			if testDifficulties['multiplication'][i-1]['termOne'][2] < testDifficulties['multiplication'][i-2]['termOne'][2] then
				didIncrese = false
				message = 'Testing that the interavalls of multiplication numbers increase as the user level increases. Now testing multiplication level ' .. i-1 .. " against level " .. i-2
			end
			if testDifficulties['multiplication'][i-1]['termTwo'][2] < testDifficulties['multiplication'][i-2]['termTwo'][2] then
				didIncrese = false
				message = 'Testing that the interavalls of multiplication numbers increase as the user level increases. Now testing multiplication level ' .. i-1 .. " against level " .. i-2
			end
		end
		it(message, function ()
			assert.is_true(didIncrese)
		end)
	end  
end)

describe('Testing the division levels', function ()
	local message = 'Nothing'
	local didIncrese = true
	for i = 1, #testDifficulties['division'] do
		if i > 1 then
			if testDifficulties['division'][i-1]['termOne'][2] < testDifficulties['division'][i-2]['termOne'][2] then
				didIncrese = false
				message = 'Testing that the interavalls of division numbers increase as the user level increases. Now testing division level ' .. i-1 .. " against level " .. i-2
			end
			if testDifficulties['division'][i-1]['termTwo'][2] < testDifficulties['division'][i-2]['termTwo'][2] then
				didIncrese = false
				message = 'Testing that the interavalls of division numbers increase as the user level increases. Now testing division level ' .. i-1 .. " against level " .. i-2
			end
		end
		it(message, function ()
			assert.is_true(didIncrese)
		end)
	end  
end)

