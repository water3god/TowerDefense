--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");

local Packages = ReplicatedStorage.Packages;
local React = require(Packages.React);
local ReactRoblox = require(Packages.ReactRoblox);
local ReactSpring = require(Packages.ReactSpring);
local e = React.createElement;

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local Join = HelperFunctions.joinDicts;

local Gui = ReplicatedStorage.Gui;
local CoreGame = Gui.CoreGame;
local CloseButton = require(CoreGame.CloseButton);
local UIStroke = require(CoreGame.UIStroke);
local Main = require(CoreGame.Main);

local function CreateBasicButton(Props: {OnClick: () -> ()?; native: {[any]: any}?, children: {}?, LabelText: string, Color: Color3})
	return e(Main.Animateables.ImageButton, {
		native = Join({
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Size = UDim2.fromScale(0.4, 0.3);
			Image = "rbxassetid://110715473491790";
			ImageColor3 = Props.Color;
			[React.Event.MouseButton1Click] = Props.OnClick;
		}, Props.native);
		children = Join({
			TextLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5);
					Size = UDim2.fromScale(0.5, 0.5);
					Text = Props.LabelText;
				};
				children = {
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(0.1, 0);
					});
					UIStroke = e(UIStroke.UIStrokeBasic, {
						Stroke = 0.002;
					});
				}
			});
			BackFrame = e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5);
					Size = UDim2.fromScale(0.95, 0.85);
					BackgroundTransparency = 0;
					BackgroundColor3 = Props.Color;
				};
			});
		}, Props.children);
	});
end

type props = {
    Title: string;
	Description: string;
	YesText: string?;
	NoText: string?;
    Enabled: boolean;
	Handler: (End: boolean?) -> ();

    native: {[any]: any}?;
};

local ConfirmGui = Instance.new("ScreenGui");
ConfirmGui.Name = "ConfirmGui";

if RunService:IsRunning() then
	ConfirmGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui;
else
	ConfirmGui.Archivable = true;
	ConfirmGui.Parent = game:GetService("StarterGui");
end

local function CreateConfirm(props: props)
    local IntEnabled, SetIntEnabled = React.useState(true);
	local Enabled, SetEnabled = React.useState(true);
	local InAnim, SetInAnim = React.useState(false);

    local Styles, api = ReactSpring.useSpring(function()
        return {
			Scale = 0.8;
			config = {
				mass = 10, tension = 100, friction = 50
			};
		};
    end)

	React.useEffect(function()
		print(IntEnabled, InAnim);
		if IntEnabled and not InAnim then
			if not IntEnabled then
				SetInAnim(true);
			end
			api.stop();
			print(Enabled);
            api.start({
                Scale = if Enabled then 1 else 0.8;
             }):andThen(function()
                 if not Enabled then
                     SetIntEnabled(false);
                 end
             end)
        end
	end, {Enabled})
    
    React.useEffect(function()
		print(Enabled)
		SetEnabled(props.Enabled);
	end, {props.Enabled});

    local OnYes = React.useCallback(function()
        props.Handler(true);
		SetEnabled(false);
    end, {Enabled})

    local OnNo = React.useCallback(function()
        props.Handler(false);
		SetEnabled(false);
    end, {Enabled})

    local OnClose = React.useCallback(function()
        props.Handler(nil);
		SetEnabled(false);
    end, {Enabled})

	return IntEnabled and ReactRoblox.createPortal(e(Main.ImageLabel, {
		native = Join({
			Position = UDim2.fromScale(0.5, 0.5);
			Size = UDim2.fromScale(0.25, 0.25);
			Image = "rbxassetid://100546338175267";
		}, props.native);
		children = {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1.813;
			});
			TitleLabel = e(Main.TextLabel, {
				native = {
					Text = props.Title;
					Position = UDim2.fromScale(0.5, 0.2);
					Size = UDim2.fromScale(0.5, 0.2);
				};
			});
			DescriptionLabel = e(Main.TextLabel, {
				native = {
					Text = props.Description;
					Position = UDim2.fromScale(0.5, 0.425);
					Size = UDim2.fromScale(0.9, 0.25);
				};
			});
			NoButton = e(CreateBasicButton, {
				OnClick = OnNo;
				LabelText = props.NoText or "No";
				Color = Color3.fromRGB(255, 0, 0);
				native = {
					Position = UDim2.fromScale(0.75, 0.75);	
				};
			});
			YesButton = e(CreateBasicButton, {
				OnClick = OnYes;
				LabelText = props.YesText or "Yes";
				Color = Color3.fromRGB(0, 255, 0);
				native = {
					Position = UDim2.fromScale(0.25, 0.75);
				};
			});
			CloseButton = e(CloseButton, {
				Position = UDim2.fromScale(1, 0);
				Size = UDim2.fromScale(0.2, 0.3);
				OnClick = OnClose;
			});
			UIScale = e("UIScale", {
				Scale = Styles.Scale;
			})
		};
	}), ConfirmGui);
end

return CreateConfirm;