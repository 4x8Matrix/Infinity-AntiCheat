--[[
	Character.lua
]]--

local FALLEN_HIEGHT_MAX = 50

return function(InfinityECS)
	-- // Services
	local SettingsService = InfinityECS:GetService("Settings", true)
	local ConnectionsService = InfinityECS:GetService("Connections", true)

	-- // Variables
	local CharacterService = InfinityECS.Service.new({ Name = script.Name })
	CharacterService.CharacterInformation = {}
	CharacterService.PlayerJanitors = {}

	-- // Functions
	function CharacterService.IsState(Player, ...)
		local CharacterInformation = CharacterService.CharacterInformation[Player]
		local States = { ... }

		if not CharacterInformation then
			return
		end

		return table.find(States, CharacterInformation.State) ~= nil
	end

	function CharacterService.WasState(Player, ...)
		local CharacterInformation = CharacterService.CharacterInformation[Player]

		for _, StateEnum in { ... } do
			if CharacterInformation.States[StateEnum] and os.clock() -  CharacterInformation.States[StateEnum] < SettingsService.HumanoidStateMargin then
				return true
			end
		end
	end

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

	ConnectionsService:BindToPlayerAdded(function(Player)
		local HumanoidStateChangedSignal

		CharacterService.PlayerJanitors[Player] = InfinityECS.Janitor.new()
		CharacterService.PlayerJanitors[Player]:Give(Player.CharacterAppearanceLoaded:Connect(function()
			if CharacterService.CharacterInformation[Player] then
				CharacterService.CharacterInformation[Player].IsLoaded = true
			end
		end))

		CharacterService.PlayerJanitors[Player]:Give(Player.CharacterAdded:Connect(function(Character)
			local Humanoid, RootPart

			Humanoid = Character:WaitForChild("Humanoid")
			RootPart = Character:WaitForChild("HumanoidRootPart")

			HumanoidStateChangedSignal = Humanoid.StateChanged:Connect(function(_, NewState)
				if not CharacterService.CharacterInformation[Player] then
					return HumanoidStateChangedSignal:Disconnect()
				end

				CharacterService.CharacterInformation[Player].State = NewState
			end)
			
			CharacterService.PlayerJanitors[Player]:Give(HumanoidStateChangedSignal)
			CharacterService.CharacterInformation[Player] = {
				Humanoid = Humanoid, 
				RootPart = RootPart,
				IsLoaded = false, 
				
				States = { },
				State = Humanoid:GetState()
			}
		end))

		CharacterService.PlayerJanitors[Player]:Give(Player.CharacterRemoving:Connect(function()
			CharacterService.CharacterInformation[Player] = nil

			if HumanoidStateChangedSignal then
				HumanoidStateChangedSignal:Disconnect()

				CharacterService.PlayerJanitors[Player]:Remove(HumanoidStateChangedSignal)
			end
		end))
	end)

	ConnectionsService:BindToPlayerRemoving(function(Player)
		CharacterService.PlayerJanitors[Player]:Clean()
	end)
end