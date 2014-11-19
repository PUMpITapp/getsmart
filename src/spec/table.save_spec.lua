dofile("table.save.lua")

-- Stubs
tableStub = {
  ["someDummyData"] = "a string"
}

tableStubString = "return {\n-- Table: {1}" ..
"\n{" ..
"\n   [\"someDummyData\"]=\"a string\"," ..
"\n}," ..
"\n}"

fileStub = 'dummyFile.lua'

-- Helper functions

function getFileContents(filename)
  local f = io.open(filename, "rb")
  local content = f:read("*all")
  f:close()
  return content
end

-- Tests

describe('Saves and loads tables from external .lua files', function ( ... )

  it('should successfully save a table to a file', function ( ... )
    assert (table.save(tableStub, fileStub) == nil)
    local fileContent = getFileContents(fileStub)
    assert.are.same(tableStubString, fileContent)
  end)

  it('should successfully load a table from a file', function ( ... )
    local tableFromFile, err = table.load(fileStub)

    assert.falsy(err)
    assert.same(tableFromFile, tableStub)
  end)

end)

-- Delete dummy file

os.remove(fileStub)