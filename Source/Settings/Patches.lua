return {
	CollisionGroups = {
		Enabled = true,
		PlayerGroupName = "PlayerCollisions"
	},

	RemoteWatcher = {
		Enabled = true,
		
		RemoteMargin = 0.25,
		RequestsPerSecond = 100,

		Services = {
			game:GetService("ReplicatedStorage")
		}
	},

	Environment = {
		RespectFilteringDisabledMessage = "SoundService.RespectFilteringEnabled - This will allow exploiters to abuse game sounds.",
		BlacklistedWorkspaceClasses = {
			"Accessory", 
			"Tool"
		}
	}
}