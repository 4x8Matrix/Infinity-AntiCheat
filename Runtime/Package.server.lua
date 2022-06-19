--[[
	Infinity AntiCheat - github.com/4x8Matrix/Infinity-AntiCheat
]]--

-- // Services
local RunService = game:GetService("RunService")


-- // Modules
local AntiCheatFolder = script.Parent.Parent

local InfinityECS = require(AntiCheatFolder.Submodules.InfinityECS)

InfinityECS.FileSystem = require(AntiCheatFolder.Submodules.RbxModules.FileSystem)

InfinityECS.Hooks = require(AntiCheatFolder.Submodules.LuaModules.Hooks)
InfinityECS.Janitor = require(AntiCheatFolder.Submodules.LuaModules.Janitor)
InfinityECS.Mutex = require(AntiCheatFolder.Submodules.LuaModules.Mutex)
InfinityECS.Promise = require(AntiCheatFolder.Submodules.LuaModules.Promise)
InfinityECS.Signal = require(AntiCheatFolder.Submodules.LuaModules.Signal)

InfinityECS._Settings = require(AntiCheatFolder.Settings)

-- // Variables
InfinityECS.IsParallelEnabled = task.desynchronize ~= nil

-- // Init
InfinityECS.Services = {}

InfinityECS.FileSystem.LoadChildren(AntiCheatFolder.Modules.Services, InfinityECS)
InfinityECS.FileSystem.LoadChildrenInto(AntiCheatFolder.Modules.Systems, InfinityECS, InfinityECS)

-- // Patch
if InfinityECS.IsParallelEnabled then
	InfinityECS.UpdateConnection:Disconnect()
	InfinityECS.UpdateConnection = RunService.Stepped:ConnectParallel(function(DeltaTime)
		InfinityECS:Update(DeltaTime)
	end)
end

-- // Post Init
local EnumService = InfinityECS:GetService("Enums", true)
local ConsoleService = InfinityECS:GetService("Console", true)
local VersionService = InfinityECS:GetService("Version", true)

if not VersionService.Validate() then
	ConsoleService.Warn("Update Available")
end

InfinityECS.Performance = EnumService.Performance.Normal

InfinityECS.World:Push("OnInitialise")
InfinityECS.World:Push("OnInitialised")