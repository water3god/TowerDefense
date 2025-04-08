--!strict

-- By Wa1er_God --

-- Meant for editing the client showcase of Units (lobby only type) --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local UnitStorage = ReplicatedStorage.ModelStorage.Units;

type UnitAnimName = "Idle";

type UnitData = {
	ModelName: string;
	Character: Model;
	Animations: {[string | UnitAnimName]: string};
	ViewerCFrame: CFrame?;
	DefaultImage: string;
};

local UnitData: {[string]: UnitData} = {
	["Scout"] = {
		ModelName = "Scout";
		Character = UnitStorage.Scout;
		Animations = {
			Idle = "rbxassetid://1";
		};
		DefaultImage = "";
	};
	["Shocker"] = {
		ModelName = "Shocker";
		Character = UnitStorage.Shocker;
		Animations = {
			Idle = "rbxassetid://1";
		};
		DefaultImage = "";
	};
	["Sniper"] = {
		ModelName = "Sniper";
		Character = UnitStorage.Sniper;
		Animations = {
			Idle = "rbxassetid://1";
		};
		DefaultImage = "";
	};
	["Shotgunner"] = {
		ModelName = "Shotgunner";
		Character = UnitStorage.Shotgunner;
		Animations = {
			Idle = "rbxassetid://1";
		};
		DefaultImage = "";
	};
	["Minigunner"] = {
		ModelName = "Minigunner";
		Character = UnitStorage.Minigunner;
		Animations = {
			Idle = "rbxassetid://1";
		};
		DefaultImage = "";
	};
};

return UnitData;

