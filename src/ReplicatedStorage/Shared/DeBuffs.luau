--!strict

-- By Wa1er_God --

export type Debuff = "Bleed" | "Slow"

export type DebuffData = {
	Name: string,
	Image: string,
	Color: Color3,
}

local Debuffs: { [string]: DebuffData } = {
	Bleed = { -- percentage of max health per second --
		Name = "Bleed",
		Image = "rbxassetid://13770684945",
		Color = Color3.fromRGB(255, 0, 0),
	},
	Slow = { -- percentage of normal speed --
		Name = "Slow",
		Image = "rbxassetid://13770684945",
		Color = Color3.fromRGB(0, 0, 255),
	},
}

return Debuffs
