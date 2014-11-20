--- Check if a table contains a given element
-- @param table #table The table to check in
-- @param element The element to check for
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

--- Shuffles an array
-- @param #table array Table to shuffle
function shuffle(array)
  local n, random, j = #array, math.random
  for i=1, n do
    j,k = random(n), random(n)
    array[j],array[k] = array[k],array[j]
  end
  return array
end