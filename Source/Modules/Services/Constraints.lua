--[[
	Constraints.lua
]]--

return function(InfinityECS)
	-- // Variables
	local ConstraintsService = InfinityECS.Service.new({ Name = script.Name })

	-- // Functions
	function ConstraintsService.GetConstraints(Player)
		local Constraints = { }

		if Player.Character then
			for _, Object in Player.Character:GetDescendants() do
				if Object:IsA("Constraint") then
					table.insert(Constraints, Object)
				end
			end
		end

		return Constraints
	end

	function ConstraintsService.GetConstraintsOfClass(Player, ...)
		local TargetConstraints = { ... }
		local Constraints = { }

		if Player.Character then
			for _, Object in Player.Character:GetDescendants() do
				if Object:IsA("Constraint") and table.find(TargetConstraints, Object.ClassName) then
					table.insert(Constraints, Object)
				end
			end
		end

		return Constraints
	end

	function ConstraintsService.IsPlayerConstrainedWith(Player, ...)
		return #ConstraintsService.GetConstraintsOfClass(Player, ...) ~= 0
	end
end