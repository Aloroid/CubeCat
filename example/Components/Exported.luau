local Plugin = script.Parent.Parent
local Packages = Plugin.Packages
local Services = Plugin.Services

local Fusion = require(Packages.Fusion)
local CubeCat = require(Packages.CubeCat)

local StateService = require(Services.StateService)

local Button =  require(CubeCat.Components.Button)
local Text = require(CubeCat.Components.Text)

local OnEvent = Fusion.OnEvent

local Import = CubeCat.Import
local Runtime = CubeCat.Runtime

local stripProps = CubeCat.Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Exported = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,
	
	

	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	
	
}

local function Exported(props: Exported)
	
	local parent, values = Import("Main")
	
	local Exported = Button {
		
		Parent = parent,
		
		Position = UDim2.fromScale(0.5, 0.6),
		AnchorPoint = Vector2.new(0.5, 0.5),
		
		Text = "Reset Button",
		
		[OnEvent "Activated"] = function()
			local textObject = values:get().textObject
			local current = textObject:get()
			
			textObject:set(Text {
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				
				Text = Runtime(function()
					return StateService:getState()
				end)
			})
			
			if current then
				current:Destroy()
			end
		end
		
	}
	
	return Fusion.Hydrate(Exported)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Exported