--[[
	This function should be used for returning the provided theme color associated
	with the given GuideColor and GuideModifier, this makes it incredibly easy for
	developers to retrieve a Theme that automatically updates according to theme
	changes.
	
]]

local Packages = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)

local Colors = require(script.Colors)

type CanBeState<T> = Fusion.CanBeState<T>?
type Computed<T> = Fusion.Computed<T>

local function Theme(GuideColor: CanBeState<Enum.StudioStyleGuideColor>, GuideModifier: CanBeState<Enum.StudioStyleGuideModifier>): Computed<Color3 | string>
	
	return Colors(GuideColor, GuideModifier)
	
end

return Theme