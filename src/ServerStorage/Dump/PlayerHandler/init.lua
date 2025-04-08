--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local Players = game:GetService("Players");

local SafePlayer = ServerScriptService.Utility.SafePlayer;

local SafePlayerAdded = require(SafePlayer.SafePlayerAdded);
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving);

local Handler = {};

local Datas: {[number]: {
	Cash: number;
	UnitCount: number;
	DamageDone: number;
	Kills: number;
	
	InGame: boolean;
}} = {};

function Handler.GetCash(PlayerId: number): number?
	if Datas[PlayerId] then
		return Datas[PlayerId].Cash;
	end
	
	return nil;
end

-- Cash --

function Handler.SetCash(PlayerId: number, Amount: number)
	local PlayerData = Datas[PlayerId];
	
	if PlayerData then
		PlayerData.Cash = Amount;
	end
end

function Handler.AddCash(PlayerId: number, Amount: number)
	local PlayerData = Datas[PlayerId];
	
	if PlayerData then
		PlayerData.Cash += Amount;
	end
end

function Handler.SubtractCash(PlayerId: number, Amount: number)
	local PlayerData = Datas[PlayerId];
	
	if PlayerData then
		PlayerData.Cash -= Amount;
	end
end

-- Unit Count --

function Handler.SetUnitCount(PlayerId: number, Count: number)
	local PlayerData = Datas[PlayerId];
	
	if PlayerData then
		PlayerData.UnitCount = Count;
	end
end

function Handler.AddUnitCount(PlayerId: number, Count: number)
	local PlayerData = Datas[PlayerId];

	if PlayerData then
		PlayerData.UnitCount += Count;
	end
end

function Handler.SubtractUnitCount(PlayerId: number, Count: number)
	local PlayerData = Datas[PlayerId];

	if PlayerData then
		PlayerData.UnitCount -= Count;
	end
end

-- Damage Done --

function Handler.SetDamage(PlayerId: number, Damage: number)
	local PlayerData = Datas[PlayerId];

	if PlayerData then
		PlayerData.DamageDone = Damage;
	end
end

function Handler.AddDamage(PlayerId: number, Damage: number)
	local PlayerData = Datas[PlayerId];
	
	if PlayerData then
		PlayerData.DamageDone += Damage;
	end
end

-- Kills --

function Handler.SetKills(PlayerId: number, Kills: number)
	local PlayerData = Datas[PlayerId];

	if PlayerData then
		PlayerData.DamageDone = Kills;
	end
end

function Handler.AddKills(PlayerId: number, Kills: number)
	local PlayerData = Datas[PlayerId];

	if PlayerData then
		PlayerData.DamageDone += Kills;
	end
end

-- Miscellanous --

function Handler.GetPlayerIds()
	local Ids = {};
	for Id, _ in pairs(Datas) do
		table.insert(Ids, Id);
	end

	return Ids;
end

function Handler.GetData()
	return Datas;
end

function Handler.PlayerIsInGame(PlayerId: number)
	if Datas[PlayerId] then
		if Datas[PlayerId].InGame then
			return true;
		end
	end
	
	return false;
end

-- Data Handler Events --

SafePlayerAdded:Connect(function(Player: Player)
	if not Datas[Player.UserId] then
		Datas[Player.UserId] = {
			Cash = 500;
			UnitCount = 0;
			DamageDone = 0;
		} :: any;

		Datas[Player.UserId].InGame = Player:IsDescendantOf(Players);
	end
end, true);

SafePlayerRemoving:Connect(function(Player: Player)
	if Datas[Player.UserId] then
		Datas[Player.UserId].InGame = false;
	end
end)


return Handler;