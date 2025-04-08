--!strict

-- By Wa1er_God --

local NumberScaler = {};

local Suffixes = {
	"";
	"K";
	"M";
	"B";
	"T";
	"Qd";
	"Qt";
	"Sx";
	"Sp";
	"O";
	"N";
	"D";
};

function NumberScaler:ShortenNumber(InputNumber: number, Precision: number?) : string
	local Precision = Precision or 2;
	local self = NumberScaler;
	
	if typeof(InputNumber) ~= "number" then
		warn("InputNumberIsNotANumber"..tostring(InputNumber)..typeof(InputNumber))
	end
	
	local Negative: boolean = false;
	
	if InputNumber < 0 then
		InputNumber = math.abs(InputNumber);
		Negative = true;
	end
	
	
	
	local Index: number = math.floor(math.log10(InputNumber));
	
	if InputNumber == 0 then
		Index = 1;
	end
	Index = Index - math.fmod(Index, 3);

	local Suffix: string = self:GetSuffixes()[(Index / 3) + 1];

	local NearestMultiple: number = math.pow(10, Index);
	local PrecisionMultiple: number = math.pow(10, Precision);

	local Result: string = tostring(math.floor((InputNumber / NearestMultiple) * PrecisionMultiple) / PrecisionMultiple) .. " " .. Suffix;
	
	if Negative then
		Result = "-"..Result;
	end
	
	return Result;
end

function NumberScaler:GetSuffixes()
	return Suffixes;
end

return NumberScaler
