local text = {}

gfx = require "gfx"
-- arial = require "apple_symbols_regular_65"

--[[fonts = {
  Lato = require "fonts/lookups/lato",
  Lor a = require "fonts/lookups/lora"
}

fontSprites = {
  Lato = gfx.loadpng("fonts/spritesheets/lato.PNG"),
  Lora = gfx.loadpng("fonts/spritesheets/lora.PNG")
}
]]--

arial = require "fonts/lookups/lato"
font_spritesheet = gfx.loadpng("fonts/spritesheets/lato.png")

-- font_spritesheet = gfx.loadpng("fonts/"..arial.file)

gfx.screen:clear({255,0,0})
gfx.update()

--- Prints text to the screen
-- @param surface The surface to print to
-- @param font The font to use
-- @param fontSize The font size to use, measured in pixel height
-- @param text The text to print
-- @param x X coordinate of upper left corner to start printing from
-- @param y Y coordinate of upper left corner to start printing from
-- @param w Width of textbox
-- @param h Height of textbox
function text.print(surface, font, fontSize, text, x, y, w, h)
    local fontScale = fontSize / font.height

    local sx = x -- Start x position on the surface
	local surface_w = surface:get_width()
	local surface_h = surface:get_height()
	if w == nil or w > surface_w then
		w = surface_w
	end
	if h == nil or h > surface_h then
		h = surface_h
	end

	for i = 1, #text do -- For each character in the text
		local c = text:sub(i,i) -- Get the character
		for j = 1, #font.chars do -- For each character in the font
			local fc = font.chars[j] -- Get the character information
			if fc.char == c then
				if x + fc.width > sx + w then -- If the text is gonna be out the surface, popup a new line
					x = math.floor(sx)
					y = math.floor(y + font.height * fontScale)
                end

				dx = math.floor(x + (fc.ox * fontScale)) -- dx is the x positon of the character, some characters need offset
				dy = math.floor(y + (font.metrics.ascender * fontScale) - (fc.oy * fontScale)) -- dy is the y position of the character, some characters need offset

                surface:copyfrom(font_spritesheet, {x=fc.x, y=fc.y, w=fc.w, h=fc.h}, {x=dx, y=dy, w = fc.w * fontScale, h = fc.h * fontScale}, true)

                x = math.floor(x + (fc.width * fontScale)) -- add offset for next character

                break
			end
		end
	end

	gfx.update()
end
--- Returns the width of the string in pixels
-- @param font 
-- @param text The text that is beoing mesured
function text.getStringLength(font, text)
	local strLength = 0
	for i =1, #text do
		local c = text:sub(i,i)
		for j = 1, #font.chars do 
			local fc = font.chars[j]
			if fc.char == c then
				strLength = strLength + fc.width
			end
		end
	end	
	return strLength
end

--- Returns the height of the font
-- @param font 
function text.getFontHeight(font)
	return font.height
end

-- Print something to the screen for test purposes
text.print(gfx.screen, arial, 50, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi maximus auctor tellus. In interdum maximus odio consequat posuere. Suspendisse convallis condimentum pharetra. Ut luctus massa eget consequat iaculis. Nunc blandit semper odio, et tristique justo vestibulum nec. Donec ex justo, iaculis eget fringilla at, tempus sed justo. Pellentesque a odio orci. Integer vel lorem sodales, laoreet quam non, porta velit.", 0, 0, 500, 500)

return text
