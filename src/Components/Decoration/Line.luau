local Packages = script.Parent.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local CubeCat = require(Packages.CubeCat)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children
local Spring = Fusion.Spring

local Theme = CubeCat.Util.Theme
local unwrap = CubeCat.Util.unwrap
local stripProps = CubeCat.Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Line = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,
	
	LineThickness: CanBeState<number>?,
	LineColor: CanBeState<Enum.StudioStyleGuideColor>?,
	LineModifier: CanBeState<Enum.StudioStyleGuideColor>?,
	
	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	"LineThickness",
	"LineColor",
	"LineModifier"
	
}

local function Line(props: Line)
	
	local LineThickness = props.LineThickness or 2
	local LineColor = props.LineColor or Enum.StudioStyleGuideColor.SubText
	local LineModifier = props.LineModifier
	
	local LineColor3 = Spring(Theme(LineColor, LineModifier), 40, 1)
	
	local Line = New "Frame" {
		
		Name = "Line",
		
		Size = Computed(function()
			return UDim2.new(1, 0, 0, unwrap(LineThickness))
		end, Fusion.doNothing),
		
		BackgroundTransparency = 1,
		
		[Children] = New "Frame" {
			
			Size = UDim2.new(1, -32, 1, 0),
			Position = UDim2.fromScale(0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			
			BackgroundColor3 = LineColor3
			
		}
		
	}
	
	
	return Fusion.Hydrate(Line)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Line