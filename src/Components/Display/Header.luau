--[[
	Text displays the given Text.
	Headers are just bigger lol
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local New = Fusion.New
local Computed = Fusion.Computed
local Spring = Fusion.Spring

local Theme = Util.Theme
local stripProps = Util.stripProps
local unwrap = Util.unwrap

type CanBeState<T> = Fusion.CanBeState<T>
export type Text = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<UDim2>?,
	
	Text: CanBeState<string>,
	TextColor: CanBeState<Enum.StudioStyleGuideColor>?,
	TextModifier: CanBeState<Enum.StudioStyleGuideModifier>?,
	HeaderSize: CanBeState<number>?
	
}

local HEADER_SIZES = {
	32,
	24,
	19,
	16,
	13,
	10
}

local COMPONENT_ONLY_PROPERTIES = {
	"Text",
	"TextColor",
	"TextModifier",
	"HeaderSize"
}

local function Text(props: Text)
	
	local TextColor3 = Spring(Theme(props.TextColor or Enum.StudioStyleGuideColor.MainText, props.TextModifier), 40, 1)
	local headerSize = props.HeaderSize
	
	local Text = New "TextLabel" {
		
		Name = "Text",
		
		AutomaticSize = Enum.AutomaticSize.XY,
		
		BackgroundTransparency = 1,
		
		Text = props.Text,
		TextColor3 = TextColor3,
		TextSize = Computed(function()
			return HEADER_SIZES[unwrap(headerSize)]
		end),
		FontFace = Font.fromEnum(Enum.Font.SourceSans)
		
	}
	
	return Fusion.Hydrate(Text)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Text