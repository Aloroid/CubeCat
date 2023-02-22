--[[
	Calls :Init on every service and allows other plugins to access this plugin.
	TODO: Develop a proper public api
	
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
	
	-- We've started
	table.freeze(publicTables)
	
	if not shared.CubeCat then
		shared.CubeCat = {}
	end
	
	shared.CubeCat[plugin.Name] = function()
		return publicTables
	end
	
	
end