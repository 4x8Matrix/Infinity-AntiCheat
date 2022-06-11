--[[
	Thread.lua
]]--

return function(InfinityECS)
	-- // Variables
	local ThreadService = InfinityECS.Service.new({ Name = script.Name })
	local _sync, _desync = task.synchronize, task.desynchronize

	function ThreadService:Sync()
		if not _sync then 
			return
		end

		return _sync() 
	end

	function ThreadService:Desync()
		if not _desync then
			return
		end

		return _desync() 
	end
end