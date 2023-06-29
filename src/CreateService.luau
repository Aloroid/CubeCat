--!nocheck
local sharedState = require(script.Parent.sharedState)

type CubeCatService = {
	Name: string,
	Public: { [any]: any }?,
	ExportAll: boolean?,
}

local function CreateService<T>(service: T & CubeCatService): T
	assert(service.Name, "Service requires a Name")

	sharedState.Services[service.Name] = service
	service.Public = service.Public or {}
	service.Public.Name = service.Name

	return service
end

return CreateService
