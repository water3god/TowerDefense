--!strict

-- By Wa1er_God --

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local LobbyClient = Client.LobbyClient;
local TradeService = require(LobbyClient.TradeService);
local ConfirmGui = require(GlobalClient.ConfirmGui);
local Shared = ReplicatedStorage.Shared;
local Types = require(Shared.Types);

local Modules = ReplicatedStorage.Modules;
local HelperFunctions = require(Modules.HelperFunctions);
local DelayHandler = require(Modules.DelayHandler);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(ReplicatedStorage.CloneGui) & typeof(game:GetService("StarterGui")) = Player.PlayerGui;

local LobbyGui: typeof(PlayerGui.LobbyGui) = PlayerGui:WaitForChild("LobbyGui");
local TradeGui = LobbyGui.TradeGui;
local TradeButton = TradeGui.Container.TradeButton;
local TradeMenu = TradeGui.TradeMenu;
local MainFrame = TradeMenu.MainFrame;
local CloseButton = TradeMenu.CloseButton;
local NoPlayers = TradeMenu.NoPlayers;

local TradeSample = script:WaitForChild("TradeSample");

local UsedRequests: {Player} = {};
local Frames: {[Player]: typeof(TradeSample)} = {};

local CurrentRequests: {[Player]: string} = {};

local function GetTextStatus(Status: Types.TradeStatusMessage)
	if Status == "CanTrade" then
		return "Trade";
	elseif Status == "Trading" then
		return "Trading";
	elseif Status == "TradeDisabled" then
		return "Disabled";
	end
	
	return "ERROR";
end

--[[ Creates the Player Trade Frame.]]
local function CreateFrame(OtherPlayer: Player, Status: Types.TradeStatusMessage, Frame: typeof(TradeSample)?)
	local TradeFrame: typeof(TradeSample) = Frame;
	
	if not TradeFrame then
		TradeFrame = TradeSample:Clone();
		TradeFrame.Name = OtherPlayer.Name;
		
		local Container: typeof(TradeSample.Container) = TradeFrame.Container;
		Container.PlayerLabel.Text = OtherPlayer.Name;
		
		task.spawn(function()
			Container.PlayerImage.ThumbnailImage.Image = HelperFunctions.GetThumbnailAsync(Player);
		end)
		
		TradeFrame.Parent = TradeMenu.MainFrame;
		
		Container.PlayerTradeButton.Activated:Connect(function()
			if not DelayHandler("PlayerTradeRequest", 0.4) then
				return;
			end
			
			if table.find(UsedRequests, OtherPlayer) then
				return;
			end
			
			Container.PlayerTradeButton.Active = false;
			
			local Status: Types.TradeStatusMessage = TradeService.TradeStatuses[OtherPlayer];
			
			if Status == "CanTrade" then
				TradeService.SendTradeRequest(OtherPlayer);
				
				table.insert(UsedRequests, OtherPlayer);
				
				task.delay(30, function()
					local Index = table.find(UsedRequests, OtherPlayer);
					
					if Index then
						table.remove(UsedRequests, Index);
						local Status: Types.TradeStatusMessage = TradeService.TradeStatuses[OtherPlayer];
						
						if OtherPlayer:IsDescendantOf(Players) and Container:FindFirstChild("PlayerTradeButton") then
							local Enabled = if Status == "CanTrade" and not table.find(UsedRequests, OtherPlayer)
								then true
								else false;
							Container.PlayerTradeButton.Active = Enabled;
							(TradeFrame :: any).LayoutOrder = if Enabled then 1 else 2;
						end
					end
				end)
			end
		end)
		
		OtherPlayer.Destroying:Once(function()
			TradeFrame:Destroy();
			Frames[Player] = nil;
		end)
		
		Frames[Player] = TradeFrame;
	end
	
	local Container = TradeFrame.Container;
	
	Container.PlayerTradeButton.Label.Text = GetTextStatus(Status);
	local Enabled = if Status == "CanTrade" and not table.find(UsedRequests, OtherPlayer) then true else false;
	Container.PlayerTradeButton.Active = Enabled;
	(TradeFrame :: any).LayoutOrder = if Enabled then 1 else 2;
end

local function HandleStatus(Data: {[Player]: Types.TradeStatusMessage})
	for Player, Status in pairs(Data) do
		if Player:IsDescendantOf(Players) then
			CreateFrame(Player, Status :: any, Frames[Player]);
		end
	end
end

HandleStatus(TradeService.TradeStatuses);

TradeService.SyncedStatus:Connect(function(Player: Player, Status: Types.TradeStatusMessage)
	HandleStatus({[Player] = Status});
end)

TradeService.NewTradeRequest:Connect(function(OtherPlayer: Player, Time: number)
	local ConfirmFrame, UniqueId = ConfirmGui.Create({
		Title = "Trade Request";
		Description = string.format("Incoming Trade From %s", OtherPlayer.Name);
		YesText = "Accept";
		NoText = "Decline";
		OnSide = true;
		EndFunc = function(End: boolean?)
			if End then
				TradeService.AcceptTrade(OtherPlayer);
			end
		end,
	});
	
	CurrentRequests[OtherPlayer] = UniqueId;
end)

TradeService.RequestEnded:Connect(function(OtherPlayer: Player)
	if CurrentRequests[OtherPlayer] then
		ConfirmGui.Close(CurrentRequests[OtherPlayer]);
		CurrentRequests[OtherPlayer] = nil;
	end
end)

local function HandlePlayers(Players: number)
	if Players < 2 then
		NoPlayers.Visible = true;
	else
		NoPlayers.Visible = false;
	end
end
HandlePlayers(#Players:GetPlayers());
Players.PlayerAdded:Connect(function()
	HandlePlayers(#Players:GetPlayers());
end)
Players.PlayerRemoving:Connect(function()
	HandlePlayers(#Players:GetPlayers());
end)

TradeButton.MouseButton1Click:Connect(function()
	TradeMenu:SetAttribute("AnimateVisible", not TradeMenu:GetAttribute("AnimateVisible"));
end)

CloseButton.MouseButton1Click:Connect(function()
	TradeMenu:SetAttribute("AnimateVisible", false);
end)