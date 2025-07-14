--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Timer = require(Packages.Timer)
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

local ModelStorage = ReplicatedStorage.ModelStorage
local Extra = ModelStorage.Extra
local Arrow = Extra.Arrow

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local WaveService = require(GlobalClient.WaveService)
local EnemyClient = require(GlobalClient.EnemyClient)
local Beziers = EnemyClient.GetBeziers()

local GlobalWorkspace = workspace.GlobalWorkspace
local Misc = GlobalWorkspace.Misc

export type ArrowData = { StartTime: number, Arrow: typeof(Arrow), Bezier: string }

local Arrows: { ArrowData } = {}
local VectorOffset = Vector3.new(0, 0.5, 0)
local ArrowSpeed = 50

local function CalculateArrowTimePosition(ArrowData: ArrowData)
	local Bezier = Beziers[ArrowData.Bezier]

	if not Bezier then
		return 0
	end

	local Difference = workspace:GetServerTimeNow() - ArrowData.StartTime
	local Length = Bezier.PathLength

	return math.clamp((ArrowSpeed / Length) * Difference, 0, 1)
end

local StartTrove = Trove.new()

local function OnStart()
	local ArrowTimer = StartTrove:Construct(Timer, 1)

	ArrowTimer.Tick:Connect(function()
		for Id, Bezier in pairs(Beziers) do
			local ArrowClone = Arrow:Clone()
			table.insert(Arrows, { StartTime = workspace:GetServerTimeNow(), Arrow = ArrowClone, Bezier = Id })
			ArrowClone.CFrame = Bezier:CalculateUniformCFrame(0)
			ArrowClone.Parent = Misc
			StartTrove:Add(ArrowClone)
		end
	end)

	StartTrove:Add(function()
		table.clear(Arrows)
	end)

	ArrowTimer:Start()
end

do
	local Data = WaveService.GetWaveData()
	if Data and Data.Wave == 0 then
		OnStart()
	end
end

WaveService.Added:Connect(function(Data)
	if Data.Wave == 0 then
		OnStart()
	end
end)

WaveService.Passed:Connect(StartTrove:WrapClean())
WaveService.Ended:Connect(StartTrove:WrapClean())

RunService.PostSimulation:Connect(function()
	for _, ArrowData in ipairs(Arrows) do
		local Bezier = Beziers[ArrowData.Bezier]
		local Time = CalculateArrowTimePosition(ArrowData)
		if Time == 0 or not Bezier then
			continue
		end
		if Time == 1 then
			ArrowData.Arrow:Destroy()
			local Index = table.find(Arrows, ArrowData)
			if Index then
				table.remove(ArrowData, Index)
			end
		end
		ArrowData.Arrow.CFrame = Bezier:CalculateUniformCFrame(Time) + VectorOffset
	end
end)
