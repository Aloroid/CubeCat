--[[
	A function that is used to import a instance from the current CubeCat framework.
	
]]

local sharedState = require(script.Parent.sharedState)
local Runtime = require(script.Parent.Runtime)

local function Import(to: string)
	return Runtime(function(oldValue)
		local export = sharedState.PublicExportInstances[to] or {}
		return export.instance, oldValue ~= export.instance
	end),
		Runtime(function(oldValue)
			local export = sharedState.PublicExportInstances[to] or {}
			return export.values, oldValue ~= export.values
		end)
end

return Import
