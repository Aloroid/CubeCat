local MarketplaceService = game:GetService("MarketplaceService")
local StudioService = game:GetService("StudioService")

local cloudIdInfoCache = {}

local getEmptyData = require(script.Parent.getEmptyData)

export type ProductData = {
	
	Name: string,
	Description: string?,
	PriceInRobux: number,
	Created: string,
	Updated: string,
	ContentRatingTypeId: number,
	MinimumMembershipLevel: number,
	IsPublicDomain: boolean,
	AssetId: number,
	AssetTypeId: number,
	IsForSale: boolean,
	IsLimited: boolean,
	IsLimitedUnique: boolean,
	IsNew: boolean,
	Sales: number,
	TargetId: number,
	
	Creator: {
		CreatorTargetId: number,
		CreatorType: string,
		HasVerifiedBadge: boolean,
		Id: number,
		Name: string
	}
	
}

local function getPluginCalling(): ProductData
	
	local traceback = string.split(debug.traceback(), "\n")
	local topLevel = traceback[#traceback - 1]
	
	local localPlugin = string.match(topLevel, "^[PluginDebugService%.]-user_(.-)%.")
	if localPlugin then
		return getEmptyData(localPlugin)
	end

	local cloudId, cloudInstance = string.match(topLevel, "^cloud_(%d-)%.(.-)[^%w_%-]")
	if cloudId then
		local info = cloudIdInfoCache[cloudId]
		if info then
			return info
		else
			local success, newInfo = pcall(MarketplaceService.GetProductInfo, MarketplaceService, tonumber(cloudId), Enum.InfoType.Asset)
			if success then
				cloudIdInfoCache[cloudId] = newInfo
				return newInfo
			end
		end

		-- Fallback to the name of the instance uploaded inside this plugin
		-- The reason this is not ideal is because creators often upload a folder named "Main" or something
		local newInfo = getEmptyData(cloudInstance)
		cloudIdInfoCache[cloudId] = newInfo
		return newInfo
	end

	return getEmptyData("Command Bar", StudioService:GetUserId())
	
end

return getPluginCalling