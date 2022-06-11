--[[
	Age.lua
]]

return function()
	return function(Player)
		return (Player.AccountAge > 2592000 and -math.clamp(math.floor((Player.AccountAge * 31540000) + .5), 1, 5)) or 3
	end
end