--[[
	MembershipHats.lua
]]

local MEMBERSHIP_HATS = {
	[17408283] = 3,
	[11844853] = 3
}

return function()
	local MarketplaceService = game:GetService("MarketplaceService")

	local function PlayerOwnsAssetAsync(Player, AssetId)
		local Success, Result

		while not Success do
			Success, Result = pcall(MarketplaceService.PlayerOwnsAsset, MarketplaceService, Player, AssetId)

			if not Success then
				task.wait(1)
			end
		end

		return Result
	end

	return function(Player)
		for HatID, HatWeight in MEMBERSHIP_HATS do
			if PlayerOwnsAssetAsync(Player, HatID) then
				return -HatWeight
			end
		end

		return 0
	end
end