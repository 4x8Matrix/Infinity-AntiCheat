--[[
	Action.lua
]]--

return function(InfinityECS)
	-- // Services
	local ParallelSchedulerService = InfinityECS:GetService("ParallelScheduler", true)
	local SettingsService = InfinityECS:GetService("Settings", true)
	local EnumService = InfinityECS:GetService("Enums", true)

	-- // Variables
	local AdorneeService = InfinityECS.Service.new({ Name = script.Name })

	-- // Functions
	function AdorneeService.Cleanup(Object)
		task.delay(SettingsService.AdorneeTime, function()
			Object:Destroy()
		end)
	end

	function AdorneeService.Object()
		local Object = Instance.new("Part")
		local Attachment = Instance.new("Attachment")

		ParallelSchedulerService.Job(EnumService.JobType.Property, Attachment, "Parent", Object)

		ParallelSchedulerService.Job(EnumService.JobType.Property, Object, "Parent", workspace)
		ParallelSchedulerService.Job(EnumService.JobType.Property, Object, "Size", Vector3.new(0, 0, 0))
		ParallelSchedulerService.Job(EnumService.JobType.Property, Object, "Anchored", true)
		ParallelSchedulerService.Job(EnumService.JobType.Property, Object, "Transparency", 1)
		ParallelSchedulerService.Job(EnumService.JobType.Property, Object, "CanCollide", false)

		AdorneeService.Cleanup(Object)

		return Object, Attachment
	end

	function AdorneeService.DrawLabel(TargetCFrame, Label)
		if not SettingsService.DebugMode then
			return
		end

	end

	function AdorneeService.DrawArrow(Position0, Position1)
		if not SettingsService.DebugMode then
			return
		end

	end

	function AdorneeService.DrawLine(Position0, Position1)
		if not SettingsService.DebugMode then
			return
		end

	end

	function AdorneeService.Sphere(TargetCFrame)
		if not SettingsService.DebugMode then
			return
		end

		local Object = AdorneeService.Object()
		local Sphere = Instance.new("SphereHandleAdornment")

		ParallelSchedulerService.Job(EnumService.JobType.Property, Object, "CFrame", TargetCFrame)
		ParallelSchedulerService.Job(EnumService.JobType.Property, Sphere, "Adornee", Object)
		ParallelSchedulerService.Job(EnumService.JobType.Property, Sphere, "Parent", Object)

		return Object
	end
end