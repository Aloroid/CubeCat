local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local CubeCat = require(Packages.CubeCat)

local Text = require(Components.Display.Text)
local Border = require(Components.Decoration.Border)
local Padding = require(Components.Decoration.Padding)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Spring = Fusion.Spring

local Theme = CubeCat.Util.Theme
local Statify = CubeCat.Util.Statify
local unwrap = CubeCat.Util.unwrap
local stripProps = CubeCat.Util.stripProps
local guideState = CubeCat.Util.guideState
local mapGuideModifier = CubeCat.Util.mapGuideColor

type CanBeState<T> = Fusion.CanBeState<T>
export type Button = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,
	
	Text: CanBeState<string>?,
	
	BackgroundColor: CanBeState<Enum.StudioStyleGuideColor>?,
	BackgroundModifier: CanBeState<Enum.StudioStyleGuideColor>?,
	BorderColor: CanBeState<Enum.StudioStyleGuideColor>?,
	BorderModifier: CanBeState<Enum.StudioStyleGuideModifier>?,
	TextColor: CanBeState<Enum.StudioStyleGuideColor>?,
	TextModifier: CanBeState<Enum.StudioStyleGuideModifier>?,
	
	Disabled: CanBeState<boolean>?,
	Selected: CanBeState<boolean>?,
	Pressed: CanBeState<boolean>?,
	Hovering: CanBeState<boolean>?,
	
	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	"Text",
	"BackgroundColor",
	"BackgroundModifier",
	"BorderColor",
	"BorderModifier",
	"TextColor",
	"TextModifier",
	"Disabled",
	"Selected",
	"Pressed",
	"Hovering",
	Children
}
local CORNER_RADIUS = 3

local function Button(props: Button)
	
	local Disabled = props.Disabled or false
	local Selected = props.Selected or false
	local Pressed = Statify(props.Pressed or false)
	local Hovering = Statify(props.Hovering)
	
	local GeneralModifier = guideState(Selected, Disabled, Pressed, Hovering)
	
	local BackgroundModifier = props.BackgroundModifier or GeneralModifier
	local BackgroundColor = props.BackgroundColor or Spring(Theme(mapGuideModifier(
		BackgroundModifier,
		{
			[Enum.StudioStyleGuideModifier.Default] = Enum.StudioStyleGuideColor.Button,
			[Enum.StudioStyleGuideModifier.Disabled] = Enum.StudioStyleGuideColor.InputFieldBackground
		}
	), BackgroundModifier), 120, 1)
	local BorderModifier = props.BorderModifier or GeneralModifier
	local BorderColor = props.BorderColor or Spring(Theme(mapGuideModifier(
		BorderModifier,
		{
		[Enum.StudioStyleGuideModifier.Default] = Enum.StudioStyleGuideColor.Border,
		[Enum.StudioStyleGuideModifier.Selected] = Enum.StudioStyleGuideColor.MainButton,
		[Enum.StudioStyleGuideModifier.Disabled] = Enum.StudioStyleGuideColor.Button
		}
	), BorderModifier), 120, 1)
	local TextModifier = props.TextModifier or GeneralModifier
	local TextColor = props.TextColor or Spring(
		Theme(Enum.StudioStyleGuideColor.ButtonText, TextModifier), 100, 1
	)
	
	local Button = New "TextButton" {
		
		Name = "Button",
		
		AutomaticSize = Enum.AutomaticSize.XY,
		
		Active = Computed(function() return not unwrap(Disabled) end),
		
		BackgroundColor3 = BackgroundColor,
		
		TextTransparency = 1,
		
		[OnEvent "MouseButton1Down"] = function() Pressed:set(true) end,
		[OnEvent "MouseButton1Up"] = function() Pressed:set(false) end,
		[OnEvent "MouseLeave"] = function() Pressed:set(false); Hovering:set(false) end,
		[OnEvent "MouseEnter"] = function() Hovering:set(true) end,
		
		[Children] = {
			
			Padding {
				Padding = 8,
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4)
			},
			
			Border {
				Color = BorderColor
			},
			
			Text {
				
				TextColor3 = TextColor,
				
				Text = props.Text,
				TextSize = props.TextSize,
				
				LayoutOrder = 100
				
			},
			
			New "UIListLayout" {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				
				Padding = UDim.new(0, 6)
			},
			
			New "UICorner" {
				CornerRadius = UDim.new(0, CORNER_RADIUS)
			},
			
			props[Children]
			
		}
		
	}
	
	
	return Fusion.Hydrate(Button)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Button