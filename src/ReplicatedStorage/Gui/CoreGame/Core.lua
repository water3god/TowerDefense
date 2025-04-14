--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local ReactSpring = require(Packages.ReactSpring)
local e = React.createElement

local Gui = ReplicatedStorage.Gui
local Inventory = Gui.Inventory
local InventoryMain = require(Inventory.InventoryMain)

local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local MainButtonFrame = require(CoreGame.MainButtonFrame)

local IsRunning = RunService:IsRunning()

local Client = ReplicatedStorage.Client
local InventoryService = require(Client.GlobalClient.InventoryService)

local Shared = ReplicatedStorage.Shared
local Types = require(Shared.Types)

export type Properties = {
	Inventory: {
		Units: { [string]: Types.VisualUnitData },
	},
	Visible: boolean,
}

local GlobalNotVisiblePosition = UDim2.fromScale(0.5, 1)

local function AnimateWrapper(Props: { Visible: boolean })
	local Styles, API = ReactSpring.useSpring(function()
		return {
			alpha = 0,
		}
	end, {})

	local FrameRef = React.useRef(nil :: GuiObject?)
	local OriginalPosition, SetPosition = React.useState(nil :: UDim2?)
	local NotVisiblePosition, SetNotVisiblePosition = React.useState(GlobalNotVisiblePosition)

	React.useEffect(function()
		if FrameRef.current then
			SetPosition(FrameRef.current.Position)
		end
	end, {})

	React.useEffect(function()
		if OriginalPosition then
			SetNotVisiblePosition(UDim2.fromScale(OriginalPosition.X.Scale, 1))
		end
	end, { OriginalPosition })

	React.useEffect(function()
		API.stop()
		API.start({
			alpha = if Props.Visible then 0 else 1,
		})
	end, { Props.Visible })

	return Styles.alpha:map(function(alpha)
		return OriginalPosition:Lerp(NotVisiblePosition, alpha)
	end), FrameRef
end

local function RenderInventory(Props: Properties)
	local Position, FrameRef = AnimateWrapper({
		Visible = Props.Visible,
	})

	return e(InventoryMain, {
		Inventory = Props.Inventory,
		native = {
			ref = FrameRef,
			Position = Position,
		},
	})
end

local function Render()
	local VisibleFrame: string?, SetVisibleFrame = React.useState(nil :: string?)

	local Styles, API = ReactSpring.useSpring(function()
		return {
			Size = 0,
		}
	end)

	local Callback = React.useCallback(function(Name: string)
		SetVisibleFrame(Name)
	end, { VisibleFrame })

	React.useEffect(function()
		API.stop()
		API.start({
			Size = if VisibleFrame then 20 else 0,
		})
	end, { VisibleFrame })

	local function Return()
		return e(React.Fragment, nil, {
			GuiBlur = IsRunning and ReactRoblox.createPortal(
				e("BlurEffect", {
					Size = Styles.Size,
				}),
				Lighting
			),
			Main = e("Folder", {}, {
				InventoryFrame = e(RenderInventory, {
					Visible = if VisibleFrame == "InventoryFrame" then true else false,
					Inventory = InventoryService:GetInventory(),
				}),
			}),
			Buttons = e("Folder", {}, {
				InventoryButton = e(MainButtonFrame, {

					Name = "Inventory",
					Icon = "",
					OnClick = function()
						Callback("InventoryFrame")
					end,
				}),
			}),
		})
	end
	if IsRunning then
		return e("ScreenGui", {
			ResetOnSpawn = false,
		}, {
			Frag = Return(),
		}) :: any
	else
		return e(Main.Frame, {
			children = {
				Name = Return(),
			},
		}) :: any
	end
end

return Render
