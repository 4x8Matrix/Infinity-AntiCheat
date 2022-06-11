--[[
	Bricksmith.lua
]]

local TARGET_BADGE_ID = 7

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

		return (Result and -5) or 0
	end
end