--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local TextChannels = TextChatService:WaitForChild("TextChannels")
local RBXGeneral: TextChannel = TextChannels:WaitForChild("RBXGeneral")

local Network = require(ReplicatedStorage.Network.Client)
local RareUnitMessage = Network.RareUnitMessage

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient

local AllInventory = require(GlobalClient.AllEquipped)

local Shared = ReplicatedStorage.Shared
local UnitInfo = require(Shared.UnitInfo)
local Titles = require(Shared.Titles)
local LevelRequirements = require(Shared.LevelRequirements)

local ChatWindowConfiguration = TextChatService.ChatWindowConfiguration

AllInventory.Changed:Wait()

TextChatService.OnChatWindowAdded = function(ChatWindow: TextChatMessage)
	if not ChatWindow.TextSource then
		return
	end

	local Properties = ChatWindowConfiguration:DeriveNewMessageProperties()

	local UserId = ChatWindow.TextSource.UserId

	if UserId then
		local Player = Players:GetPlayerByUserId(UserId)
		if Player then
			local Data = AllInventory.GetEquipped(Player)
			if Data then
				Properties.PrefixText = string.format("[%s]", Data.Title)

				local HighestColor = LevelRequirements.GetHighestColor(Data.Level).Keypoints[1].Value

				local R, G, B = HighestColor.R, HighestColor.G, HighestColor.B

				Properties.Text = string.format(
					'<font color="rgb(%d, %d, %d)">%s:</font> %s',
					R * 255,
					G * 255,
					B * 255,
					Player.DisplayName,
					ChatWindow.Text
				)

				Properties.PrefixTextProperties = Properties

				local Gradient = Instance.new("UIGradient")
				Gradient.Color = Titles[Data.Title].Color
				Gradient.Parent = Properties.PrefixTextProperties

				return Properties
			end
		end
	end
end

type RareSummonMessage = {
	PlayerName: string,
	PlayerUserId: number,
	UnitName: string,
}

RareUnitMessage.SetCallback(function(Data: RareSummonMessage)
	local UnitData = UnitInfo.UnitInfo[Data.UnitName]
	if not UnitData then
		return
	end

	local Message = string.format(
		"<b><font color='#FFD700'>%s</font> has summoned a <font color='#FFD700'>%s %s!</font></b>",
		Data.PlayerName,
		UnitData.Rarity,
		Data.UnitName
	)

	RBXGeneral:DisplaySystemMessage(Message)
end)
