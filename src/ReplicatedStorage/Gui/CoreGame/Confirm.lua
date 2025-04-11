--!strict

-- By Wa1er_God --

local MinSize = 0.8;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

local Packages = ReplicatedStorage.Packages;
local React = require(Packages.React);
local ReactRoblox = require(Packages.ReactRoblox);
local ReactSpring = require(Packages.ReactSpring);
local e = React.createElement;

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local Lerps = require(Modules.Lerps);
local GenerateId = require(Modules.GenerateId);
local Join = HelperFunctions.joinDicts;

local Gui = ReplicatedStorage.Gui;
local CoreGame = Gui.CoreGame;
local CloseButton = require(CoreGame.CloseButton);
local UIStroke = require(CoreGame.UIStroke);
local Main = require(CoreGame.Main);
local Hooks = require(CoreGame.Hooks);

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

export type Properties = {
	Title: string;
	Description: string;
	YesText: string?;
	NoText: string?;
	Handler: (End: boolean?) -> ();
};

local Component = React.Component:extend("Confirm");

local ConfirmGui = Instance.new("ScreenGui");
ConfirmGui.Name = "ConfirmGui";

function Component:init()
	self.Scale, self.SetScale = ReactSpring.useSpring(function()
		return {Scale = 1};
	end)
	self.Visible, self.SetVisiblity = React.createBinding(false);

	self.Start = function()
		self.SetScale(MinSize);
		
	end

	self.End = function()
		
	end

	self.Handler = function(Input: boolean?)
		self.props.Handler(Input);
		--self:EndAnimation();
	end

	self.OnNo = function()
		self.Handler(false);
	end;

	self.OnYes = function()
		self.Handler(true);
	end

	self.OnClose = function()
		self.Handler(nil);
	end
end

function Component:EndAnimation()
	React.useEffect(self.End, {});
end

function Component:render()
	return ReactRoblox.createPortal({
		[GenerateId.GenerateId()] = {
			e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5);
					Size = UDim2.fromScale(0.25, 0.25);
					Image = "rbxassetid://100546338175267";
				};
				children = {
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 1.813;
					});
					TitleLabel = e(Main.TextLabel, {
						native = {
							Text = self.props.Title;
							Position = UDim2.fromScale(0.5, 0.2);
							Size = UDim2.fromScale(0.5, 0.2);
						};
					});
					DescriptionLabel = e(Main.TextLabel, {
						native = {
							Text = self.props.Description;
							Position = UDim2.fromScale(0.5, 0.425);
							Size = UDim2.fromScale(0.9, 0.25);
						};
					});
					NoButton = e(CreateBasicButton, {
						OnClick = self.OnNo;
						LabelText = self.props.NoText or "No";
						Color = Color3.fromRGB(255, 0, 0);
						native = {
							Position = UDim2.fromScale(0.75, 0.75);	
						};
					});
					YesButton = e(CreateBasicButton, {
						OnClick = self.OnYes;
						LabelText = self.props.YesText or "Yes";
						Color = Color3.fromRGB(0, 255, 0);
						native = {
							Position = UDim2.fromScale(0.25, 0.75);
						};
					});
					CloseButton = e(CloseButton, {
						Position = UDim2.fromScale(1, 0);
						Size = UDim2.fromScale(0.2, 0.3);
						OnClick = self.OnClose;
					});
					UIScale = e("UIScale", {
						Scale = self.Scale;
					})
				};
			});
	}}, ConfirmGui);
end

--[[function Component:componentDidMount()
	React.useEffect(self.Start, {});
end]]

return Component;