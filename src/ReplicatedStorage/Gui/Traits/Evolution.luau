--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

-- Libraries --
local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

local Network = require(ReplicatedStorage.Network.Client)
local EvolveUnit = Network.EvolveUnit
local UnitEvolved = Network.UnitEvolved

local Touched = require(ReplicatedStorage.Network.ClientOnly).EvolutionTouched

-- Reference UI --
local Gui = ReplicatedStorage.Gui
local CoreGame = Gui.CoreGame
local Main = require(CoreGame.Main)
local UIStroke = require(CoreGame.UIStroke)
local CloseButton = require(CoreGame.CloseButton)
local Title = require(CoreGame.Title)
local Hooks = require(CoreGame.Hooks)

local Components = Gui.Components
local Plus = require(Components.Plus)

local InventoryFolder = Gui.Inventory
local InventoryContext = require(InventoryFolder.InventoryContext)
local PromptContext = require(InventoryFolder.PromptContext)

local UnitFrame = require(InventoryFolder.UnitFrame)
local ResourceFrame = require(InventoryFolder.ResourceFrame)

local WarningFolder = Gui.Warning
local WarningContext = require(WarningFolder.WarningContext)

local GlobalClient = ReplicatedStorage.Client.GlobalClient
local SFXService = require(GlobalClient.SFXService)

local Shared = ReplicatedStorage.Shared
local Evolutions = require(Shared.Evolutions)

local Sounds = SoundService.SoundEffects.Sounds
local Evolve_Zap = Sounds.Evolve_Zap

