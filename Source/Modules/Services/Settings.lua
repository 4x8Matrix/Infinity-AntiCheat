--[[
	Settings.lua
]]--

return function(InfinityECS)
	-- // Variables
	local SettingsService = InfinityECS.Service.new({ Name = script.Name })
	local Settings = InfinityECS._Settings
	InfinityECS._Settings = nil

	for Index, Value in Settings do
		SettingsService[Index] = Value
	end
end