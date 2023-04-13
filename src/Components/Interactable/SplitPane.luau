--[[
	A split pane allows you to create resizeable elements
	
]]

local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)
local Studio = require(CubeCat.Studio)

local Background = require(Components.Decoration.Background)
local Mouse = require(Components.Utility.Mouse)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs
local OnEvent = Fusion.OnEvent
local Cleanup = Fusion.Cleanup
local Out = Fusion.Out
local Ref = Fusion.Ref

local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>
export type SplitPane = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,
	
	Sizes: CanBeState<{Value<number>}>,
	MinSizes: CanBeState<{CanBeState<number>}>,
	
	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	"Sizes",
	"MinSizes",
	Children
	
}

local RESIZE_RANGE = 24

local function SplitPane(props: SplitPane)
	
	local splitPaneAbsoluteSize = Value(Vector2.new())
	local object = Value()
	local mousePosition = Value(Vector2.zero)
	local isDown = Value(false)
	
	local SplitPane = Background {
		Size = UDim2.new(1, 0, 0, 32),
		
		NoPadding = true,
		NoList = true,
		
		[Ref] = object,
		[Out "AbsoluteSize"] = splitPaneAbsoluteSize,
		[Children] = {
			
			Mouse {
				MousePosition = mousePosition,
				MouseButton1Down = isDown
			},
			
			ForPairs(props[Children], function(index: number, child: Instance)
				if child:IsA("GuiBase2d") == false then return index, child end
				
				local position = Computed(function()
					local scale = 0
					
					for i = 1, index-1 do
						scale += unwrap(unwrap(props.Sizes)[i])
					end
					
					return scale
				end)
				local resizing = false
				local resizingLeft = false
				local resizingRight = false
				
				local absoluteSize = Value(Vector2.zero)
				local absolutePosition = Value(Vector2.zero)
				local beginX = 0
				
				return index, New "TextButton" {
					
					Size = Computed(function()
						return UDim2.fromScale(unwrap(unwrap(props.Sizes)[index]), 1)
					end),
					Position = Computed(function()
						return UDim2.fromScale(unwrap(position), 0)
					end),
					
					BackgroundTransparency = 1,
					
					BorderSizePixel = 1,
					
					[Children] = child,
					
					[Out "AbsoluteSize"] = absoluteSize,
					[Out "AbsolutePosition"] = absolutePosition,
					
					[OnEvent "MouseMoved"] = function(x)
						if resizing then return end
						
						resizingLeft = x < unwrap(absolutePosition).X + RESIZE_RANGE and index ~= 1
						resizingRight = (x > (unwrap(absolutePosition).X + unwrap(absoluteSize).X - RESIZE_RANGE)) and index ~= #props[Children]
						
						if resizingLeft or resizingRight then
							Studio.SetMouseIcon("rbxasset://textures/StudioUIEditor/icon_resize2.png")
						else
							Studio.SetMouseIcon("rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png")
						end
					end,
					
					[OnEvent "MouseLeave"] = function()
						Studio.SetMouseIcon("rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png")
					end,
					
					[OnEvent "MouseButton1Down"] = function(bx)
						if resizingLeft or resizingRight then
							local x = unwrap(mousePosition).X
							resizing = true
							beginX = x
						end
					end,
					
					[Cleanup] = RunService.Heartbeat:Connect(function()
						local x = unwrap(mousePosition).X
						
						resizing = resizing and unwrap(isDown)
						
						if resizing == false then return end
						
						local difference = beginX - x
						local scale = difference / unwrap(splitPaneAbsoluteSize).X
						
						local minSizeCurrent = unwrap(unwrap(props.MinSizes)[index])
						local sizeCurrent = unwrap(unwrap(props.Sizes)[index])
						
						if resizingLeft then
							scale = math.max(-(sizeCurrent - minSizeCurrent), scale)
							
							for i = index - 1, 1, -1 do
								local minSizePrevious = unwrap(unwrap(props.MinSizes)[i])
								local sizePrevious = unwrap(unwrap(props.Sizes)[i])
								
								local maxTotalChange = math.min(scale, sizePrevious - minSizePrevious)
								
								unwrap(props.Sizes)[i]:set(sizePrevious - maxTotalChange)
								unwrap(props.Sizes)[index]:set(unwrap(unwrap(props.Sizes)[index]) + maxTotalChange)
								scale -= maxTotalChange
								
								if scale == 0 then break end
							end
							
						elseif resizingRight then
							scale = math.min((sizeCurrent - minSizeCurrent), scale)
							scale = -scale
							for i = index + 1, #unwrap(props.Sizes), 1 do
								local minSizePrevious = unwrap(unwrap(props.MinSizes)[i])
								local sizePrevious = unwrap(unwrap(props.Sizes)[i])
								
								local maxTotalChange = math.min(scale, sizePrevious - minSizePrevious)
								
								unwrap(props.Sizes)[i]:set(sizePrevious - maxTotalChange)
								unwrap(props.Sizes)[index]:set(unwrap(unwrap(props.Sizes)[index]) + maxTotalChange)
								scale -= maxTotalChange
								
								if scale == 0 then break end
							end
						end
						
						beginX = x
						
					end)
					
				}
				
			end, Fusion.cleanup)
			
		}
		
	}
	
	
	return Fusion.Hydrate(SplitPane)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return SplitPane