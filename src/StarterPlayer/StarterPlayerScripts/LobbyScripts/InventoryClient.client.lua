--!strict
-- -500, -1500, -4855, -2943, 1050, 5400
-- By Wa1er_God --
-- -15, 67 -147
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PhysicsService = game:GetService("PhysicsService")
local TweenService = game:GetService("TweenService")

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local InventoryService = require(GlobalClient.InventoryService)
local UnitClient = require(GlobalClient.UnitClient)
local ConfirmGui = require(GlobalClient.ConfirmGui)
local UnitShowcase = require(GlobalClient.UnitShowcase)

local Modules = ReplicatedStorage.Modules
local LayoutUtil = require(Modules.LayoutUtil)
local Trove = require(Modules.Trove)
local GuiAnimate = require(Modules.GuiAnimate)
local HelperFunctions = require(Modules.HelperFunctions)

local Remotes = ReplicatedStorage.Remotes
local UnitClientFuncs = Remotes.UnitClient
local PlacementEvent = UnitClientFuncs.Placement

local ModelStorage = ReplicatedStorage.ModelStorage

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local Types = require(Shared.Types)

local CloneGui = ReplicatedStorage.CloneGui

local Player = Players.LocalPlayer
local PlayerGui: typeof(StarterGui) & typeof(CloneGui) = Player.PlayerGui
local Camera = workspace.CurrentCamera

local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui")
local LobbyGui: typeof(PlayerGui.LobbyGui) = PlayerGui:WaitForChild("LobbyGui")
local InventoryGui = LobbyGui.InventoryGui

local OpenButton = InventoryGui.Container.OpenButton

local InventoryFrame = InventoryGui.InventoryFrame
local MainDataFrame = InventoryFrame.MainDataFrame
local CoreCloseButton = InventoryFrame.CloseButton
local CoreSellButton = InventoryFrame.SellButton
local CoreCheckButton = InventoryFrame.CheckButton

local InfoFrame = InventoryFrame.InfoFrame
local EquipButton = InfoFrame.EquipButton
local EquipLabel = EquipButton.TextLabel
local InfoButton = InfoFrame.InfoButton
local SellButton = InfoFrame.SellButton
local XPBar = InfoFrame.Bar
local NameLabel = InfoFrame.NameLabel
local InfoViewport = InfoFrame.ViewportFrame

local NameLabelGradient = NameLabel.UIStroke.UIGradient
local NameTextGradient = NameLabel.UIGradient
local RarityLabel = InfoFrame.RarityLabel
local RarityLabelGradient = RarityLabel.UIStroke.UIGradient
local RarityTextGradient = RarityLabel.UIGradient

local StatsFrame = InventoryGui.StatsFrame

local DataFrames: { [string]: Frame } = {
	Units = script:WaitForChild("UnitFrame"),
	Gamepasses = script:WaitForChild("GamepassFrame"),
}

local CollisionRadius = ModelStorage.Extra.CollisionRadius

local CollisionReference = script:WaitForChild("CollisionRadius")
local RangeDisplayReference = script:WaitForChild("RangeDisplayValue")

local RangeDisplay = script:WaitForChild("RangeDisplay")
local XSellExample = script:WaitForChild("XSellSample")

local OpenName: string = "Units"
local OpenFrameName: string? = nil
local FrameConnections: { any } = {}

local UniqueIds = {}
local SellConnections = {}
local Selling = false

local OpenProcess: string? = nil

local CurrentData: { [string]: any } = {}
local FrameData: { [string]: any } = {}

local function SellUnits(Units: { string })
	for _, Unit in ipairs(Units) do
		if FrameData[Unit] then
			FrameData[Unit].Frame:Destroy()
		end
	end
	InventoryService.SellUnits(Units)
end

local function OpenFrame(FrameName: string)
	for _, Frame in ipairs(MainDataFrame:GetChildren()) do
		if Frame:IsA("Frame") then
			Frame.Parent = nil
		end
	end

	for UniqueId, ItemData in pairs(CurrentData) do
		local FrameData = FrameData[UniqueId]

		if not FrameData then
			continue
		end

		if FrameData.Type == FrameName then
			FrameData.Frame.Parent = MainDataFrame
		end
	end
