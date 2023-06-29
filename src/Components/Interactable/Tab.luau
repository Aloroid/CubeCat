--[[
	Allows you to implement multiple different views inside a Background to
	display multiple different elements.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local Background = require(Components.Decoration.Background)
local Button = require(Components.Interactable.Button)
local Border = require(Components.Decoration.Border)
local Padding = require(Components.Decoration.Padding)

local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs
local OnEvent = Fusion.OnEvent
local Spring = Fusion.Spring

local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Tab = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Tabs: CanBeState<{ { Name: CanBeState<string>, Children: CanBeState<Instance> } }>,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Tabs",
}

local function Tab(props: Tab)
	local tabs = props.Tabs
	local currentView = Value(unwrap(props.Tabs, false)[1] or {})

	local Tab = Background {

		NoPadding = true,
		NoList = true,

		[Children] = {

			Background {
				Name = "Tabs",

				Size = UDim2.new(1, 0, 0, 18),
				Position = UDim2.fromOffset(-1, 0),

				BackgroundColor = Enum.StudioStyleGuideColor.TabBar,

				NoPadding = true,
				ListPadding = 1,

				FillDirection = Enum.FillDirection.Horizontal,

				ClipsDescendants = true,

				[Children] = {

					Padding {
						Padding = 1,
					},

					ForPairs(tabs, function(index: number, data)
						return index,
							Button {

								Size = Spring(
									Computed(function()
										return UDim2.fromOffset(0, 18)
									end),
									40,
									1
								),
								AnchorPoint = Vector2.new(0, 1),

								Text = data.Name,
								TextSize = 14,
								NoPadding = true,

								BackgroundColor = Enum.StudioStyleGuideColor.Tab,
								BorderColor = Enum.StudioStyleGuideColor.Border,

								Selected = Computed(function()
									return unwrap(currentView) == data
								end),

								[Children] = {

									Padding {
										Padding = 6,
										PaddingTop = UDim.new(0, 0),
										PaddingBottom = UDim.new(0, 2),
									},
								},

								[OnEvent "Activated"] = function()
									currentView:set(data)
								end,
							}
					end, Fusion.cleanup),
				},
			},

			Background {
				Name = "Container",

				Size = UDim2.new(1, 0, 1, -18),
				Position = UDim2.fromOffset(0, 18),

				[Children] = {
					Border {},

					Computed(function()
						return unwrap(unwrap(currentView).Children)
					end, Fusion.doNothing),
				},
			},
		},
	}

	return Fusion.Hydrate(Tab)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Tab
