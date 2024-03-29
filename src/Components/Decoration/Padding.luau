--[[
	This component is used to offset components from the borders. This is useful
	to make UI not intersect with eachother or have empty space in-between to
	prevent misclicks from the user.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local New = Fusion.New
local Computed = Fusion.Computed

local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Padding = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Padding: CanBeState<number>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Padding",
}

local function Padding(props: Padding)
	local padding = props.Padding or 4
	local defaultPadding = Computed(function()
		return UDim.new(0, unwrap(padding))
	end)

	local Padding = New "UIPadding" {

		PaddingTop = defaultPadding,
		PaddingLeft = defaultPadding,
		PaddingRight = defaultPadding,
		PaddingBottom = defaultPadding,
	}

	return Fusion.Hydrate(Padding)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Padding
