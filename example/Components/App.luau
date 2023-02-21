local Plugin = script.Parent.Parent
local Packages = Plugin.Packages

local Fusion = require(Packages.Fusion)
local CubeCat = require(Packages.CubeCat)

local Background = CubeCat.Components.Background

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
	local App = Background {
		
		NoList = true,
		
		[Export "Main"] = {textObject = textObject},
		
		[Children] = {
			textObject
		}
		
	}
	
	return Fusion.Hydrate(App)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return App