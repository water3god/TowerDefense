--!strict

-- By Wa1er_God --

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local ReactLua = ReplicatedStorage.Modules.ReactLua;
local React = require(ReactLua.React);
local e = React.createElement;

local Gui = ReplicatedStorage.Gui;
local Inventory = Gui.Inventory;
local InventoryMain = require(Inventory.InventoryMain);
local StatsFrame = require(Inventory.StatsFrame);
local UnitFrame = require(Inventory.UnitFrame);