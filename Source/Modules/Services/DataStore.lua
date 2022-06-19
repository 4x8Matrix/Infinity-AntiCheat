--[[
	DataStore.lua
]]--

return function(InfinityECS)
	-- // Services
	local DataStoreService = InfinityECS:GetService("DataStoreService")
	local ConsoleService = InfinityECS:GetService("Console", true)
	local SettingsService = InfinityECS:GetService("Settings", true)

	-- // Variables
	local DataStore = InfinityECS.Service.new({ Name = script.Name })

	-- // Functions
	function DataStore.RecursiveCallAsync(Callback0, Callback1, ...)
		local success, result = pcall(Callback0, ...)

		if not success then
			if Callback1(result) then
				task.wait(SettingsService.DataStore.RecoveryTime)

				result = DataStore.RecursiveCallAsync(Callback0, Callback1, ...)
			end
		end

		return result
	end

	function DataStore.GetPlayerInformation(Player)
		if not SettingsService.DataStore.Enabled then
			return nil
		end

		return DataStore.RecursiveCallAsync(function()
			return DataStore.Store:GetAsync(Player)
		end, function(Exception)
			ConsoleService.Warn(string.format(SettingsService.DataStore.Exceptions.GetAsync, Exception))

			return true
		end)
	end

	function DataStore.SetPlayerInformation(Player, Data)
		if not SettingsService.DataStore.Enabled then
			return nil
		end
		
		DataStore.RecursiveCallAsync(function()
			return DataStore.Store:SetAsync(Player, Data, { Player.UserId })
		end, function(Exception)
			ConsoleService.Warn(string.format(SettingsService.DataStore.Exceptions.SetAsync, Exception))

			return true
		end)
	end

	function DataStore.UnitStore()
		if not SettingsService.DataStore.Enabled then
			return nil
		end

		DataStore.RecursiveCallAsync(function(StoreName)
			DataStore.Store = DataStoreService:GetDataStore(StoreName)
		end, function(Exception)
			ConsoleService.Warn(string.format(SettingsService.DataStore.Exceptions.UnitStore, Exception))

			return true
		end, SettingsService.DataStore.DataStore)
	end

	DataStore.UnitStore()
end