--[[
	This utility module is used by CubeCat to determine if a user plugin has the
	permission to use this plugin.
	
]]

local MarketplaceService = game:GetService("MarketplaceService")

local sharedState = require(script.Parent.sharedState)

local Permissions = {}
local cloudIdInfoCache = {}

local ancestorPlugin = script:FindFirstAncestorWhichIsA("Plugin")

function Permissions.new(name: string, description: string)
	local permission = {
		name = name,
		description = description,
		
		allowed = {}
	}
	
	sharedState.Permissions[name] = permission
	
	return permission
end

local function _getPluginName()
	
	local traceback = string.split(debug.traceback(), "\n")
	local topLevel = traceback[#traceback - 1]

	local localPlugin = string.match(topLevel, "user_(.-)%.")
	if localPlugin then
		return localPlugin
	end
	
	if topLevel == ancestorPlugin.Name then
		return "Main Plugin", true
	end

	local cloudId, cloudInstance = string.match(topLevel, "cloud_(%d-)%.(.-)[^%w_%-]")
	if cloudId then
		local info = cloudIdInfoCache[cloudId]
		if info then
			return info.Name .. " by " .. info.Creator.Name
		else
			local success, newInfo = pcall(MarketplaceService.GetProductInfo, MarketplaceService, tonumber(cloudId), Enum.InfoType.Asset)
			if success then
				cloudIdInfoCache[cloudId] = newInfo
				return newInfo.Name .. " by " .. newInfo.Creator.Name
			end
		end

		-- Fallback to the name of the instance uploaded inside this plugin
		-- The reason this is not ideal is because creators often upload a folder named "Main" or something
		return cloudInstance
	end

	return "Command Bar"
	
end

function Permissions.HasPermission(name: string): boolean
	
	local requesting, isSelf = _getPluginName()
	
	-- We are being called by our own plugin, so we already have permission.
	if isSelf then
		return true
	end
	
	-- We'll have to see if the user plugin is allowed to use the given feature
	local permission = sharedState.Permissions
	
	assert(permission, `[CubeCat] Unable to find permission with the name "{name}"`)
	
	if permission.allowed[requesting] ~= true then
		--TODO: Prompt the user if they want to allow the plugin
		--		to inject into the given game.
		return false
	else
		return true
	end
	
end

return Permissions