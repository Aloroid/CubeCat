--[[
	This utility module is used by CubeCat to determine if a user plugin has the
	permission to use this plugin.
	
]]

local sharedState = require(script.Parent.sharedState)
local getPluginInfo = require(script.getPluginInfo)
local prompt = require(script.Prompt)

local Permissions = {}

function Permissions.new(identifier: string, name: string, description: string)
	local permission = {
		identifier = identifier,
		name = name,
		description = description,
		
		allowed = {}
	}
	
	sharedState.Permissions[identifier] = permission
	
	return permission
end

local function requestPrompt(plugin, requestingId, permissions)
	
	local results = prompt({ProductInfo = plugin, PermissionsRequested = permissions})
	
	for permission, result in results do
		permission.allowed[requestingId] = if result then true else nil
	end
	
	
	
	return results
	
end

function Permissions.request(permissionIdentifiers: {string})
	
	local requesting = getPluginInfo()
	local requestingId = `{requesting.AssetId}:{requesting.Creator.Id}:{requesting.Created}`
	
	local permissions = {}
	
	for _, identifier in permissionIdentifiers do
		local permission = sharedState.Permissions[identifier]
		assert(permission, `[CubeCat] Unable to find permission with the identifier "{identifier}"`)
		
		table.insert(permissions, permission)
	end
	
	requestPrompt(requesting, requestingId, permissions)
	
end

function Permissions.has(identifier: string): boolean
	
	local requesting = getPluginInfo()
	local requestingId = `{requesting.AssetId}:{requesting.Creator.Id}`
	
	-- We'll have to see if the user plugin is allowed to use the given feature
	local permission = sharedState.Permissions[identifier]
	assert(permission, `[CubeCat] Unable to find permission with the identifier "{identifier}"`)
	
	if permission.allowed[requestingId] then
		return true
	else
		requestPrompt(requesting, requestingId, {permission})
		
		return permission.allowed[requestingId], `[CubeCat] "{requesting.Name}" lacks permission "{identifier}"`
	end
	
end

return Permissions