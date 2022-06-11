--[[
	Friendship.lua
]]

local TARGET_BADGE_ID = 2

return function(InfinityECS)
	local BadgeService = InfinityECS:GetService("BadgeService")

	return function(Player)
		local Success, Result

		while not Success do
			Success, Result = pcall(BadgeService.UserHasBadgeAsync, BadgeService, Player.UserId, TARGET_BADGE_ID)

			if not Success then
				task.wait(1)
			end
		end

		return (Result and -2) or 2
	end
end