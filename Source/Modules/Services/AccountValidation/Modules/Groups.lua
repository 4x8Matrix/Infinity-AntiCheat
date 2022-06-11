--[[
	Groups.lua
]]

return function(InfinityECS)
	local GroupService = InfinityECS:GetService("GroupService")
	local function GetPlayerGroupsAsync(Player)
		local Success, Result

		while not Success do
			Success, Result = pcall(GroupService.GetGroupsAsync, GroupService, Player.UserId)

			if not Success then
				task.wait(1)
			end
		end

		return Result
	end

	return function(Player)
		local GroupInformation = GetPlayerGroupsAsync(Player)

		local IsAdvancedInGroup = false
		local IsInPrimaryGroup = false

		for _, GroupData in ipairs(GroupInformation) do
			if GroupData.IsPrimary then
				IsInPrimaryGroup = true
			end

			if GroupData.Rank > 100 then
				IsAdvancedInGroup = true
			end
		end

		if IsInPrimaryGroup and IsAdvancedInGroup then return -3 end
		if #GroupInformation > 7 then return -2 end

		return 1
	end
end