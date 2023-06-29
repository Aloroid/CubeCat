local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Components = script.Parent.Parent.Parent
local Packages = script.Parent.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent.Parent

local Topbar = require(script.Topbar)
local FusionPlasma = require(Packages.FusionPlasma)
local Shadow = require(Components.Decoration.Shadow)
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
local Statify = Util.Statify
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

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Position",

	"Title",
	"WidgetId",

	"InitialDockState",
	"InitialEnabled",
	"OverrideEnabled",
	"FloatingSize",
	"MinimumSize",

	"DockWidgetInfo",
	"OnClose",
	Children,
}

local RESIZE_RANGE = 5
local canAccessCoregui, coreGui = pcall(function()
	return game:GetService("CoreGui")
end)

local function Widget(props: Widget)
	local LocalPlayer = Players.LocalPlayer
	assert(LocalPlayer or canAccessCoregui, "[CubeCat] This must be ran on a client")

	local title = props.Title
	local position = Value(props.Position or Vector2.zero)
	local size = Value(unwrap(props.FloatingSize))
	local resizing = false
	local minimumSize = unwrap(props.MinimumSize)
	local enabled = Statify(unwrap(props.InitialEnabled) or props.Enabled)
	local onClose = props.OnClose or function()
		enabled:set(false)
	end

	local top = Vector2.new()
	local bottom = Vector2.new()
	local resizingTop = false
	local resizingLeft = false
	local resizingBottom = false
	local resizingRight = false

	-- Create a fake Widget
	local Widget = New "ScreenGui" {
		Name = title,
		Parent = coreGui or LocalPlayer:WaitForChild("PlayerGui"),

		IgnoreGuiInset = true,
		Enabled = enabled,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,

		[Children] = {

			Shadow {

				Position = Computed(function()
					local currentPosition = unwrap(position)
					return UDim2.fromOffset(currentPosition.X, currentPosition.Y)
				end),

				[Children] = {

					New "UIListLayout" {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					},

					Background {
						Name = "Widget",

						BackgroundColor = Enum.StudioStyleGuideColor.MainBackground,

						Size = Computed(function()
							local currentSize = unwrap(size)
							return UDim2.fromOffset(currentSize.X, currentSize.Y)
						end),

						Padding = 2,
						ListPadding = 1,

						[Children] = {

							Topbar {
								Title = title,
								Position = position,
								OnClose = onClose,
							},

							Background {
								Name = "Container",

								Size = UDim2.new(1, 0, 1, -24),
								Position = UDim2.fromOffset(0, 24),

								BackgroundTransparency = 1,

								NoList = true,
								NoPadding = true,
								ClipsDescendants = true,

								[Children] = props[Children],
								[FusionPlasma.ParentTo] = true,
							},

							Border {},

							New "UICorner" {
								CornerRadius = UDim.new(0, 2),
							},
						},
					},
				},

				[OnEvent "MouseLeave"] = function()
					if resizing then
						return
					end
					UserInputService.MouseIcon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"
				end,

				[OnEvent "MouseMoved"] = function(x, y)
					if resizing then
						return
					end
					x -= unwrap(position).X
					y -= unwrap(position).Y

					resizingTop = y < RESIZE_RANGE
					resizingLeft = x < RESIZE_RANGE
					resizingBottom = y > (unwrap(size).Y - RESIZE_RANGE)
					resizingRight = x > (unwrap(size).X - RESIZE_RANGE)

					UserInputService.MouseIcon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"

					if (resizingTop and resizingLeft) or (resizingBottom and resizingRight) then
						UserInputService.MouseIcon = "rbxasset://textures/StudioUIEditor/icon_resize3.png"
					elseif (resizingTop and resizingRight) or (resizingBottom and resizingLeft) then
						UserInputService.MouseIcon = "rbxasset://textures/StudioUIEditor/icon_resize1.png"
					elseif resizingTop or resizingBottom then
						UserInputService.MouseIcon = "rbxasset://textures/StudioUIEditor/icon_resize4.png"
					elseif resizingLeft or resizingRight then
						UserInputService.MouseIcon = "rbxasset://textures/StudioUIEditor/icon_resize2.png"
					end
				end,

				[OnEvent "InputBegan"] = function(input: InputObject)
					if
						input.UserInputType ~= Enum.UserInputType.MouseButton1
						and input.UserInputType ~= Enum.UserInputType.Touch
					then
						return
					end
					resizing = true
					top = unwrap(position)
					bottom = unwrap(position) + unwrap(size)
				end,

				[Cleanup] = RunService.RenderStepped:Connect(function()
					local mposition = UserInputService:GetMouseLocation()
					local x, y = mposition.X, mposition.Y

					resizing = resizing
						and (
							UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
							or UserInputService:IsMouseButtonPressed(Enum.UserInputType.Touch)
						)

					if resizing == false then
						return
					end

					if resizingBottom then
						size:set(Vector2.new(unwrap(size).X, math.max(y - top.Y, minimumSize.Y)))
					end
					if resizingRight then
						size:set(Vector2.new(math.max(x - top.X, minimumSize.X), unwrap(size).Y))
					end
					if resizingTop then
						local ySize = math.max(bottom.Y - y, minimumSize.Y)
						size:set(Vector2.new(unwrap(size).X, ySize))
						position:set(Vector2.new(unwrap(position).X, math.min(y, bottom.Y - minimumSize.Y)))
					end
					if resizingLeft then
						local xSize = math.max(bottom.X - x, minimumSize.X)
						size:set(Vector2.new(xSize, unwrap(size).Y))
						position:set(Vector2.new(math.min(x, bottom.X - minimumSize.X), unwrap(position).Y))
					end
				end),
			},
		},
	}

	return Fusion.Hydrate(Widget)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Widget
