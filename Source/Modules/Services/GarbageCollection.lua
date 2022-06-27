--[[
	GarbageCollection.lua

	This is only a GarbageCollection implementation for Parrallel Lua.
	LuaU will not allow you to call :Destroy in parrallel, this class presents a solution.
]]--

return function(InfinityECS)
	-- // Services
	local RunService = InfinityECS:GetService("RunService")

	-- // Variables
	local GarbageCollectionService = InfinityECS.Service.new({ Name = script.Name })
	local GarbageCollectionFolder = Instance.new("Folder")

	GarbageCollectionFolder.Name = "Infinity-GC"

	-- // Functions
	function GarbageCollectionService.Push(Object)
		Object.Parent = GarbageCollectionFolder
	end

	RunService.Stepped:Connect(function()
		GarbageCollectionFolder:ClearAllChildren()
	end)
end