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
				UserId = Player.UserId,

				__Janitors = {
					Global = {},
					Character = {}
				}
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
			for _, JanitorList in PlayerEntity.__Janitors:Iter() do
				for _, Janitor in JanitorList do
					Janitor:Clean()
				end
			end

			InfinityECS.World:Push("OnPlayerRemoving", PlayerEntity)
			InfinityECS.World:RemoveEntities(PlayerEntity)
		end
	end

	function PlayerSystem.OnInitialised()
		Connections:BindToPlayerAdded(PlayerSystem.InitPlayer)
		Connections:BindToPlayerRemoving(PlayerSystem.RemovePlayer)
	end

	-- // Binds
	InfinityECS.World:AddSystems(PlayerSystem)
end