--[[
	Lists are special objects used to stream a static set of objects into a
	scrollingframe to grant more ideal performance with extremely large lists.
	
	Use the StreamIn function to Stream In objects
	Use the ItemSize state to determine how big each item is.
	Use MaxItems to limit the maximum number of items
	Use MinItems to limit the minimum number of items
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local CubeCat = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local ScrollingFrame = require(Components.Decoration.ScrollingFrame)

local unwrap = Util.unwrap
local stripProps = Util.stripProps

local Value = Fusion.Value
local Out = Fusion.Out
local Computed = Fusion.Computed
local Children = Fusion.Children

local COMPONENT_ONLY_PROPERTIES = {
	"ItemSize",
	"StreamIn",
	"MaxItems",
	"MinItems",
	"BackgroundColor",
}

type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>
export type List = {
	ItemSize: Fusion.CanBeState<number>,

	StreamIn: (index: Value<number>) -> Instance,
	MaxItems: CanBeState<number>?,
	MinItems: CanBeState<number>?,

	BackgroundColor: CanBeState<Enum.StudioStyleGuideColor>?,

	[any]: any,
}

local function List(props: List)
	local itemSize = props.ItemSize
	local streamIn = props.StreamIn
	local maxItems = props.MaxItems or math.huge
	local minItems = props.MinItems or 0

	-- These tables contain all the elements which are currently streamed in and their index state.
	local streamed = {}
	local streamedStates = {}

	local absoluteSize = Value(Vector2.new())
	local absoluteCanvasSize = Value(Vector2.new())
	local canvasPosition = Value(Vector2.new())

	-- Determines the lowest and highest index to render and returns it as a table.
	local itemsIndexes = Computed(function()
		local currentAbsoluteSize = unwrap(absoluteSize)
		local currentAbsoluteCanvasSize = unwrap(absoluteCanvasSize)
		local currentCanvasPosition = unwrap(canvasPosition)
		local currentItemSize = unwrap(itemSize)
		local minItems = unwrap(minItems)
		local maxItems = unwrap(maxItems)

		if not (currentAbsoluteSize and currentAbsoluteCanvasSize and currentCanvasPosition) then
			return { 1, 2 }
		end

		-- Determines the indexes to render it for.
		local areaMin, areaMax = currentCanvasPosition, currentCanvasPosition + currentAbsoluteSize

		-- Computes the lowest index and highest index by dividing the total area we have by how long each item is.
		-- We then proceed to remove/add 3 to the min and max index to ensure smooth scrolling and is clamped by the minItems
		-- and maxItems values.
		local minIndex = math.clamp(math.floor(areaMin.Y / currentItemSize) - 3, minItems, maxItems)
		local maxIndex = math.clamp(math.ceil(areaMax.Y / currentItemSize) + 3, minItems, maxItems)

		return { minIndex, maxIndex }
	end)

	-- Returns how many items are currently rendered.
	local totalItems = Computed(function()
		local currentAbsoluteSize = unwrap(absoluteSize) or Vector2.zero
		local currentItemSize = unwrap(itemSize)

		return math.min(currentAbsoluteSize.Y / currentItemSize + 6, unwrap(maxItems))
	end)

	-- Creates and updates all the items which will be rendered to the user.
	local items = Computed(function()
		local itemIndexes = unwrap(itemsIndexes)
		local itemsToRender = unwrap(totalItems)
		local minIndex = itemIndexes[1] - 1

		-- Go through every item currently streamed and determine the following
		for i = 1, math.max(#streamed, itemsToRender) do
			if not streamed[i] then
				-- If there is no streamed item for this index we will create a new item.
				local index = Value(minIndex + i)

				streamedStates[i] = index
				streamed[i] = streamIn(index)
			elseif streamed[i] and i > itemsToRender then
				-- If the streamed item is here but there are too many items, we will destroy
				-- the streamed Item.

				streamedStates[i] = nil

				streamed[i]:Destroy()
				streamed[i] = nil
			else
				-- If the streamed item is here and doesn't overflow the amount of items we're allowed
				-- change the index of that streamedItem to their new index.
				streamedStates[i]:set(minIndex + i)
			end
		end

		return streamed
	end)

	local List = ScrollingFrame {

		NoList = true,
		NoPadding = true,

		BackgroundColor = props.BackgroundColor,

		CanvasSize = props.CanvasSize or Computed(function()
			if unwrap(maxItems) == math.huge then
				local itemIndexes = unwrap(itemsIndexes)
				local canvasSize = unwrap(absoluteCanvasSize) or Vector2.new()

				return UDim2.fromOffset(0, math.max((itemIndexes[2] + 2) * unwrap(itemSize), canvasSize.Y))
			else
				return UDim2.fromOffset(0, unwrap(maxItems) * unwrap(itemSize))
			end
		end),
		AutomaticCanvasSize = Enum.AutomaticSize.X,

		[Out "AbsoluteSize"] = absoluteSize,
		[Out "AbsoluteCanvasSize"] = absoluteCanvasSize,
		[Out "CanvasPosition"] = canvasPosition,

		[Children] = items,
	}

	return Fusion.Hydrate(List)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return List
