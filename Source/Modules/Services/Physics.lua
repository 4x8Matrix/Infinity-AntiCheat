--[[
	Zone.lua
]]--

return function(InfinityECS)
	-- // Services
	local Zone = InfinityECS:GetService("Zone", true)
	local Settings = InfinityECS:GetService("Settings", true)

	-- // Variables
	local PhysicsService = InfinityECS.Service.new({ Name = script.Name })

	function PhysicsService.Validate(Player, Position)
		local Objects = Zone.GetInstanceClassInRadius(Player, Position)

		for _, Object in Objects do
			if table.find(Settings.Physics.PhysicsComponents, Object.ClassName) then
				return true
			end
		end

		for _, Object in ipairs(Player.Character:GetDescendants()) do
			if table.find(Settings.Physics.PhysicsComponents, Object.ClassName) then
				return true
			end
		end
	end
end