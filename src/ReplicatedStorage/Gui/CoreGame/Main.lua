--!strict

-- By Wa1er_God --

local DefaultFont = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");

local Modules = ReplicatedStorage.Modules;
local JoinDicts = require(Modules.JoinDicts);

local ReactLua = Modules.ReactLua;
local React = require(ReactLua.React);
local e = React.createElement;

local Gui = ReplicatedStorage.Gui;
local CoreGame = Gui.CoreGame;
local DefaultScrolling = require(CoreGame.DefaultScrolling);

local DefaultGui = {};

local DefaultProps = {
	BackgroundTransparency = 1;
	BackgroundColor3 = Color3.new(1, 1, 1);
	BorderColor3 = Color3.new(0, 0, 0);
	AnchorPoint = Vector2.new(0.5, 0.5);
	Position = UDim2.fromScale(0.5, 0.5);
	Size = UDim2.fromScale(1, 1);
};

local DefaultText = {
	Text = "DefaultText";
	FontFace = DefaultFont;
	TextScaled = true;
	RichText = true;
	TextColor3 = Color3.new(1, 1, 1);
};

local DefaultImage = {
	Image = "rbxassetid://113696247140901";
};

local DefaultButton = {
	AutoButtonColor = false;
};

export type Properties = {
	native: {[any]: any}?;
	children: {[any]: any}?;
};

local function ReactLerp(TotalTime: number, EndValue: number, Binding: React.Binding<number>, SetBinding: React.BindingUpdater<number>)
	React.useEffect(function()
		local StartTime = workspace:GetServerTimeNow();
		local Connection: RBXScriptConnection? = nil;
		local StartValue = Binding:getValue();
		Connection = RunService.PostSimulation:Connect(function(Delta: number)
			local Time = (workspace:GetServerTimeNow() - StartTime) + TotalTime;
			local alpha = (math.clamp(Time / TotalTime, 0, 1));
			SetBinding(math.lerp(StartValue, EndValue, alpha));

			if alpha == 1 then
				if Connection then
					Connection:Disconnect();
				end
			end
		end)

		return function()
			if Connection then
				Connection:Disconnect();
			end
		end
	end, {})

	return Binding, SetBinding;
end

function DefaultGui.Frame(Properties: Properties)
	local Scale, SetScale = React.createBinding(1);
	local Callback = React.useCallback(function(Instance: GuiObject)
		if Instance.GuiState == Enum.GuiState.Hover then
			ReactLerp(0.1, 1.2, Scale, SetScale)
		elseif Instance.GuiState == Enum.GuiState.Press then
			ReactLerp(0.1, 0.8, Scale, SetScale)
		elseif Instance.GuiState == Enum.GuiState.Idle then
			ReactLerp(0.1, 1, Scale, SetScale)
		end
	end, {});

	return e("Frame",
		JoinDicts(
			DefaultProps,
			{
				BackgroundTransparency = 0;
				[React.Change.GuiState] = Callback;
			},
			Properties.native
		), {
			UIScale = e("UIScale", {
				Scale = Scale;
			})
		},
		 Properties.children
	);
end

function DefaultGui.ImageLabel(Properties: Properties)
	return e("ImageLabel",
		JoinDicts(
			DefaultProps,
			DefaultImage,
			{

			},
			Properties.native
		),
		Properties.children
	)
end

function DefaultGui.ImageButton(Properties: Properties)
	return e("ImageButton",
		JoinDicts(
			DefaultProps,
			DefaultImage,
			DefaultButton,
			{
				
			},
			Properties.native
		),
		Properties.children
	)
end

function DefaultGui.TextLabel(Properties: Properties)
	return e("TextLabel",
		JoinDicts(
			DefaultProps,
			DefaultText,
			{

			},
			Properties.native
		),
		Properties.children
	)
end

function DefaultGui.TextButton(Properties: Properties)
	return e("TextButton",
		JoinDicts(
			DefaultProps,
			DefaultText,
			DefaultButton,
			{

			},
			Properties.native
		),
		Properties.children
	)
end

function DefaultGui.TextBox(Properties: Properties)
	return e("TextBox",
		JoinDicts(
			DefaultProps,
			DefaultText,
			{
				PlaceholderText = "Enter Text...";
			},
			Properties.native
		),
		Properties.children
	)
end

function DefaultGui.CanvasGroup(Properties: Properties)
	return e("CanvasGroup",
		JoinDicts(
			DefaultProps,
			Properties.native
		),
		Properties.children
	)
