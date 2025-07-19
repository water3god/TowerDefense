--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local AllEquipped = require(GlobalClient.AllEquipped)

local LobbyClient = Client.LobbyClient
local Follower = require(LobbyClient.Follower)

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)

if not IsLobby then
	return
end

local FollowerCache: { [Player]: { { UniqueId: string, Follower: Follower.Follower } } } = {}

local function CreateFollower(Character: Follower.Character, Data: AllEquipped.UnitDataSent, Index: number)
	return Follower.new({
		UnitName = Data.UnitName,
		Index = Index,
		Character = Character,
	})
end

local function InitalizePlayer(Player: Player)
	FollowerCache[Player] = {}

	local function OnCharacterAdded(Character: Follower.Character)
		local EquippedData = AllEquipped.Equipped[Player]
		if EquippedData then
			for Index, UnitData in pairs(EquippedData.EquippedUnits) do
				FollowerCache[Player][Index] =
					{ UniqueId = UnitData.Id, Follower = CreateFollower(Character, UnitData, Index) }
			end
		end

		local Connection = AllEquipped.Changed:Connect(function(OtherPlayer, Data)
			if OtherPlayer == Player then
				for Index, UnitData in pairs(Data.EquippedUnits) do
					local CachedTable = FollowerCache[Player][Index]
					if not CachedTable or CachedTable.UniqueId ~= UnitData.Id then
						if FollowerCache[Player][Index] then
							FollowerCache[Player][Index].Follower:Destroy()
						end

						FollowerCache[Player][Index] =
							{ UniqueId = UnitData.Id, Follower = CreateFollower(Character, UnitData, Index) }
					end
				end

				for Key, FollowerData in pairs(FollowerCache[Player]) do
					if not Data.EquippedUnits[Key] then
						FollowerData.Follower:Destroy()
						FollowerCache[Player][Key] = nil
					end
				end
			end
		end)

		Player.CharacterRemoving:Once(function()
			Connection:Disconnect()
			for _, FollowerData in pairs(FollowerCache[Player]) do
				FollowerData.Follower:Destroy()
			end
		end)
	end

	if Player.Character then
		OnCharacterAdded(Player.Character)
	end

	Player.CharacterAdded:Connect(OnCharacterAdded)
end

for _, Player in ipairs(Players:GetPlayers()) do
	InitalizePlayer(Player)
end

Players.PlayerAdded:Connect(InitalizePlayer)

Players.PlayerRemoving:Connect(function(Player)
	task.defer(function()
		FollowerCache[Player] = nil
	end)
end)
