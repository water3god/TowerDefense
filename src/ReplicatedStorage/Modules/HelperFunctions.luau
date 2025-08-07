--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Promise = require(Packages.Promise)

local DelayHandler = require(script.Parent.DelayHandler)

local Camera = workspace.CurrentCamera

local Random = Random.new()

local Funcs = {}

local function CreateRaw()
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanQuery = false
	Part.CanTouch = false
	Part.Size = Vector3.one

	return Part
end

local function CreateDefaultPart()
	local Part = CreateRaw()

	task.delay(0.1, function()
		Part:Destroy()
	end)

	return Part
end

-- General Functions --

function Funcs.DeepFreeze<T>(Table: {} & T): T
	local NewTable: any = Table

	for _, v in pairs(NewTable) do
		if typeof(v) == "table" then
			Funcs.DeepFreeze(v)
		end
	end

	table.freeze(NewTable)

	return NewTable
end

function Funcs.DeepClone<T>(Table: {} & T): T
	local NewTable = {}

	for k, v in pairs(Table) do
		NewTable[k] = if typeof(v) == "table" then Funcs.DeepClone(v) else v
	end

	return NewTable :: any
end

function Funcs.IsSameTable(...: { [any]: any })
	local List = table.pack(...)

	for _, Table in ipairs(List) do
		for Index, Value in pairs(Table) do
			for _, NewTable in ipairs(List) do
				if NewTable[Index] ~= Value then
					return false
				end
			end
		end
	end

	return true
end

--[[
	Only do this on Arrays
]]
function Funcs.GetLimitedArray(t1, t2)
	local NewTable = {}

	for _, Value in ipairs(t1) do
		if table.find(t2, Value) then
			table.insert(NewTable, Value)
		end
	end

	return NewTable
end

function Funcs.GetDifferentTable(t1, t2)
	local OneOnly = {}
	local TwoOnly = {}

	for _, Value in ipairs(t1) do
		if not table.find(t2, Value) then
			table.insert(OneOnly, Value)
		end
	end

	for _, Value in ipairs(t2) do
		if not table.find(t1, Value) then
			table.insert(TwoOnly, Value)
		end
	end

	return OneOnly, TwoOnly
end

function Funcs.BecomeInnerArray(Array: { any }, Name: string)
	local NewArray = {}
	for _, Value in ipairs(Array) do
		table.insert(NewArray, Value[Name])
	end

	return NewArray
end

function Funcs.BecomeInnerDict(Dict, Name: string)
	local NewDict = {}
	for Key, Value in pairs(Dict) do
		NewDict[Key] = Value[Name]
	end

	return NewDict
end

function Funcs.SyncArray(Array, SampleArray, Name: string)
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
		Array[i] = Funcs.DeepClone(NewArray[i])
	end
end

function Funcs.CopyTableToTable<T>(Dest: any, Source: T): T
	local Clone = table.clone(Dest)
	table.clear(Dest)
	for Key, Value in pairs(Source :: any) do
		if typeof(Clone[Key]) == "table" then
			Dest[Key] = Funcs.CopyTableToTable(Clone[Key], Value)
		else
			Dest[Key] = Value
		end
	end

	return Dest
end

Funcs.RemoveQueue = {}

function Funcs.RemoveQueue.Init()
	return {}
end

function Funcs.RemoveQueue.AddIndex(Table: { number }, Index: number)
	if not table.find(Table, Index) then
		table.insert(Table, Index)
	end
end

function Funcs.RemoveQueue.Cleanup(Table, RemovedIds: { number })
	table.sort(RemovedIds, function(a, b)
		return a > b
	end)

	for _, Index in ipairs(RemovedIds) do
		if RemovedIds[Index] then
			table.remove(Table, Index)
		else
			print("InvalidIds", RemovedIds, Index)
		end
	end
end

function Funcs.PrintTableTypes(Table: { [any]: any })
	for Key, Value in pairs(Table) do
		if typeof(Value) == "table" then
			print(Key, typeof(Value))
			Funcs.PrintTableTypes(Value)
		else
			print(Key, typeof(Value), Value)
		end
	end
end

local EMPTY = {}
function Funcs.joinDicts<K, V>(...: { [K]: V }?): { [K]: V }
	local final = nil
	local changed = false

	for index = 1, select("#", ...) do
		local dict = select(index, ...)
		if dict == nil then
			continue
		end

		if next(dict) == nil then
			continue
		end

		if final == nil then
			final = dict
		else
			assert(final ~= nil, "Luau")

			if not changed then
				final = table.clone(final)
				changed = true
			end

			for key, value in dict do
				final[key] = value
			end
		end
	end

	return final or EMPTY
