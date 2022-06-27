--[[
	Scheduler.lua
]]--

return function(InfinityECS)
	-- // Services
	local RunService = InfinityECS:GetService("RunService")
	local EnumService = InfinityECS:GetService("Enums", true)

	-- // Variables
	local ParallelSchedulerService = InfinityECS.Service.new({ Name = script.Name })
	local Jobs, Awaiting = {}, {}

	-- // Functions
	function ParallelSchedulerService.Await(JobId)
		if Awaiting[JobId] then
			table.insert(Awaiting[JobId], coroutine.running())

			return coroutine.yield()
		end
	end

	function ParallelSchedulerService.IsExpired(JobId)
		return Jobs[JobId] ~= nil
	end

	function ParallelSchedulerService.Job(JobType, ...)
		local JobId = InfinityECS:_Id()

		Awaiting[JobId] = {}
		Jobs[JobId] = { JobType, { ... } }
		
		if JobType == EnumService.JobType.Namecall then
			local JobArgs = { ... }
			
			Jobs[JobId][2] = {
				table.remove(JobArgs, 1),
				table.remove(JobArgs, 1),
				JobArgs
			}
		end

		return JobId
	end

	RunService.Stepped:Connect(function()
		for Id, Job in Jobs do
			local JobResult
			local JobType = Job[1]
			local JobData = Job[2]

			if JobType == EnumService.JobType.Routine then
				task.spawn(table.remove(JobData[1]), table.unpack(JobData))
			elseif JobType == EnumService.JobType.Namecall then
				JobResult = JobData[1][JobData[2]](JobData[1], table.unpack(JobData[3]))
			elseif JobType == EnumService.JobType.Property then
				JobData[1][JobData[2]] = JobData[3]
			end

			for _, JobCoro in Awaiting[Id] do
				coroutine.resume(JobCoro, JobResult)
			end

			Jobs[Id] = nil
			Awaiting[Id] = nil
		end
	end)
end