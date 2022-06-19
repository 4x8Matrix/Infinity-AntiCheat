--[[
	Terrain.lua
]]--

return function(InfinityECS)
	-- // Services
	local Hitbox = InfinityECS:GetService("Hitbox", true)

	-- // Variables
	local TerrainService = InfinityECS.Service.new({ Name = script.Name })

	-- // Methods
	function TerrainService.IsMaterialIn3DArray(Voxel3DArray, Material)
		for X = 1, Voxel3DArray.Size.X do
			for Y = 1, Voxel3DArray.Size.Y do
				for Z = 1, Voxel3DArray.Size.Z do
					if Voxel3DArray[X][Y][Z] == Material then
						return true
					end
				end
			end
		end
	end

	function TerrainService.ReadPlayerVoxels(Player)
		local Size = Hitbox.GetSize(Player)
		local Position = Hitbox.GetPosition(Player)

		if not Size or not Position then
			return false
		end

		return workspace.Terrain:ReadVoxels(
			Region3.new(
				Position - Size,
				Position + Size
			), 4
		)
	end

	function TerrainService.IsMaterialInPlayersHitbox(Player, Material)
		local Voxel3DArray = TerrainService.ReadPlayerVoxels(Player)

		if Voxel3DArray then
			return TerrainService.IsMaterialIn3DArray(Voxel3DArray, Material)
		end
	end
end