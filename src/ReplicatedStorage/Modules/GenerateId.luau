--!strict

-- By Wa1er_God --

local CurrentIds: {string} = {};

local RandomList: {string} = {
	"0";
	"1";
	"2";
	"3";
	"4";
	"5";
	"6";
	"7";
	"8";
	"9";
	
	"A";
	"B";
	"C";
	"D";
	"E";
	"F";
	"G";
	"H";
	"I";
	"J";
	"K";
	"L";
	"M";
	"N";
	"O";
	"P";
	"Q";
	"R";
	"S";
	"T";
	"U";
	"V";
	"W";
	"X";
	"Y";
	"Z";
	
	"a";
	"b";
	"c";
	"d";
	"e";
	"f";
	"g";
	"h";
	"i";
	"j";
	"k";
	"l";
	"m";
	"n";
	"o";
	"p";
	"q";
	"r";
	"s";
	"t";
	"u";
	"v";
	"w";
	"x";
	"y";
	"z";
};

local Random = Random.new();

local function GenerateId()
	--local NewId = Random:NextInteger(-math.huge, math.huge);
	
	local NewIdString = "";
	
	for i = 1, 20, 1 do
		NewIdString = NewIdString..RandomList[Random:NextInteger(1, #RandomList)];
	end
	
	if table.find(CurrentIds, NewIdString) then
		return GenerateId();
	else
		table.insert(CurrentIds, NewIdString);
		return NewIdString;
	end
end

local Data = {};

function Data.AddId(Id: string)
	if not table.find(CurrentIds, Id) then
		table.insert(CurrentIds, Id);
	end
end

function Data.IdIsTaken(Id: string)
	if table.find(CurrentIds, Id) then
		return true;
	else
		return false;
	end
end

function Data.GenerateId()
	local Id = GenerateId();
	return Id;
end

return Data;