end

function Funcs.DisconnectAll(Table: { [any]: RBXScriptConnection })
	for _, Connection in pairs(Table) do
		Connection:Disconnect()
	end
	table.clear(Table)
end

function Funcs.Round(Number: number, Place: number)
	return math.round(Number * math.pow(10, Place)) / math.pow(10, Place)
end

function Funcs.Lerp(Start: number, Goal: number, Alpha: number)
	return Start + (Goal - Start) * Alpha
end

local BigNumber = {}
function BigNumber:Convert(InputNumber: number): number
	return InputNumber ~= 0 and math.floor(math.log(InputNumber) / math.log(1.0000001)) or 0
end

function BigNumber:Deconvert(InputNumber: number): number
	return InputNumber ~= 0 and (1.0000001 ^ InputNumber) or 0
end

Funcs.BigNumber = BigNumber

function Funcs.FormatTime(Time: number)
	local TimeVar: number = Time

	local Hours = math.floor(TimeVar / 3600)
	TimeVar -= Hours * 3600
	local Minutes = math.floor(TimeVar / 60)
	TimeVar -= Minutes * 60
	local Seconds = math.floor(TimeVar)

	if Hours == 0 then
		return string.format("%u:%s", Minutes, string.format("%0.2i", Seconds))
	end

	return string.format("%u:%s:%s", Hours, string.format("%0.2i", Minutes), string.format("%0.2i", Seconds))
end

function Funcs.IsClick(Input: InputObject)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		return true
	elseif Input.UserInputType == Enum.UserInputType.Gamepad1 then
		if Input.KeyCode == Enum.KeyCode.ButtonL3 then
			return true
		end
	end

	return false
end

function Funcs.MouseButton1Click(Frame: GuiObject, Func: () -> (), NewTrove: Trove.Trove?)
	local Connection1 = Frame.InputBegan:Connect(function(Input: InputObject)
		if Funcs.IsClick(Input) then
			Func()
		end
	end)
	local Connection2 = Frame.TouchTap:Connect(Func)

	if NewTrove then
		NewTrove:Add(Connection1)
		NewTrove:Add(Connection2)
	end

	return { Connection1, Connection2 }
end

function Funcs.Len(Table: { [any]: any })
	local Count = 0
	for _, _ in pairs(Table) do
		Count += 1
	end
	return Count
end

function Funcs.ClearThreads(Data: { thread })
	for _, thread in ipairs(Data) do
		if coroutine.status(thread) ~= "running" then
			task.cancel(thread)
		end
	end
	table.clear(Data)
end

function Funcs.ConvertToVec2(Vec: Vector3)
	return Vector2.new(Vec.X, Vec.Z)
end

function Funcs.TpModelTo(Model: Model, NewCFrame: CFrame)
	local Pos, Size = Model:GetBoundingBox()
	local Root = Model.PrimaryPart :: BasePart

	local HeightDifference = (Root.Position - Pos.Position).Y

	local AlteredCFrame = NewCFrame + Vector3.new(0, Size.Y / 2 + HeightDifference, 0)

	return AlteredCFrame
end

function Funcs.GetModelVectorOffset(Model: Model)
	local Pos, Size = Model:GetBoundingBox()
	local Root = Model.PrimaryPart :: BasePart

	local HeightDifference = (Root.Position - Pos.Position).Y

	return Vector3.new(0, Size.Y / 2 + HeightDifference, 0)
end

function Funcs.IsNan(Input: any)
	if typeof(Input) == "CFrame" then
		for _, Comp in pairs(table.pack(Input:GetComponents())) do
			if Comp ~= Comp then
				return true
			end
		end
	elseif typeof(Input) == "Vector3" then
		if Input.X ~= Input.X or Input.Y ~= Input.Y or Input.Z ~= Input.Z then
			return true
		end
	elseif typeof(Input) == "number" then
		return Input ~= Input
	end

	return false
end

function Funcs.IsInteger(Number: number)
	return Number % 1 == 0
end

function Funcs.FireClients(Event: RemoteEvent, Clients: { Player }?, ...)
	if Clients then
		for _, Player in ipairs(Clients) do
			Event:FireClient(Player, ...)
		end
	else
		Event:FireAllClients(...)
	end
end