end

local function RemoveOpenNameFrame()
	if OpenFrameName then
		local Frame = FrameData[OpenFrameName].Frame
		if Frame then
			Frame.Container.BackgroundImage.Image = "rbxassetid://122297615155487"
		end
		OpenFrameName = nil
	end
end

local function SubFrameClick(Data: any, Frame: any)
	local UnitData = UnitInfo.UnitInfo[Data.Unit]
	local RarityData = UnitInfo.RarityInfo[UnitData.Rarity]
	local LevelData = UnitInfo.LevelInfo[HelperFunctions.GetSmallestNumber(UnitInfo.LevelInfo, Data.Level)]

	HelperFunctions.DisconnectAll(FrameConnections)

	if OpenFrameName then
		local Frame = FrameData[OpenFrameName].Frame
		Frame.Container.BackgroundImage.Image = "rbxassetid://122297615155487"
	end

	OpenFrameName = Data.UniqueId

	local function Update()
		NameLabel.Text = Data.Unit
		RarityLabel.Text = UnitData.Rarity
		NameLabelGradient.Color = RarityData.StrokeColor
		RarityLabelGradient.Color = RarityData.StrokeColor
		NameTextGradient.Color = RarityData.UnitColor
		RarityTextGradient.Color = RarityData.UnitColor

		XPBar.TimeLabel.Text = string.format("%u/%u", Data.XP, Data.NeededXP)
		local Ratio = math.clamp(Data.XP / Data.NeededXP, 0, 1)
		XPBar.BarOverlay.InnerBar.Size = UDim2.fromScale(Ratio, 0.9)
	end

	Frame.Container.BackgroundImage.Image = "rbxassetid://82394198587561"

	Update()

	local Connection = InventoryService.UnitChanged:Connect(function(SentUnitData)
		if SentUnitData.UniqueId == Data.UniqueId then
			Update()
		end
	end)

	UnitShowcase.AnimateViewport(InfoViewport, Data.Unit)

	local Equipped = if InventoryService.UnitIsEquipped(Data.UniqueId) then true else false

	local function EquipButtonHandler()
		if OpenProcess then
			return
		end
		if Equipped then
			InventoryService.EquipUnit(Data.UniqueId, false)
		else
			InventoryService.EquipUnit(Data.UniqueId, true)
		end
	end

	local function SellButtonHandler(End: boolean?)
		if End == true then
			SellUnits({ Data.UniqueId })
		end
		OpenProcess = nil
	end

	local ConnectionB = EquipButton.MouseButton1Click:Connect(EquipButtonHandler)

	local ConnectionC = SellButton.MouseButton1Click:Connect(function()
		if OpenProcess then
			return
		end
		RemoveOpenNameFrame()
		local Frame, UniqueId = ConfirmGui.Create({
			Title = "Sell Unit",
			Description = "Are you sure you want to sell this unit?",
			EndFunc = SellButtonHandler,
			OnSide = false,
		})
		OpenProcess = UniqueId
	end)

	local function HandleEquippedLabel(Equipped: boolean)
		if Equipped then
			EquipLabel.Text = "Unequip"
		else
			EquipLabel.Text = "Equip"
		end
	end

	HandleEquippedLabel(Equipped)

	local ConnectionD = InventoryService.UnitEquipChanged:Connect(function(InputData: any)
		if Data.UniqueId == InputData.UniqueId then
			Equipped = InputData.Equip
			HandleEquippedLabel(InputData.Equip)
		end
	end)

	local ConnectionE = InfoButton.MouseButton1Click:Connect(function()
		if OpenProcess then
			return
		end
		StatsFrame.CostLabel.Text =
			string.format('Placement Cost: <font color="#FF7800">%u</font>', UnitData.PlacementCost)
		StatsFrame.Visible = true
	end)

	table.insert(FrameConnections, Connection)
	table.insert(FrameConnections, ConnectionB)
	table.insert(FrameConnections, ConnectionC)
	table.insert(FrameConnections, ConnectionD)
	table.insert(FrameConnections, ConnectionE)

	InfoFrame.Visible = true
