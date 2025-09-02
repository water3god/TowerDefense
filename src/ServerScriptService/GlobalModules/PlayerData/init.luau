--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Promise = require(Packages.Promise)
local TableUtil = require(Packages.TableUtil)
local Signal = require(Packages.Signal)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local GenerateId = require(Modules.GenerateId)

local Shared = ReplicatedStorage.Shared
local LevelRequirements = require(Shared.LevelRequirements)
local GameInfo = require(Shared.GameInfo)
local ProductInfo = require(Shared.ProductInfo)
local DailyRewards = require(Shared.DailyRewards)
local SettingData = require(Shared.Settings)
local TitleData = require(Shared.Titles)
local QuestData = require(Shared.Quests)
local Traits = require(Shared.Traits)
local Constants = require(Shared.Constants)

local CalculateUnitXP = GameInfo.XPData.CalculateUnitXP
local CalculatePlayerXP = GameInfo.XPData.CalculatePlayerXP
local UnitMaxLevel = GameInfo.XPData.UnitMaxLevel

local Utility = ServerScriptService.Utility
local ProfileStore = require(Utility.ProfileStore)

local Template = require(ServerStorage.Data.DefaultData)

local IsStudio = RunService:IsStudio()

export type GetStageData = {
	Map: string,
	Stage: number,
}

export type StageParamData = {
	Map: string,
	Stage: number,
	Difficulty: string,
	TimeFinished: number,
}

export type InfiniteStageParamData = {
	Map: string,
	Stage: number,
	Difficulty: string,
	Wave: number,
	Damage: number,
}

type PlayerDataData<T> = {
	_Trove: Trove.Trove,

	Player: Player,
	Profile: ProfileStore.Profile<Template.Data>,

	CurrentRoll: string?,
	CurrentWave: string?,

	NeededXP: number,

	SettingSignals: { [string]: Signal.Signal<any> },

	UnitEquipped: Signal.Signal<string, number>,
	UnitUnequipped: Signal.Signal<string, number>,
	UnitAdded: Signal.Signal<Template.UnitData>,
	UnitChanged: Signal.Signal<Template.UnitData>,
	UnitRemoved: Signal.Signal<Template.UnitData>,
	AutoRollChanged: Signal.Signal<boolean>,

	ProductChanged: Signal.Signal<string, Template.ProductData>,
	ProductRedeemed: Signal.Signal<number, boolean>,
	ResourceChanged: Signal.Signal<string, Template.ResourceData, number?>,

	StageChanged: Signal.Signal<StageParamData>,
	InfiniteStageChanged: Signal.Signal<InfiniteStageParamData>,

	Rolled: Signal.Signal<any>,
	Summoned: Signal.Signal<Template.UnitData>,

	SettingChanged: Signal.Signal<string, any>,

	XPChanged: Signal.Signal<number>,
	LeveledUp: Signal.Signal<number>,

	GoldChanged: Signal.Signal<number>,
	RobuxSpent: Signal.Signal<number, number>,
	TotalGoldGained: Signal.Signal<number>,
	DamageDone: Signal.Signal<number>,

	DailyRedeemed: Signal.Signal<number, number>,
	TitleChanged: Signal.Signal<string>,
	TitleAdded: Signal.Signal<string>,

	LeaderboardChanged: Signal.Signal<string, number>,

	DailyRegenerated: Signal.Signal<>,
	WeeklyRegenerated: Signal.Signal<>,

	QuestProgressed: Signal.Signal<{ { Id: string, Data: QuestData.DefaultQuestData } }>,
	QuestRedeemed: Signal.Signal<QuestData.DefaultQuestData>,

	BoostChanged: Signal.Signal<string, number>,
	InventorySpaceChanged: Signal.Signal<number>,

	Destroying: Signal.Signal<>,
}

