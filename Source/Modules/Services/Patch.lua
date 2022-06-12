--[[
	Patch.lua
]]--

return function(InfinityECS)
	-- // Variables
	local PatchService = InfinityECS.Service.new({ Name = script.Name })

	local CFrameObject = CFrame.new()
	
	local Infinite = math.huge
	local NegativeInfinite = -Infinite

	function PatchService.GetExtentsSize(Model)
		-- @Credit: Pyseph & XAXA
		
		local MinX, MinY, MinZ = Infinite, Infinite, Infinite
		local MaxX, MaxY, MaxZ = NegativeInfinite, NegativeInfinite, NegativeInfinite
		
		for _, Object in ipairs(Model:GetDescendants()) do
			if Object:IsA("BasePart") then
				local CF = CFrameObject:ToObjectSpace(Object.CFrame)
				local SizeX, SizeY, SizeZ = Object.Size.X, Object.Size.Y, Object.Size.Z

				local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = CFrameObject.GetComponents(CF)

				local WidthSizeX = 0.5 * (math.abs(R00) * SizeX + math.abs(R01) * SizeY + math.abs(R02) * SizeZ)
				local WidthSizeY = 0.5 * (math.abs(R10) * SizeX + math.abs(R11) * SizeY + math.abs(R12) * SizeZ)
				local WidthSizeZ = 0.5 * (math.abs(R20) * SizeX + math.abs(R21) * SizeY + math.abs(R22) * SizeZ)

				MinX = (MinX > X - WidthSizeX and X - WidthSizeX) or MinX
				MinY = (MinY > Y - WidthSizeY and Y - WidthSizeY) or MinY
				MinZ = (MinZ > Z - WidthSizeZ and Z - WidthSizeZ) or MinZ

				MaxX = (MaxX < X + WidthSizeX and X + WidthSizeX) or MaxX
				MaxY = (MaxY < Y + WidthSizeY and Y + WidthSizeY) or MaxY
				MaxZ = (MaxZ < Z + WidthSizeZ and Z + WidthSizeZ) or MaxZ
			end
		end
		
		return Vector3.new(MaxX, MaxY, MaxZ) - Vector3.new(MinX, MinY, MinZ)
	end
end