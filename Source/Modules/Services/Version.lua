--[[
	Version.lua
]]--

return function(InfinityECS)
	-- // Services
	local Console = InfinityECS:GetService("Console", true)
	local Settings = InfinityECS:GetService("Settings", true)
	local HttpService = InfinityECS:GetService("HttpService")

	-- // Variables
	local VersionService = InfinityECS.Service.new({ Name = script.Name })
	VersionService.LocalVersion = "2.0.0"
	
	-- // Functions
	function VersionService.GetHTTPVersion()
		return select(2, xpcall(function()
			local TargetURL = (Settings.Version.GitToken ~= "" and string.format(Settings.Version.TokenURL, Settings.Version.GitFile, Settings.Version.GitToken)) or Settings.Version.TokenURL
			local EncodedResponse = HttpService:GetAsync(TargetURL, true)
			local DecodedResponse = InfinityECS.Json:DecodeJSON(EncodedResponse)

			VersionService.RemoteVersion = DecodedResponse.version
			return DecodedResponse.version == VersionService.LocalVersion
		end, function(Exception)
			Console.Warn(Exception)

			return true
		end))
	end

	function VersionService.Validate()
		if not Settings.Version.Validate then
			Console.Log("Skipping AntiCheat version validation")

			return true
		end

		if VersionService.RemoteVersion then
			return VersionService.RemoteVersion == VersionService.LocalVersion
		else
			return VersionService.GetHTTPVersion()
		end
	end
end