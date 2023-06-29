--[[
	Text displays the given Text.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local New = Fusion.New
local Spring = Fusion.Spring
local Computed = Fusion.Computed
local Children = Fusion.Children

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
	NoList: CanBeState<boolean>?,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Text",
	"TextColor",
	"TextModifier",
	"NoList",
}

local function Text(props: Text)
	local TextColor3 = Spring(Theme(props.TextColor or Enum.StudioStyleGuideColor.MainText, props.TextModifier), 40, 1)
	local NoList = props.NoList

	local Text = New "TextLabel" {

		Name = "Text",

		AutomaticSize = Enum.AutomaticSize.XY,

		BackgroundTransparency = 1,

		Text = props.Text,
		TextColor3 = TextColor3,
		TextSize = 18,
		FontFace = Font.fromEnum(Enum.Font.SourceSans),

		[Children] = Computed(function()
			if unwrap(NoList) then
				return nil
			end
			return New "UIListLayout" {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}
		end, Fusion.cleanup),
	}

	return Fusion.Hydrate(Text)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Text
