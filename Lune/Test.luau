local function SyncArray(Array, SampleArray, Name: string)
	-- Build a map from Name to value for fast lookup
	local ArrayMap = {}
	for _, Value in ipairs(Array) do
		ArrayMap[Value[Name]] = Value
	end

	-- Build the new array in the order of SampleArray
	local NewArray = {}
	for _, SampleValue in ipairs(SampleArray) do
		local Id = SampleValue[Name]
		if ArrayMap[Id] then
			table.insert(NewArray, ArrayMap[Id])
		else
			table.insert(NewArray, SampleValue)
		end
	end

	-- Replace contents of Array with NewArray
	table.clear(Array)
	for i = 1, #NewArray do
		Array[i] = NewArray[i]
	end
end

local OldArray = {
	{ Id = 100, Value = 10 },
	{ Id = 25, Value = 6 },
	{ Id = 50, Value = 10 },
	{ Id = 20, Value = 5 },
}
local SampleArray = {
	{ Id = 100, Value = 10 },
	{ Id = 55, Value = 3 },
	{ Id = 50, Value = 20 },
	{ Id = 22, Value = 2 },
}
SyncArray(OldArray, SampleArray, "Id")
print(OldArray)
