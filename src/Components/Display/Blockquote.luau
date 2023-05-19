--[[
	Text displays the given Text.
	Headers are just bigger lol
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local Background = require(Components.Decoration.Background)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Out = Fusion.Out
local Children = Fusion.Children

local Theme = Util.Theme
local stripProps = Util.stripProps
local unwrap = Util.unwrap

type CanBeState<T> = Fusion.CanBeState<T>
export type Text = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<UDim2>?,
	
}

local COMPONENT_ONLY_PROPERTIES = {
	Children
}

local function Text(props: Text)
	
	local size = Value(Vector2.zero)
	
	local Text = New "Frame" {
		
		Name = "Blockquote",
		
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		
		BackgroundTransparency = 1,
		
		[Children] = {
			
			New "UIListLayout" {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
			},
			
			New "Frame" {
				
				Size = Computed(function()
					local currentSize = unwrap(size) or Vector2.zero
					return UDim2.new(0, 8, 0, currentSize.Y)
				end),
				
				BackgroundColor3 = Theme(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Selected),
				
			},
			
			Background {
				
				Size = UDim2.new(1, -16, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				
				[Children] = props[Children],
				[Out "AbsoluteSize"] = size
				
			}
			
		}
		
	}
	
	return Fusion.Hydrate(Text)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Text