end

local function CreateData(Type: string, Data: any)
	local Frame: any = nil

	if Type == "Units" then
		local NewFrame = InventoryService.ApplyDataUnitFrame(Data)

		HelperFunctions.MouseButton1Click(NewFrame, function()
			if Selling then
				return
			end
			if OpenFrameName == Data.UniqueId then
				return
			end

			SubFrameClick(Data, NewFrame)
		end)

		Frame = NewFrame
	elseif Type == "Gamepasses" then
	end

	FrameData[Data.UniqueId] = {
		Frame = Frame,
		Type = Type,
	}

	if Type == OpenName then
		Frame.Parent = MainDataFrame
	end
end

local function DestroyData(UniqueId: string)
	if CurrentData[UniqueId] then
		CurrentData[UniqueId] = nil
	end

	if OpenFrameName == UniqueId then
		HelperFunctions.DisconnectAll(FrameConnections)
		OpenFrameName = nil
	end

	if FrameData[UniqueId] then
		FrameData[UniqueId].Frame:Destroy()
		FrameData[UniqueId] = nil
	end
end

if not InventoryService.IsSynced then
	InventoryService.Synced:Wait()
end

local Inventory = InventoryService:GetInventory()

UnitShowcase.ConnectViewport(InfoViewport)

for Type, Data in pairs(Inventory) do
	for UniqueId, Item in pairs(Data) do
		CurrentData[UniqueId] = {}
		for i, v in pairs(Item) do
			CurrentData[UniqueId][i] = v
		end
		CreateData(Type, Item)
	end
end

InventoryService.UnitAdded:Connect(function(UnitData: any)
	CurrentData[UnitData.UniqueId] = {}
	for i, v in pairs(UnitData) do
		CurrentData[UnitData.UniqueId][i] = v
	end
	CreateData("Units", UnitData)
end)

InventoryService.UnitRemoved:Connect(function(UniqueId: string)
	DestroyData(UniqueId)
end)

OpenButton.MouseButton1Click:Connect(function()
	InventoryFrame:SetAttribute("AnimateVisible", not InventoryFrame:GetAttribute("AnimateVisible"))
end)

CoreCloseButton.MouseButton1Click:Connect(function()
	InventoryFrame:SetAttribute("AnimateVisible", false)
end)

local function StopSelling()
	HelperFunctions.DisconnectAll(SellConnections)
	for _, UniqueId in ipairs(UniqueIds) do
		local FrameData = FrameData[UniqueId]

		if FrameData then
			local XSellFrame = FrameData.Frame:FindFirstChild("XSellSample")

			if XSellFrame then
				XSellFrame:Destroy()
			end
		end
	end
	table.clear(UniqueIds)
	Selling = false
	CoreCheckButton.Visible = false
end

local function OnSell(End: boolean?)
	if End then
		SellUnits(UniqueIds)
		StopSelling()
	elseif End == false then
		StopSelling()
	end
	OpenProcess = nil
end

