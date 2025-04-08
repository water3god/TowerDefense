--!strict

-- By Wa1er_God --

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");

local Modules = ReplicatedStorage.Modules;
local Trove = require(Modules.Trove);
local GoodSignal = require(Modules.GoodSignal);

type DialogInput = {
	Character: Model;
	Dialog: {string};
};

type DialogData = {
	_Trove: Trove.Trove;

	Character: Model;
	Dialog: {string};
};

type DialogImpl = {
	new: (Input: DialogInput) -> Dialog;

	Delete: (self: Dialog) -> ();

	__index: DialogImpl;
};

export type Dialog = typeof(setmetatable({} :: DialogData, {} :: DialogImpl))

local Dialog: DialogImpl = {} :: DialogImpl;
Dialog.__index = Dialog;

function Dialog.new(Input: DialogInput)
	local self = setmetatable({}, Dialog) :: Dialog;

	self._Trove = Trove.new();
	self.Character = Input.Character;
	self.Dialog = Dialog;
	
	local Proximity: ProximityPrompt = self._Trove:Construct(Instance, "ProximityPrompt");
	Proximity.Name = "DialogPrompt";
	Proximity.Style = Enum.ProximityPromptStyle.Custom;
	
	Proximity.Parent = self.Character;
	
	Proximity.PromptShown:Connect(function(InputType: Enum.ProximityPromptInputType)
		
	end)
	
	Proximity.PromptHidden:Connect(function()
		
	end)

	return self;
end

function Dialog:Delete()

end

return Dialog;

