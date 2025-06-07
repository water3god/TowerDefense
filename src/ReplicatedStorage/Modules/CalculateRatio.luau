--!nocheck

-- By Wa1er_God --

--[[ Currently Accepts DataTypes: number, UDim, UDim2,
Vector2, Vector3, Vector2int16, Vector3int16.
]]

local IsStudio = game:GetService("RunService"):IsStudio()

local function CalculateMagnitude(Vector: any)
	local Values = { Vector.X, Vector.Y, Vector.Z }

	if #Values == 2 then
		return math.sqrt(math.abs(Values[1] ^ 2 + Values[2] ^ 2))
	elseif #Values == 3 then
		return math.sqrt(math.abs(Values[1] ^ 2 + Values[2] ^ 2 + Values[3] ^ 2))
	else
		if IsStudio then
			warn(string.format("CalculateMagntiude: %s is not a Supported Length!", tostring(Vector)))
		end
		return 0
	end
end

local function CalculateRatio<T>(Current: T, Start: T, End: T): number
	local ValueType: string = typeof(Current)

	if typeof(Start) ~= ValueType or typeof(End) ~= ValueType then
		if IsStudio then
			warn(string.format("CalculateRatio: One or more Inputs are not the same! Current: %s", ValueType))
		end

		return 0
	end

	if ValueType == "number" then
		return (Current - End) / (Start - End)
	elseif ValueType == "UDim" then
		local IsOffset: boolean = nil

		if Current.Offset ~= 0 or Start.Offset ~= 0 or End.Offset ~= 0 then
			IsOffset = true
		end

		if IsOffset then
			return (Current.Offset - End.Offset) / (Start.Offset - End.Offset)
		else
			return (Current.Scale - End.Scale) / (Start.Scale - End.Scale)
		end
	elseif ValueType == "UDim2" then
		local IsOffset: boolean = nil

		if
			Current.X.Offset ~= 0
			or Current.Y.Offset ~= 0
			or Start.X.Offset ~= 0
			or Start.Y.Offset ~= 0
			or End.X.Offset ~= 0
			or End.Y.Offset ~= 0
		then
			IsOffset = true
		end

		if IsOffset then
			local X = (Current.X.Offset - End.X.Offset) / (Start.X.Offset - End.X.Offset)
			local Y = (Start.Y.Offset - Start.Y.Offset) / (Start.Y.Offset - End.Y.Offset)

			return (X + Y) / 2
		else
			local X = (Current.X.Scale - End.X.Scale) / (Start.X.Scale - End.X.Scale)
			local Y = (Start.Y.Scale - Start.Y.Scale) / (Start.Y.Scale - End.Y.Scale)

			local Product = (X + Y) / 2

			if tostring(Product) == "nan" then
				return 0.01
			else
				warn(string.format("NAN value of %u, %u, %u in Calculateratio!", Current, Start, End))
				return 0
			end
		end
	elseif ValueType == "Vector2" or ValueType == "Vector3" then
		return (Current - End).Magnitude / (Start - End).Magnitude
	elseif ValueType == "Vector2int16" or ValueType == "Vector3int16" then
		return CalculateMagnitude(Current - End) / CalculateMagnitude(Start - End)
	else
		if IsStudio then
			warn(string.format("CalculateRatio: %s is not a Supported DataType!", ValueType))
		end

		return 0
	end
end

return CalculateRatio
