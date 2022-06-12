--[[
	Action.lua
]]--

return function(InfinityECS)
	-- // Services
	local SettingsService = InfinityECS:GetService("Settings", true)

	-- // Variables
	local ActionService = InfinityECS.Service.new({ Name = script.Name })

	-- // Hook Functions
	function ActionService.Kick(Player, Message)
		Message = (SettingsService.Action.Kick.Message ~= "" and SettingsService.Action.Kick.Message) or Message

		if not SettingsService.Action.Kick.Message.Enabled then
			return
		end

		Player:Kick(Message)
	end
	
	-- // Functions
	function ActionService.TakeAction(Player)
		
	end
end