function Funcs.SafeTeleport(func: () -> TeleportAsyncResult, MaxCount: number): TeleportAsyncResult?
	local Success, Returned = pcall(func)
	local Count = 1

	if not Success then
		print(Returned)
	end

	if not Returned then
		repeat
			task.wait(1)
			Success, Returned = pcall(func)
			Count += 1
		until Success or Count >= MaxCount
	end

	return Returned
end

function Funcs.GetPlayerFromPart(Part: BasePart)
	local Parent = Part.Parent :: Instance
	if Parent:IsA("Model") then
		if Parent:FindFirstChildWhichIsA("Humanoid") and DelayHandler(Parent, 1) then
			local Player = Players:GetPlayerFromCharacter(Parent)

			return Player
		end
	end

	return
end

function Funcs.CalcTime(Time: number, StartTime: number, CurrentTime: number)
	return Time - (CurrentTime - StartTime)
end

function Funcs.ConnectTime(_StartTime: number, EndTime: number, Func: (Time: number) -> (), TimeTrove: Trove.Trove?)
	local Connection = nil
	if TimeTrove then
		Connection = TimeTrove:Connect(RunService.Heartbeat, function()
			local NewTime = -(workspace:GetServerTimeNow() - EndTime)

			if NewTime >= 0 then
				Func(NewTime)
			else
				TimeTrove:Remove(Connection)
			end
		end)
	else
		Connection = RunService.Heartbeat:Connect(function()
			local NewTime = -(workspace:GetServerTimeNow() - EndTime)
			if NewTime >= 0 then
				Func(NewTime)
			else
				Connection:Disconnect()
			end
		end)
	end

	return Connection
end

function Funcs.TweenPromise(TotalTime: number, Handler: (alpha: number) -> ())
	return Promise.new(function(resolve, reject, onCancel)
		local Count = 0

		local Connection: RBXScriptConnection? = nil

		onCancel(function()
			if Connection then
				Connection:Disconnect()
				reject()
			end
		end)

		Connection = RunService.Heartbeat:Connect(function(Delta: number)
			Count = math.clamp(Count + Delta / TotalTime, 0, 1)
			Handler(Count)

			if Count >= 1 then
				if Connection then
					Connection:Disconnect()
					resolve()
				end
			end
		end)
	end)
end

function Funcs.ConventialTween(Instance: Instance, TweenInfo: TweenInfo, Properties: { [string]: any })
	local TweenService = game:GetService("TweenService")
	local Tween = TweenService:Create(Instance, TweenInfo, Properties)

	return Promise.new(function(resolve, reject, onCancel)
		onCancel(function()
			Tween:Cancel()
		end)

		Tween.Completed:Once(function(Status)
			if Status == Enum.PlaybackState.Completed then
				resolve()
			else
				reject("Tween was cancelled or failed.")
			end
		end)

		Tween:Play()
		Tween.Completed:Wait()
	end)
end

function Funcs.FormatNumberConditional(number: number, maxDecimals: number?): string
	local decimals = maxDecimals or 2
	local formatted = string.format("%." .. decimals .. "f", number)

	-- Remove trailing zeros and decimal point if not needed
	formatted = string.gsub(formatted, "%.?0+$", "")

	return formatted
end

local NumberScaler = {}

local Suffixes = {
	"",
	"K",
	"M",
	"B",
	"T",
	"Qd",
	"Qt",
	"Sx",
	"Sp",
	"O",
	"N",
	"D",
}

function NumberScaler.ShortenNumber(InputNumber: number, PrecisionInput: number?): string
	local Precision = PrecisionInput or 2
	local self = NumberScaler

	if typeof(InputNumber) ~= "number" then
		warn("InputNumberIsNotANumber" .. tostring(InputNumber) .. typeof(InputNumber))
	end

	local Negative: boolean = false

	if InputNumber < 0 then
		InputNumber = math.abs(InputNumber)
		Negative = true
	end

	local Index: number = math.floor(math.log10(InputNumber))

	if InputNumber == 0 then
		Index = 1
	end
	Index = Index - math.fmod(Index, 3)

	local Suffix: string = self.GetSuffixes()[(Index / 3) + 1]

	local NearestMultiple: number = math.pow(10, Index)
	local PrecisionMultiple: number = math.pow(10, Precision)

	local Result: string = tostring(math.floor((InputNumber / NearestMultiple) * PrecisionMultiple) / PrecisionMultiple)
		.. Suffix

	if Negative then
		Result = "-" .. Result
	end

	return Result
end

function NumberScaler.GetSuffixes()
	return Suffixes
end

Funcs.NumberScaler = NumberScaler

