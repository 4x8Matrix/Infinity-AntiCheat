--[[
	Tool.lua
]]--

return function(InfinityECS)
	-- // Variables
	local ToolService = InfinityECS.Service.new({ Name = script.Name })
	ToolService.ToolOwners = {}

	function ToolService.SetOwner(Tool, Owner)
		ToolService.ToolOwners[Tool] = Owner
	end

	function ToolService.GetOwner(Tool)
		return ToolService.ToolOwners[Tool]
	end
end