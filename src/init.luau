local Components = script.Components
local Util = script.Utility

local CubeCat = {
	
	CreateService = require(script.CreateService),
	AddServices = require(script.AddServices),
	Start = require(script.Start),
	
	Export = require(script.Export),
	Import = require(script.Import),
	Runtime = require(script.Runtime),
	
	Components = {
		Background = Components.Decoration.Background,
		Border = Components.Decoration.Border,
		Line = Components.Decoration.Line,
		Padding = Components.Decoration.Padding,
		Pane = Components.Decoration.Pane,
		ScrollingFrame = Components.Decoration.ScrollingFrame,
		Shadow = Components.Decoration.Shadow,
		
		Image = Components.Display.Image,
		Text = Components.Display.Text,
		
		Button = Components.Interactable.Button,
		Checkbox = Components.Interactable.Checkbox,
		Dropdown = Components.Interactable.Dropdown,
		ExpandablePane = Components.Interactable.ExpandablePane,
		ImageButton = Components.Interactable.ImageButton,
		TextInput = Components.Interactable.TextInput,
		
		List = Components.Optimization.List
	},
	
	Util = {
		guideState = require(Util.guideState),
		mapGuideColor = require(Util.mapGuideColor),
		Theme = require(Util.Theme),
		
		Statify = require(Util.Statify),
		unwrap = require(Util.unwrap),
		stripProps = require(Util.stripProps),
		
		quickInsert = require(Util.quickInsert),
		quickRemove = require(Util.quickRemove),
		
	}
}

return CubeCat