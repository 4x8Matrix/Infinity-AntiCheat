--[[
	Romillions.lua
]]

return function(InfinityECS)
	local HttpService = InfinityECS:GetService("HttpService")

	local function GetDataAsync(Player)
		local Success, Result = pcall(HttpService.GetAsync, HttpService, "https://www.rolimons.com/api/playerassets/" .. Player.UserId)

		return (Success and Result)
	end

	return function(Player)
		if Player.AccountAge > 2592000 then
			local EncodedResult = GetDataAsync(Player)
			local DecodedResult = EncodedResult and HttpService:JSONDecode(EncodedResult)

			if DecodedResult then
				if not DecodedResult.success then return 0 end
				if DecodedResult.playerVerified then return -4 end

				return -2
			end
		end

		return 0
	end
end