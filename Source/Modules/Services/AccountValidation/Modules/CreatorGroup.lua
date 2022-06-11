--[[
	CreatorGroup.lua
]]

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
		if game.CreatorType == Enum.CreatorType.Group then
			return (IsPlayerInGroup(Player, game.CreatorId) and -2) or 1
		end
	end
end