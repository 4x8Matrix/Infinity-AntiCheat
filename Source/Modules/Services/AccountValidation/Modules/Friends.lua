--[[
	Friends.lua
]]

return function(InfinityECS)
	local Players = InfinityECS:GetService("Players")

	local function GetPlayerFriendsAsync(Player)
		local Success, Result

		while not Success do
			Success, Result = pcall(Players.GetFriendsAsync, Players, Player.UserId)

			if not Success then
				task.wait(1)
			end
		end

		return Result
	end

	function IteratePlayerFriends(pages)
		return coroutine.wrap(function()
			local pagenum = 1
			while true do
				for _, item in ipairs(pages:GetCurrentPage()) do
					coroutine.yield(item, pagenum)
				end
				if pages.IsFinished then
					break
				end
				pages:AdvanceToNextPageAsync()
				pagenum = pagenum + 1
			end
		end)
	end

	return function(Player)
		local PlayerFriends = GetPlayerFriendsAsync(Player)
		local PlayerCount = 0

		for PlayerItem in IteratePlayerFriends(PlayerFriends) do
			if math.abs(Player.UserId - PlayerItem.Id) >= 100 and Player ~= nil then
				PlayerCount += 1
			end
		end

		return (PlayerCount >= 2 and -2) or 2
	end
end