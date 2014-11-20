--- Check if a table contains a given element
-- @param table The table to check in
-- @param element The element to check for
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end