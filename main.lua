local Characters = {
	["1"] = "A"; ["2"] = "B"; ["3"] = "C"; ["4"] = "D"; ["5"] = "E"; ["6"] = "F"; ["7"] = "G"; ["8"] = "H"; ["9"] = "I"; ["10"] = "J";
	["11"] = "K"; ["12"] = "L"; ["13"] = "M"; ["14"] = "N"; ["15"] = "O"; ["16"] = "P"; ["17"] = "Q"; ["18"] = "R"; ["19"] = "S"; ["20"] = "T"; 
	["21"] = "U"; ["22"] = "V"; ["23"] = "W"; ["24"] = "X"; ["25"] = "Y"; ["26"] = "Z";
}

local function Key(CharactersCount)
	local rCount = CharactersCount - 1
	local key = nil

	local decide = math.random(0, 1)
	if decide == 0 then
		key = tostring(math.random(0, 9))
	else
		key = tostring(Characters[tostring(math.random(1, 26))])
	end

	for i = 1, rCount do
		local decide = math.random(0, 1)
		if decide == 0 then
			key = key .. tostring(math.random(0, 9))
		else
			key = key .. tostring(Characters[tostring(math.random(1, 26))])
		end
	end

	return key
end

local Token = Key(15)

local function Highlight(Parent: Instance, FillColor: Color3, OutlineColor: Color3)
	local chams = Instance.new("Highlight")
	chams.Parent = Parent
	chams.Name = Token
	chams.FillColor = FillColor
	chams.OutlineColor = OutlineColor
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Players = {}
local SelectedPlayer = false
local Cheats = {
    ["InfJump"] = false;
    ["ESP"] = false;
}

local Window = Fluent:CreateWindow({
    Title = "Turis",
    SubTitle = "v0.0.8",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Player = Window:AddTab({Title = "Player", Icon = "user"});
    Players = Window:AddTab({Title = "Players", Icon = "users"});
    Visuals = Window:AddTab({Title = "Visuals", Icon = "eye"});
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"});
}

Tabs.Player:AddParagraph({
    Title = "Movement";
})

local WalkSpeeds = Tabs.Player:AddSlider("Slider", {
    Title = "WalkSpeed";
    Description = "";
    Default = 16;
    Min = 0;
    Max = 500,
    Rounding = 0;
})

WalkSpeeds:OnChanged(function(Value)
    game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

local JumpHeights = Tabs.Player:AddSlider("Slider", {
    Title = "JumpHeight";
    Description = "";
    Default = 7.2;
    Min = 0;
    Max = 500,
    Rounding = 0;
})

JumpHeights:OnChanged(function(Value)
    game:GetService("Players").LocalPlayer.Character.Humanoid.JumpHeight = Value
end)

local InfJumpt = Tabs.Player:AddToggle("MyToggle", {
    Title = "Infinity Jump",
    Default = false
})

InfJumpt:OnChanged(function(Value)
    Cheats.InfJump = Value
end)

local Playerd = Tabs.Players:AddDropdown("Dropdown", {
    Title = "Player",
    Values = {},
    Multi = false,
    Default = "Select a Player",
})

Playerd:OnChanged(function(Value)
    SelectedPlayer = Value
end)

local Teleportb = Tabs.Players:AddButton({
    Title = "Teleport",
    Description = "Teleports you to the selected player.",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players")[SelectedPlayer].Character.HumanoidRootPart.CFrame
    end
})

for i, v in pairs(game:GetService("Players"):GetChildren()) do
    if not table.find(Players, tostring(v)) then
        table.insert(Players, tostring(v))
    end
end

Playerd:SetValues(Players)

game:GetService("Players").PlayerAdded:Connect(function(plr)
    table.insert(Players, tostring(plr))
    Playerd:SetValues(Players)
end)

game:GetService("Players").PlayerRemoving:Connect(function(plr)
    table.remove(Players, tonumber(table.find(Players, tostring(plr))))
    Playerd:SetValues(Players)
end)

local ESPt = Tabs.Visuals:AddToggle("ESP", {
    Title = "ESP",
    Default = false
})

ESPt:OnChanged(function(Value)
    Cheats.ESP = Value

    if Cheats.ESP then
        spawn(function()
            while wait(1) and Cheats.ESP do
                for i, v in pairs(game:GetService("Players"):GetChildren()) do
                    local plr = v
                    local char = v.Character
                    
                    if char:FindFirstChild(Token) then
                        if char[Token].OutlineColor == BrickColor.new(tostring(v.TeamColor)).Color then else
                            char[Token].OutlineColor = BrickColor.new(tostring(v.TeamColor)).Color
                        end
                    else
                        Highlight(char, Color3.new(1, 1, 1), BrickColor.new(tostring(v.TeamColor)).Color)
                    end
                end
            end
        end)
    else
        for i, v in pairs(game:GetService("Players"):GetChildren()) do
            if v.Character:FindFirstChild(Token) then
                v.Character[Token]:Destroy()
            end
        end
    end
end)

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("Turis HUB")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(1)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if Cheats.InfJump then
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
