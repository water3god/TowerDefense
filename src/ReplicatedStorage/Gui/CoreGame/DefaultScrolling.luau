--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local React = require(Packages.React)
local e = React.createElement

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local Join = HelperFunctions.joinDicts

export type Properties = {
	BarSize: number?,

	native: { [any]: any }?,
	children: { [any]: any }?,
}

local function GetScrollingSize(Size: number, selfRef: any)
	if selfRef.current then
		return math.ceil(Size * selfRef.current.AbsoluteSize.X)
	else
		return 1
	end
end

local function CreateDefaultScrolling(Properties: Properties)
	local BarSize = Properties.BarSize or 0.1
	local selfRef = React.useRef(nil)
	local Bar, SetBar = React.useState(1)

	React.useEffect(function()
		if selfRef.current then
			SetBar(GetScrollingSize(BarSize, selfRef))
		end
	end, { Properties.BarSize })

	return e(
		"ScrollingFrame",
		Join({
			ref = selfRef,

			ScrollBarThickness = Bar,
			[React.Change.AbsoluteSize] = function()
				SetBar(GetScrollingSize(BarSize, selfRef))
			end,
		}, Properties.native),
		Properties.children
	)
end

return CreateDefaultScrolling
