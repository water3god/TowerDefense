--!strict

-- By Wa1er_God --

return function(RandomList: { [string]: number }, Seed: number?): string?
	local Random = Random.new(Seed)
	local TotalPercent: number = 0
	local CurrentValue: number = 0

	for _, Percent in pairs(RandomList) do
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
