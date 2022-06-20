--[[
	IdleSystem.lua
]]--

return function(InfinityECS)
	-- // Services

	-- // Variables
	local IdleSystem = InfinityECS.System.new()

	-- // Binds
	InfinityECS.World:AddSystems(IdleSystem)
end