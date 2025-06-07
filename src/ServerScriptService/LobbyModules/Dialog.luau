--!strict

-- By Wa1er_God --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local Packages = ReplicatedStorage.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

type DialogInput = {
	Character: Model,
	Dialog: { string },
}

type DialogData = {
	_Trove: Trove.Trove,

	Charater: Model,
	Dialog: { string },
}

type DialogImpl = {
	new: (Input: DialogInput) -> Dialog,

	Delete: (self: Dialog) -> (),

	__index: DialogImpl,
}

export type Dialog = typeof(setmetatable({} :: DialogData, {} :: DialogImpl))

local Dialog: DialogImpl = {} :: DialogImpl
Dialog.__index = Dialog

function Dialog.new(Input: DialogInput)
	local self = setmetatable({}, Dialog) :: Dialog

	self._Trove = Trove.new()
	self.Charater = Input.Character
	self.Dialog = Dialog

	return self
end

function Dialog:Delete() end

return Dialog
