--!strict

-- By Wa1er_God --

local RunService = game:GetService("RunService")

local IsStudio = RunService:IsStudio()

local VectorInt = {}

-- Cap is -32768, 32767 --

function VectorInt:Convert(Vector: Vector2 | Vector3): (Vector2int16 | Vector3int16)?
	if typeof(Vector) == "Vector2" then
		return Vector2int16.new(Vector.X * 100, Vector.Y * 100)
	elseif typeof(Vector) == "Vector3" then
		return Vector3int16.new(Vector.X * 100, Vector.Y * 100, Vector.Z * 100)
	else
		if IsStudio then
			warn("VectorInt:Convert() - Invalid Vector type.")
		end
		return nil
	end
end

function VectorInt:Deconvert(VectorInt16: Vector2int16 | Vector3int16): (Vector2 | Vector3)?
	if typeof(VectorInt16) == "Vector2int16" then
		return Vector2.new(VectorInt16.X / 100, VectorInt16.Y / 100)
	elseif typeof(VectorInt16) == "Vector3int16" then
		return Vector3.new(VectorInt16.X / 100, VectorInt16.Y / 100, VectorInt16.Z / 100)
	else
		if IsStudio then
			warn("VectorInt:Deconvert() - Invalid Vector type.")
		end
		return nil
	end
end

return VectorInt
