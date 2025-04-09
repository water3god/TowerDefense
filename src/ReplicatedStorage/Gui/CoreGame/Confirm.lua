--!strict

-- By Wa1er_God --

local DefaultFont = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local Join = require(Modules.JoinDicts);
local Lerps = require(Modules.Lerps);

local ReactLua = Modules.ReactLua;
local React = require(ReactLua.React);
local ReactRoblox = require(ReactLua.ReactRoblox);
local e = React.createElement;

local Gui = ReplicatedStorage.Gui;
local CoreGame = Gui.CoreGame;
local CloseButton = require(CoreGame.CloseButton);
local UIStroke = require(CoreGame.UIStroke);

export type Properties = {
	Title: string;
	Description: string;
	YesText: string?;
	NoText: string?;
	Handler: (End: boolean?) -> ();
};

local PlayerGui = Players.LocalPlayer.PlayerGui;

local Gui = Instance.new("ScreenGui");
Gui.Name = "ConfirmGui";
Gui.ResetOnSpawn = false;
Gui.Parent = PlayerGui;

local Root = ReactRoblox.createRoot(Gui);

local function CreateBasicButton(Props: {OnClick: () -> ()?; native: {[any]: any}?, children: {}?, LabelText: string, Color: Color3})
	return e("ImageButton", {
		Join({
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Size = UDim2.fromScale(0.4, 0.3);
			Image = "rbxassetid://110715473491790";
			ImageColor3 = Props.Color;
			[React.Event.MouseButton1Click] = Props.OnClick;
		}, Props.native)
	}, Join({
		TextLabel = e("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Size = UDim2.fromScale(0.5, 0.5);
			Text = Props.LabelText;
			TextColor3 = Color3.new(1, 1, 1);
			TextScaled = true;
			FontFace = DefaultFont;
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.1, 0);
			});
			UIStroke = e(UIStroke.UIStrokeBasic, {
				Stroke = 0.004;
			});
		});
		BackFrame = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Size = UDim2.fromScale(0.95, 0.85);
			BackgroundColor3 = Props.Color;
		});
	}, Props.children));
end

local function CreateConfirm(Properties: Properties)

	local OnNo = React.useCallback(function()
		Properties.Handler(false);
	end, {});

	local OnYes = React.useCallback(function()
		Properties.Handler(true);
	end, {});

	local OnClose = React.useCallback(function()
		Properties.Handler(nil);
	end, {});

	--local Scale, SetScale = UDim2.fromScale()

	React.useEffect(function()

	end, {});

	local ConfirmFrame = e("ImageLabel", {
		BackgroundTransparency = 1;
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = UDim2.fromScale(0.5, 0.5);
		Size = UDim2.fromScale(0.25, 0.25);
		Image = "rbxassetid://100546338175267";
	}, {
		Titlelabel = e("TextLabel", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Text = Properties.Title;
			TextScaled = true;
			FontFace = DefaultFont;
			TextColor3 = Color3.new(1, 1, 1);
			Position = UDim2.fromScale(0.5, 0.2);
			Size = UDim2.fromScale(0.5, 0.2);

		});
		DescriptionLabel = e("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5);
			Text = Properties.Description;
			TextScaled = true;
			FontFace = DefaultFont;
			TextColor3 = Color3.new(1, 1, 1);
			Position = UDim2.fromScale(0.5, 0.425);
			Size = UDim2.fromScale(0.9, 0.25);
		});
		NoButton = e(CreateBasicButton, {
			OnClick = OnNo;
			LabelText = Properties.NoText or "No";
			Color = Color3.fromRGB(255, 0, 0);
			native = {
				Position = UDim2.fromScale(0.75, 0.75);	
			};
		});
		YesButton = e(CreateBasicButton, {
			OnClick = OnYes;
			LabelText = Properties.YesText or "Yes";
			Color = Color3.fromRGB(0, 255, 0);
			native = {
				Position = UDim2.fromScale(0.75, 0.75);
			};
		});
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0);
			Size = UDim2.fromScale(0.2, 0.3);
			OnClick = OnClose;
		});
		UIScale = e("UIScale", {
			Scale = 1;
		})
	});

	Root:render(ConfirmFrame);
end

return CreateConfirm;