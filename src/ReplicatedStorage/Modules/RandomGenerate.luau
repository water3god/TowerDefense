--!strict

-- By Wa1er_God --

local Random = Random.new()

return function(RandomList: { [string]: number }): string?
	local TotalPercent: number = 0
	local CurrentValue: number = 0

	for Name, Percent in pairs(RandomList) do
		TotalPercent += Percent
	end

	local RandomNumber: number = Random:NextNumber(0, TotalPercent)

	for Name, Percent in pairs(RandomList) do
		CurrentValue += Percent

		if CurrentValue >= RandomNumber then
			return Name
		end
	end

	return nil
end
