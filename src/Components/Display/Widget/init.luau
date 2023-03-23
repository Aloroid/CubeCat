--[[
	Wrapper for DockWidget and Widget
	
]]

local Packages = script.Parent.Parent.Parent.Parent

local plugin = script:FindFirstAncestorWhichIsA("Plugin")

local DockWidget = require(script.DockWidget)
local UIWidget = require(script.UIWidget)

local Fusion = require(Packages.Fusion)

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
	
	[any]: any
}

local function Widget(props: Widget)
	
	if not plugin then
		return UIWidget(props)
		
	else
		return DockWidget(props)
		
	end
	
end

return Widget