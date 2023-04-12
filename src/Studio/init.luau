--[[
	Provides wrappers around commonly used plugin calls.
	
]]

if script:FindFirstAncestorWhichIsA("Plugin") then
	
	return {
		Plugin = script:FindFirstAncestorWhichIsA("Plugin"),
		StudioService = game:GetService("StudioService"),
		SetMouseIcon = require(script.SetMouseIcon),
		IsFake = false
	}
	
else
	
	return {
		Plugin = require(script.Plugin),
		StudioService = require(script.StudioService),
		SetMouseIcon = require(script.SetMouseIcon),
		IsFake = true
	}
	
end