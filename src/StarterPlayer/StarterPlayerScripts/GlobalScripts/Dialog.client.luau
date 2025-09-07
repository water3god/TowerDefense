--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Packages = ReplicatedStorage.Packages
local ReactRoblox = require(Packages.ReactRoblox)
local React = require(Packages.React)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local NewGui = require(CoreGame.NewGui)
local Hooks = require(CoreGame.Hooks)

local Message = require(Gui.Message.Message)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local WaveService = require(GlobalClient.WaveService)

local Shared = ReplicatedStorage.Shared
local WaveDialog = require(Shared.WaveDialog)

local Root = ReactRoblox.createRoot(Instance.new("Folder"))

local function CreateDialog()
	local Data: { Messages: { string }, SpeakerName: string, SpeakerImage: string? }?, SetData = React.useState(nil :: {
		SpeakerName: string,
		Messages: { string },
		SpeakerImage: string?,
	}?)

	local HandleWave = React.useCallback(function(Wave: WaveService.WaveData)
		if Wave then
			local MapInfo = WaveDialog[Wave.MapId]
			if MapInfo then
				local Dialog = MapInfo[Wave.StageId]
				if Dialog and Dialog[Wave.Wave] then
					local DialogData = Dialog[Wave.Wave]
					SetData({
						SpeakerName = DialogData.Title,
						Messages = DialogData.Message,
						SpeakerImage = DialogData.Image,
					})
				end
			end
		end
	end, {})

	React.useEffect(function()
		local WaveData = WaveService.GetWaveData()
		if WaveData then
			HandleWave(WaveData)
		end
	end, { HandleWave })

	Hooks.useEventConnection(WaveService.Added, HandleWave, { HandleWave })

	Hooks.useEventConnection(WaveService.Passed, function(Num: number)
		local Wave = WaveService.GetWaveData()
		if Wave then
			local MapInfo = WaveDialog[Wave.MapId]
			if MapInfo then
				local Dialog = MapInfo[Wave.StageId]
				if Dialog and Dialog[Num] then
					local DialogData = Dialog[Num]
					SetData({
						SpeakerName = DialogData.Title,
						Messages = DialogData.Message,
						SpeakerImage = DialogData.Image,
					})
				end
			end
		end
	end, {})

	local CloseClick = React.useCallback(function()
		SetData(nil)
	end, {})

	return Data
		and e(Message, {
			SpeakerName = Data.SpeakerName,
			Messages = Data.Messages,
			SpeakerImage = Data.SpeakerImage,
			CloseClick = CloseClick,
		})
end

Root:render(ReactRoblox.createPortal(
	e(NewGui, {
		DisplayOrder = 100,
	}, {
		Dialog = e(CreateDialog),
	}),
	PlayerGui
))
