--!strict

-- By Wa1er_God --

-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

-- Libraries --
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local ObserveTag = require(Modules.ObserveTag)

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local NewGui = require(CoreGame.NewGui)
local Hooks = require(CoreGame.Hooks)
local Indicator = require(Gui.Message.Indicator)

local MiscContexts = Gui.MiscContexts
local TutorialContext = require(MiscContexts.PassedTutorial)

local Client = ReplicatedStorage.Client
local GlobalClient = Client.GlobalClient
local UnitClient = require(GlobalClient.UnitClient)

local Shared = ReplicatedStorage.Shared
local IsLobby = require(Shared.IsLobby)
local IsTutorial = require(Shared.IsTutorial)
local Types = require(Shared.Types)

local function Render(props: { Character: Types.Rig, Wave: number?, Status: string? })
	local Position, SetPosition = React.useBinding(Vector3.zero)
	local OnScreen, SetOnScreen = React.useBinding(false)

	local Root, SetRoot = React.useState(nil :: BasePart?)

	React.useEffect(function()
		local RootPromise = Promise.try(function()
			return props.Character:FindFirstChild("HumanoidRootPart") :: BasePart
		end):andThen(function(RootPart)
			SetRoot(RootPart)
		end)

		return function()
			RootPromise:cancel()
		end
	end, { props.Character })

	Hooks.useEventConnection(RunService.PostSimulation, function()
		if not Root then
			return
		end

		local Pos, OnScr = workspace.CurrentCamera:WorldToScreenPoint(Root.Position)

		if Pos then
			SetPosition(Pos)
			SetOnScreen(OnScr)
		else
			SetOnScreen(false)
		end
	end, { Root })

	return e(Main.Frame, {
		native = {
			Position = Position:map(function(pos: Vector3)
				return UDim2.fromOffset(pos.X, pos.Y)
			end),
			Size = UDim2.fromScale(0.1, 0.1),
			Visible = OnScreen,
		},
	}, {
		Indicator = e(Indicator, {
			Wave = props.Wave,
			Status = props.Status,
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1,
			}),
		}),
	})
end

if IsTutorial then
	local ReactRoot = ReactRoblox.createRoot(Instance.new("Folder"))
	if not next(UnitClient.GetUnits()) then
		UnitClient.NewUnit:Wait()
	end

	local _, Unit = next(UnitClient.GetUnits())

	ReactRoot:render(ReactRoblox.createPortal(
		e(NewGui, {}, {
			Indicator = e(Render, {
				Character = Unit,
				Wave = 2,
			}),
		}),
		PlayerGui
	))
elseif IsLobby then
	ObserveTag.ObserveTag("NPCTalk", function(Character)
		if Character:IsA("Model") then
			local ReactRoot = ReactRoblox.createRoot(Instance.new("Folder"))
			ReactRoot:render(ReactRoblox.createPortal(
				e(NewGui, {}, {
					TutorialProvider = e(TutorialContext.Provider, {}, {
						Indicator = e(Render, {
							Character = Character :: Types.Rig,
							Status = "Active",
						}),
					}),
				}),
				PlayerGui
			))

			return function()
				ReactRoot:unmount()
			end
		end

		return function() end
	end)
end
