--[[
	Background creates a empty themed frame that covers the entire frame.
	
]]

local Packages = script.Parent.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local CubeCat = require(Packages.CubeCat)

local New = Fusion.New
local Spring = Fusion.Spring

local Theme = CubeCat.Util.Theme
local stripProps = CubeCat.Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Background = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,
	
	BackgroundColor: CanBeState<Enum.StudioStyleGuideColor>?,
	BackgroundModifier: CanBeState<Enum.StudioStyleGuideModifier>?,
	
	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	"BackgroundColor",
	"BackgroundModifier"
	
}

local function Background(props: Background)
	
	local BackgroundColor = props.BackgroundColor or Enum.StudioStyleGuideColor.MainBackground
	local BackgroundModifier = props.BackgroundModifier
	
	local BackgroundColor3 = Spring(Theme(BackgroundColor, BackgroundModifier), 40, 1)
	
	local Background = New "Frame" {
		
		Name = "Background",
		
		Size = UDim2.fromScale(1, 1),
		
		BackgroundColor3 = BackgroundColor3,
		
	}
	
	return Fusion.Hydrate(Background)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Background