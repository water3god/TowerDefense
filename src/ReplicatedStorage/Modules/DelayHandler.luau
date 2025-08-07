--!strict

-- By Wa1er_God --

local RunService = game:GetService("RunService")

local Delays: { [any]: number } = {}

RunService.Heartbeat:Connect(function(DeltaTime: number)
	for Name, DelayTime in pairs(Delays) do
		Delays[Name] = math.max(DelayTime - DeltaTime, 0)

		if Delays[Name] == 0 then
			Delays[Name] = nil
		end
	end
end)

return function(Name: any, Delay: number): boolean
	if Delays[Name] then
		return false
	end
	Delays[Name] = Delay

	return true
end