function Funcs.PlaySound(Sound: Sound, Origin: CFrame)
	local Part = CreateDefaultPart()
	Part.Transparency = 1
	Part.Size = Vector3.one
	Part.CFrame = Origin
	Part.Parent = workspace

	local PlayedSound = Sound:Clone()

	PlayedSound.PlaybackSpeed = PlayedSound.PlaybackSpeed
		+ Random:NextNumber(-PlayedSound.PlaybackSpeed * 0.05, PlayedSound.PlaybackSpeed * 0.05)
	PlayedSound.Volume = PlayedSound.Volume + Random:NextNumber(-0.05, PlayedSound.Volume * 0.05)

	PlayedSound.Parent = Part

	PlayedSound:Play()

	PlayedSound.Ended:Once(function()
		Part:Destroy()
	end)
end

function Funcs.PlaySoundGlobal(Sound: Sound)
	local PlayedSound = Sound:Clone()

	PlayedSound.PlaybackSpeed = PlayedSound.PlaybackSpeed
		+ Random:NextNumber(-PlayedSound.PlaybackSpeed * 0.05, PlayedSound.PlaybackSpeed * 0.05)
	PlayedSound.Volume = PlayedSound.Volume + Random:NextNumber(-0.05, PlayedSound.Volume * 0.05)

	PlayedSound.Parent = SoundService.PlayingSounds
	PlayedSound:Play()

	PlayedSound.Ended:Once(function()
		PlayedSound:Destroy()
	end)
end

local Thumbnails: { [Player]: string } = {}

function Funcs.GetThumbnailAsync(Player: Player)
	if Thumbnails[Player] then
		return Thumbnails[Player], true
	else
		local Thumbnail, Available =
			Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)

		Thumbnails[Player] = Thumbnail

		return Thumbnail, Available
	end
end

local IdThumbnails: { [number]: string } = {}

function Funcs.GetThumbnailIdAsync(UserId: number)
	if IdThumbnails[UserId] then
		return IdThumbnails[UserId], true
	else
		local Thumbnail, Available =
			Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)

		IdThumbnails[UserId] = Thumbnail

		return Thumbnail, Available
	end
end

local PlayerNames: { [number]: string } = {}

function Funcs.GetNameFromIdAsync(UserId: number)
	return Promise.new(function(resolve, reject)
		if PlayerNames[UserId] then
			resolve(PlayerNames[UserId])
			return
		end
		local Name = Players:GetNameFromUserIdAsync(UserId)
		if Name then
			PlayerNames[UserId] = Name
			resolve(Name)
		else
			reject("Player not found")
		end
	end)
end

function Funcs.LoadAnimation(Character: Model, Animation: Animation): AnimationTrack?
	local Humanoid = Character:FindFirstAncestorWhichIsA("Humanoid")
	if not Humanoid then
		return nil
	end

	local Animator = Humanoid:FindFirstAncestorWhichIsA("Animator")
	if not Animator then
		return nil
	end

	local AnimationTrack = Animator:LoadAnimation(Animation)
	if not AnimationTrack then
		return nil
	end

	return AnimationTrack
end

function Funcs.GetSmallestNumber(Data: { [number]: any }, Target: number)
	local LargestNumber: number = 0
	for Number, _ in pairs(Data) do
		if Number >= LargestNumber and Number <= Target then
			LargestNumber = Number
		end
	end

	return LargestNumber
end

function Funcs.InstanceAdd(Table: { [any]: any }, Index: any, Instance: Instance)
	Table[Index] = Instance

	Instance.Destroying:Once(function()
		Table[Index] = nil
	end)
end

function Funcs.InstanceAddi(Table: { [number]: any }, Instance: Instance)
	table.insert(Table, Instance)

	Instance.Destroying:Once(function()
		local Index = table.find(Table, Instance)

		if Index then
			table.remove(Table, Index)
		end
	end)
end

function Funcs.InstanceAddkey(Table: { [any]: any }, Index: Instance, Value: any)
	Table[Index] = Value

	Index.Destroying:Once(function()
		Table[Index] = nil
	end)
end

function Funcs.DisableHumanoid(Humanoid: Humanoid)
	Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	Humanoid.EvaluateStateMachine = false
	Humanoid.AutomaticScalingEnabled = true
	Humanoid.AutoJumpEnabled = false

	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

	local Animate: LocalScript? = nil

	if Humanoid.Parent and Humanoid.Parent:FindFirstChild("Animate") then
		Animate = (Humanoid.Parent :: any).Animate

		if Animate then
			Animate:Destroy()
		end
	end
end

