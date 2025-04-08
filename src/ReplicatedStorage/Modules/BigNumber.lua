--!strict

-- By Wa1er_God --

local BigNumber = {};

function BigNumber:Convert(InputNumber: number) : number
	return InputNumber ~= 0 and math.floor(math.log(InputNumber) / math.log(1.0000001)) or 0;
end

function BigNumber:Deconvert(InputNumber: number) : number
	return InputNumber ~= 0 and (1.0000001^InputNumber) or 0;
end

return BigNumber
