--[[
	Console.lua

	Console is a static lua class offering a multitude of API's for logging in roblox.
	Console will allow you to retrieve a stable amount of pre-cached log objects.
]]--

return function(InfinityECS)
	-- // Services
	local SettingsService = InfinityECS:GetService("Settings", true)

	-- // Variables
	local ConsoleService = InfinityECS.Service.new({ Name = script.Name, Logs = {} })
	local ConsoleMap = {
		["Log"] = {
			Callback = print,
			Args = {}
		},
		["Warn"] = {
			Callback = warn,
			Args = {}
		},
		["Error"] = {
			Callback = error,
			Args = { 100 }
		},
		["Critical"] = {
			Callback = error,
			Args = { 100 }
		}
	}

	-- // Events
	ConsoleService.OnNewMessageReceived  = InfinityECS.Signal.new()

	-- // Functions
	function ConsoleService.Get(Int)
		local Logs = {}

		Int = Int or #ConsoleService.Logs

		for Index = 1, Int do
			table.insert(Logs, ConsoleService.Logs[Int - (Index - 1)])
		end

		return Logs
	end

	-- // Function Builder
	for Callback, CallbackData in ConsoleMap do
		ConsoleService[Callback] = function(...)
			local Message = table.concat({ ... }, " ")
			local Source = debug.info(2, "s")

			local TaggedMessage = string.format("[%s][%s]: %s", Source, Callback, Message)

			table.insert(ConsoleService.Logs, {
				Message = Message,
				Source = Source,
				Time = os.time()
			})

			ConsoleService.OnNewMessageReceived:Fire(ConsoleService.Logs[#ConsoleService.Logs])
			if SettingsService.DebugMode then
				CallbackData.Callback(TaggedMessage, table.unpack(CallbackData.Args))
			end
		end
	end
end