--!strict

-- By Wa1er_God --

local DefaultFont = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local ReactLua = ReplicatedStorage.Modules.ReactLua;
local React = require(ReactLua.React);
local e = React.createElement;

local Gui = ReplicatedStorage.Gui;
local InventoryGUI = Gui.Inventory;
local UnitFrame = require(InventoryGUI.UnitFrame);
local InfoFrame = require(InventoryGUI.InfoFrame);

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local InventoryService = require(GlobalClient.InventoryService);

local Modules = ReplicatedStorage.Modules;
local JoinDicts = require(Modules.JoinDicts);

local CoreGame = Gui.CoreGame;
local CloseButton = require(CoreGame.CloseButton);
local DefaultScrolling = require(CoreGame.DefaultScrolling);

local Shared = ReplicatedStorage.Shared;
local UnitInfo = require(Shared.UnitInfo);
local RarityInfo = require(Shared.RarityInfo);
local Types = require(Shared.Types);

export type Properties = {
	Inventory: {
		Units: {[string]: Types.VisualUnitData};
	};
};

local function Sell(UniqueIds: {string})
	
end

local function CreateBaseButton(Properties: {
		Position: UDim2;
		Text: string;
	})
	return React.createElement("ImageButton", {
		BackgroundTransparency = 1;
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = Properties.Position;
		Size = UDim2.fromScale(0.175, 0.14);
		Image = "rbxassetid://90225038866735";
		[React.Tag] = "GuiAnimateBasic";
	}, {
		TextLabel = React.createElement("TextLabel", {
			Text = Properties.Text;
			TextScaled = true;
			FontFace = DefaultFont;
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Size = UDim2.fromScale(0.9, 0.6);
			TextColor3 = Color3.fromRGB(255, 255, 255);
		});
	});
end

