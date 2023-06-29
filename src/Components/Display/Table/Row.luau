local Packages = script.Parent.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local Background = require(Components.Decoration.Background)
local Text = require(Components.Display.Text)
local Border = require(Components.Decoration.Border)

local Computed = Fusion.Computed
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs

local unwrap = Util.unwrap

type CanBeState<T> = Fusion.CanBeState<T>
export type Row = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Index: CanBeState<number>?,
	Columns: CanBeState<{ [any]: any }>?,
	Order: { any },
	Sizes: { unknown },

	DisplayType: CanBeState<boolean>?,

	[any]: any,
}

local function Row(props: Row)
	local displayType = props.DisplayType or false

	-- This function converts the given value into a string
	local function tostringValue(value)
		local vType = typeof(value)
		if vType == "thread" or vType == "table" or vType == "function" or vType == "userdata" or vType == "number" then
			return tostring(value)
		elseif vType == "string" then
			return `"{value}"`
		elseif vType == "CFrame" then
			return `[{tostring(value.Position)}] [{tostring(value.XVector)}] [{tostring(value.YVector)}] [{tostring(value.ZVector)}]`
		else
			return if unwrap(displayType) then `{typeof(value)}: {tostring(value)}` else tostring(value)
		end
	end

	local order = props.Order
	local columns = props.Columns
	local sizes = props.Sizes

	local Row = Background {
		Name = "row",
		Position = Computed(function()
			return UDim2.fromOffset(0, (unwrap(props.Index) - 1) * 24 - 1)
		end),
		Size = UDim2.new(1, 0, 0, 24),

		BackgroundColor = Enum.StudioStyleGuideColor.TableItem,

		NoList = true,
		Padding = 0,

		[Children] = ForPairs(order, function(index, key)
			local value = Computed(function()
				return unwrap(columns)[key]
			end)

			return index,
				Background {
					Size = Computed(function()
						local scale = unwrap(unwrap(sizes)[index])
						return UDim2.new(scale, 0, 0, 24)
					end),
					Position = Computed(function()
						local scale = 0

						for i = 1, index - 1 do
							scale += unwrap(unwrap(props.Sizes)[i])
						end

						return UDim2.fromScale(scale, 0)
					end),

					BackgroundColor = Enum.StudioStyleGuideColor.TableItem,

					NoList = true,
					NoPadding = true,

					[Children] = {

						Text {

							Size = UDim2.fromScale(1, 1),
							AutomaticSize = Enum.AutomaticSize.None,

							Text = Computed(function()
								local realValue = unwrap(value)
								return if key == "Index" or key == "Key"
									then tostring(realValue)
									else tostringValue(realValue)
							end),
							TextTruncate = Enum.TextTruncate.AtEnd,
						},

						Border {},
					},
				}
		end, Fusion.cleanup),
	}

	return Row
end

return Row