type PlayerDataImpl = {
	new: (Player: Player) -> PlayerData?,

	GetOwnedUnits: (self: PlayerData) -> { [string]: Template.UnitData },
	GetEquippedUnits: (self: PlayerData) -> { string },

	OwnsUnit: (self: PlayerData, UnitId: string) -> boolean,
	UnitIsEquipped: (self: PlayerData, UnitId: string) -> boolean,

	EquipUnit: (self: PlayerData, UnitId: string) -> (),
	UnequipUnit: (self: PlayerData, UnitId: string) -> (),
	AddUnit: (self: PlayerData, UnitName: string, ExtraData: {}?) -> Template.UnitData?,
	AddUnitFromExisting: (self: PlayerData, UnitData: Template.UnitData) -> Template.UnitData?,
	ChangeUnitTrait: (self: PlayerData, UniqueId: string, TraitName: string?) -> Template.UnitData?,
	DeleteUnit: (self: PlayerData, UniqueId: string) -> (),

	GetUnitFromId: (self: PlayerData, UniqueId: string) -> Template.UnitData?,

	HasProduct: (self: PlayerData, Id: number, IsGamepass: boolean) -> boolean,

	RedeemGamepass: (self: PlayerData, GamepassId: number) -> (),
	OwnsGamepass: (self: PlayerData, GamepassId: number) -> boolean,

	AddProduct: (self: PlayerData, ProductId: number, Count: number?) -> (),
	RemoveProduct: (self: PlayerData, ProductId: number, Count: number?) -> (),
	RedeemProduct: (self: PlayerData, ProductId: number) -> (),

	GetProductFromId: (self: PlayerData, UniqueId: string) -> Template.ProductData?,

	AddResource: (self: PlayerData, Resource: string, Count: number?) -> (),
	RemoveResource: (self: PlayerData, Resource: string, Count: number?) -> (),

	GetResourceFromId: (self: PlayerData, UniqueId: string) -> Template.ResourceData?,
	HasEnoughResource: (self: PlayerData, Resource: string, Count: number) -> boolean,

	SetGold: (self: PlayerData, Gold: number) -> (),
	AddGold: (self: PlayerData, Gold: number) -> (),
	SubtractGold: (self: PlayerData, Gold: number) -> (),

	CalculateGoldMultiplier: (self: PlayerData) -> number,
	CalculateXPMultiplier: (self: PlayerData) -> number,

	AddDamageDone: (self: PlayerData, Damage: number) -> (),
	AddRobuxSpent: (self: PlayerData, Robux: number) -> (),

	OwnsMap: (self: PlayerData, Map: string) -> boolean,
	OwnsStage: (self: PlayerData, Data: GetStageData) -> boolean,
	AddStage: (self: PlayerData, Data: StageParamData) -> (),
	AddInfiniteStage: (self: PlayerData, Data: InfiniteStageParamData) -> (),

	RedeemDaily: (self: PlayerData) -> (),

	GetQuestFromId: (self: PlayerData, Id: string) -> QuestData.DefaultQuestData?,

	RegenerateDailyQuests: (self: PlayerData) -> (),
	RegenerateWeeklyQuests: (self: PlayerData) -> (),

	ProgressQuests: (
		self: PlayerData,
		Data: {
			Amount: number,
			Type: QuestData.QuestType | string,
			SubType: QuestData.QuestSubs | string?,
			ExtraData: { any: any }?,
		}
	) -> (),
	RedeemQuest: (self: PlayerData, Id: string) -> (),

	GetSetting: (self: PlayerData, Setting: string) -> any,
	ChangeSetting: (self: PlayerData, Setting: string, Value: any) -> (),
	GetSettingChangedSignal: (self: PlayerData, Setting: string) -> Signal.Signal<any>,

	ChangeInGame: (self: PlayerData, InGame: boolean) -> (),

	AddTitle: (self: PlayerData, Title: string) -> (),
	ChangeTitle: (self: PlayerData, Title: string) -> (),

	CalculateInventorySpace: (self: PlayerData) -> number,

	ChangeLeaderboardPosition: (self: PlayerData, LeaderboardName: string, Position: number) -> (),

	AddRoll: (self: PlayerData, Count: number) -> (),

	AddUnitXP: (self: PlayerData, UnitId: string, XP: number) -> (),
	AddXP: (self: PlayerData, XP: number) -> (),

	AddBoost: (self: PlayerData, Boost: string, Duration: number) -> (),
	HasBoost: (self: PlayerData, Boost: string) -> boolean,

	Delete: (self: PlayerData) -> (),

	GetPlayerData: (Player: Player) -> PlayerData?,
	GetPlayerDataAsync: (Player: Player) -> PlayerData?,
	GetDatas: () -> { [Player]: PlayerData },

	DataAdded: Signal.Signal<PlayerData>,

	__index: PlayerDataImpl,
}

export type PlayerData = typeof(setmetatable({} :: PlayerDataData<any>, {} :: PlayerDataImpl))

local PlayerData: PlayerDataImpl = {} :: PlayerDataImpl
PlayerData.__index = PlayerData

local MainDatastore = ProfileStore.New(Constants.MainDataStore, Template)

local PlayerDatas: { [Player]: PlayerData } = {}

local LevelData = LevelRequirements

local function GetMaxUnits(Level: number)
	local UnitsAvailable = 0

	for _, LevelReq in ipairs(LevelData.EquippedFrames) do
		if Level >= LevelReq then
			UnitsAvailable += 1
		end
	end

	return UnitsAvailable
end

local function SyncIds(Table: { [string]: any }, Func: ((OldId: string, NewId: string) -> ())?)
	for UniqueId, Data in pairs(Table) do
		if GenerateId.IdIsTaken(UniqueId) then
			local NewId = GenerateId.GenerateId()
			Table[UniqueId] = nil
			Table[NewId] = Data
			Data.UniqueId = NewId
			if Func then
				Func(UniqueId, NewId)
			end
		else
			GenerateId.AddId(UniqueId)
		end
	end
end

local function ReconcileQuests(Quests: QuestData.Quests)
	local function Handle(Name: string)
		HelperFunctions.SyncArray(Quests[Name], QuestData.Quests[Name], "Id")

		local SampleTable = QuestData.Quests[Name]
		local CurrentTable: QuestData.QuestSubType = Quests[Name]

		if #SampleTable ~= #CurrentTable then
			warn("Error: Quest count mismatch for " .. Name)
		else
			for i = 1, #SampleTable, 1 do
				local CurrentValue = CurrentTable[i]
				local SampleValue = SampleTable[i]

				if CurrentValue.Id ~= SampleValue.Id then
					warn("Error: Quest ID mismatch for " .. Name .. " at index " .. i)
				else
					CurrentValue.Name = SampleValue.Name
					CurrentValue.Description = SampleValue.Description
					CurrentValue.QuestReward = TableUtil.Copy(SampleValue.QuestReward)
					CurrentValue.NeededValue = SampleValue.NeededValue
				end
			end
		end
	end

	Handle("EventQuests")
	Handle("GlobalQuests")
end

local function RemoveOld(Keys: { string }, Table: { [string]: any })
	for Key, _ in pairs(Table) do
		if not table.find(Keys, Key) then
			Table[Key] = nil
		end
	end
end

