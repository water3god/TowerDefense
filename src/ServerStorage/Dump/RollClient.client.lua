--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");

local Remotes = ReplicatedStorage.Remotes;
local RollEvents = Remotes.Roll;

local DoRoll = RollEvents.DoRoll;
local ConfirmRoll = RollEvents.ConfirmRoll;
local RollEvent = RollEvents.RollEvent;

local UnitStorage: {[string]: Model} = {};
for _, Unit in ipairs(ReplicatedStorage.ModelStorage.Units:GetChildren()) do
	UnitStorage[Unit.Name] = Unit;
end

local Shared = ReplicatedStorage.Shared;
local UnitInfo = require(Shared.UnitInfo);
local SettingsService = require(ReplicatedStorage.Client.SettingsService);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(ReplicatedStorage.CloneGui) & typeof(game:GetService("StarterGui")) = Player.PlayerGui;

local GamblingGui: typeof(PlayerGui.GamblingGui) = PlayerGui:WaitForChild("GamblingGui");
local OpenRollFrame = GamblingGui.OpenRollFrame;
local UnitName = OpenRollFrame.UnitName;

local RarityMainColor = UnitName.UIGradient;
local StrokeColor = UnitName.UIStroke.UIGradient;

local UnitView = OpenRollFrame.UnitView;
local WorldModel = UnitView.WorldModel;
local YesButton = OpenRollFrame.YesButton;
local NoButton = OpenRollFrame.NoButton;
local AutoRollButton = GamblingGui.AutoRollButton;

local RollFrame = GamblingGui.RollFrame;
local RollButton = RollFrame.Roll;

local ClickSound = SoundService:WaitForChild("click2down");

--[[
	CameraCFrame: Position: (0, 0, 50), Orientation: (0, 0, 0);
	RigRootCFrame: Position: (-0, -1, 40), Orientation: (0, 180, 0);
]]

local MoveWhenOpenGui = {
	PlayerGui:WaitForChild("MenuGui").StoryFrame;
	PlayerGui:WaitForChild("InventoryGui").InventoryFrame;
	PlayerGui:WaitForChild("SettingsGui").Main;
	PlayerGui:WaitForChild("UnitGui").OpenFrame;
};

local CurrentViewModel: Model? = nil;
local CurrentTask: thread? = nil;

local ModelCache: {[string]: Model} = {};
local AnimationCache: {[string]: AnimationTrack} = {};

local CacheThreads: {[Instance]: thread} = {};
local DelayTime = 60;

local function HandleCache<T>(Data: {[string]: T}, Value: T)
	if typeof(Value) ~= "Instance" then
		return;
	end
	if CacheThreads[Value] then
		task.cancel(CacheThreads[Value]);
		CacheThreads[Value] = nil;
	end
	
	if not Data[Value.Name] then
		Data[Value.Name] = Value;
	end
	
	CacheThreads[Value] = task.delay(DelayTime, function()
		if CurrentViewModel == Data[Value.Name] :: any then
			CurrentViewModel = nil;
		end
		if Data[Value.Name] then
			(Data[Value.Name] :: any):Destroy();
			Data[Value.Name] = nil;
		end
		
		CacheThreads[Value] = nil;
	end)
end

local function HandleModel(Model: Model)
	if CurrentViewModel and CurrentViewModel.Name ~= Model.Name then
		CurrentViewModel.Parent = nil;
	end
	local CurrentModel: Model = nil;
	
	if ModelCache[Model.Name] then
		CurrentModel = ModelCache[Model.Name];
	else
		CurrentModel = Model:Clone();
		CurrentViewModel = CurrentModel;
		
		local Humanoid = CurrentModel:FindFirstChildWhichIsA("Humanoid") :: Humanoid;
		(CurrentModel:WaitForChild("Animate") :: LocalScript).Enabled = false;
		
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false);
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false);
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false);
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false);
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false);
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false);
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false);
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false);
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false);
		
		ModelCache[CurrentModel.Name] = CurrentModel;
	end
	
	HandleCache(ModelCache, CurrentModel);
	
	local Root = CurrentModel.PrimaryPart :: BasePart;
	Root.Anchored = true;
	
	local AnimationId = CurrentModel:GetAttribute("Idle");
	
	--print(AnimationId)
	if AnimationId then
		local Track: AnimationTrack = nil;
		if AnimationCache[CurrentModel.Name] then
			Track = AnimationCache[CurrentModel.Name];
		else
			local Animator = (CurrentModel :: any):FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator") :: Animator;

			local Anim = Instance.new("Animation");
			Anim.AnimationId = AnimationId;

			Track = Animator:LoadAnimation(Anim);
			Track.Name = Model.Name;
			Track.Priority = Enum.AnimationPriority.Idle;
			Track.Looped = true;
		end
		
		Track:Play();
		
		AnimationCache[CurrentModel.Name] = Track;
		HandleCache(AnimationCache, Track);
	end
	
	Root.CFrame = CFrame.new(0, -1, 40) * CFrame.Angles(0, math.rad(180), 0);
	CurrentModel.Parent = WorldModel;
end

local Tweens: {[string]: Tween} = {};

