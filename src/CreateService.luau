
local sharedState = require(script.Parent.sharedState)

type CubeCatService = {
	Name: string,
	Public: {[any]: any}
	
}

local function CreateService<T>(service: T & CubeCatService): T & CubeCatService
	sharedState.Services[service.Name] = service
	service.Public = service.Public or {}
	
	return service
end

return CreateService