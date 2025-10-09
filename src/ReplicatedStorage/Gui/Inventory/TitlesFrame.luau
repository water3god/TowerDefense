--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local InventoryService = require(GlobalClient.InventoryService)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local Title = require(CoreGame.Title)
local CloseButton = require(CoreGame.CloseButton)
local UIStroke = require(CoreGame.UIStroke)
local Hooks = require(CoreGame.Hooks)
local AnimatedGradient = require(CoreGame.AnimatedGradient)

local Components = Gui.Components
local Button = require(Components.Button)

local Shared = ReplicatedStorage.Shared
local TitleInfo = require(Shared.Titles)

export type Properties = {
	Titles: { string },
	EquippedTitle: string,
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type TitleProps = {
	TitleName: string,
	Equipped: boolean?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateTitle(props: TitleProps)
	local TitleData = React.useMemo(function()
		return TitleInfo[props.TitleName]
	end, { props.TitleName })

	local EquipTitle = React.useCallback(function()
		InventoryService.EquipTitle(props.TitleName)
	end, { props.TitleName })

	return e(Main.Frame, {
		native = Join({
			Size = UDim2.fromScale(1, 0.2),
			ZIndex = TitleData.Priority,
		}, props.native),
	}, {
		Container = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.95, 0.9),
				Image = "rbxassetid://81483731389339",
			},
		}, {
			Label = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.325, 0.35),
					Size = UDim2.fromScale(0.55, 0.4),
					Text = props.TitleName,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				UIGradient = e(AnimatedGradient, {
					GradColor = TitleData and TitleData.Color or ColorSequence.new(Color3.new(1, 1, 1)),
					Animate = true,
					Speed = 1,
				}),
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.015,
				}),
			}),
			DescriptionLabel = e(Main.TextLabel, {
				native = {
					Position = UDim2.fromScale(0.325, 0.7),
					Size = UDim2.fromScale(0.55, 0.2),
					Text = TitleData and TitleData.Description or "No description available.",
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.01,
				}),
			}),
			ToggleButton = e(Button, {
				Text = props.Equipped and "Equipped" or "Equip",
				Position = UDim2.fromScale(0.8, 0.5),
				Size = UDim2.fromScale(0.6, 0.8),
				OnClick = EquipTitle,
				Color = props.Equipped and "Gray" or "Green",
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.2, 0),
			}),
		}),
	}, props.children)
end

local function CreateTitlesFrame(props: Properties)
	local TitleFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}

		for _, TitleName in ipairs(props.Titles) do
			local TitleData = TitleInfo[TitleName]
			if TitleData then
				Frames[TitleName] = e(CreateTitle, {
					TitleName = TitleName,
					Equipped = TitleName == props.EquippedTitle,
				})
			else
				warn("Title not found:", TitleName)
			end
		end

		return Frames
	end, { props.Titles, props.EquippedTitle } :: { unknown })

	return e(Main.ImageLabel, {
		native = Join({
			Size = UDim2.fromScale(0.5, 0.7),
			Image = "rbxassetid://78579166773802",
		}, props.native),
	}, {
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(210, 230),
			MaxSize = Vector2.new(840, 920),
		}),
		Title = e(Title, {
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromScale(1, 0.175),
			Title = "TITLES",
		}),
		MainFrame = e(Main.ScrollingFrame, {
			BarSize = 0.01,
			native = {
				Position = UDim2.fromScale(0.5, 0.51),
				Size = UDim2.fromScale(0.95, 0.8),
				ZIndex = 2,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
			},
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 0),
				FillDirection = Enum.FillDirection.Vertical,
			}),
		}, TitleFrames),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 0.8,
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.175, 0.25),
			OnClick = props.CloseClick,
		}),
	}, props.children)
end

local function Connected(props: { CloseClick: (() -> ())?, native: { [any]: any }?, children: { [any]: any }? })
	local Titles, SetTitles = React.useState({} :: { string })
	local EquippedTitle, SetEquippedTitle = React.useState("Player")

	React.useEffect(function()
		local SyncedPromise = Promise.new(function(resolve)
			if not InventoryService.IsSynced then
				InventoryService.Synced:Wait()
			end
			resolve({
				Titles = InventoryService.TitleData.Titles,
				EquippedTitle = InventoryService.TitleData.EquippedTitle,
			})
		end):andThen(function(data)
			SetTitles(data.Titles)
			SetEquippedTitle(data.EquippedTitle)
		end)

		return function()
			SyncedPromise:cancel()
		end
	end, {})

	Hooks.useEventConnection(InventoryService.TitleAdded, function()
		SetTitles(table.clone(InventoryService.TitleData.Titles))
	end, {})

	Hooks.useEventConnection(InventoryService.TitleChanged, function(EquippedTitleValue: string)
		SetEquippedTitle(EquippedTitleValue)
	end, {})

	return e(CreateTitlesFrame, {
		native = props.native,
		CloseClick = props.CloseClick,
		Titles = Titles,
		EquippedTitle = EquippedTitle,
	}, props.children)
end

return {
	Create = CreateTitlesFrame,
	Connected = Connected,
}
