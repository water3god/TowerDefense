--!strict

-- By Wa1er_God --

local DefaultBackgroundImage = "rbxassetid://122297615155487";
local HighlightedBackgroundImage = "rbxassetid://82394198587561";

local DefaultFont = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local ReactLua = ReplicatedStorage.Modules.ReactLua;
local React = require(ReactLua.React);
local e = React.createElement;

local UIStroke = require(ReplicatedStorage.Gui.CoreGame.UIStroke);

export type Properties = {
	Position: UDim2?;
	Size: UDim2?;
	
	Name: string;
	LeftText: string;
	RightText: string;
	UnitImage: string?;
	Hovered: boolean?;
	
	BackgroundColor: ColorSequence?;
	NameColor: ColorSequence?;
	NameStrokeColor: ColorSequence?;
	LeftColor: ColorSequence?;
	LeftStrokeColor: ColorSequence?;
	RightColor: ColorSequence?;
	RightStrokeColor: ColorSequence?;
	
	OnClick: {(...any) -> (...any)}?;
};

local function CreateBaseFrame(Properties: Properties)
	return e("Frame", {
		BackgroundTransparency = 1;
		AnchorPoint = Vector2.new(0.5, 0.5);
		Position = Properties.Position or UDim2.fromScale(0.5, 0.5);
		Size = Properties.Size or UDim2.fromScale(1, 1);
	}, {
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1;
		});
		Container = e("Frame", {
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0.5, 0.5);
			Position = UDim2.fromScale(0.5, 0.5);
			Size = UDim2.fromScale(1, 1);
			[React.Tag] = "GuiAnimateBasic";
		}, {
			InvisButton = e("TextButton", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.5);
				Size = UDim2.fromScale(1, 1);
				Text = "";
				ZIndex = -1;
				[React.Event.MouseButton1Click] = Properties.OnClick and function()
					for _, Func in ipairs(Properties.OnClick) do
						Func();
					end
				end,
			});
			BackgroundImage = e("ImageLabel", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.5);
				Size = UDim2.fromScale(1, 1);
				ZIndex = 0;
				Image = if Properties.Hovered then HighlightedBackgroundImage else DefaultBackgroundImage;
			}, {
				UIGradient = e("UIGradient", {
					Color = Properties.BackgroundColor or ColorSequence.new(Color3.new(1, 1, 1));
				});
			});
			MainImage = e("ImageLabel", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.5);
				Size = UDim2.fromScale(1, 1);
				Image = Properties.UnitImage or "";
			});
			BaseName = e("TextLabel", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.5, 0.8);
				Size = UDim2.fromScale(0.7, 0.2);
				BorderColor3 = Color3.new(1, 1, 1);
				TextColor3 = Color3.new(1, 1, 1);
				TextScaled = true;
				Text = Properties.Name;
				FontFace = DefaultFont;
				RichText = true;
			}, {
				UIStroke = e(UIStroke.UIStroke, {
					Stroke = 0.002;
					GradColor = if Properties.NameStrokeColor then Properties.NameStrokeColor else ColorSequence.new(Color3.new(1, 1, 1));
					native = {
						Enabled = if Properties.NameStrokeColor then true else false
					};
				});
				UIGradient = e("UIGradient", {
					Color = Properties.NameColor or ColorSequence.new(Color3.new(1, 1, 1));
				});
			});
			TopLeftLabel = e("TextLabel", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.55, 0.2);
				Size = UDim2.fromScale(0.8, 0.2);
				BorderColor3 = Color3.new(1, 1, 1);
				TextColor3 = Color3.new(1, 1, 1);
				TextScaled = true;
				TextXAlignment = Enum.TextXAlignment.Left;
				Text = Properties.LeftText;
				FontFace = DefaultFont;
				RichText = true;
			}, {
				UIStroke = e(UIStroke.UIStroke, {
					Stroke = 0.002;
					GradColor = Properties.LeftStrokeColor or ColorSequence.new(Color3.new(1, 1, 1));
					Enabled = if Properties.LeftStrokeColor then true else false;
				});
				UIGradient = e("UIGradient", {
					Color = Properties.LeftColor or ColorSequence.new(Color3.new(1, 1, 1));
				});
			});
			TopRightLabel = e("TextLabel", {
				BackgroundTransparency = 1;
				AnchorPoint = Vector2.new(0.5, 0.5);
				Position = UDim2.fromScale(0.45, 0.2);
				Size = UDim2.fromScale(0.8, 0.2);
				BorderColor3 = Color3.new(1, 1, 1);
				TextColor3 = Color3.new(1, 1, 1);
				TextScaled = true;
				TextXAlignment = Enum.TextXAlignment.Right;
				Text = Properties.RightText;
				FontFace = DefaultFont;
				RichText = true;
			}, {
				UIStroke = e(UIStroke.UIStroke, {
					Stroke = 0.002;
					GradColor = Properties.RightStrokeColor or ColorSequence.new(Color3.new(1, 1, 1));
					Enabled = if Properties.RightStrokeColor then true else false;
				});
				UIGradient = e("UIGradient", {
					Color = Properties.RightColor or ColorSequence.new(Color3.new(1, 1, 1));
				});
			})
		});
	})
end

return CreateBaseFrame;