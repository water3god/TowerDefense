--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UnitFrame = require(Gui.Inventory.UnitFrame)

local GameFrames = Gui.GameFrames
local EquippedUnitsContext = require(GameFrames.EquippedUnitsContext)

local Shared = ReplicatedStorage.Shared
local LevelRequirements = require(Shared.LevelRequirements)

export type Properties = {
	native: { [any]: any }?,
	children: { [any]: any }?,
}

export type OtherProps = {
	UnitName: string?,
	GlobalLevel: number,
	Level: number?,
	LevelReq: number,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateBaseFrame(Properties: OtherProps)
	local BelowLevel = Properties.GlobalLevel < Properties.LevelReq
	local IsDisabled = BelowLevel or not Properties.UnitName
	return e(UnitFrame.CreateUnitFrame, {
		UnitName = if Properties.UnitName and not IsDisabled then Properties.UnitName else "BLANK",
		Disabled = IsDisabled,
		Level = Properties.Level or 1,
		native = Properties.native,
		children = Properties.children,
		containerChildren = {
			Lock = e(Main.ImageLabel, {
				native = {
					Position = UDim2.fromScale(0.5, 0.4),
					Size = UDim2.fromScale(0.4, 0.4),
					Visible = BelowLevel,
					Image = "rbxassetid://106849723034867",
					ZIndex = 2,
				},
				children = {
					UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
						AspectRatio = 0.83,
					}),
				},
			}),
			LevelLock = e(Main.TextLabel, {
				native = {
					Visible = BelowLevel,
					Position = UDim2.fromScale(0.5, 0.75),
					Size = UDim2.fromScale(0.85, 0.2),
					Text = string.format("Level %u", Properties.LevelReq or 1),
				},
			}),
		},
	})
end

local Size = UDim2.fromScale(0.15, 0.6)

local function CreateBottomFrame(Properties: Properties)
	local Context = React.useContext(EquippedUnitsContext.Context)
	local Units = Context.Value
	return e(Main.CanvasGroup, {
		native = Join({
			Size = UDim2.fromScale(0.4, 0.2),
			Position = UDim2.fromScale(0.5, 0.9),
		}, Properties.native),
		children = Join({
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.555,
			}),
			Frame1 = e(CreateBaseFrame, {
				LevelReq = LevelRequirements.EquippedFrames[1],
				UnitName = Units[1] and Units[1].Unit,
				Level = Units[1] and Units[1].Level,
				GlobalLevel = Context.GlobalLevel,
				native = {
					Position = UDim2.fromScale(0.15, 0.35),
					Size = Size,
				},
			}),
			Frame2 = e(CreateBaseFrame, {
				LevelReq = LevelRequirements.EquippedFrames[2],
				UnitName = Units[2] and Units[2].Unit,
				Level = Units[2] and Units[2].Level,
				GlobalLevel = Context.GlobalLevel,
				native = {
					Position = UDim2.fromScale(0.325, 0.35),
					Size = Size,
				},
			}),
			Frame3 = e(CreateBaseFrame, {
				LevelReq = LevelRequirements.EquippedFrames[3],
				UnitName = Units[3] and Units[3].Unit,
				Level = Units[3] and Units[3].Level,
				GlobalLevel = Context.GlobalLevel,
				native = {
					Position = UDim2.fromScale(0.5, 0.35),
					Size = Size,
				},
			}),
			Frame4 = e(CreateBaseFrame, {
				LevelReq = LevelRequirements.EquippedFrames[4],
				UnitName = Units[4] and Units[4].Unit,
				Level = Units[4] and Units[4].Level,
				GlobalLevel = Context.GlobalLevel,
				native = {
					Position = UDim2.fromScale(0.675, 0.35),
					Size = Size,
				},
			}),
			Frame5 = e(CreateBaseFrame, {
				LevelReq = LevelRequirements.EquippedFrames[5],
				UnitName = Units[5] and Units[5].Unit,
				Level = Units[5] and Units[5].Level,
				GlobalLevel = Context.GlobalLevel,
				native = {
					Position = UDim2.fromScale(0.85, 0.35),
					Size = Size,
				},
			}),
		}, Properties.children),
	})
end

return CreateBottomFrame
