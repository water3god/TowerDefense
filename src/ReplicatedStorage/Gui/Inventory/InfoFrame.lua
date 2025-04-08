--!strict

-- By Wa1er_God --

local DefaultFont = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);

local ReactLua = Modules.ReactLua;
local React = require(ReactLua.React);
local e = React.createElement;

local Gui = ReplicatedStorage.Gui;
local CoreGame = Gui.CoreGame;
local UIStroke = require(CoreGame.UIStroke);

local Shared = ReplicatedStorage.Shared;
local UnitInfo = require(Shared.UnitInfo);
local RarityInfo = require(Shared.RarityInfo);
local Types = require(Shared.Types);

local UnitModels = ReplicatedStorage.ModelStorage.Units;
local UnitAnimations = ReplicatedStorage.Animations.Units;
export type InfoType = "Unit" | "Gamepass";

export type UnitData = {
	UnitData: Types.VisualUnitData;
	UnitInfo: UnitInfo.UnitInfo;
}

export type Data = UnitData | {
	
};

export type Properties = {
	Visible: boolean;
	
	Type: InfoType | string;
	Name: string?;
	Rarity: string?;
	
	Data: Data?;
	RarityInfo: RarityInfo.RarityInfo?;
	
	OnEquipClick: () -> ()?;
	OnSellClick: () -> ()?;
};

local function InitViewport(Viewport: ViewportFrame, Data: UnitData)
	local UnitName = Data.UnitData.Unit;
	local Model = UnitModels:FindFirstChild(UnitName):Clone();
	local Humanoid = Model:FindFirstChildWhichIsA("Humanoid");
	local Animator = Humanoid:FindFirstChildWhichIsA("Animator");
	local Animation = UnitAnimations:FindFirstChild(UnitName):FindFirstChild("Idle");
	
	HelperFunctions.DisableHumanoid(Humanoid);
	local Track = Animator:LoadAnimation(Animation);
	Track:Play();
	
	return function()
		Model:Destroy();
	end
end

local function CreateInfoFrame(Properties: Properties)
	local ViewportReference = React.useRef(nil :: ViewportFrame?);
	local IsUnit = if Properties.Type == "Unit" then true else false;
	local HasValue = if Properties.Data then true else false;
	local UnitData: UnitData = Properties.Data :: UnitData;
	
	React.useEffect(function()
		if ViewportReference.current then
			if Properties.Data and IsUnit then
				return InitViewport(ViewportReference.current, Properties.Data :: UnitData);
			end
		else
			warn("No Refference");
		end
		return function()

		end
	end, {Properties.Name})
	
	return e("ImageLabel", {
		BackgroundTransparency = 1;
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = UDim2.fromScale(0.85, 0.525);
		Size = UDim2.fromScale(0.2, 0.85);
		Image = "rbxassetid://75971006528952";
		Visible = Properties.Visible;
	}, {
		ViewportFrame = e("ViewportFrame", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.45);
			Size = UDim2.fromScale(0.9, 0.425);
			ref = ViewportReference;
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1;	
			});
			Camera = e("Camera", {
				CFrame = CFrame.new(0, 0, 0);
			})
		});
		EquipButton = e("ImageButton", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.92);
			Size = UDim2.fromScale(0.9, 0.125);
			Image = "rbxassetid://72606508098140";
			[React.Tag] = "GuiAnimateBasic" :: any;
			[React.Event.MouseButton1Click] = Properties.OnEquipClick;
		}, {
			TextLabel = e("TextLabel", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.5);
				Size = UDim2.fromScale(0.6, 0.6);
				TextScaled = true;
				Text = "Equip";
				TextColor3 = Color3.new(1, 1, 1);
				RichText = true;
				FontFace = DefaultFont;
			});
		});
		InfoButton = e("ImageButton", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.8, 0.66);
			Size = UDim2.fromScale(0.21, 0.12);
			Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
			[React.Tag] = "GuiAnimateBasic";
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1;	
			});
		});
		SellButton = e("ImageButton", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.79);
			Size = UDim2.fromScale(0.9, 0.125);
			Image = "rbxassetid://135833754402129";
			ImageColor3 = Color3.fromRGB(255, 43, 47);
			[React.Tag] = "GuiAnimateBasic" :: any;
			[React.Event.MouseButton1Click] = Properties.OnSellClick;
		}, {
			TextLabel = e("TextLabel", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.5);
				Size = UDim2.fromScale(0.6, 0.6);
				TextScaled = true;
				Text = "Sell";
				TextColor3 = Color3.new(1, 1, 1);
				RichText = true;
				FontFace = DefaultFont;
			});
		});
		Bar = e("ImageLabel", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.26);
			Size = UDim2.fromScale(0.7, 0.055);
			Image = "rbxassetid://125478192482439";
			Visible = IsUnit;
		}, {
			BarOverlay = e("Frame", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.5);
				Size = UDim2.fromScale(0.99, 0.9);
			}, {
				InnerBar = e("Frame", {
					BackgroundTransparency = 0;
					BackgroundColor3 = Color3.fromRGB(255, 0, 201);
					AnchorPoint = Vector2.new(0, 0);
					Position = UDim2.fromScale(0, 0.05);
					Size = if IsUnit and HasValue then UDim2.fromScale(UnitData.UnitData.XP / UnitData.UnitData.NeededXP, 0.9) else UDim2.fromScale(0, 0);
				}, {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(1, 0);
					})
				});
			});
			XPLabel = e("TextLabel", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.5);
				Size = UDim2.fromScale(0.99, 0.9);
				TextScaled = true;
				Text = if IsUnit and HasValue then string.format("%u/%u", UnitData.UnitData.XP, UnitData.UnitData.NeededXP) else "";
				RichText = true;
				FontFace = DefaultFont;
			});
		});
		NameLabel = e("TextLabel", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.1);
			Size = UDim2.fromScale(0.8, 0.12);
			TextScaled = true;
			Text = Properties.Name;
			RichText = true;
			FontFace = DefaultFont;
			TextXAlignment = Enum.TextXAlignment.Left;
		}, {
			UIStroke = e(UIStroke.UIStroke, {
				Stroke = 0.002;
				GradColor = Properties.RarityInfo and Properties.RarityInfo.StrokeColor;
			});
			UIGradient = e("UIGradient", {
				Color = Properties.RarityInfo and Properties.RarityInfo.Color;
			});	
		});
		RarityLabel = e("TextLabel", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.19);
			Size = UDim2.fromScale(0.8, 0.05);
			TextScaled = true;
			Text = Properties.Rarity;
			RichText = true;
			FontFace = DefaultFont;
			TextXAlignment = Enum.TextXAlignment.Left;
		}, {
			UIStroke = e(UIStroke.UIStroke, {
				Stroke = 0.002;
				GradColor = Properties.RarityInfo and Properties.RarityInfo.StrokeColor;
			});
			UIGradient = e("UIGradient", {
				Color = Properties.RarityInfo and Properties.RarityInfo.Color;
			});
		});
	});
end

return CreateInfoFrame;