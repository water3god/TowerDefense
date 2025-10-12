--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local _Promise = require(Packages.Promise)

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Client = ReplicatedStorage.Client
local WaveService = require(Client.GlobalClient.WaveService)
local SettingsService = require(Client.GlobalClient.SettingsService)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)

local Components = Gui.Components
local Button = require(Components.Button)

local SettingsFolder = Gui.Settings
local SettingsContext = require(SettingsFolder.SettingsContext)

export type Props = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateVoteFrame(Props: Props)
	local SettingsData = React.useContext(SettingsContext.Context)

	local IsVisible, SetVisible = React.useState(false)
	local Styles, API = ReactSpring.useSpring(function()
		return {
			Scale = 0.9,
			config = {
				mass = 1,
				tension = 500,
				friction = 30,
				precision = 0.02,
			},
		}
	end)
	local Time, _, SetTime = Hooks.UseTime()
	local PlayerData, SetData = React.useBinding({
		Votes = 1,
		Total = 3,
	})

	React.useEffect(function()
		if SettingsService.IsSynced then
			if SettingsData.WaveAutoSkip then
				WaveService.Vote()
				SetVisible(false)
			else
				local Data = WaveService.GetVoteData()
				if Data then
					SetData({
						Votes = Data.CurrentCount,
						Total = Data.NeededCount,
					})
					SetTime(Data.Time, Data.StartTime)
					SetVisible(true)
				end
			end
		end
	end, {})

	React.useEffect(function()
		local Connection = SettingsService.GetSettingChangedSignal("WaveAutoSkip"):Connect(function()
			SetVisible(false)
		end)

		return function()
			Connection:Disconnect()
		end
	end, {})

	Hooks.useEventConnection(SettingsService.Synced, function()
		if SettingsData.WaveAutoSkip then
			WaveService.Vote()
			SetVisible(false)
		else
			local Data = WaveService.GetVoteData()
			if Data then
				SetData({
					Votes = Data.CurrentCount,
					Total = Data.NeededCount,
				})
				SetTime(Data.Time, Data.StartTime)
				SetVisible(true)
			end
		end
	end, { SettingsData })

	Hooks.useEventConnection(WaveService.VoteData.VoteStarted, function(Data)
		if SettingsData.WaveAutoSkip then
			SetVisible(false)
			WaveService.Vote()
		else
			SetData({
				Votes = Data.CurrentCount,
				Total = Data.NeededCount,
			})
			local Wave = WaveService.GetWaveData()
			SetTime(Data.Time, Data.StartTime, Wave and Wave.WaveSpeed)
			SetVisible(true)
		end
	end, { SettingsData })

	Hooks.useEventConnection(WaveService.VoteData.VoteChanged, function(CurrentCount, NeededCount)
		SetData({
			Votes = CurrentCount,
			Total = NeededCount,
		})
	end, {})

	Hooks.useEventConnection(WaveService.VoteData.VoteEnded, function()
		SetVisible(false)
	end, {})

	Hooks.useEventConnection(WaveService.Ended, function()
		SetVisible(false)
	end, {})

	local Visiblity, SetVisibility = React.useState(false)
	local Promise = React.useRef(nil :: _Promise.Promise?)

	React.useEffect(function()
		if IsVisible then
			if Promise.current then
				Promise.current:cancel()
			end
			SetVisibility(true)
			API.start({
				Scale = 1,
			})
		else
			Promise.current = API.start({
				Scale = 0.9,
			}):andThen(function()
				SetVisibility(false)
			end)
		end
	end, { IsVisible })

	local YesClick = React.useCallback(function()
		WaveService.Vote()
		SetVisible(false)
	end, {})

	local NoClick = React.useCallback(function()
		SetVisible(false)
	end, {})

	return e(Main.ImageLabel, {
		native = Join({
			AnchorPoint = Vector2.new(0.5, 0),
			Image = "rbxassetid://124008352699396",
			Position = UDim2.fromScale(0.5, 0.2),
			Size = UDim2.fromScale(0.175, 0.175),
			Visible = Visiblity,
		}, Props.native),
	}, {
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(120, 50),
			MaxSize = Vector2.new(480, 200),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.77,
		}),
		NoButton = e(Button, {
			Text = "No",
			Color = "Red",
			Position = UDim2.fromScale(0.25, 0.75),
			Size = UDim2.fromScale(0.4, 0.4),
			OnClick = NoClick,
		}),
		YesButton = e(Button, {
			Text = "Yes",
			Color = "Green",
			Position = UDim2.fromScale(0.75, 0.75),
			Size = UDim2.fromScale(0.4, 0.4),
			OnClick = YesClick,
		}),
		PlayerCount = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.45),
				Size = UDim2.fromScale(0.3, 0.15),
				Text = PlayerData:map(function(Data)
					return string.format("%u/%u", Data.Votes, Data.Total)
				end),
				AutoLocalize = false,
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.02,
			}),
		}),
		TimeLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 1.15),
				Size = UDim2.fromScale(0.6, 0.15),
				Text = Time:map(function(TimeInput: number)
					return string.format("Starts In: %u", math.floor(TimeInput))
				end),
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		Title = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.2),
				Size = UDim2.fromScale(0.7, 0.2),
				Text = "Vote Start",
			},
		}, {
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Stroke = 0.015,
			}),
		}),
		Scale = e("UIScale", {
			Scale = Styles.Scale,
		}),
	}, Props.children)
end

return CreateVoteFrame
