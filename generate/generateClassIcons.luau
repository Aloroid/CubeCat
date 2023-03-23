local ChangeHistoryService = game:GetService("ChangeHistoryService")
local HttpService = game:GetService("HttpService")
local Selection = game:GetService("Selection")
local StudioService = game:GetService("StudioService")
local apiDump = HttpService:GetAsync("https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/API-Dump.json", true)
local lines = {
	"return {",
	"\t"
}

apiDump = HttpService:JSONDecode(apiDump)

local indents = 1

local function line(line: string)
	return string.rep("\t", indents)..line
end

for _, class in apiDump.Classes do
	
	local ok, result = pcall(StudioService.GetClassIcon, StudioService, class.Name)
	
	if ok == false then
		continue
	end
	
	print("checking class", class.Name)
	
	local iconData = result
	
	table.insert(lines, line(`["{class.Name}"] = \{`))
	
	indents += 1
	
	for k, v in iconData do
		local value = if typeof(v) == "Vector2" then `Vector2.new({v.X}, {v.Y})` else string.format("%q", v)
		
		table.insert(lines, line(`{k} = {value},`))
	end
	
	indents -= 1
	table.insert(lines, line("},"))
	table.insert(lines, line(""))
	
end

table.insert(lines, "}")

print("finished")

ChangeHistoryService:SetWaypoint("Creating Script")
local script = Instance.new("ModuleScript")
script.Source = table.concat(lines, "\n")
script.Parent = workspace
script.Name = "ClassIcons"
Selection:Set({script})
ChangeHistoryService:SetWaypoint("Create Theme")

