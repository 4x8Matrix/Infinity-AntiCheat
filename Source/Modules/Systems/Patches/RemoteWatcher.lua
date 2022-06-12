--[[
	RemoteWatcher.lua
]]--

return function(InfinityECS)
	-- // Services
	local Settings = InfinityECS:GetService("Settings")
	local Action = InfinityECS:GetService("Action")
	local Connections = InfinityECS:GetService("Connections")

	-- // Variables
	local RemoteWatcher = InfinityECS.System.new()
	RemoteWatcher.RemoteCount = {}
	RemoteWatcher.RemoteClocks = {}

	-- // Functions#
	function RemoteWatcher.RemoveFromRemotes(Source, Object)
		for _, RemoteData in Source do
			if RemoteData[Object] then
				RemoteData[Object] = nil
			end
		end
	end
	
	function RemoteWatcher.OnPlayerRemoving(Player)
		RemoteWatcher.RemoveFromRemotes(RemoteWatcher.RemoteCount, Player)
		RemoteWatcher.RemoveFromRemotes(RemoteWatcher.RemoteClocks, Player)
	end

	function RemoteWatcher.IsViolatingRemoteClock(Player, Remote)
		if not RemoteWatcher.RemoteClocks[Remote][Player] then
			return
		end

		if os.clock() - RemoteWatcher.RemoteClocks[Remote][Player] < Settings.Patches.RemoteWatcher.RemoteMargin then
			return true
		end
	end

	function RemoteWatcher.IsViolatingRemoteCount(Player, Remote)
		if not RemoteWatcher.RemoteCount[Remote][Player] then
			return
		end

		if RemoteWatcher.RemoteCount[Remote][Player] > Settings.Patches.RemoteWatcher.RequestsPerSecond then
			return true
		end
	end

	function RemoteWatcher.InitRemote(Remote)
		RemoteWatcher.RemoteCount[Remote] = {}
		RemoteWatcher.RemoteClocks[Remote] = {}

		Remote.OnServerEvent:Connect(function(Player)
			if RemoteWatcher.IsViolatingRemoteClock(Player, Remote) then
				Action.TakeAction(Player, Settings.Violations.ViolatingRemoteClock)
			elseif RemoteWatcher.IsViolatingRemoteCount(Player, Remote) then
				Action.TakeAction(Player, Settings.Violations.ViolatingRemoteCount)
			end

			RemoteWatcher.RemoteClocks[Remote][Player] = os.clock()
			RemoteWatcher.RemoteCount[Remote][Player] = (RemoteWatcher.RemoteCount[Remote][Player] and RemoteWatcher.RemoteCount[Remote][Player] + 1) or 1
		end)
	end

	-- // Init
	for _, Service in Settings.Patches.RemoteWatcher.Services do
		Service.DescendantAdded:Connect(function(Remote)
			if Remote:IsA("RemoteEvent") then
				RemoteWatcher.InitRemote(Remote)
			end
		end)

		for _, Remote in Service:GetDescendants() do
			if Remote:IsA("RemoteEvent") then
				RemoteWatcher.InitRemote(Remote)
			end
		end
	end

	-- // Binds
	InfinityECS.World:AddSystems(RemoteWatcher)
	Connections:BindToPlayerRemoving(RemoteWatcher.OnPlayerRemoving)
end