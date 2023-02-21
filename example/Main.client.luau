--[[
	Starts all the modules and such
	
]]

local Packages = script.Parent.Packages
local Services = script.Parent.Services

print("Requiring CubeCat")
local CubeCat = require(Packages.CubeCat)

print("Adding Services")
CubeCat.AddServices(Services:GetChildren())
print("Starting")
CubeCat.Start()
print("Started")