function PlayerData.new(Player: Player)
	local self = setmetatable({}, PlayerData) :: PlayerData

	self._Trove = Trove.new()

	self.UnitAdded = self._Trove:Construct(Signal)
	self.UnitChanged = self._Trove:Construct(Signal)
	self.UnitRemoved = self._Trove:Construct(Signal)
	self.UnitEquipped = self._Trove:Construct(Signal)
	self.UnitUnequipped = self._Trove:Construct(Signal)

	self.SettingChanged = self._Trove:Construct(Signal)

	self.Rolled = self._Trove:Construct(Signal)
	self.Summoned = self._Trove:Construct(Signal)

	self.AutoRollChanged = self._Trove:Construct(Signal)

	self.ProductChanged = self._Trove:Construct(Signal)
	self.ProductRedeemed = self._Trove:Construct(Signal)
	self.ResourceChanged = self._Trove:Construct(Signal)

	self.XPChanged = self._Trove:Construct(Signal)
	self.LeveledUp = self._Trove:Construct(Signal)

	self.GoldChanged = self._Trove:Construct(Signal)
	self.RobuxSpent = self._Trove:Construct(Signal)
	self.TotalGoldGained = self._Trove:Construct(Signal)
	self.DamageDone = self._Trove:Construct(Signal)

	self.StageChanged = self._Trove:Construct(Signal)
	self.InfiniteStageChanged = self._Trove:Construct(Signal)

	self.DailyRedeemed = self._Trove:Construct(Signal)

	self.TitleChanged = self._Trove:Construct(Signal)
	self.TitleAdded = self._Trove:Construct(Signal)

	self.LeaderboardChanged = self._Trove:Construct(Signal)

	self.DailyRegenerated = self._Trove:Construct(Signal)
	self.WeeklyRegenerated = self._Trove:Construct(Signal)

	self.QuestProgressed = self._Trove:Construct(Signal)
	self.QuestRedeemed = self._Trove:Construct(Signal)

	self.BoostChanged = self._Trove:Construct(Signal)
	self.InventorySpaceChanged = self._Trove:Construct(Signal)

	self.Destroying = self._Trove:Construct(Signal)

	self.SettingSignals = {}
	self.Player = Player

	if game.PlaceId == 0 then
		self.Profile = MainDatastore.Mock:StartSessionAsync("PlayerData9" .. Player.UserId, {
			Cancel = function()
				return Player.Parent ~= Players
			end,
		}) :: any
	else
		self.Profile = MainDatastore:StartSessionAsync("PlayerData9" .. Player.UserId, {
			Cancel = function()
				return Player.Parent ~= Players
			end,
		}) :: any
	end

	if self.Profile then
		self.Profile:AddUserId(Player.UserId)
		self.Profile:Reconcile()

		local Data = self.Profile.Data

		SyncIds(Data.Units, function(OldId: string, NewId: string)
			local Index = table.find(Data.EquippedUnits, OldId)
			if Index then
				Data.EquippedUnits[Index] = NewId
			end
		end)

		for _, Unit in pairs(Data.Units) do
			if Unit and Unit.Trait then
				if not Traits.Traits[Unit.Trait] then
					Unit.Trait = nil
				end
			end
		end

		for i = #Data.Titles, 1, -1 do
			if not TitleData[Data.Titles[i]] then
				table.remove(Data.Titles, i)
			end
		end

		SyncIds(Data.Products)
		SyncIds(Data.Resources)
		RemoveOld(SettingData.SettingIndexes, Data.Settings :: any)
		ReconcileQuests(Data.Quests)
		TableUtil.Reconcile(Data.QuestData, QuestData.QuestPlayerData.DailyQuests)
		TableUtil.Reconcile(Data.QuestData, QuestData.QuestPlayerData.WeeklyQuests)
		TableUtil.Reconcile(Data.QuestData, QuestData.QuestPlayerData.EventQuests)
		TableUtil.Reconcile(Data.QuestData, QuestData.QuestPlayerData.GlobalQuests)

		if Constants.CurrentEvent ~= Data.Quests.MetaData.CurrentEvent then
			Data.Quests.EventQuests = TableUtil.Copy(QuestData.Quests.EventQuests)
		end

		for _, Quest in pairs(Data.Quests.DailyQuests) do
			Quest.Redeemed = false
		end

		self:CalculateInventorySpace()

		do
			local Day = (DateTime.now():ToUniversalTime() :: any).Day
			if Day ~= Data.ReferredDate then
				Data.ReferredDate = Day
				Data.Referrals = {}
			end
		end

		self.Profile.OnSessionEnd:Connect(function()
			self:Delete()
			Player:Kick("Error Loading Profile: Player not in game.")
		end)

		if self.Player:IsDescendantOf(Players) then
			PlayerDatas[self.Player] = self
		else
			self:Delete()
			Player:Kick("Error Loading Profile: Player not in game.")
			return
		end
	else
		self:Delete()
		Player:Kick("Error Loading Profile: Player not in game.")
		return
	end

	if IsStudio then
		print(self.Profile.Data)
		print("Loaded Profile " .. Player.UserId)
	end

	self._Trove:Connect(self.Destroying, function()
		self.Profile:EndSession()
	end)

	self.NeededXP = CalculatePlayerXP(self.Profile.Data.Level)

	do
		local QuestsMetaData = self.Profile.Data.Quests.MetaData
		local CurrentTime = DateTime.now()

		if QuestsMetaData.DailyRegenerated + 86400 < CurrentTime.UnixTimestamp then
			self:RegenerateDailyQuests()
		end
		if QuestsMetaData.WeeklyRegenerated + 604800 < CurrentTime.UnixTimestamp then
			self:RegenerateWeeklyQuests()
		end
	end

	local function DailyQuestsPromise(): Promise.Promise
		return Promise.new(function(resolve)
			local CurrentTime = DateTime.now()
			local NewTime = math.ceil(CurrentTime.UnixTimestamp / 86400) * 86400
			local Seconds = NewTime - CurrentTime.UnixTimestamp

			task.wait(Seconds + 1)
			resolve()
		end)
			:andThen(function()
				self:RegenerateDailyQuests()
			end)
			:andThen(function()
				return DailyQuestsPromise()
			end)
	end

	local function WeeklyQuestsPromise(): Promise.Promise
		return Promise.new(function(resolve)
			local CurrentTime = DateTime.now()
			local NewTime = math.ceil(CurrentTime.UnixTimestamp / 604800) * 604800
			local Seconds = NewTime - CurrentTime.UnixTimestamp

			task.wait(Seconds + 1)
			resolve()
		end)
			:andThen(function()
				self:RegenerateWeeklyQuests()
			end)
			:andThen(function()
				return WeeklyQuestsPromise()
			end)
	end

	self._Trove:AddPromise(DailyQuestsPromise() :: any)
	self._Trove:AddPromise(WeeklyQuestsPromise() :: any)

	do
		local Promises: { [string]: Promise.Promise } = {}

		local function HandleBoostChange(Boost: string, EndTime: number)
			if Promises[Boost] then
				self._Trove:Remove(Promises[Boost] :: any)
			end

			Promises[Boost] = Promise.delay(EndTime - DateTime.now().UnixTimestamp):andThen(function()
				self.Profile.Data.Boosts[Boost] = nil
				Promises[Boost] = nil
			end)
			self._Trove:AddPromise(Promises[Boost] :: any)
		end

		for Boost, EndTime in pairs(self.Profile.Data.Boosts) do
			if EndTime > DateTime.now().UnixTimestamp then
				HandleBoostChange(Boost, EndTime)
			else
				self.Profile.Data.Boosts[Boost] = nil
			end
		end

		self.BoostChanged:Connect(HandleBoostChange)
	end

	self.ProductRedeemed:Connect(function(_, IsGamepass: boolean)
		if IsGamepass then
			self:CalculateInventorySpace()
		end
	end)

	if self.Profile.Data.Gold < 20 then
		self:AddGold(1000000)
	end

	self.DataAdded:Fire(self)

	return self
