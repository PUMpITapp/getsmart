gfx = require "gfx"
text = require "write_text"

--print(checkTestMode())
gfx.screen.clear({255, 255, 0})
gfx.update()

text.print(gfx.screen, 'lato', 'white', 'medium', 'LOOOL', 0, 0, 200, 200)

gfx.update()