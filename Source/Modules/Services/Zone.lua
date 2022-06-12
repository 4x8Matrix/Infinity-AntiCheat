--[[
	Zone.lua
]]--

return function(InfinityECS)
	-- // Services
	local Params = InfinityECS:GetService("Params", true)
	local Hitbox = InfinityECS:GetService("Hitbox", true)
	local Character = InfinityECS:GetService("Character", true)
	local Settings = InfinityECS:GetService("Settings", true)

	-- // Variables
	local ZoneService = InfinityECS.Service.new({ Name = script.Name })
	ZoneService.VoidVector = Vector3.new(0, 0, 0)

	function ZoneService.Validate(Player)
		local Objects = ZoneService.GetInstanceClassInRadius(Player)

		for _, Object in Objects do
			if Object.AssemblyLinearVelocity ~= ZoneService.VoidVector then
				return true
			end

			if Object.AssemblyAngularVelocity ~= ZoneService.VoidVector then
				return true
			end

			if table.find(Settings.Physics.PhysicsComponents, Object.ClassName) then
				return true
			end

			if Settings.Physics.ConstraintsEnabled and table.find(Settings.Physics.PhysicsConstraints, Object.ClassName) then
				if Object.Attachment0 and Object.Attachment0:IsDescendantOf(Character) then
					return true
				elseif Object.Attachment1 and Object.Attachment1:IsDescendantOf(Character) then
					return true
				end
			end
		end
	end

	function ZoneService.GetInstanceClassInRadius(Player, ClassName)
		local RootPart = Character.Root(Player)

		local Size = Hitbox.GetSize(Player)
		local Position = Hitbox.GetPosition(Player)

		ClassName = ClassName or "<<ROOT>>"

		if RootPart then
			local Instances = {}
			local TargetObjects = workspace:GetPartBoundsInRadius(
				Position,
				Size,
				Params.Build()
			)

			for _, Object in TargetObjects do
				if Object:IsA(ClassName) then
					table.insert(Instances, Object)
				end
			end

			return Instances
		end
	end
end