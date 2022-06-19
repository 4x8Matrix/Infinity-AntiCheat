--[[
	Character.lua
]]--

local FALLEN_HIEGHT_MAX = 50

return function(InfinityECS)
	-- // Variables
	local CharacterService = InfinityECS.Service.new({ Name = script.Name })

	-- // Functions
	function CharacterService.IsAlive(Player)
		local Humanoid = CharacterService.Humanoid(Player)

		if not Humanoid then
			return
		end

		if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
			return
		end

		if Humanoid.Health == 0 then 
			return
		end

		return true
	end

	function CharacterService.IsInBounds(Player)
		local RootPart = CharacterService.RootPart(Player)

		if not RootPart then
			return
		end

		if RootPart.Position.Y - workspace.FallenPartsDestroyHeight < FALLEN_HIEGHT_MAX then
			return
		end

		return true
	end

	function CharacterService.GetComponent(Character, Component, Async)
		local Target = (Async and Character:WaitForChild(Component)) or Character:FindFirstChild(Component)
 
		return Target
	end
	
	function CharacterService.Humanoid(Player, ...)
		if not Player.Character then
			return
		end

		return CharacterService.GetComponent(Player.Character, "Humanoid", ...)
	end

	function CharacterService.RootPart(Player, ...)
		if not Player.Character then
			return
		end

		return CharacterService.GetComponent(Player.Character, "HumanoidRootPart", ...)
	end
end