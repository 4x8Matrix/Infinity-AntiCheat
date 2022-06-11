--[[
	PopularGroups.lua
]]

local POPULAR_GROUPS = { 4705120, 3982592, 295182, 3336691, 3959677, 3333298, 2782840, 3233280, 1127093, 7 }

return function()
	local function IsPlayerInGroup(Player, GroupId)
		local Success, Result

		while not Success do
			Success, Result = pcall(Player.IsInGroup, Player, GroupId)

			if not Success then
				task.wait(1)
			end
		end

		return Result
	end

	return function(Player)
		for _, GroupId in ipairs(POPULAR_GROUPS) do
			if IsPlayerInGroup(Player, GroupId)  then
				return -2
			end
		end

		return 1
	end
end