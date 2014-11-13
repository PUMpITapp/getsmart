local text = {}


function text.print(surface, fontFace, fontColor, fontSize, text, x, y, w, h)
	return text
end

function text.getStringLength(fontFace, fontSize, text)
    font = require ("fonts/lookups/" .. fontFace .. "_" .. fontSize)
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

function text.getFontHeight(fontFace, fontSize)
  font = require ("fonts/lookups/" .. fontFace .. "_" .. fontSize)
  return font.height
end


return text
