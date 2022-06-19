--[[
	Context.lua
]]--

return function(InfinityECS)
	-- // Variables
	local ContextService = InfinityECS.Service.new({ Name = script.Name })
	local Objects = {}

	-- // Functions
	function ContextService.ObjectDestroyedByServer(Object)
		task.wait()

		return Objects[Object]
	end

	function ContextService.Remove(Object)
		Objects[Object] = nil
	end
	
	function ContextService.Listen(Object)
		return Object.Destroying:Connect(function()
			Objects[Object] = true
		end)
	end
end