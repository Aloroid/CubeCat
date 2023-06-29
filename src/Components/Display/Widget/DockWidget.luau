local Packages = script.Parent.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent.Parent

local plugin = script:FindFirstAncestorWhichIsA("Plugin")

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local stripProps = Util.stripProps
local unwrap = Util.unwrap

type CanBeState<T> = Fusion.CanBeState<T>
export type Widget = {
	WidgetId: string,

	InitialDockState: Enum.InitialDockState,
	InitialEnabled: boolean,
	OverrideEnabled: boolean,
	FloatingSize: Vector2,
	MinimumSize: Vector2,

	--DockWidgetInfo: DockWidgetPluginGuiInfo,

	OnClose: () -> ()?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"WidgetId",

	"InitialDockState",
	"InitialEnabled",
	"OverrideEnabled",
	"FloatingSize",
	"MinimumSize",

	"DockWidgetInfo",
	"OnClose",
}

local function Widget(props: Widget)
	local dockWidget = props.DockWidgetInfo
		or DockWidgetPluginGuiInfo.new(
			unwrap(props.InitialDockState, false),
			unwrap(props.InitialEnabled, false),
			unwrap(props.OverrideEnabled, false),
			unwrap(props.FloatingSize, false).X,
			unwrap(props.FloatingSize, false).Y,
			unwrap(props.MinimumSize, false).X,
			unwrap(props.MinimumSize, false).Y
		)

	assert(plugin, "[CubeCat] Unable to create a widget without plugin")

	local Widget = plugin:CreateDockWidgetPluginGui(props.WidgetId, dockWidget)

	if props.OnClose then
		Widget:BindToClose(props.OnClose)
	end

	return Fusion.Hydrate(Widget)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Widget