end

function PlayerData:GetOwnedUnits()
	return self.Profile.Data.Units
end

function PlayerData:GetEquippedUnits()
	return self.Profile.Data.EquippedUnits
end

function PlayerData:OwnsUnit(UnitId: string)
	local Data = self.Profile.Data

	if Data.Units[UnitId] then
		return true
	else
		return false
	end
end

function PlayerData:UnitIsEquipped(UnitId: string)
	local Data = self.Profile.Data

	for _, UniqueId in pairs(Data.EquippedUnits) do
		if UniqueId == UnitId then
			return true
		end
	end

	return false
end

function PlayerData:EquipUnit(Id: string)
	local Data = self.Profile.Data

	if self:OwnsUnit(Id) and not self:UnitIsEquipped(Id) then
		local MaxUnits = GetMaxUnits(Data.Level)
		for i = 1, MaxUnits, 1 do
			if Data.EquippedUnits[i] == nil then
				Data.EquippedUnits[i] = Id
				self.UnitEquipped:Fire(Id, i)
				return
			end
		end

		self.UnitUnequipped:Fire(Data.EquippedUnits[MaxUnits], MaxUnits)
		Data.EquippedUnits[MaxUnits] = Id
		self.UnitEquipped:Fire(Id, MaxUnits)
	end
end

function PlayerData:UnequipUnit(Id: string)
	local Data = self.Profile.Data

	for Index, UniqueId in pairs(Data.EquippedUnits) do
		if UniqueId == Id then
			self.UnitUnequipped:Fire(Id, Index)
			Data.EquippedUnits[Index] = nil
			return
		end
	end
end

function PlayerData:AddUnit(UnitName: string, ExtraData: {}?)
	local Data = self.Profile.Data

	local Id = GenerateId.GenerateId()

	local UnitData = {
		UniqueId = Id,
		Unit = UnitName,
		Level = 1,
		XP = 0,
		NeededXP = CalculateUnitXP(1),
	}

	if ExtraData then
		for Index, Value in pairs(ExtraData) do
			UnitData[Index] = Value
		end
	end

	Data.Units[Id] = UnitData
	self.UnitAdded:Fire(UnitData)

	return UnitData
end

function PlayerData:AddUnitFromExisting(UnitData: Template.UnitData)
	local Data = self.Profile.Data

	Data.Units[UnitData.UniqueId] = UnitData
	self.UnitAdded:Fire(UnitData)

	return UnitData
end

function PlayerData:ChangeUnitTrait(UniqueId: string, TraitName: string?)
	local Data = self.Profile.Data

	local Unit = Data.Units[UniqueId]

	if Unit then
		local OldTrait = Unit.Trait
		Unit.Trait = TraitName
		if OldTrait ~= TraitName then
			self.UnitChanged:Fire(Unit)
		end
		return Unit
	end

	return nil
end

function PlayerData:DeleteUnit(UniqueId: string)
	local Data = self.Profile.Data

	for Index, EquippedId in pairs(Data.EquippedUnits) do
		if EquippedId == UniqueId then
			Data.EquippedUnits[Index] = nil
			self.UnitUnequipped:Fire(UniqueId, Index)
		end
	end

	if Data.Units[UniqueId] then
		self.UnitRemoved:Fire(Data.Units[UniqueId])
		Data.Units[UniqueId] = nil
	end
end

function PlayerData:GetUnitFromId(UniqueId: string)
	local Data = self.Profile.Data

	return Data.Units[UniqueId]
end