export type Properties = {
	SetVisible: (() -> ())?,
	CloseClick: (() -> ())?,
	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function CreateEvolution(props: Properties)
	local InventoryData = React.useContext(InventoryContext.Context)
	local PromptData = React.useContext(PromptContext.Context)
	local WarningData = React.useContext(WarningContext.Context)

	local CurrentUnit, SetCurrentUnit = React.useState(nil :: any)
	local ProductUnit, SetProductUnit = React.useState(nil :: any)
	local Resources, SetResources = React.useState({} :: { Evolutions.EvolutionResource })

	local PromptVisible = React.useRef(false)

	local OnPlusClick = React.useCallback(function()
		PromptData.SetVisible(true)
		PromptVisible.current = true
	end, { PromptData })

	local EvolveClick = React.useCallback(function()
		if CurrentUnit and Resources then
			for _, Resource in ipairs(Resources) do
				local ResourceInv = InventoryData.Resources[Resource.Name]
				if not ResourceInv or ResourceInv.Count < Resource.Amount then
					WarningData.Add(string.format("Not enough %s!", Resource.Name))
					return
				end
			end
			EvolveUnit.Fire({
				UniqueId = CurrentUnit.UniqueId,
			})
		end
	end, { CurrentUnit, Resources } :: { unknown })

	Hooks.useEventConnection(PromptData.Added, function(Id: string, OpenFrame: string)
		if PromptVisible.current then
			PromptData.SetVisible(false)
			PromptData.ClearIds()
			PromptVisible.current = false

			local CurrentUnitData = InventoryData.Units[Id]

			if not CurrentUnitData then
				WarningData.Add("Error: Unit not found")
				return
			end

			local EvolutionData = Evolutions[CurrentUnitData.Unit]

			if CurrentUnitData and EvolutionData and OpenFrame == "Unit" then
				SetCurrentUnit({
					Level = CurrentUnitData.Level,
					Trait = CurrentUnitData.Trait,
					UnitName = CurrentUnitData.Unit,
					UniqueId = CurrentUnitData.UniqueId,
				})
				SetProductUnit({
					Level = 1,
					UnitName = EvolutionData.Evolution,
				})
				SetResources(EvolutionData.Resources)
			else
				WarningData.Add("This unit cannot be evolved!")
			end
		end
	end, { InventoryData })

	Hooks.useEventConnection(Touched, function()
		if props.SetVisible then
			props.SetVisible()
		end
	end, { props.SetVisible })

	Hooks.useZapConnection(UnitEvolved, function(Data: { UnitName: string })
		SetCurrentUnit(nil)
		SetResources({})
		SetProductUnit({
			Level = 1,
			UnitName = Data.UnitName,
		})
		SFXService.PlaySoundGlobal(Evolve_Zap)
	end, {})

	local ResourceFrames = React.useMemo(function()
		local Frames: { [string]: React.Node } = {}
		for Index, Resource in ipairs(Resources) do
			local ResourceInv = InventoryData.Resources[Resource.Name]
			local Count = 0

			if ResourceInv then
				Count = ResourceInv.Count
			end

			Frames["Resource" .. Index] = e(ResourceFrame, {
				Name = Resource.Name,
				LeftValue = string.format("%d/%d", Count, Resource.Amount),
			})
		end

		return Frames
	end, { Resources })

	local CloseClick = React.useCallback(function()
		if props.CloseClick then
			props.CloseClick()
		end
		PromptData.SetVisible(false)
	end, { props.CloseClick, PromptData } :: { unknown })

	return e(Main.Frame, {
		native = Join({
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0.062745, 0.062745, 0.062745),
			Size = UDim2.fromScale(0.7, 0.6),
		}, props.native),
	}, {
		UISizeConstraint = e("UISizeConstraint", {
			MinSize = Vector2.new(310, 230),
			MaxSize = Vector2.new(1240, 920),
		}),
		InputLabel = e(Main.TextLabel, {
			native = {
				Position = UDim2.fromScale(0.5, 0.15),
				Size = UDim2.fromScale(0.8, 0.08),
				Text = "Select a unit to evolve",
				TextColor3 = Color3.new(1, 1, 1),
				TextScaled = true,
			},
		}),
		InputFrame = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.35, 0.5),
				Position = UDim2.fromScale(0.25, 0.5),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.298039, 0.094118, 0.470588),
			},
		}, {
			UIListLayout = e("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0.1),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Color = Color3.new(0.388235, 0.101961, 0.486275),
				Stroke = 0.01,
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
			Plus = not CurrentUnit and e(Plus, {
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.4, 0.4),
					[React.Event.MouseButton1Click] = OnPlusClick,
				},
			}),
			CurrentUnit = CurrentUnit and e(UnitFrame.CreateUnitFrame, {
				UnitName = CurrentUnit.UnitName,
				Level = CurrentUnit.Level,
				Trait = CurrentUnit.Trait,
				OnClick = OnPlusClick,
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.4, 0.4),
				},
			}),
			ResourceFrames = #Resources > 0 and e(Main.Frame, {
				native = {
					Position = UDim2.fromScale(0.5, 0.85),
					Size = UDim2.fromScale(0.8, 0.3),
					LayoutOrder = 2,
				},
			}, {
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
			}, ResourceFrames),
		}),
		Arrow = e(Main.ImageLabel, {
			native = {
				Size = UDim2.fromScale(0.1, 0.15),
				Image = "rbxassetid://90650317828395",
				ImageColor3 = Color3.new(0.376471, 0.117647, 0.588235),
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 1.4,
			}),
		}),
		ProductFrame = e(Main.Frame, {
			native = {
				Size = UDim2.fromScale(0.35, 0.5),
				Position = UDim2.fromScale(0.75, 0.5),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0.298039, 0.094118, 0.470588),
			},
		}, {
			Empty = not ProductUnit and e(Plus, {
				Text = "?",
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.4, 0.4),
				},
			}),
			ProductUnit = ProductUnit and e(UnitFrame.CreateUnitFrame, {
				UnitName = ProductUnit.UnitName,
				Level = ProductUnit.Level,
				Hidden = if CurrentUnit then true else false,
				native = {
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.4, 0.4),
				},
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Color = Color3.new(0.388235, 0.101961, 0.486275),
				Stroke = 0.01,
				native = {
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
		EvolveButton = e(Main.Animateables.ImageButton, {
			native = {
				Position = UDim2.fromScale(0.5, 0.875),
				Size = UDim2.fromScale(0.3, 0.1),
				Image = "rbxassetid://80739823452825",
				ImageColor3 = Color3.fromRGB(135, 1, 203),
				[React.Event.MouseButton1Click] = EvolveClick,
			},
		}, {
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = 3.5,
			}),
			Label = e(Main.TextLabel, {
				native = {
					Size = UDim2.fromScale(0.7, 0.7),
					Text = "EVOLVE!",
				},
			}, {
				UIStroke = e(UIStroke.UIStrokeAdvanced, {
					Stroke = 0.03,
				}),
			}),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = 1.5,
		}),
		Title = e(Title, {
			Position = UDim2.fromScale(0.2, -0.02),
			Size = UDim2.fromScale(0.6, 0.3),
			Title = "EVOLUTION",
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.02, 0),
		}),
		CloseButton = e(CloseButton, {
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.3, 0.2),
			OnClick = CloseClick,
		}),
		InnerFrame = e(Main.Frame, {
			native = {
				Position = UDim2.fromScale(0.5, 0.52),
				Size = UDim2.fromScale(0.94, 0.9),
			},
		}, {
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.015, 0),
			}),
			UIStroke = e(UIStroke.UIStrokeAdvanced, {
				Color = Color3.new(0.388235, 0.101961, 0.486275),
				Stroke = 0.002,
				native = {
					Transparency = 0.1,
					LineJoinMode = Enum.LineJoinMode.Round,
				},
			}),
		}),
		UIStroke = e(UIStroke.UIStrokeAdvanced, {
			Color = Color3.new(0.866667, 0.866667, 0.866667),
			Stroke = 0.002,
			native = {
				LineJoinMode = Enum.LineJoinMode.Round,
			},
		}),
	}, props.children)
end

return CreateEvolution
