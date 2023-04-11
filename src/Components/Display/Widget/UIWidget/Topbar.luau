local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Packages = script.Parent.Parent.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent.Parent.Parent

local Text = require(Components.Display.Text)
local Background = require(Components.Decoration.Background)
local Border = require(Components.Decoration.Border)

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Cleanup = Fusion.Cleanup

local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Topbar = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,
	
	Title: CanBeState<string>?,

	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	"Position",
	"Title"
	
}

local function Topbar(props: Topbar)
	
	local position = props.Position
	
	local offset = Vector2.new()
	local dragging = false
	
	local Topbar = Background {
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
		end,
		
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
	
	return Fusion.Hydrate(Topbar)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Topbar