CoreSellButton.MouseButton1Click:Connect(function()
	if OpenProcess then
		return
	end
	RemoveOpenNameFrame()
	if not Selling then
		Selling = true
		HelperFunctions.DisconnectAll(FrameConnections)
		InfoFrame.Visible = false
		for UniqueId, Info in pairs(FrameData) do
			local Connection = Info.Frame.InputBegan:Connect(function(Input: InputObject)
				if HelperFunctions.IsClick(Input) then
					local Index = table.find(UniqueIds, UniqueId)
					if Index then
						table.remove(UniqueIds, Index)
						local XSellFrame = Info.Frame:FindFirstChild("XSellSample")
						if XSellFrame then
							XSellFrame:Destroy()
						end
					else
						table.insert(UniqueIds, UniqueId)
						local XSellFrame = XSellExample:Clone()
						XSellFrame.Parent = Info.Frame
					end
				end
			end)

			table.insert(SellConnections, Connection)
		end
		local Connection = CoreCheckButton.MouseButton1Click:Connect(function()
			if #UniqueIds == 0 then
				return
			end
			local Frame, UniqueId = ConfirmGui.Create({
				Title = "Selling Units",
				Description = string.format("Are you sure that you want to sell %u Units?", #UniqueIds),
				EndFunc = OnSell,
				OnSide = false,
			})
			OpenProcess = UniqueId
		end)
		table.insert(SellConnections, Connection)
		CoreCheckButton.Visible = true
	else
		StopSelling()
	end
end)

StatsFrame.CloseButton.MouseButton1Click:Connect(function()
	StatsFrame.Visible = false
end)

InventoryService.GetItemRequest:Connect(function(Type: string?) end)

InventoryFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	local Visible = InventoryFrame.Visible
	if not Visible then
		if Selling then
			StopSelling()
		end
		if OpenProcess then
			ConfirmGui.Close(OpenProcess, false)
			OpenProcess = nil
		end

		if OpenFrameName then
			local Frame = FrameData[OpenFrameName].Frame
			Frame.Container.BackgroundImage.Image = "rbxassetid://122297615155487"
		end

		if StatsFrame then
			StatsFrame.Visible = false
		end

		HelperFunctions.DisconnectAll(FrameConnections)
		if not InventoryFrame.Visible then
			InfoFrame.Visible = false
			OpenFrameName = nil
		end
	end
end)

Player.CharacterRemoving:Connect(function()
	InventoryFrame:SetAttribute("AnimateVisible", false)
	HelperFunctions.DisconnectAll(FrameConnections)
	InfoFrame.Visible = false
end)

local GameGui = GlobalGui.GameGui
local Main = GameGui.BottomFrame

local LevelData: { [number]: number } = {
	[1] = 3,
	[10] = 4,
	[20] = 5,
}

local Frames = {
	[1] = Main.Frame1,
	[2] = Main.Frame2,
	[3] = Main.Frame3,
	[4] = Main.Frame4,
	[5] = Main.Frame5,
}

local EquippedConnections: { [number]: any } = {}

local function GetMaxUnits(Level: number)
	local CurrentIndex: number = 1
	local MaxUnits: number = LevelData[CurrentIndex]

	for LowestLevel, UnitNum in pairs(LevelData) do
		if LowestLevel <= Level and LowestLevel > CurrentIndex then
			CurrentIndex = LowestLevel
			MaxUnits = UnitNum
		end
	end

	return MaxUnits
end

local Keys = {
	Enum.KeyCode.One,
	Enum.KeyCode.Two,
	Enum.KeyCode.Three,
	Enum.KeyCode.Four,
	Enum.KeyCode.Five,
}

local function OnEquipChanged(UnitData: any, Index: number, Equip: boolean)
	local Frame = Frames[Index]
	if EquippedConnections[Index] then
		HelperFunctions.DisconnectAll(EquippedConnections[Index])
	else
		EquippedConnections[Index] = {}
	end

	if Equip then
		local Connection = Frame.InputBegan:Connect(function(Input: InputObject)
			if HelperFunctions.IsClick(Input) then
				if OpenFrameName then
					if UnitData.UniqueId == OpenFrameName then
						InventoryFrame:SetAttribute("AnimateVisible", false)
						return
					end
				end
				local Frame = FrameData[UnitData.UniqueId].Frame
				SubFrameClick(UnitData, Frame)
				InventoryFrame:SetAttribute("AnimateVisible", true)
			end
		end)

		table.insert(EquippedConnections[Index], Connection)
	else
		local Connection = Frame.InputBegan:Connect(function(Input: InputObject)
			if HelperFunctions.IsClick(Input) then
				InventoryFrame:SetAttribute("AnimateVisible", true)
			end
		end)

		table.insert(EquippedConnections[Index], Connection)
	end
end

for Index = 1, GetMaxUnits(InventoryService.Level), 1 do
	local UniqueId = InventoryService.EquippedUnits[Index]

	if UniqueId then
		local UnitData = Inventory.Units[UniqueId]

		OnEquipChanged(UnitData, Index, true)
	else
		OnEquipChanged(nil, Index, false)
	end
end

InventoryService.UnitEquipChanged:Connect(function(Data: any)
	OnEquipChanged(Inventory.Units[Data.UniqueId], Data.Index, Data.Equip)
end)
