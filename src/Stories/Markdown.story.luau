local CubeCat = script.Parent.Parent
local Components = CubeCat.Components

local Fusion = require(CubeCat.Parent.Fusion)

local Children = Fusion.Children

local Text = require(Components.Display.Markdown)
local ScrollingFrame = require(Components.Decoration.ScrollingFrame)

return function(target)
	local text = ScrollingFrame {

		Parent = target,

		Size = UDim2.fromScale(1, 1),

		[Children] = Text {

			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),

			Markdown = [[
# Header

Yo!
Soooo

# **Bold**
*Itaics*
***Italics n Bolded***

-  uh
	- err

> We're just testing markdown.
>
> > we can embed
>
> We can embed markdown
> I'm trying to fix this :p

- well

]],
		},
	}

	return function()
		text:Destroy()
	end
end