function PlayerData:HasProduct(ProductId: number, IsGamepass: boolean)
	local Data = self.Profile.Data
	for _, ProductData in pairs(Data.Products) do
		if ProductData.ProductId == ProductId and ProductData.IsGamepass == IsGamepass then
			return true
		end
	end

	return false
end

function PlayerData:RedeemGamepass(GamepassId: number)
	if not table.find(self.Profile.Data.Gamepasses, GamepassId) then
		table.insert(self.Profile.Data.Gamepasses, GamepassId)
		self.ProductRedeemed:Fire(GamepassId, true)
		self:RemoveProduct(GamepassId, 1)
		self.Profile:Save()
	end
end

function PlayerData:OwnsGamepass(GamepassId: number)
	if table.find(self.Profile.Data.Gamepasses, GamepassId) then
		return true
	else
		return false
	end
end

function PlayerData:RedeemProduct(ProductId: number)
	local Data = self.Profile.Data
	if Data.CachedProducts[ProductId] then
		Data.CachedProducts[ProductId] += 1
	else
		Data.CachedProducts[ProductId] = 1
	end
	self:RemoveProduct(ProductId, 1)
	self.ProductRedeemed:Fire(ProductId, false)
	self.Profile:Save()
end

function PlayerData:AddProduct(ProductId: number, CountInput: number?)
	local Products = self.Profile.Data.Products
	local FoundId = nil
	local Count = CountInput or 1

	for _, ProductData in pairs(Products) do
		if ProductData.ProductId == ProductId then
			FoundId = ProductData.UniqueId
			break
		end
	end

	if FoundId then
		local Data = Products[FoundId]
		Products[FoundId].Count += Count
		self.ProductChanged:Fire("Changed", Data)
	else
		if ProductInfo.ProductInfo[ProductId] then
			local Id = GenerateId.GenerateId()
			local Data = {
				IsGamepass = false,
				ProductId = ProductId,
				UniqueId = Id,
				Count = Count,
			}
			Products[Id] = Data
			self.ProductChanged:Fire("Added", Data)
		elseif ProductInfo.GamepassInfo[ProductId] then
			local Id = GenerateId.GenerateId()
			local Data = {
				IsGamepass = true,
				ProductId = ProductId,
				UniqueId = Id,
				Count = Count,
			}
			Products[Id] = Data
			self.ProductChanged:Fire("Added", Data)
		else
			task.spawn(function()
				error(string.format("NO PRODUCT WITH ID: %u", ProductId))
			end)
		end
	end
end

function PlayerData:RemoveProduct(ProductId: number, CountInput: number?)
	local Products = self.Profile.Data.Products
	local FoundId = nil

	for _, ProductData in pairs(Products) do
		if ProductData.ProductId == ProductId then
			FoundId = ProductData.UniqueId
			break
		end
	end

	if FoundId then
		local TotalProductCount = Products[FoundId].Count

		if CountInput and TotalProductCount > CountInput then
			local Data = Products[FoundId]
			Data.Count -= CountInput
			self.ProductChanged:Fire("Changed", Data)
		else
			self.ProductChanged:Fire("Removed", Products[FoundId])
			Products[FoundId] = nil
		end
	end
end

function PlayerData:GetProductFromId(UniqueId: string)
	local Products = self.Profile.Data.Products
	return Products[UniqueId]
end

function PlayerData:AddResource(Resource: string, CountInput: number?)
	local Resources = self.Profile.Data.Resources
	local FoundId = nil
	local Count = CountInput or 1

	for _, ResourceData in pairs(Resources) do
		if ResourceData.Resource == Resource then
			FoundId = ResourceData.UniqueId
			break
		end
	end

	if FoundId then
		local Data = Resources[FoundId]
		Data.Count += Count
		self.ResourceChanged:Fire("Added", Data, CountInput)
	elseif GameInfo.RewardInfo[Resource] then
		local UniqueId = GenerateId.GenerateId()
		local Data = { Resource = Resource, UniqueId = UniqueId, Count = Count }
		Resources[UniqueId] = { Resource = Resource, UniqueId = UniqueId, Count = Count }
		self.ResourceChanged:Fire("Changed", Data)
	end
end

function PlayerData:RemoveResource(Resource: string, CountInput: number?)
	local Resources = self.Profile.Data.Resources
	local FoundId = nil

	for _, ResourceData in pairs(Resources) do
		if ResourceData.Resource == Resource then
			FoundId = ResourceData.UniqueId
			break
		end
	end

	if FoundId then
		local TotalResourceCount = Resources[FoundId].Count

		if CountInput and TotalResourceCount > CountInput then
			local Data = Resources[FoundId]
			Data.Count -= CountInput
			self.ResourceChanged:Fire("Changed", Data)
		else
			self.ResourceChanged:Fire("Removed", Resources[FoundId])
			Resources[FoundId] = nil
		end
	end
end

function PlayerData:GetResourceFromId(UniqueId: string)
	local Resources = self.Profile.Data.Resources
	return Resources[UniqueId]
end

function PlayerData:HasEnoughResource(Resource: string, Count: number)
	local Resources = self.Profile.Data.Resources

	for _, ResourceData in pairs(Resources) do
		if ResourceData.Resource == Resource then
			return ResourceData.Count >= Count
		end
	end

	return false
end

function PlayerData:SetGold(Gold: number)
	local Data = self.Profile.Data
	local GoldCount = math.floor(math.max(Gold, 0))
	local OldCount = Data.Gold
	Data.Gold = GoldCount
	self.GoldChanged:Fire(GoldCount)
	if Gold > OldCount then
		Data.TotalGoldGained += (Gold - OldCount)
		self.TotalGoldGained:Fire(Data.TotalGoldGained)
	end
