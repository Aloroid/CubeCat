local function getEmptyData(name: string?, userId: number?)
	
	return {
					
		Name = name or "Unknown",
		Description = nil,
		PriceInRobux = 0,
		Created = DateTime.now():ToIsoDate(),
		Updated = DateTime.now():ToIsoDate(),
		ContentRatingTypeId = 0,
		MinimumMembershipLevel = 0,
		IsPublicDomain = true,
		
		Creator = {
			CreatorTargetId = userId or 0,
			CreatorType = "User",
			HasVerifiedBadge = false,
			Id = userId or 0,
			Name = ""
		},
		
		AssetId = 0,
		AssetTypeId = 38,
		IsForSale = false,
		IsLimited = false,
		IsLimitedUnique = false,
		IsNew = false,
		Sales = 0,
		TargetId = 0
		
	}
	
end

return getEmptyData