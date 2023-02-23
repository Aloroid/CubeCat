local Packages = script.Parent.Parent.Parent.Parent

local plugin = script:FindFirstAncestorWhichIsA("Plugin")

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Widget = {
	WidgetId: string,
	DockWidgetInfo: DockWidgetPluginGuiInfo,
	
	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	"WidgetId",
	"DockWidgetInfo"
	
}

local function Widget(props: Widget)
	
	assert(plugin, "[CubeCat] Unable to create a widget without plugin")
	
	local Widget = plugin:CreateDockWidgetPluginGui(props.WidgetId, props.DockWidgetInfo)
	
	return Fusion.Hydrate(Widget)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Widget