local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Components = script.Parent.Parent.Parent
local Packages = script.Parent.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent.Parent

local Text = require(Components.Display.Text)
local Background = require(Components.Decoration.Background)
local Border = require(Components.Decoration.Border)

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children
local Cleanup = Fusion.Cleanup

local unwrap = Util.unwrap
local stripProps = Util.stripProps

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

local COMPONENT_ONLY_PROPERTIES = {
	"Title",
	"WidgetId",
	
	"InitialDockState",
	"InitialEnabled",
	"OverrideEnabled",
	"FloatingSize",
	"MinimumSize",
	
	"DockWidgetInfo",
	"OnClose",
	Children
}

local function Widget(props: Widget)
	
	local LocalPlayer = Players.LocalPlayer
	assert(LocalPlayer, "[CubeCat] This must be ran on a client")
	
	local title = props.Title
	local position = Value(Vector2.zero)
	local size = Value(props.FloatingSize)
	
	local dragging = false
	local offset = Vector2.new()
	
	-- Create a fake Widget
	local Widget = New "ScreenGui" {
		Name = title,
		Parent = LocalPlayer:WaitForChild("PlayerGui"),
		
		IgnoreGuiInset = false,
		Enabled = props.InitialEnabled,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		
		[Children] = {
			
			Background {
				Name = "Widget",
				
				BackgroundColor = Enum.StudioStyleGuideColor.MainBackground,
				
				Position = Computed(function()
					local currentPosition = unwrap(position)
					return UDim2.fromOffset(currentPosition.X, currentPosition.Y)
				end),
				Size = Computed(function()
					local currentSize = unwrap(size)
					return UDim2.fromOffset(currentSize.X, currentSize.Y)
				end),
				
				Padding = 2,
				ListPadding = 1,
				
				[Children] = {
					
					Background {
						Name = "Topbar",
						
						Size = UDim2.new(1, 0, 0, 24),
						
						BackgroundColor = Enum.StudioStyleGuideColor.Button,
						
						FillDirection = Enum.FillDirection.Horizontal,
						NoPadding = true,
						
						ZIndex = 1,
						
						[Children] = {
							
							Text {
								Size = UDim2.new(1, -24, 1, 0),
								
								Text = props.Title,
								TextColor = Enum.StudioStyleGuideColor.SubText,
								TextSize = 14
							},
							
							Border {}
							
						},
						
						[OnEvent "InputBegan"] = function(input: InputObject)
							if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
							
							offset = position:get() - Vector2.new(input.Position.X, input.Position.Y)
							dragging = true
						end
						
					},
					
					Background {
						Name = "Container",
						
						Size = UDim2.new(1, 0, 1, -24),
						Position = UDim2.fromOffset(0, 24),
						
						BackgroundTransparency = 1,
						
						NoList = true,
						NoPadding = true,
						ClipsDescendants = true,
						
						[Children] = props[Children]
						
					},
					
					Border {},
					
					New "UICorner" {
						CornerRadius = UDim.new(0, 2)
					}
					
				}
				
			},
			
		},
		
		[Cleanup] = RunService.Heartbeat:Connect(function()
			-- Handles dragging
			if dragging == false then return end
			if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) == false then
				dragging = false
				return
			end
			
			position:set(UserInputService:GetMouseLocation() + offset - GuiService:GetGuiInset())
			
		end)
		
	}
	
	return Fusion.Hydrate(Widget)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Widget