end

function DefaultGui.ScrollingFrame(Properties: Properties & {BarSize: number})
	return e(DefaultScrolling,
		{
			native = JoinDicts(
			DefaultProps,
			{
				BarSize = Properties.BarSize;
				ScrollBarImageColor3 = Color3.new(0.444053, 0.448447, 0.448447);
			},
			Properties.native
			)
		},
		Properties.children
	)
end

function DefaultGui.ViewportFrame(Properties: Properties)
	return e("ViewportFrame",
		JoinDicts(
			DefaultProps,
			Properties.native
		),
		Properties.children
	)
end

local Animateables = {};
DefaultGui.Animateables = Animateables;

do
	function Animateables.Frame(Properties: Properties)
		local Scale, SetScale = React.createBinding(1);
		local Callback = React.useCallback(function(Instance: GuiObject)
			if Instance.GuiState == Enum.GuiState.Hover then
				ReactLerp(0.1, 1.2, Scale, SetScale)
			elseif Instance.GuiState == Enum.GuiState.Press then
				ReactLerp(0.1, 0.8, Scale, SetScale)
			elseif Instance.GuiState == Enum.GuiState.Idle then
				ReactLerp(0.1, 1, Scale, SetScale)
			end
		end, {});
	
		return e(DefaultGui.Frame, {
			native = JoinDicts(
				Properties.native,
				{
					[React.Change.GuiState] = Callback;
				}
			);
			 children = JoinDicts(
				{
					AnimateScale = e("UIScale", {
						Scale = Scale;
					});
				},
				Properties.children
			)
		});
	end
	
	function Animateables.ImageButton(Properties: Properties)
		local Scale, SetScale = React.createBinding(1);
		local Callback = React.useCallback(function(Instance: GuiObject)
			if Instance.GuiState == Enum.GuiState.Hover then
				ReactLerp(0.1, 1.2, Scale, SetScale)
			elseif Instance.GuiState == Enum.GuiState.Press then
				ReactLerp(0.1, 0.8, Scale, SetScale)
			elseif Instance.GuiState == Enum.GuiState.Idle then
				ReactLerp(0.1, 1, Scale, SetScale)
			end
		end, {});
	
		return e(DefaultGui.ImageButton, {
			native = JoinDicts(
				Properties.native,
				{
					[React.Change.GuiState] = Callback;
				}
			);
			 children = JoinDicts(
				{
					AnimateScale = e("UIScale", {
						Scale = Scale;
					});
				},
				Properties.children
			)
		});
	end
	
	function Animateables.TextButton(Properties: Properties)
		local Scale, SetScale = React.createBinding(1);
		local Callback = React.useCallback(function(Instance: GuiObject)
			if Instance.GuiState == Enum.GuiState.Hover then
				ReactLerp(0.1, 1.2, Scale, SetScale)
			elseif Instance.GuiState == Enum.GuiState.Press then
				ReactLerp(0.1, 0.8, Scale, SetScale)
			elseif Instance.GuiState == Enum.GuiState.Idle then
				ReactLerp(0.1, 1, Scale, SetScale)
			end
		end, {});
	
		return e(DefaultGui.TextButton, {
			native = JoinDicts(
				Properties.native,
				{
					[React.Change.GuiState] = Callback;
				}
			);
			 children = JoinDicts(
				{
					AnimateScale = e("UIScale", {
						Scale = Scale;
					});
				},
				Properties.children
			)
		});
	end
	
	function Animateables.CanvasGroup(Properties: Properties)
		local Scale, SetScale = React.createBinding(1);
		local Callback = React.useCallback(function(Instance: GuiObject)
			if Instance.GuiState == Enum.GuiState.Hover then
				ReactLerp(0.1, 1.2, Scale, SetScale)
			elseif Instance.GuiState == Enum.GuiState.Press then
				ReactLerp(0.1, 0.8, Scale, SetScale)
			elseif Instance.GuiState == Enum.GuiState.Idle then
				ReactLerp(0.1, 1, Scale, SetScale)
			end
		end, {});
	
		return e(DefaultGui.CanvasGroup, {
			native = JoinDicts(
				Properties.native,
				{
					[React.Change.GuiState] = Callback;
				}
			);
			 children = JoinDicts(
				{
					AnimateScale = e("UIScale", {
						Scale = Scale;
					});
				},
				Properties.children
			)
		});
	end
end

return DefaultGui;