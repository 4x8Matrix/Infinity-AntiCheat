--[[
	Email.lua
]]

local TARGET_ASSET_ID = 102611803

return function(InfinityECS)
	local MarketplaceService = InfinityECS:GetService("MarketplaceService")

	return function(Player)
		local Success, Result

		while not Success do
			Success, Result = pcall(MarketplaceService.PlayerOwnsAsset, MarketplaceService, Player, TARGET_ASSET_ID)

			if not Success then
				task.wait(1)
			end
		end

		return (Result and -2) or 5
	end
end