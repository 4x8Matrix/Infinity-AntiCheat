--[[
	CollisionGroups.lua
]]--

return function(InfinityECS)
	-- // Services
	local Settings = InfinityECS:GetService("Settings")
	local Connections = InfinityECS:GetService("Connections")
	local PhysicsService = InfinityECS:GetService("PhysicsService")
	
	-- // Variables
	local CollisionGroups = InfinityECS.System.new()
	local ObjectGroups = { }
	local SetCollisionGroup

	-- // Functions
	function SetCollisionGroup(Base, GroupName)
		if Base:IsA("BasePart") then
			ObjectGroups[Base] = PhysicsService:GetCollisionGroupName(Base.CollisionGroupId)
			
			PhysicsService:SetPartCollisionGroup(Base, GroupName)
		end
		
		for _, Object in ipairs(Base:GetChildren()) do
			SetCollisionGroup(Object, GroupName)
		end
	end

	function CollisionGroups.OnInitialised()
		if not Settings.Patches.Collision.Enabled then
			return
		end

		PhysicsService:CreateCollisionGroup(Settings.Patches.Collision.PlayerGroupName)
		PhysicsService:CollisionGroupSetCollidable(
			Settings.Patches.Collision.PlayerGroupName,
			Settings.Patches.Collision.PlayerGroupName,
			false
		)

		Connections:BindToPlayerAdded(function(Player)
			local CharacterJanitor
			
			Player.CharacterAdded:Connect(function(Character)
				CharacterJanitor = InfinityECS.Janitor.new()
				
				SetCollisionGroup(Character, Settings.Patches.Collision.PlayerGroupName)
				
				CharacterJanitor:Give(Character.DescendantAdded:Connect(function(Object)
					SetCollisionGroup(Object, Settings.Patches.Collision.PlayerGroupName)
				end))
				
				CharacterJanitor:Give(Character.DescendantRemoving:Connect(function(Object)
					if not ObjectGroups[Object] then return end
					
					SetCollisionGroup(Object, ObjectGroups[Object])
					ObjectGroups[Object] = nil
				end))
			end)
			
			Player.CharacterRemoving:Connect(function()
				if CharacterJanitor then
					CharacterJanitor:Clean()
					CharacterJanitor = nil
				end
			end)
		end)
	end

	-- // Binds
	InfinityECS.World:AddSystems(CollisionGroups)
end