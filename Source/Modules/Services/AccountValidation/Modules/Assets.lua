--[[
	Assets.lua
]]

return function(InfinityECS)
	local Players = InfinityECS:GetService("Players")
	local MarketplaceService = InfinityECS:GetService("MarketplaceService")

	local function WrapCall(Call, ...)
		local Success, Result

		while not Success do
			Success, Result = pcall(Call, ...)

			if not Success then
				task.wait(1)
			end
		end

		return Result
	end

	local function GetPlayerCharacterAppearanceAsync(Player)
		return WrapCall(Players.GetCharacterAppearanceInfoAsync, Players, Player.UserId)
	end

	local function GetProductInfoAsync(AssetId)
		return WrapCall(MarketplaceService.GetProductInfo, MarketplaceService, AssetId)
	end

	return function(Player)
		local Appearance = GetPlayerCharacterAppearanceAsync(Player)
		local Total = 0

		for _, AssetData in ipairs(Appearance.assets) do
			local ProductInformation = GetProductInfoAsync(AssetData.id)
			
			if ProductInformation.Creator.Id ~= Player.UserId then
				if ProductInformation.IsLimited or ProductInformation.IsLimitedUnique or ProductInformation.PriceInRobux then
					Total += 1
				end
			end
		end

		return (Total > 0 and -Total) or 1
	end
end