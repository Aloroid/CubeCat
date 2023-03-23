--[[
	Provides wrappers around commonly used plugin calls.
	
]]

if script:FindFirstAncestorWhichIsA("Plugin") then
	
	return {
		Plugin = script:FindFirstAncestorWhichIsA("Plugin"),
		StudioService = game:GetService("StudioService"),
		IsFake = false
	}
	
else
	
	return {
		Plugin = require(script.Plugin),
		StudioService = require(script.StudioService),
		IsFake = true
	}
	
end