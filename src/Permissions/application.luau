local MarketplaceService = game:GetService("MarketplaceService")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") or { Name = "Game Plugin" }

local getEmptyData = require(script.Parent.getEmptyData)

local localPlugin = string.match(plugin.Name, "user_(.*)%.")
if localPlugin then
	return getEmptyData(localPlugin)
end

local cloudId, cloudInstance = string.match(plugin.Name, "cloud_(%d-)%.(.-)[^%w_%-]")
if cloudId then
	local success, newInfo =
		pcall(MarketplaceService.GetProductInfo, MarketplaceService, tonumber(cloudId), Enum.InfoType.Asset)
	if success then
		return newInfo
	end

	-- Fallback to the name of the instance uploaded inside this plugin
	-- The reason this is not ideal is because creators often upload a folder named "Main" or something
	return getEmptyData(cloudInstance)
end

return getEmptyData("Game Plugin")
