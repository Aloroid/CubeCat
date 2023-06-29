--[[
	Allows for really crappy Markdown.
	
	Markdown component is really buggy atm, please don't expect much out of it.
	It's really only designed for basic stuff, and it can't even do that correctly.
		
	Just try to avoid nested lists.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local CubeCat = script.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(CubeCat.Utility)
local MarkdownParser = require(Packages.Markdown)

local Header = require(Components.Display.Header)
local Text = require(Components.Display.Text)
local Blockquote = require(Components.Display.Blockquote)
local Background = require(Components.Decoration.Background)

local Computed = Fusion.Computed
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs

local unwrap = Util.unwrap
local stripProps = Util.stripProps

type Node = MarkdownParser.Node
type CanBeState<T> = Fusion.CanBeState<T>
export type Markdown = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Markdown: CanBeState<string>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Markdown",
}

local function Markdown(props: Markdown)
	local raw = props.Markdown or "Hello World!"
	local nodes = Computed(function()
		local thread = coroutine.create(MarkdownParser)
		local success, result = coroutine.resume(thread, unwrap(raw))
		--print(success, result, debug.traceback(thread))
		return {
			success = success,
			result = result,
			trace = debug.traceback(thread),
		}
	end)

	local function processNode(i: number, node: Node)
		local element

		if node.name == "header" then
			element = Header {

				Text = node.value,
				TextWrapped = true,
				HeaderSize = node.size,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,
			}
		elseif node.name == "paragraph" then
			if type(node.value) == "string" then
				element = Text {

					Text = node.value,
					TextSize = 16,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,

					RichText = true,
				}
			elseif typeof(node.value) == "table" then
				--FIXME: Won't properly respect Layout
				element = Background {

					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,

					BackgroundTransparency = 1,
					FillDirection = Enum.FillDirection.Horizontal,

					[Children] = ForPairs(node.value, function(i, value)
						if type(node) == "string" then
							return processNode(
								i,
								{ name = "paragraph", value = value, tag = "p", begin = 0, parent = node }
							)
						else
							return processNode(i, value)
						end
					end, Fusion.cleanup),
				}
			end
		elseif node.name == "listitem" then
			local raw

			if type(node.value) == "string" then
				raw = if node.parent.name == "unorderedlist" then `• {node.value}` else `{i}. {node.value}`
			else
				raw = if node.parent.name == "unorderedlist" then `• {node.value}` else `{i}. {node.value}`
			end

			element = Text {
				Text = raw,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = true,

				[Children] = Background {

					Position = UDim2.fromScale(1, 0),
					Size = UDim2.new(),
					AutomaticSize = Enum.AutomaticSize.XY,
					NoPadding = true,

					[Children] = if type(node.value) == "table"
						then ForPairs(node.value, processNode, Fusion.cleanup)
						else nil,
				},
			}
		elseif node.name == "unorderedlist" or node.name == "orderedlist" then
			element = Background {
				Size = UDim2.new(),
				AutomaticSize = Enum.AutomaticSize.XY,

				BackgroundTransparency = 1,
				ListPadding = 2,

				[Children] = ForPairs(node.value, processNode, Fusion.cleanup),
			}
		elseif node.name == "code" then
			element = Background {

				Size = UDim2.new(),
				AutomaticSize = Enum.AutomaticSize.XY,

				Padding = 2,

				[Children] = Text {

					Text = node.value,
					TextColor = Enum.StudioStyleGuideColor.WarningText,
					TextXAlignment = Enum.TextXAlignment.Left,
				},
			}
		elseif node.name == "blockquote" then
			element = Blockquote {

				[Children] = ForPairs(node.value, processNode, Fusion.cleanup),
			}
		end

		return i, element
	end

	local elements = ForPairs(
		Computed(function()
			if unwrap(nodes).success == false then
				return {}
			else
				return unwrap(nodes).result
			end
		end),
		processNode,
		Fusion.cleanup
	)

	local Markdown = Background {

		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,

		BackgroundTransparency = 1,

		[Children] = Computed(function()
			local result = unwrap(nodes)

			if result.success == false then
				return Text {

					TextColor = Enum.StudioStyleGuideColor.ErrorText,
					Text = `{result.result}\n\n{result.trace}`,
				}
			else
				return unwrap(elements)
			end
		end, Fusion.cleanup),
	}

	return Fusion.Hydrate(Markdown)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Markdown
