local Components = script.Components

local CubeCat = {

	CreateService = require(script.CreateService),
	AddServices = require(script.AddServices),
	Start = require(script.Start),

	Export = require(script.Export),
	Import = require(script.Import),
	Runtime = require(script.Runtime),

	Permissions = require(script.Permissions),

	Studio = require(script.Studio),

	Components = {
		Background = require(Components.Decoration.Background),
		Border = require(Components.Decoration.Border),
		Line = require(Components.Decoration.Line),
		Padding = require(Components.Decoration.Padding),
		Pane = require(Components.Decoration.Pane),
		ScrollingFrame = require(Components.Decoration.ScrollingFrame),
		Shadow = require(Components.Decoration.Shadow),

		Image = require(Components.Display.Image),
		Text = require(Components.Display.Text),
		Table = require(Components.Display.Table),
		AssetViewport = require(Components.Display.AssetViewport),
		Widget = require(Components.Display.Widget),

		Button = require(Components.Interactable.Button),
		Checkbox = require(Components.Interactable.Checkbox),
		Dropdown = require(Components.Interactable.Dropdown),
		ExpandablePane = require(Components.Interactable.ExpandablePane),
		ImageButton = require(Components.Interactable.ImageButton),
		TextInput = require(Components.Interactable.TextInput),
		Tabs = require(Components.Interactable.Tab),
		SplitPane = require(Components.Interactable.SplitPane),

		List = require(Components.Optimization.List),
	},

	Widgets = require(script.Widgets),

	Util = require(script.Utility),
}

return CubeCat
