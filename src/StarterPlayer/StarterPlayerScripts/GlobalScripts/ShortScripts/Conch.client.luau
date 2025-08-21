--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Conch = require(Packages.Conch)
local UI = require(Packages.Conch_ui)

local Shared = ReplicatedStorage.Shared
local _Conch_types = require(Shared.Conch_types)

Conch.register_default_commands()
Conch.initiate_default_lifecycle()
UI.bind_to(Enum.KeyCode.F4)
