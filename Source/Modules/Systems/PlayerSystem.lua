--[[
	PlayerSystem.lua
]]--

return function(InfinityECS)
	-- // Services
	local Connections = InfinityECS:GetService("Connections", true)

	-- // Variables
	local PlayerSystem = InfinityECS.System.new()
	local PlayerQuery = InfinityECS.Query.new(InfinityECS.World):FromComponents("Player")

	-- // Functions
	function PlayerSystem.InitPlayer(Player)
		local PlayerEntity = InfinityECS.Entity.new(
			InfinityECS.ComponentBuilder.new({
				State = true,
				Player = Player,
				UserId = Player.UserId
			}):Build(), Player.ClassName
		)

		InfinityECS.World:AddEntities(PlayerEntity)
		InfinityECS.World:Push("OnPlayerAdded", PlayerEntity)
	end

	function PlayerSystem.RemovePlayer(Player)
		local PlayerEntity = PlayerQuery:Filter(function(_, Component)
			return Component:Is(Player)
		end):GetResult()[1]

		if PlayerEntity then
			InfinityECS.World:Push("OnPlayerRemoving", PlayerEntity)
			InfinityECS.World:RemoveEntities(PlayerEntity)
		end
	end

	-- // Binds
	InfinityECS.World:AddSystem(PlayerSystem)

	Connections:BindToPlayerAdded(PlayerSystem.InitPlayer)
	Connections:BindToPlayerRemoving(PlayerSystem.RemovePlayer)
end