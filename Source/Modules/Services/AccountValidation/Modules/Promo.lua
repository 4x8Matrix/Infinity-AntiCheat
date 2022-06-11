--[[
	Promo.lua
]]

local PROMOTIONAL_ITEMS = { 3164811019, 253151806, 5552252553, 6909084751, 5825350067, 16630147, 20418658, 12145366, 1192464705, 5230647416, 5230727530, 5971691715, 4619597156, 6375710342, 4819740796, 3302593407, 2309348359, 3302591859, 607702162, 7212278970 }

return function(InfinityECS)
	local MarketplaceService = InfinityECS:GetService("MarketplaceService")

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
		for _, AssetId in PROMOTIONAL_ITEMS do
			if PlayerOwnsAssetAsync(Player, AssetId)  then
				return -2
			end
		end

		return 1
	end
end