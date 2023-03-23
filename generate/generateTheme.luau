local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local lines = {
	"return {",
	"\t"
}

local indents = 1
local theme = settings().Studio.Theme :: StudioTheme

local function line(line: string)
	return string.rep("\t", indents)..line
end

for _, guideColor in Enum.StudioStyleGuideColor:GetEnumItems() do
	table.insert(lines, line(`[Enum.StudioStyleGuideColor.{guideColor.Name}] = \{`))
	indents += 1
	
	for _, guideModifier in Enum.StudioStyleGuideModifier:GetEnumItems() do
		local color = theme:GetColor(guideColor, guideModifier)
		local r, g, b = math.round(color.R * 255), math.round(color.G * 255), math.round(color.B * 255)
		table.insert(lines, line(`[Enum.StudioStyleGuideModifier.{guideModifier.Name}] = Color3.fromRGB({r}, {g}, {b}),`))
	end
	
	indents -= 1
	table.insert(lines, line("},"))
	table.insert(lines, line(""))
	
end

table.insert(lines, "}")

ChangeHistoryService:SetWaypoint("Creating Script")
local script = Instance.new("ModuleScript")
script.Source = table.concat(lines, "\n")
script.Parent = workspace
script.Name = theme.Name
Selection:Set({script})
ChangeHistoryService:SetWaypoint("Create Theme")