local function CancelTweens()
	for Index, Tween: Tween in pairs(Tweens) do
		Tween:Cancel();
		Tweens[Index] = nil;
	end
end

local StartSize = OpenRollFrame.Size;
local EndSize = UDim2.fromScale(0.25, 0.25);
local CurrentThread: thread? = nil;

local CurrentValue: string? = nil;

local function AnimateGui(Speed: number)
	CancelTweens();
	
	OpenRollFrame.Size = StartSize;
	
	Tweens.OpenRollFrame = TweenService:Create(
		OpenRollFrame, 
		TweenInfo.new(Speed, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{Size = EndSize}
	)
	
	ClickSound.PlaybackSpeed = 1 / (Speed * 10) + 0.7;
	ClickSound:Play();
	
	Tweens.OpenRollFrame:Play();

	return Tweens.OpenRollFrame;
end

local function OpenRoll()
	OpenRollFrame.Visible = true;
end

local function CloseRoll()
	OpenRollFrame.Visible = false;
	if CurrentViewModel then
		CurrentViewModel.Parent = nil;
	end
	CurrentValue = nil;
end

local InRoll: boolean = false;
local InAutoRoll: boolean = false;

if SettingsService.IsSynced then
	InAutoRoll = SettingsService.GetSetting("AutoRoll");
else
	SettingsService.Synced:Wait();
	InAutoRoll = SettingsService.GetSetting("AutoRoll");
end

local function AnimateRoll(Data: {string})
	if CurrentTask then
		task.cancel(CurrentTask);
		CurrentTask = nil;
	end
	
	OpenRoll();
	
	if CurrentThread then
		task.cancel(CurrentThread);
		CurrentThread = nil;
	end
	
	CurrentValue = Data[#Data];
	
	YesButton.Visible = false;
	NoButton.Visible = false;
	
	CurrentThread = task.spawn(function()
		for Index, Unit in ipairs(Data) do
			local UnitData = UnitInfo.UnitInfo[Unit];
			local RarityData = UnitInfo.RarityInfo[UnitData.Rarity];
			
			UnitName.Text = Unit;
			RarityMainColor.Color = RarityData.StrokeColor;
			StrokeColor.Color = RarityData.UnitColor;
			
			if UnitStorage[Unit] then
				HandleModel(UnitStorage[Unit]);
			end
			local Speed = (Index / #Data) / (2.5^ (Index / 50 + 1)) + 0.08;
			AnimateGui(Speed);
			task.wait(Speed);
		end
		
		ClickSound:Play();
		
		if Tweens.OpenRollFrame and Tweens.OpenRollFrame.PlaybackState == Enum.PlaybackState.Completed then
			OpenRollFrame.Size = StartSize;
		elseif Tweens.OpenRollFrame then
			Tweens.OpenRollFrame.Completed:Once(function()
				OpenRollFrame.Size = StartSize;
			end)
		end
		
		YesButton.Visible = true;
		NoButton.Visible = true;
	end)
end

YesButton.MouseButton1Click:Connect(function()
	if CurrentValue ~= nil then
		ConfirmRoll:FireServer(CurrentValue, true);
		CloseRoll();
	end
end)

NoButton.MouseButton1Click:Connect(function()
	if CurrentValue ~= nil then
		ConfirmRoll:FireServer(CurrentValue, false);
		CloseRoll();
	end
end)

RollButton.MouseButton1Click:Connect(function()
	if not InAutoRoll then
		local Data: {string} = DoRoll:InvokeServer();

		if Data then
			AnimateRoll(Data);
		end
	end
end)

RollEvent.OnClientEvent:Connect(function(Data: {string}, Time: number)
	if workspace:GetServerTimeNow() - Time <= 1.7736 then
		AnimateRoll(Data);
	end
end)

AutoRollButton.MouseButton1Click:Connect(function()
	SettingsService.ChangeSetting("AutoRoll", not SettingsService.GetSetting("AutoRoll"));
	InAutoRoll = SettingsService.GetSetting("AutoRoll");
end)

local function MoveTo(Remote: boolean)
	local MoveToPosition = if Remote then UDim2.fromScale(0.85, 0.5) else UDim2.fromScale(0.5, 0.6);
	local Tween = TweenService:Create(
		OpenRollFrame,
		TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{Position = MoveToPosition}
	);
	
	Tween:Play();
end

local Open = false;
local Overriden = SettingsService.GetSetting("RollFrameLeft", true);

local function HandleFrame()
	local Visible = false;
	if not Overriden then
		for _, Frame: Frame in ipairs(MoveWhenOpenGui) do
			if Frame.Visible then
				Visible = true;
				break;
			end
		end
	else
		Visible = true;
	end
	
	if Visible then
		if not Open then
			MoveTo(true);
			Open = true;
		end
	else
		if Open then
			MoveTo(false);
			Open = false;
		end
	end
end

HandleFrame();
for _, Frame: Frame in ipairs(MoveWhenOpenGui) do
	Frame:GetPropertyChangedSignal("Visible"):Connect(HandleFrame)
end

SettingsService.GetSettingChangedSignal("RollFrameLeft"):Connect(function(Value)
	Overriden  = Value;
end)

