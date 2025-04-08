--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

local Client = ReplicatedStorage.Client;
local GlobalClient = Client.GlobalClient;
local CurrencyService = require(GlobalClient.CurrencyService);
local WaveService = require(GlobalClient.WaveService);

local Player = Players.LocalPlayer;
local PlayerGui: typeof(ReplicatedStorage.CloneGui) & typeof(game:GetService("StarterGui")) = Player.PlayerGui;
local GlobalGui: typeof(PlayerGui.GlobalGui) = PlayerGui:WaitForChild("GlobalGui");
local GameGui = GlobalGui.GameGui;

local BottomFrame = GameGui.BottomFrame;

local CoinFrame = BottomFrame.CoinFrame;
local CoinLabel = CoinFrame.CoinLabel;

local YenFrame = BottomFrame.YenFrame;
local YenLabel = YenFrame.YenLabel;

task.spawn(function()
	if not CurrencyService.CoinIsSynced then
		CurrencyService.CoinSynced:Wait();
	end
	
	CoinLabel.Text = CurrencyService.CurrencyData.Coins;
	
	CurrencyService.CoinChanged:Connect(function(Coins: number)
		CoinLabel.Text = Coins;
	end)
	
	CoinFrame.Visible = true;
end)

task.spawn(function()
	YenLabel.Text = CurrencyService.CurrencyData.Yen;
	
	CurrencyService.YenChanged:Connect(function(Yen: number)
		YenLabel.Text = Yen;
	end)
end)

local function YenChange(Connected: boolean)
	if Connected then
		YenFrame.Visible = true;
		CoinFrame.Visible = false;
	else
		YenFrame.Visible = false;
		if CurrencyService.CoinIsSynced then
			CoinFrame.Visible = true;
		end
	end
end

YenChange(CurrencyService.YenConnected);
CurrencyService.YenConnect:Connect(YenChange);