--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local GenerateId = require(Modules.GenerateId)

local GlobalModules = ServerScriptService.GlobalModules
local PlayerData = require(GlobalModules.PlayerData)

local Shared = ReplicatedStorage.Shared
local Constants = require(Shared.Constants)
local Types = require(Shared.Types)
local GameInfo = require(Shared.GameInfo)

local VectorOffset = Vector3.new(0, 3, 0)

export type Status = "Idle" | "ChoosingMap" | "LoadingPlayers" | "LoadingIn"

type BoothData = {
	UniqueId: string,
	Trove: Trove.Trove,
	StatusTrove: Trove.Trove,

	Players: { Player },

	Data: Types.SentData?,

	Status: Status,
	StartTime: number,
	TimeLeft: number,

	FirstTouchReject: Signal.Signal<Player>,
	LaterTouchesReject: Signal.Signal<Player>,

	PlayerAdded: Signal.Signal<Player>,
	PlayerRemoving: Signal.Signal<Player>,

	StartedChoosing: Signal.Signal<Player>,
	StartedWaiting: Signal.Signal<>,
	MapLoading: Signal.Signal<>,
	BoothEnded: Signal.Signal<>,
}

export type BoothInput = {
	Folder: Model,
	TouchPart: BasePart,
	TPInPart: BasePart,
	TPOutPart: BasePart,

	FirstTouchWrap: ((self: Booth, Player: Player) -> boolean)?,
	LaterTouchesWrap: ((self: Booth, Player: Player) -> boolean)?,
}

type BoothImpl = {
	new: (Input: BoothInput) -> Booth,

	StartPlayerChoosing: (self: Booth, Player: Player) -> (),
	ChooseMap: (self: Booth, MapId: string, LevelId: string, Difficulty: string) -> (),
	Start: (self: Booth) -> (),
	AddPlayer: (self: Booth, Player: Player) -> (),
	RemovePlayer: (self: Booth, Player: Player) -> (),

	CalculateTimeLeft: (self: Booth) -> number,

	Reset: (self: Booth) -> (),

	GetBooth: (UniqueId: string) -> Booth?,
	GetBooths: () -> { [Instance]: Booth },
	GetBoothFromPlayer: (Player: Player) -> Booth?,

	__index: BoothImpl,
	__eq: (a: Booth, b: Booth) -> (),
}

export type Booth = typeof(setmetatable({} :: BoothData, {} :: BoothImpl))

local Booth: BoothImpl = {} :: BoothImpl
Booth.__index = Booth

function Booth.__eq(a: Booth, b: Booth)
	return a.UniqueId == b.UniqueId
end

local Booths: { [Instance]: Booth } = {}

local _Statuses = { "Idle", "ChoosingMap", "LoadingPlayers", "LoadingIn" }
local GlobalPlayersQueue: { Player } = {}
local threads: { [Player]: thread } = {}

function Booth.new(Input: BoothInput)
	local self = setmetatable({}, Booth) :: Booth

	self.UniqueId = GenerateId.GenerateId()
	self.Trove = Trove.new()
	self.StatusTrove = self.Trove:Extend()

	self.FirstTouchReject = self.Trove:Construct(Signal)
	self.LaterTouchesReject = self.Trove:Construct(Signal)

	self.PlayerAdded = self.Trove:Construct(Signal)
	self.PlayerRemoving = self.Trove:Construct(Signal)

	self.StartedChoosing = self.Trove:Construct(Signal)
	self.StartedWaiting = self.Trove:Construct(Signal)
	self.MapLoading = self.Trove:Construct(Signal)
	self.BoothEnded = self.Trove:Construct(Signal)

	self.Status = "Idle"
	self.StartTime = 0
	self.TimeLeft = 0

	self.Players = {}

	self.Trove:Connect(Input.TouchPart.Touched, function(BasePart: BasePart)
		if self.Status == "ChoosingMap" or self.Status == "LoadingIn" then
			return
		end

		local Player = HelperFunctions.GetPlayerFromPart(BasePart)

		if Player then
			if table.find(GlobalPlayersQueue, Player) then
				return
			end

			for _, OtherBooth in pairs(Booths) do
				if table.find(OtherBooth.Players, Player) then
					return
				end
			end

			if self.Status == "Idle" then
				if not Input.FirstTouchWrap or Input.FirstTouchWrap(self, Player) then
					self:StartPlayerChoosing(Player)
				else
					self.LaterTouchesReject:Fire(Player)
				end
			elseif self.Status == "LoadingPlayers" then
				if not Input.LaterTouchesWrap or Input.LaterTouchesWrap(self, Player) then
					self:AddPlayer(Player)
				else
					self.LaterTouchesReject:Fire(Player)
				end
			end
		end
	end)

	self.Trove:Connect(self.PlayerAdded, function(Player: Player)
		if Player.Character then
			Player.Character:PivotTo(Input.TPInPart.CFrame + VectorOffset)
		end
	end)

	self.Trove:Connect(self.PlayerRemoving, function(Player: Player)
		if Player.Character then
			Player.Character:PivotTo(Input.TPOutPart.CFrame + VectorOffset)
		end

		if threads[Player] then
			task.cancel(threads[Player])
			threads[Player] = nil
		end
		if not table.find(GlobalPlayersQueue, Player) then
			table.insert(GlobalPlayersQueue, Player)
		end

		local thread = task.delay(Constants.BOOTHTOUCHDELAY, function()
			local Index = table.find(GlobalPlayersQueue, Player)
			if Index then
				table.remove(GlobalPlayersQueue, Index)
			end

			if threads[Player] then
				if coroutine.status(threads[Player]) ~= "running" then
					task.cancel(threads[Player])
				end
				threads[Player] = nil
			end
		end)
		threads[Player] = thread
	end)

	Booths[Input.Folder] = self

	return self
