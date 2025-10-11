--!strict

-- By Wa1er_God --

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules
local HelperFunctions = require(Modules.HelperFunctions)
local ObserveTag = require(Modules.ObserveTag)

local Packages = ReplicatedStorage.Packages
local Signal = require(Packages.Signal)

local ClientOnly = require(ReplicatedStorage.Network.ClientOnly)
local VFXEmit = ClientOnly.VFXEmit

local VFX: { [string]: { [ParticleEmitter]: boolean } } = {}

VFXEmit:Connect(function(Name: string, Connector: (Emitter: ParticleEmitter) -> () | number?)
	if VFX[Name] then
		for Emitter, _ in pairs(VFX[Name]) do
			if typeof(Connector) == "function" then
				Connector(Emitter)
			elseif typeof(Connector) == "number" then
				Emitter:Emit(Connector)
			else
				Emitter:Emit()
			end
		end
	end
end)

ObserveTag.ObserveTag("VFX", function(Emitter: Instance)
	local Name = Emitter:GetAttribute("VFXName")

	if typeof(Name) ~= "string" then
		warn(Emitter:GetFullName(), "VFX emitter missing VFXName attribute")
		return
	end

	if not Emitter:IsA("ParticleEmitter") then
		warn(Emitter:GetFullName(), "VFX emitter is not a ParticleEmitter")
		return
	end

	if not VFX[Name] then
		VFX[Name] = {}
	end

	VFX[Name][Emitter] = true

	return function()
		VFX[Name][Emitter] = nil
		if not next(VFX[Name]) then
			VFX[Name] = nil
		end
	end
end)
