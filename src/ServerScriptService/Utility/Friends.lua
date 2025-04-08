--!strict

-- By Wa1er_God --

-- Note: This Module does not support Friends outside the current game! --

local ServerScriptService = game:GetService("ServerScriptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

local SafePlayer = ServerScriptService.Utility.SafePlayer;
local SafePlayerAdded = require(SafePlayer.SafePlayerAdded);
local SafePlayerRemoving = require(SafePlayer.SafePlayerRemoving);

local JoinName = "FriendsListv1Join";

local FriendsList: {[Player]: {Player}} = {};
local Yields: {Player} = {};

local Friends = {};

Friends.FriendAdded = Instance.new("BindableEvent");
Friends.FriendRemoving = Instance.new("BindableEvent");

function Friends.IsFriendsWith(Player1: Player, Player2: Player)
	Friends._YieldUntilLoaded(Player1);
	Friends._YieldUntilLoaded(Player2);
	if FriendsList[Player1] then
		if table.find(FriendsList[Player1], Player2) then
			return true;
		end
	end
	
	if FriendsList[Player2] then
		if table.find(FriendsList[Player2], Player1) then
			return true;
		end
	end
	
	return false;
end

function Friends._YieldUntilLoaded(Player: Player)
	if not table.find(Yields, Player) then
		repeat
			task.wait();
		until table.find(Yields, Player) or not Player:IsDescendantOf(Players)
	end
	
	return;
end

function Friends.GetFriendsInGameOf(Player: Player)
	return FriendsList[Player];
end

SafePlayerAdded:Connect(function(PlayerAdded: Player)
	FriendsList[PlayerAdded] = {};

	for _, Player in ipairs(Players:GetPlayers()) do
		if PlayerAdded:IsFriendsWith(Player.UserId) then
			table.insert(FriendsList[PlayerAdded], Player);
			table.insert(FriendsList[Player], PlayerAdded);
			Friends.FriendAdded:Fire(Player, PlayerAdded);
		end
	end
	table.insert(Yields, PlayerAdded);
end, true)

SafePlayerRemoving:Connect(function(PlayerRemoving: Player)

	for Player, PlayerFriends in pairs(FriendsList) do
		local Index = table.find(PlayerFriends, PlayerRemoving);
		if Index then
			table.remove(PlayerFriends, Index);
			Friends.FriendRemoving:Fire(Player, PlayerRemoving);
		end
	end

	FriendsList[PlayerRemoving] = nil;
	table.insert(Yields, PlayerRemoving);
end);

return Friends;
