--[[
	Membership.lua
]]

return function()
	return function(Player)
		return (Player.MembershipType ~= Enum.MembershipType.None and -5) or 0 
	end
end