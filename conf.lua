-- Configuration
function love.conf(t)
	t.title = "FoxGame" -- The title of the window the game is in (string)
	t.version = "0.10.1"         -- The LÖVE version this game was made for (string)
	t.window.width = 1000       -- we want our game to be long and thin.
	t.window.height = 700

	-- For Windows debugging
	--t.console = true
end