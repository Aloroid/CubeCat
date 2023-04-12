local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local Teleporter = require(Components.Utility.Teleporter)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Ref = Fusion.Ref
local Children = Fusion.Children
local Cleanup = Fusion.Cleanup

local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>
export type Mouse = {
	MousePosition: Value<Vector2>,
	MouseButton1Down: Value<boolean>,

	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	"MouseButton1Down",
	"MousePosition"
	
}

local function Mouse(props: Mouse)
	
	local object = Value()
	local isInWidgetDown = Value(false)
	
	local Mouse = Teleporter {
		IgnoreOffset = true,
		[Children] = New "Frame" {
		
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = Computed(function()
				return UDim2.fromOffset(unwrap(props.MousePosition).X, unwrap(props.MousePosition).Y)
			end),
			Size = UDim2.fromOffset(200, 200),
			
			Active = false,
			
			BackgroundTransparency = 1,
			
			[Ref] = object,
			
			[OnEvent "InputBegan"] = function(input: InputObject)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isInWidgetDown:set(true)
				end
			end,
			
			[OnEvent "InputEnded"] = function(input: InputObject)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isInWidgetDown:set(false)
				end
			end,
			
			[Cleanup] = RunService.RenderStepped:Connect(function()
				local object = unwrap(object) :: Instance
				local dockWidget = object:FindFirstAncestorWhichIsA("DockWidgetPluginGui")
				local position = UserInputService:GetMouseLocation()
				
				props.MouseButton1Down:set(unwrap(isInWidgetDown) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1))
				
				if dockWidget then
					position = dockWidget:GetRelativeMousePosition()
				end
					
				props.MousePosition:set(position)
			end)
			
		}
		
	}
	
	return Fusion.Hydrate(Mouse)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Mouse