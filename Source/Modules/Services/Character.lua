--[[
	Character.lua
]]--

return function(InfinityECS)
	-- // Variables
	local CharacterService = InfinityECS.Service.new({ Name = script.Name })

	-- // Functions
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

	function CharacterService.Root(Player, ...)
		if not Player.Character then
			return
		end

		return CharacterService.GetComponent(Player.Character, "HumanoidRootPart", ...)
	end
end