end

function Booth:StartPlayerChoosing(Player: Player)
	if self.Status ~= "Idle" then
		return
	end
	self.StatusTrove:Destroy()

	self.Status = "ChoosingMap"
	self.StartTime = workspace:GetServerTimeNow()
	self.TimeLeft = Constants.BOOTHMAPCHOSETIME

	self:AddPlayer(Player)

	self.StartedChoosing:Fire(Player)
	self.StatusTrove:Add(task.delay(self.TimeLeft, function()
		self:Reset()
	end))
end

function Booth:ChooseMap(MapId: string, LevelId: string, Difficulty: string)
	if self.Status ~= "ChoosingMap" then
		return
	end
	self.StatusTrove:Destroy()

	local Owner = self.Players[1]

	local PData = PlayerData.GetPlayerData(Owner)

	if PData then
		local _, LevelInfo = GameInfo.GetDataFromInfo(MapId, LevelId)
		if LevelInfo then
			if not (PData:OwnsMap(MapId) and PData:OwnsStage({
				Map = MapId,
				Stage = LevelInfo.Index,
			})) then
				return
			end
		else
			return
		end
	else
		return
	end

	self.Data = {
		MapId = MapId,
		LevelId = LevelId,
		Difficulty = Difficulty,
		Players = self.Players,
	}

	self.Status = "LoadingPlayers"
	self.StartTime = workspace:GetServerTimeNow()
	self.TimeLeft = Constants.BOOTHWAITTIME
	self.StartedWaiting:Fire()

	self.StatusTrove:Add(task.delay(self.TimeLeft, function()
		self:Start()
	end))
end

function Booth:Start()
	if self.Status ~= "LoadingPlayers" then
		return
	end
	self.StatusTrove:Destroy()
	self.Status = "LoadingIn"
	self.MapLoading:Fire()
	self.StartTime = workspace:GetServerTimeNow()
	self.TimeLeft = Constants.BOOTHMAPCHOSETIME
	self.StatusTrove:Add(task.delay(self.TimeLeft, function()
		self:Reset()
	end))
end

function Booth:AddPlayer(Player: Player)
	for _, NewBooth in pairs(Booths) do
		if table.find(NewBooth.Players, Player) then
			return
		end
	end

	table.insert(self.Players, Player)

	self.PlayerAdded:Fire(Player)
	self.StatusTrove:Connect(Player.CharacterRemoving, function()
		self:RemovePlayer(Player)
	end)
end

function Booth:RemovePlayer(Player: Player)
	if self.Players[1] == Player then
		self:Reset()
	else
		local Index = table.find(self.Players, Player)
		if Index then
			self.PlayerRemoving:Fire(Player)
			table.remove(self.Players, Index)
		end

		if #self.Players == 0 then
			self:Reset()
		end
	end
end

function Booth:CalculateTimeLeft()
	return math.max(self.TimeLeft - (workspace:GetServerTimeNow() - self.StartTime), 0)
end

--[=[
	Resets Booth to before anything has been done to it.
]=]
function Booth:Reset()
	self.Data = nil
	self.BoothEnded:Fire()
	self.StartTime = 0
	self.TimeLeft = 0

	for _, Player in ipairs(self.Players) do
		self.PlayerRemoving:Fire(Player)
	end

	table.clear(self.Players)
	self.StatusTrove:Destroy()
	self.Status = "Idle"
end

function Booth.GetBooth(UniqueId: string)
	for _, OtherBooth in pairs(Booths) do
		if OtherBooth.UniqueId == UniqueId then
			return OtherBooth
		end
	end

	return
end

function Booth.GetBooths()
	return Booths
end

function Booth.GetBoothFromPlayer(Player: Player)
	for _, OtherBooth in pairs(Booths) do
		if table.find(OtherBooth.Players, Player) then
			return OtherBooth
		end
	end

	return
end

return table.freeze(Booth)