local function CreateInventory(Properties: Properties)
	local Units, SetUnits = React.useState({} :: {[string]: any});
	local SellingUnits, SetSellingUnits = React.useState({} :: {string});
	local HoveredId, SetHovered = React.useState(nil :: string?);
	
	local InSell, ToggleSell = React.useState(false);
	
	local OpenFrame: string = "Unit";
	local CurrentUnit: Types.VisualUnitData? = nil;
	local Rarity: string? = nil;
	local RarityData: typeof(RarityInfo["Common" :: RarityInfo.Rarity])? =  nil;
	
	local HandleUnit = React.useCallback(function(Data: Types.VisualUnitData)
		local UnitData = UnitInfo.UnitInfo[Data.Unit];
		local RarityData = RarityInfo[UnitData.Rarity];

		local function OnClick()
			if HoveredId ~= Data.UniqueId then
				OpenFrame = "Unit";
				CurrentUnit = Data;
				Rarity = UnitData.Rarity;
				RarityData = RarityData;
				SetHovered(Data.UniqueId);
			end
		end
		
		local Value: any = e(UnitFrame, {
			UnitName = Data.Unit;
			Level = Data.Level;
			Cost = UnitData.PlacementCost;

			Color = RarityData.Color;
			StrokeColor = RarityData.StrokeColor;
			BackgroundColor = RarityData.BackgroundColor;

			OnClick = {OnClick};

			Hovered = if HoveredId and HoveredId == Data.UniqueId then true else false;
		}, {
			BeingSoldFrame = e("ImageLabel", {
				Visible = table.find(SellingUnits, Data.UniqueId);
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.5);
				Size = UDim2.fromScale(0.9, 0.9);
			})
		});
		local Merged = JoinDicts(Units, {[Data.Unit] = Value});
		SetUnits(Merged);
	end, {})
	
	local OnEquip = React.useCallback(function()
		if HoveredId then
			if InventoryService.UnitIsEquipped(HoveredId) then
				InventoryService.EquipUnit(HoveredId, false);
			else
				InventoryService.EquipUnit(HoveredId, true)
			end
		end
	end, {})
	
	local IndividualSell = React.useCallback(function()
		
	end, {});
	
	local StartSelling = React.useCallback(function()
		SetHovered(nil :: any);
		ToggleSell(not InSell);
		SetSellingUnits({});
	end, {});
	
	local BulkSell = React.useCallback(function()
		if InSell then
			
		end
	end, {})
	
	React.useEffect(function()
		for _, Data in pairs(Properties.Inventory.Units) do
			HandleUnit(Data);
		end
		InventoryService.UnitAdded:Connect(function(Unit: Types.VisualUnitData)
			HandleUnit(Unit);
		end)
	end, {});
	
	local MainFrame = React.useRef(nil) :: any;
	
	return e("ImageLabel", {
		ref = MainFrame;
		BackgroundTransparency = 1;
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = UDim2.fromScale(0.5, 0.5);
		Size = UDim2.fromScale(0.55, 0.5);
		Image = "rbxassetid://103903141717286";
		[React.Tag] = "AnimateFrameVisibility";
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 2;	
		});
		MainDataFrame = e(DefaultScrolling, {
			BarSize = 0.1;
			Position = UDim2.fromScale(0.385, 0.6);
			Size = UDim2.fromScale(0.675, 0.65);
			AutomaticCanvasSize = Enum.AutomaticSize.Y;
			ScrollBarImageColor3 = Color3.fromRGB(68, 11, 93);
		}, {
			UIGridLayout = e("UIGridLayout", {
				CellPadding = UDim2.fromScale(0, 0);
				CellSize = UDim2.fromScale(0.2, 0.41);
				FillDirection = Enum.FillDirection.Horizontal;
				SortOrder = Enum.SortOrder.LayoutOrder;
				StartCorner = Enum.StartCorner.TopLeft;
				HorizontalAlignment = Enum.HorizontalAlignment.Left;
				VerticalAlignment = Enum.VerticalAlignment.Top;
			});
			UIPadding = e("UIPadding", {
				PaddingRight = Vector2.new(0.03, 0);
			});
		}, Units);
		CheckButton = e("ImageButton", {
			BackgroundTransparency = 1;
			Visible = if InSell then true else false;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.64, 0.175);
			Size = UDim2.fromScale(0.05, 0.1);
			Image = "rbxassetid://78742556758797";
			ImageColor3 = Color3.fromRGB(34, 255, 0);
			[React.Tag] = "GuiAnimateBasic" :: any;
			[React.Event.MouseButton1Click] = BulkSell,
		});
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0);
			Size = UDim2.fromScale(0.1, 0.2);
			OnClick = function()
				MainFrame.current:SetAttribute("AnimateVisible", false);
			end,
		});
		SellButton = e("ImageButton", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.7, 0.175);
			Size = UDim2.fromScale(0.05, 0.1);
			Image = "rbxassetid://135893657768702";
			ImageColor3 = Color3.fromRGB(255, 0, 4);
			[React.Tag] = "GuiAnimateBasic" :: any;
			[React.Event.MouseButton1Click] = StartSelling,
		});
		
		InfoFrame = e(InfoFrame, {
			Visible = if CurrentUnit then true else false;
			
			Type = OpenFrame;
			Rarity = Rarity;
			RarityData = RarityData;
		});
		UnitsButton = e(CreateBaseButton, {
			Position = UDim2.fromScale(0.14, 0.175);
			Text = "Units";
		});
		GamepassesButton = e(CreateBaseButton, {
			Position = UDim2.fromScale(0.33, 0.175);
			Text = "Gamepasses";
		});
		Title = e("ImageLabel", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.15, -0.03);
			Size = UDim2.fromScale(0.5, 0.5);
			Image = "rbxassetid://82588529589997";
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 4.625;	
			});
			TextLabel = e("TextLabel", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.55);
				Size = UDim2.fromScale(0.7, 0.5);
				TextScaled = true;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				Text = "INVENTORY";
				FontFace = DefaultFont;
			}, {
				UIGradient = e("UIGradient", {
					Color = ColorSequence.new(
						{
							ColorSequenceKeypoint.new(0, Color3.new(0.768627, 0.380392, 1)),
							ColorSequenceKeypoint.new(0.623, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
						}
					);
					Rotation = -90;
				});
			});
		});
	})
end

return CreateInventory;
