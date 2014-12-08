--- Sets the package paths when the app runs on the STB
runsOnSTB = false

if runsOnSTB then
	package.path = package.path .. ';' .. sys.root_path() .. 'images/?.png'                                                                                       
	package.path = package.path .. ';' .. sys.root_path() .. 'images/menu/?.png'
    package.path = package.path .. ';' .. sys.root_path() .. 'images/profile/?.png' 
    package.path = package.path .. ';' .. sys.root_path() .. "fonts/lookups/?.lua"
    package.path = package.path .. ';' .. sys.root_path() .. "fonts/spritesheets/?.png"
    package.path = package.path .. ';' .. sys.root_path() .. "images/KeyboardPics/?.png"

    dir = sys.root_path()
else
	dir = ""
end
