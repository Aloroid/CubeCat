--!strict

local Packages = script.Parent.Parent.Parent
local Components = script.Parent.Parent.Components

local FusionPlasma = require(Packages.FusionPlasma)
local Widget = require(Components.Display.Widget)

return FusionPlasma.wrap(Widget, function(widgetId: string, options: Widget.Widget, children: () -> ())
	options.WidgetId = widgetId
	return options, children
end, {})
