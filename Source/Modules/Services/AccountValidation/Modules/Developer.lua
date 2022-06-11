--[[
	Developer.lua
]]

local TARGET_GROUP_IDS = {
	[3514227] = 3,

	[10720185] = 2,
	[2627479] = 2
}

return function()
	return function(Player)
		for GroupID, GroupValidation in TARGET_GROUP_IDS do
			local Success, Result

			while not Success do
				Success, Result = pcall(Player.IsInGroup, Player, GroupID)
	
				if not Success then
					task.wait(1)
				end
			end
	
			if Result then
				return -GroupValidation
			end
		end

		return 0
	end
end