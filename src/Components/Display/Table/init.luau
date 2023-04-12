local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)

local Background = require(Components.Decoration.Background)
local SplitPane = require(Components.Interactable.SplitPane)
local Text = require(Components.Display.Text)
local Border = require(Components.Decoration.Border)
local List = require(Components.Optimization.List)
local Row = require(script.Row)

local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local ForValues = Fusion.ForValues

local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Table = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,
	
	Table: CanBeState<{[any]: any}>?,
	Rows: CanBeState<{{[any]: any}}>?,
	Order: {string}?,
	InitialSizes: {number}?,
	
	DisplayTotal: CanBeState<number>?,
	
	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	"Table",
	"Rows",
	"Order",
	"DisplayTotal",
	"InitialSizes"
	
}

local function Table(props: Table)
	
	local initialSize = props.InitialSizes or {}
	local sizes = {}
	local minSizes = {}
	local keys = {}
	local rows = props.Rows
	
	local displayTotal = props.DisplayTotal or 30
	
	-- Converts or adjusts the above values so that it can properly fit.
	if props.Table then
		sizes = {Value(0.2), Value(0.8)}
		minSizes = {Value(0.1), Value(0.1)}
		keys = {"Key", "Value"}
		
		rows = Computed(function()
			local data = unwrap(props.Table)
			local newRows = {}
			for key, value in data do
				table.insert(newRows, {Key = key, Value = value})
			end
			return newRows
		end)
	elseif props.Rows then
		local totalFields = 0
		local sizeAvailable = 1
		
		if props.Order then
			totalFields = #props.Order
			for i, key in props.Order do
				table.insert(keys, key)
				sizeAvailable -= initialSize[i] or 0
			end
		else
			for key in unwrap(props.Rows)[1] do
				totalFields += 1
				table.insert(keys, key)
				sizeAvailable -= initialSize[totalFields] or 0
			end
		end
		
		for i = 1, totalFields do
			table.insert(sizes, Value(sizeAvailable / (totalFields - #initialSize)))
			table.insert(minSizes, 0.075)
		end
		
	end
	
	if props.InitialSizes then
		local totalSize = 0
		for i, size in props.InitialSizes do
			totalSize += size
			sizes[i]:set(size)
		end
		
	end
	
	local Table = Background {
		
		AutomaticSize = Enum.AutomaticSize.Y,
		
		Size = UDim2.new(1, 0, 0, 24),
		
		NoPadding = true,
		ListPadding = 1,
		
		[Children] = {
			
			SplitPane {
				
				Size = UDim2.new(1, 0, 0, 24),
				
				Sizes = sizes,
				MinSizes = minSizes,
				
				[Children] = ForValues(keys, function(key)
					return Background {
						BackgroundColor = Enum.StudioStyleGuideColor.Button,
						
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						
						[Children] = {
							
							Text {
								AutomaticSize = Enum.AutomaticSize.None,
								Size = UDim2.fromScale(1, 1),
								
								Text = key,
								TextTruncate = Enum.TextTruncate.AtEnd
							},
							
							Border {}
							
						}
					}
				end, Fusion.cleanup)
				
			},
			
			List {
				
				Size = Computed(function()
					return UDim2.new(1, 0, 0, 24 * unwrap(displayTotal))
				end),
				
				BackgroundColor = Enum.StudioStyleGuideColor.ViewPortBackground,
				
				StreamIn = function(index)
					if props.Table then
						return Row {
							Sizes = sizes,
							Order = keys,
							Index = index,
							Columns = Computed(function()
								return unwrap(rows)[unwrap(index)]
							end)
						}
					else
						return Row {
							Sizes = sizes,
							Order = keys,
							Index = index,
							Columns = Computed(function()
								return unwrap(rows)[unwrap(index)]
							end)
						}
					end
				end,
				ItemSize = 24,
				
				MinItems = 1,
				MaxItems = Computed(function()
					return #unwrap(rows)
				end),
				
				[Children] = Border {}
				
			}
			
		}
		
	}
	
	return Fusion.Hydrate(Table)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return Table