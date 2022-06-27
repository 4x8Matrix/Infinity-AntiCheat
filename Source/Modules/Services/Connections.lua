--[[
	Connections.lua
]]--

return function(InfinityECS)
	-- // Services
	local Players = game:GetService("Players")

	-- // Variables
	local ConnectionsService = InfinityECS.Service.new({ Name = script.Name })

	-- // Functions
	function ConnectionsService.BindToPlayerAdded(Callback)
		for _, Player in Players:GetPlayers() do
			task.spawn(Callback, Player)
		end

		return Players.PlayerAdded:Connect(Callback)
	end

	function ConnectionsService.BindToPlayerRemoving(Callback)
		return Players.PlayerRemoving:Connect(Callback)
	end
end