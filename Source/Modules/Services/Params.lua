--[[
	Params.lua
]]--

return function(InfinityECS)
	-- // Services
	local Thread = InfinityECS:GetService("Thread", true)
	local Players = InfinityECS:GetService("Players")

	-- // Variables
	local ParamsService = InfinityECS.Service.new({ Name = script.Name, Params = {}, Cache = setmetatable({}, { _mode = "kv" }) })

	function ParamsService.IsArrayUnique(Array0, Array1)
		for Index, Value in Array0 do
			if Array1[Index] ~= Value then
				return true
			end
		end

		for Index, Value in Array1 do
			if Array0[Index] ~= Value then
				return true
			end
		end
	end

	function ParamsService.BuildParams(Params, FilterDescendantsInstances)

		-- Would rather a cache over than repeatedly calling Thread.Sync

		if #ParamsService.Cache > 50 then
			table.remove(ParamsService.Cache, 50)
		end

		for Array, CachedParams in ParamsService.Cache do
			local IsUnique = ParamsService.IsArrayUnique(Array, FilterDescendantsInstances)

			if not IsUnique then
				return CachedParams
			end
		end

		-- We can't set `FilterDescendantsInstances` in parallel.

		Thread.Sync()

		Params = Params.new()
		Params.FilterDescendantsInstances = FilterDescendantsInstances

		Thread.Desync()

		ParamsService.Cache[FilterDescendantsInstances] = Params
		return ParamsService.Cache[FilterDescendantsInstances]
	end
	
	function ParamsService.BuildWithoutPlayer(Params, Target)
		local FilterDescendantsInstances = {}

		-- Using .GetChildren as .GetPlayers is violating lua paralell

		for _, Player in Players:GetChildren() do
			if Player.Character and Player ~= Target then
				table.insert(FilterDescendantsInstances, Player.Character)
			end
		end
		
		return ParamsService.BuildParams(Params, FilterDescendantsInstances)
	end

	function ParamsService.Build(Params)
		local FilterDescendantsInstances = {}

		-- Using .GetChildren as .GetPlayers is violating lua paralell

		for _, Player in Players:GetChildren() do
			if Player.Character then
				table.insert(FilterDescendantsInstances, Player.Character)
			end
		end
		
		return ParamsService.BuildParams(Params, FilterDescendantsInstances)
	end
end