-- Uses Viewport (Not Screen) to raycast
function Funcs.Raycast(Position: Vector2, Params: RaycastParams?)
	local Ray = Camera:ViewportPointToRay(Position.X, Position.Y)
	return workspace:Raycast(Ray.Origin, Ray.Direction * 500, Params)
end

function Funcs.EmitContinous(
	ParticleEmitter: { ParticleEmitter },
	CFrame: CFrame,
	Func: ((Particle: ParticleEmitter) -> ())?
)
	local Part = CreateRaw()
	Part.Size = Vector3.one
	Part.Transparency = 1
	Part.CFrame = CFrame
	local Attachment = Instance.new("Attachment")
	Attachment.Parent = Part
	for _, Particle in ipairs(ParticleEmitter) do
		local ParticleClone = Particle:Clone()
		if Func then
			Func(ParticleClone)
		end
		ParticleClone.Enabled = true
		ParticleClone.Parent = Attachment
	end

	return Part
end

function Funcs.EmitParticle(
	ParticleEmitter: { ParticleEmitter },
	CFrame: CFrame,
	Times: number?,
	Func: ((Particle: ParticleEmitter, Part: Part) -> ())?,
	HasAttachment: boolean?
)
	local Part = CreateRaw()
	Part.Size = Vector3.one
	Part.Transparency = 1
	Part.CFrame = CFrame
	local Attachment
	if HasAttachment then
		Attachment = Instance.new("Attachment")
		Attachment.Parent = Part
	end

	local Longest = 0
	for _, Particle in ipairs(ParticleEmitter) do
		local ParticleClone = Particle:Clone()
		ParticleClone.Enabled = false
		ParticleClone.Parent = if HasAttachment then Attachment else Part
		if Func then
			Func(ParticleClone, Part)
		end
		ParticleClone:Emit(Times)
		if Longest < Particle.Lifetime.Max then
			Longest = Particle.Lifetime.Max
		end
	end
	task.delay(Longest, function()
		Part:Destroy()
	end)

	return Part
end

Funcs.CreateRaw = CreateRaw

-- Debug Functions --

Funcs.Debug = {}

function Funcs.Debug.VisualizeRaycast(Origin: Vector3, Direction: Vector3)
	local Raycast = CreateDefaultPart()
	Raycast.CFrame = CFrame.new(Origin + Direction / 2, Origin + Direction)
	Raycast.Name = "Raycast"
	Raycast.Size = Vector3.new(1, 1, Direction.Magnitude)
	Raycast.Parent = workspace
end

function Funcs.Debug.VisualizeRay(Ray: Ray)
	Funcs.Debug.VisualizeRaycast(Ray.Origin, Ray.Direction)
end

function Funcs.Debug.VisualizeRayResult(Result: RaycastResult?)
	if Result then
		local Part = CreateDefaultPart()
		Part.Position = Result.Position
		Part.Parent = workspace
	end
end

function Funcs.Debug.VisualizeScreenPos(Position: Vector2)
	local Gui: any = nil
	if RunService:IsRunning() then
		Gui = Players.LocalPlayer.PlayerGui
	else
		Gui = game:GetService("StarterGui")
	end

	local Screen = Instance.new("ScreenGui")
	Screen.Archivable = false
	Screen.IgnoreGuiInset = true
	Screen.DisplayOrder = 20

	local Frame = Instance.new("Frame")
	Frame.Name = "DebugFrame"
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Size = UDim2.fromScale(0.04, 0.04)
	Frame.Position = UDim2.fromOffset(Position.X, Position.Y)
	Frame.Parent = Screen

	Screen.Parent = Gui

	task.delay(2, function()
		Screen:Destroy()
	end)
end

function Funcs.Debug.VisualizePosition(Position: Vector3)
	local Part = CreateDefaultPart()
	Part.Position = Position
	Part.Parent = workspace
end

function Funcs.Debug.VisualizeCFrame(CFrame: CFrame)
	local Part = CreateDefaultPart()
	Part.CFrame = CFrame
	Part.Parent = workspace
end

function Funcs.Debug.VisualizeDirection(Origin: Vector3, Direction: Vector3)
	local Part = CreateDefaultPart()
	Part.CFrame = CFrame.lookAlong(Origin, Direction)
	Part.Parent = workspace
end

function Funcs.Debug.VisualizePartSpatialQuery(QueryPart: BasePart)
	local Part = CreateDefaultPart()
	Part.Size = QueryPart.Size
	Part.CFrame = QueryPart.CFrame
	Part.Parent = workspace
end

--ps: try using Line Handler Adornement for further visualization --

return Funcs