end

function PlayerData:AddGold(Gold: number)
	local CurrentGold = self.Profile.Data.Gold
	self:SetGold(CurrentGold + Gold)
end

function PlayerData:SubtractGold(Gold: number)
	local CurrentGold = self.Profile.Data.Gold
	self:SetGold(CurrentGold - Gold)
end

function PlayerData:CalculateGoldMultiplier()
	local Multiplier = 1

	if self:OwnsGamepass(1382164818) then
		Multiplier += 0.2
	end

	if self.Player.MembershipType == Enum.MembershipType.Premium then
		Multiplier += 0.1
	end
	return Multiplier
end

function PlayerData:CalculateXPMultiplier()
	local Multiplier = 1

	if self:OwnsGamepass(1382164818) then
		Multiplier += 0.2
	end
	if self:OwnsGamepass(1403365727) then
		Multiplier += 0.2
	end

	if self.Player.MembershipType == Enum.MembershipType.Premium then
		Multiplier += 0.1
	end
	return Multiplier
end

function PlayerData:AddDamageDone(DamageInput: number)
	local Damage = math.floor(math.max(DamageInput, 0))
	local Data = self.Profile.Data
	Data.TotalDamageDone += Damage
	self.DamageDone:Fire(Data.TotalDamageDone)
end

function PlayerData:AddRobuxSpent(RobuxSpentInput: number)
	local RobuxSpent = math.floor(math.max(RobuxSpentInput, 0))
	local Data = self.Profile.Data
	Data.RobuxSpent += RobuxSpent
	self.RobuxSpent:Fire(Data.RobuxSpent, RobuxSpent)
end

