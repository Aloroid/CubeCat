--[[
	Calls :Init on every service
	
]]

local plugin = script:FindFirstAncestorWhichIsA("Plugin")

local sharedState = require(script.Parent.sharedState)

return function()
	
	local publicTables = {}
	for serviceName, service in sharedState.Services do
		if service.Init then
			
			task.spawn(function()
				service:Init()
			end)
			
			publicTables[serviceName] = service.Public
			
		end
	end
	
	-- We've initiated, let's open up the flood gates >:)
	table.freeze(publicTables)
	
	if not _G.CubeCat then
		_G.CubeCat = {}
	end
	
	_G.CubeCat[plugin.Name] = function()
		return publicTables
	end
	
	
end