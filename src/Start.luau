--[[
	Calls :Init on every service
	
]]

local sharedState = require(script.Parent.sharedState)

return function()
	
	for serviceName, service in sharedState.Services do
		if service.Init then
			service:Init()
		end
	end
	
end