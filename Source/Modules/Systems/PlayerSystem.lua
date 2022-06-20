--[[
	PlayerSystem.lua
]]--

return function(InfinityECS)
	-- // Services
	local DataStore = InfinityECS:GetService("DataStore", true)
	local Connections = InfinityECS:GetService("Connections", true)
	local Action = InfinityECS:GetService("Action", true)

	-- // Variables
	local PlayerSystem = InfinityECS.System.new()
	local PlayerQuery = InfinityECS.Query.new(InfinityECS.World):FromComponents("Player")

	-- // Functions
	function PlayerSystem.InitEntity(Player)
		return InfinityECS.Entity.new(
			InfinityECS.ComponentBuilder.new({
				State = true,
				Player = Player,
				UserId = Player.UserId,

				ToolCount = 0,
				Locked = false,
				Timeout = false,
				Idled = false,

				Connections = {},
				Janitors = {
					Global = {},
					Character = {}
				}
			}):Build(), Player.ClassName
		)
	end

	function PlayerSystem.InitEvents(PlayerEntity)
		local Player = PlayerEntity.Player:Get()
		local PlayerConnections = PlayerEntity.Connections:Get()

		table.insert(PlayerConnections, Player.CharacterRemoving:Connect(function()
			local Janitors = PlayerEntity.Janitors:Get()

			for _, Janitor in Janitors.Character do
				Janitor:Clean()
			end

			Janitors.Character = {}
		end))
	end

	function PlayerSystem.InitStore(PlayerEntity)
		local Player = PlayerEntity.Player:Get()
		local StoreInfo = DataStore.GetPlayerInformation(Player)

		if StoreInfo and StoreInfo.IsBanned then
			if StoreInfo.IsTempBan then
				local Delta = os.time() - StoreInfo.TimeOfBan

				if Delta < StoreInfo.LengthOfBan then
					local Minutes = Delta / 60
					local Seconds = Delta % 60

					Action.Kick(Player, string.format("\nYou're banned.\n--- --- --- --- ---\nTime: %s\n--- --- --- --- --", Minutes .. ":" .. Seconds))

					return true
				end
			end

			Action.Kick(Player, "\nYou're banned.")

			return true
		end
	end

	function PlayerSystem.InitPlayer(Player)
		local PlayerEntity = PlayerSystem.InitEntity(Player)

		if PlayerSystem.InitStore(PlayerEntity) then
			return
		end

		PlayerSystem.InitEvents(PlayerEntity)

		InfinityECS.World:AddEntities(PlayerEntity)
		InfinityECS.World:Push("OnPlayerLoaded", PlayerEntity)
	end

	function PlayerSystem.RemovePlayer(Player)
		local PlayerEntity = PlayerQuery:Filter(function(_, Component)
			return Component:Is(Player)
		end):GetResult()[1]

		if PlayerEntity then
			for _, JanitorList in PlayerEntity.Janitors:Iter() do
				for _, Janitor in JanitorList do
					Janitor:Clean()
				end
			end

			for _, Connection in PlayerEntity.Connections:Iter() do
				Connection:Disconnect()
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