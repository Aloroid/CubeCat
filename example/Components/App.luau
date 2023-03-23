local Plugin = script.Parent.Parent
local Packages = Plugin.Packages

local Fusion = require(Packages.Fusion)
local CubeCat = require(Packages.CubeCat)

local Background = CubeCat.Components.Background
local Widget = CubeCat.Components.Widget

local Children = Fusion.Children
local Value = Fusion.Value

local Export = CubeCat.Export

local stripProps = CubeCat.Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type App = {

	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	
	
}

local function App(props: App)
	
	local textObject = Value()
	local App = Widget {
		
		Title = "Test",
		WidgetId = "Test",
		
		InitialDockState = Enum.InitialDockState.Float,
		InitialEnabled = true,
		OverrideEnabled = true,
		FloatingSize = Vector2.new(300, 300),
		MinimumSize = Vector2.new(100, 100),
		
		[Children] = Background {
			NoList = true,
			
			[Export "Main"] = {textObject = textObject},
			
			[Children] = {
				textObject
			}
		}
	}
	
	return Fusion.Hydrate(App)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return App