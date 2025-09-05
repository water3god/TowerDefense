--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient

local AllInventory = require(GlobalClient.AllEquipped)

local Shared = ReplicatedStorage.Shared
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
			end
		end
	end

	return Properties
end