function PlayerData:OwnsMap(Map: string)
	local CompletedMaps = self.Profile.Data.CompletedMaps

	if CompletedMaps[Map] then
		return true
	else
		local MapData = GameInfo.GetMapFromId(Map)
		if MapData then
			if MapData.Prerequisite then
				local PrerequisiteData = CompletedMaps[MapData.Prerequisite]
				local CurrentMapInfo = GameInfo.GetMapFromId(MapData.Prerequisite)
				if PrerequisiteData and CurrentMapInfo and PrerequisiteData[#CurrentMapInfo.LevelInfo] then
					return true
				end
			else
				return true
			end
		end
	end

	return false
end

function PlayerData:OwnsStage(ParamData: GetStageData)
	local CompletedMaps = self.Profile.Data.CompletedMaps

	if CompletedMaps[ParamData.Map] then
		if ParamData.Stage == 0 or ParamData.Stage == 1 or CompletedMaps[ParamData.Map][ParamData.Stage - 1] then
			return true
		end
	else
		local MapData = GameInfo.GetMapFromId(ParamData.Map)
		if MapData and (ParamData.Stage == 1 or ParamData.Stage == 0) then
			if not MapData.Prerequisite then
				return true
			elseif CompletedMaps[MapData.Prerequisite] then
				return true
			end
		end
	end

	return false
end

function PlayerData:AddStage(StageParamData: StageParamData)
	if
		typeof(StageParamData) ~= "table"
		or typeof(StageParamData.Map) ~= "string"
		or typeof(StageParamData.Stage) ~= "number"
		or typeof(StageParamData.Difficulty) ~= "string"
		or typeof(StageParamData.TimeFinished) ~= "number"
	then
		warn("PlayerData:AddStage (Invalid Parameters)")
	end

	local Data = self.Profile.Data
	if not Data.CompletedMaps[StageParamData.Map] then
		Data.CompletedMaps[StageParamData.Map] = {}
	end
	local MapData = Data.CompletedMaps[StageParamData.Map]
	if not MapData[StageParamData.Stage] then
		MapData[StageParamData.Stage] = {}
	end
	local StageData = MapData[StageParamData.Stage]
	if not StageData[StageParamData.Difficulty] then
		StageData[StageParamData.Difficulty] = {
			FastestTime = StageParamData.TimeFinished,
			FinishedCount = 1,
		}
	end

	local DifficultyData = StageData[StageParamData.Difficulty]
	if StageParamData.TimeFinished < DifficultyData.FastestTime then
		DifficultyData.FastestTime = StageParamData.TimeFinished
	end
	DifficultyData.FinishedCount += 1
	self.StageChanged:Fire(StageParamData)
end

function PlayerData:AddInfiniteStage(StageParamData: InfiniteStageParamData)
	if
		typeof(StageParamData) ~= "table"
		or typeof(StageParamData.Map) ~= "string"
		or typeof(StageParamData.Wave) ~= "number"
		or typeof(StageParamData.Stage) ~= "number"
		or typeof(StageParamData.Difficulty) ~= "string"
	then
		warn("PlayerData:AddInfiniteStage (Invalid Parameters)")
		return
	end

	local Data = self.Profile.Data
	if not Data.CompletedInfinites[StageParamData.Map] then
		Data.CompletedInfinites[StageParamData.Map] = {}
	end
	local MapData = Data.CompletedInfinites[StageParamData.Map]
	if not MapData[StageParamData.Stage] then
		MapData[StageParamData.Stage] = {}
	end
	local StageData = MapData[StageParamData.Stage]
	if StageData[StageParamData.Difficulty] then
		local DifficultyData = StageData[StageParamData.Difficulty]
		if DifficultyData.Wave < StageParamData.Wave then
			DifficultyData.Wave = StageParamData.Wave
			DifficultyData.Damage = StageParamData.Damage
		end
	else
		StageData[StageParamData.Difficulty] = {
			Damage = StageParamData.Damage,
			Wave = StageParamData.Wave,
		}
	end

	self.InfiniteStageChanged:Fire(StageParamData)
end

function PlayerData:RedeemDaily()
	local Data = self.Profile.Data

	if Data.DailyData.LastRedeemed + 60 * 60 * 24 > workspace:GetServerTimeNow() then
		return
	end

	local Day = Data.DailyData.Day

	local RewardData = DailyRewards.Rewards[Day]

	if RewardData.Type == "Unit" then
		self:AddUnit(RewardData.Name, RewardData.ExtraData)
	elseif RewardData.Type == "Resource" then
		if RewardData.Name == "Gold" then
			self:AddGold(RewardData.Count)
		else
			self:AddResource(RewardData.Name, RewardData.Count)
		end
	elseif RewardData.Type == "Product" then
		local _, ProductId = ProductInfo.GetProductFromNameOnly(RewardData.Name)
		if ProductId then
			self:AddProduct(ProductId, RewardData.Count)
		else
			warn("No Product with Name: " .. RewardData.Name)
		end
	end

	if Day >= #DailyRewards.Rewards then
		Data.DailyData.Day = 1
	else
		Data.DailyData.Day += 1
	end

	Data.DailyData.LastRedeemed = workspace:GetServerTimeNow()

	self.DailyRedeemed:Fire(Data.DailyData.Day, Data.DailyData.LastRedeemed)
end

function PlayerData:GetQuestFromId(Id: string)
	local Quests = self.Profile.Data.Quests

	for Name, QuestTypes in pairs(Quests) do
		if Name == "MetaData" then
			continue
		end
		for _, Quest in pairs(QuestTypes) do
			if Quest and Quest.Id == Id then
				return Quest
			end
		end
	end

	return nil
end

function PlayerData:RegenerateDailyQuests()
	local Quests = self.Profile.Data.Quests
	local DailyQuestsData = QuestData.Quests.DailyQuests

	local NewQuests = {}
	local UsedIds = {}

	for _ = 1, math.min(5, #DailyQuestsData), 1 do
		local RandomQuest = DailyQuestsData[math.random(1, #DailyQuestsData)]
		while table.find(UsedIds, RandomQuest.Id) do
			RandomQuest = DailyQuestsData[math.random(1, #DailyQuestsData)]
		end

		table.insert(UsedIds, RandomQuest.Id)
		table.insert(NewQuests, TableUtil.Copy(RandomQuest, true))
	end

	local CurrentTime = DateTime.now().UnixTimestamp
	local DayTime = math.floor(CurrentTime / 86400 * 86400)

	Quests.MetaData.DailyRegenerated = DayTime
	Quests.DailyQuests = NewQuests
	local QData = self.Profile.Data.QuestData
	QData.DailyQuests = HelperFunctions.CopyTableToTable(QData.DailyQuests, QuestData.QuestPlayerData.DailyQuests)
	self.DailyRegenerated:Fire()
end

function PlayerData:RegenerateWeeklyQuests()
	local Quests = self.Profile.Data.Quests
	local WeeklyQuestsData = QuestData.Quests.WeeklyQuests

	local NewQuests = {}
	local UsedIds = {}

	for _ = 1, math.min(10, #WeeklyQuestsData), 1 do
		local RandomQuest = WeeklyQuestsData[math.random(1, #WeeklyQuestsData)]
		while table.find(UsedIds, RandomQuest.Id) do
			RandomQuest = WeeklyQuestsData[math.random(1, #WeeklyQuestsData)]
		end

		table.insert(UsedIds, RandomQuest.Id)
		table.insert(NewQuests, TableUtil.Copy(RandomQuest, true))
	end

	local CurrentTime = DateTime.now().UnixTimestamp
	local WeekTime = math.floor(CurrentTime / (7 * 86400) * (7 * 86400))

	Quests.MetaData.WeeklyRegenerated = WeekTime
	Quests.WeeklyQuests = NewQuests
	local QData = self.Profile.Data.QuestData
	QData.WeeklyQuests = HelperFunctions.CopyTableToTable(QData.WeeklyQuests, QuestData.QuestPlayerData.WeeklyQuests)
	self.WeeklyRegenerated:Fire()
end

function PlayerData:ProgressQuests(Data)
	local DataToFire = {}
	local PData = self.Profile.Data
	local function Progress(Type: QuestData.QuestSubs | string)
		local Quests: { QuestData.DefaultQuestData } = PData.Quests[Type]
		for _, Quest in ipairs(Quests) do
			if Quest.Type == Data.Type and Quest.CurrentValue ~= Data.Amount then
				if QuestData.ValidFunctions[Quest.Type] and Data.ExtraData then
					local Valid = QuestData.ValidFunctions[Quest.Type](Quest, Data.ExtraData)
					if not Valid then
						continue
					end
				end

				Quest.CurrentValue = math.min(Data.Amount, Quest.NeededValue)
				table.insert(DataToFire, { Id = Quest.Id, Data = Quest })
			end
		end
	end

	if Data.SubType then
		Progress(Data.SubType)
	else
		Progress("DailyQuests")
		Progress("WeeklyQuests")
		Progress("EventQuests")
		Progress("GlobalQuests")
	end

	self.QuestProgressed:Fire(DataToFire)
end

function PlayerData:RedeemQuest(Id: string)
	local Quest = self:GetQuestFromId(Id)

	if not Quest or Quest.Redeemed then
		return
	end

	Quest.Redeemed = true

	local Reward = Quest.QuestReward
	if Reward.Type == "Unit" then
		self:AddUnit(Reward.Value)
	elseif Reward.Type == "Resource" then
		if Reward.Value == "Gold" then
			self:AddGold(Reward.Count)
		else
			self:AddResource(Reward.Value, Reward.Count)
		end
	elseif Reward.Type == "Product" then
		local _, ProductId = ProductInfo.GetProductFromNameOnly(Reward.Value)
		if ProductId then
			self:AddProduct(ProductId, Reward.Count)
		else
			warn("No Product with Name: " .. Reward.Value)
		end
	elseif Reward.Type == "Title" then
		if TitleData[Reward.Value] then
			self:AddTitle(Reward.Value)
		else
			warn("No Title with Name: " .. Reward.Value)
		end
	end

	self.QuestRedeemed:Fire(Quest)
end

function PlayerData:GetSetting(Setting: string)
	local Data = self.Profile.Data

	if typeof(Setting) ~= "string" then
		error("No Setting")
	end

	return Data.Settings[Setting :: any]
end

function PlayerData:ChangeSetting(Setting: string, Value: any)
	local Data = self.Profile.Data

	if typeof(Setting) ~= "string" then
		return
	end

	if table.find(SettingData.SettingIndexes, Setting) and typeof(Value) == SettingData.SettingTypes[Setting] then
		Data.Settings[Setting :: any] = Value
		self.SettingChanged:Fire(Setting, Value)
		if self.SettingSignals[Setting] then
			self.SettingSignals[Setting]:Fire(Value)
		end
	end
end

function PlayerData:GetSettingChangedSignal(Setting: string)
	if self.SettingSignals[Setting] then
		return self.SettingSignals[Setting]
	else
		local SettingSignal = self._Trove:Construct(Signal)

		self.SettingSignals[Setting] = SettingSignal
		return SettingSignal
	end
end

function PlayerData:AddTitle(Title: string)
	local Data = self.Profile.Data

	if not Title or Title == "" then
		return
	end
	if not TitleData[Title] then
		return
	end
	if not table.find(Data.Titles, Title) then
		table.insert(Data.Titles, Title)
		self.TitleAdded:Fire(Title)
	end
end

function PlayerData:ChangeTitle(Title: string)
	local Data = self.Profile.Data

	if not Title or Title == "" then
		return
	end

	if not table.find(Data.Titles, Title) then
		return
	end

	Data.EquippedTitle = Title
	self.TitleChanged:Fire(Title)
end

function PlayerData:CalculateInventorySpace()
	local Data = self.Profile.Data
	local InventorySpace = Constants.BASEINVENTORYUNITSPACE

	if self:OwnsGamepass(1435928862) then
		InventorySpace += 50
	elseif self:OwnsGamepass(1435582002) then
		InventorySpace += 100
	end

	local Old = Data.MaxUnitCount

	Data.MaxUnitCount = InventorySpace

	if Old ~= InventorySpace then
		self.InventorySpaceChanged:Fire(InventorySpace)
	end

	return InventorySpace
end

function PlayerData:ChangeLeaderboardPosition(LeaderboardName: string, Position: number)
	local Data = self.Profile.Data

	if typeof(LeaderboardName) ~= "string" or typeof(Position) ~= "number" then
		return
	end

	Data.LeaderboardData[LeaderboardName] = Position
	self.LeaderboardChanged:Fire(LeaderboardName, Position)
end

function PlayerData:AddRoll(Count: number)
	local Data = self.Profile.Data

	Data.RollCount += Count
	self.Rolled:Fire(Data.RollCount)
end

function PlayerData:AddUnitXP(UnitId: string, XP: number)
	local Data = self.Profile.Data

	local UnitData = Data.Units[UnitId]

	if UnitData then
		if UnitData.Level >= UnitMaxLevel then
			return
		end

		UnitData.XP += XP
		while UnitData.XP >= UnitData.NeededXP do
			UnitData.XP -= UnitData.NeededXP
			UnitData.Level += 1
			UnitData.NeededXP = CalculateUnitXP(UnitData.Level)

			if UnitData.Level >= UnitMaxLevel then
				break
			end
		end
		self.UnitChanged:Fire(UnitData)
	end
end

function PlayerData:AddXP(XPInput: number)
	local XP = math.floor(math.max(XPInput, 0))
	local Data = self.Profile.Data

	Data.XP += XP

	while Data.XP >= self.NeededXP do
		Data.Level += 1
		Data.XP -= self.NeededXP
		self.NeededXP = CalculatePlayerXP(Data.Level)
		self.LeveledUp:Fire(Data.Level)
	end

	self.XPChanged:Fire(Data.XP)
end

function PlayerData:AddBoost(Boost: string, Duration: number)
	local Data = self.Profile.Data

	if Data.Boosts[Boost] then
		Data.Boosts[Boost] += Duration
	else
		Data.Boosts[Boost] = DateTime.now().UnixTimestamp + Duration
	end

	self.BoostChanged:Fire(Boost, Data.Boosts[Boost])
end

function PlayerData:HasBoost(Boost: string)
	local Data = self.Profile.Data

	if Data.Boosts[Boost] then
		return true
	else
		return false
	end
end

function PlayerData:Delete()
	self.Destroying:Fire()
	PlayerDatas[self.Player] = nil
	self._Trove:Destroy()

	table.clear(self :: any)
	setmetatable(self :: any, nil)
end

function PlayerData.GetPlayerData(Player: Player)
	return PlayerDatas[Player]
end

function PlayerData.GetPlayerDataAsync(Player: Player)
	if not PlayerDatas[Player] then
		repeat
			task.wait()
		until PlayerDatas[Player] or not Player:IsDescendantOf(Players)
	end

	return PlayerDatas[Player]
end

function PlayerData.GetDatas()
	return PlayerDatas
end

PlayerData.DataAdded = Signal.new()

return PlayerData
