--[[
	Environment.lua
]]--

return function(InfinityECS)
	-- // Services
	local Console = InfinityECS:GetService("Console", true)
	local Settings = InfinityECS:GetService("Settings", true)
	local SoundService = InfinityECS:GetService("SoundService")

	-- // Variables
	local Environment = InfinityECS.System.new()

	function Environment.OnInitialised()
		workspace.ChildAdded:Connect(function(Object)
			if table.find(Settings.Patches.Environment.BlacklistedWorkspaceClasses, Object.ClassName)  then
				task.delay(0, Object.Destroy, Object)
			end
		end)
		
		if not SoundService.RespectFilteringEnabled then
			Console.Warn(Settings.Patches.Environment.RespectFilteringDisabledMessage)
		end
	end

	-- // Binds
	InfinityECS.World:AddSystems(Environment)
end