--[[
	AccountValidation.lua
]]--

local MAX_VALIDATION_SCORE = 50

local VALIDATION_SCORE_OFFSET = 14
local VALIDATION_TARGET = 25

return function(InfinityECS)
	-- // Variables
	local AccountValidationService = InfinityECS.Service.new({ Name = script.Name, Modules = {}, Cache = {} })

	function AccountValidationService.Score(Player)
		local TotalScore = 0
		
		for _, ValidationModule in AccountValidationService.Modules do
			if not Player or not Player.Parent then break end
			local Success, Result = pcall(ValidationModule, Player)
			
			if Success then
				TotalScore += Result or 0
			end
		end

		return TotalScore
	end

	function AccountValidationService:Validate(Player)
		if AccountValidationService.Cache[Player.UserId] then
			return AccountValidationService.Cache[Player.UserId]
		else
			local Score = AccountValidationService.Score(Player)
			local Ratio = MAX_VALIDATION_SCORE - (Score + VALIDATION_SCORE_OFFSET)

			AccountValidationService.Cache[Player.UserId] = Ratio < VALIDATION_TARGET
		end
		
		return AccountValidationService.Cache[Player.UserId]
	end

	InfinityECS.FileSystem:LoadChildrenInto(script.Modules, AccountValidationService.Modules, InfinityECS)
end