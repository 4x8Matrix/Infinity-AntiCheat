--[[
	PatchesSystem.lua
]]--

return function(InfinityECS)
	-- // Variables
	local PatchesSystem = InfinityECS.System.new()

	-- // Binds
	InfinityECS.FileSystem.LoadChildren(script.Parent.Patches)
	InfinityECS.World:AddSystem(PatchesSystem)
end