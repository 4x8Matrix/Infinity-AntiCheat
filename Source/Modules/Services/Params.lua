--[[
	Params.lua
]]--

return function(InfinityECS)
	-- // Services
	local Players = InfinityECS:GetService("Players")

	-- // Variables
	local ParamsService = InfinityECS.Service.new({ Name = script.Name, Params = {} })
	
	function ParamsService.BuildWithoutPlayer(Params, Target)
		local FilterDescendantsInstances = {}

		for _, Player in Players:GetPlayers() do
			if Player.Character and Player ~= Target then
				table.insert(FilterDescendantsInstances, Player.Character)
			end
		end
		
		Params = Params.new()
		Params.FilterDescendantsInstances = FilterDescendantsInstances

		return Params
	end

	function ParamsService.Build(Params)
		local FilterDescendantsInstances = {}

		for _, Player in Players:GetPlayers() do
			if Player.Character then
				table.insert(FilterDescendantsInstances, Player.Character)
			end
		end
		
		Params = Params.new()
		Params.FilterDescendantsInstances = FilterDescendantsInstances

		return Params
	end
end