--[[
	Hitbox.lua
]]--

return function(InfinityECS)
	-- // Services
	local Patch = InfinityECS:GetService("Patch", true)
	local Character = InfinityECS:GetService("Character", true)

	-- // Variables
	local HitboxService = InfinityECS.Service.new({ Name = script.Name })

	-- // Functions
	function HitboxService.GetSize(Player)
		if Player.Character then
			local ExtentsSize = Patch.GetExtentsSize(Player.Character)
			
			return ExtentsSize * Vector3.new(1.2, 1.2, 1.2)
		end
	end

	function HitboxService.GetPosition(Player)
		local Root = Character.RootPart(Player)

		return Root and Root.Position
	end
end