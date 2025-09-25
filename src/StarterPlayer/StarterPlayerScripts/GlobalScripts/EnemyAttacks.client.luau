--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Network.Client)
local AttackEvent = Network.EnemyAttackEvent

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local EnemyClient = require(GlobalClient.EnemyClient)

local Shared = ReplicatedStorage.Shared
local EnemyAttacks = require(Shared.EnemyAttacks)

AttackEvent.SetCallback(function(Data)
	local Enemy = EnemyClient.GetEnemy(Data.UniqueId)
	if Enemy then
		local AttackTable = EnemyAttacks[Enemy.ModelName]
		if AttackTable then
			local AttackFunc = AttackTable.Funcs[Data.AttackName]
			if AttackFunc then
				Enemy.AttackTrove:Destroy()
				AttackFunc(Enemy, Data.SpeedRatio, workspace:GetServerTimeNow() - Data.TimeSent)
			end
		end
	end
end)
