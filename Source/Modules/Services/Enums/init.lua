--[[
	Settings.lua
]]--

return function(InfinityECS)
	-- // Variables
	local SettingsService = InfinityECS.Service.new({ Name = script.Name })

	for _, EnumModule in script:GetChildren() do
		SettingsService[EnumModule.Name] = require(EnumModule)
	end
end