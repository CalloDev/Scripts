--// Create OrionUI
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "TGC", HidePremium = true, SaveConfig = true, ConfigFolder = "TGC_Config"})

--// Data
local GroupData = {
    NighthawkGroup = {
        GroupID = 1174414;
        Ranks = {
            StartingRankWithMod = 14
        };
    };
}

local IconData = {

}

--// Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character
local ModsOnline = 0
local ModsOnlineString = "Mods Online: "..tostring(ModsOnline)
local CurrentToolName = nil

local PlayerTable = {}

--// Modules/Remotes Paths
local WEAPON_SETTINGS = require(game.ReplicatedStorage.WEAPON_SETTINGS)
local RunAndStamina = require(Character.Modules.RunAndStamina)

--// Welcome Notification
OrionLib:MakeNotification({
	Name = "Welcome!",
	Content = "Thank you for using this TGC Script!\nDeveloped by: CalloWest#8635",
	Image = "rbxassetid://7733964719",
	Time = 10
})

--// Information Tab
local InfoTab = Window:MakeTab({
	Name = "Information",
	Icon = "rbxassetid://7733964719",
	PremiumOnly = false
})

local ModsOnlineLabel = InfoTab:AddLabel(ModsOnlineString)

local function ChangeModsOnline(player, Increment)
    if player:GetRankInGroup(GroupData.NighthawkGroup.GroupID) >= GroupData.NighthawkGroup.Ranks.StartingRankWithMod then
        ModsOnline += Increment
        ModsOnlineLabel:Set(ModsOnlineString)
    end
end

for _,Players in pairs(game.Players:GetPlayers()) do
    if Players:GetRankInGroup(GroupData.NighthawkGroup.GroupID) >= GroupData.NighthawkGroup.Ranks.StartingRankWithMod then
        ModsOnline += 1
        ModsOnlineLabel:Set(ModsOnlineString)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    ChangeModsOnline(player, 1)
end)

game.Players.PlayerRemoving:Connect(function(player)
    ChangeModsOnline(player, -1)
end)

--// Player Tab
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://7743875962"
})

PlayerTab:AddSlider({
	Name = "WalkSpeed",
	Min = 0,
	Max = 300,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Walk Speed",
	Callback = function(Speed)
		Character:WaitForChild("Humanoid").WalkSpeed = Speed
	end    
})

PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 0,
    Max = 750,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Jump Power",
    Callback = function(Power)
        Character:WaitForChild("Humanoid").JumpPower = Power
    end
})

PlayerTab:AddButton({
    Name = "Infinite Stamina",
    Callback = function()
        while true do
            wait()
            RunAndStamina.stamina = 1
        end
    end
})

--// Weapons Tab
local WeaponsTab = Window:MakeTab({
    Name = "Weapons",
    Icon = ""
})

OrionLib:MakeNotification({
    Name = "Warning!",
    Content = "This is easily noticeable by mods/people, use with caution!\nCheck the amount of mods online to be sure.",
    Image = "",
    Time = 10
})

WeaponsTab:AddTextbox({
	Name = "Weapon",
	Default = "",
	TextDisappear = false,
	Callback = function(ChosenWeapon)
		CurrentToolName = ChosenWeapon
	end	  
})

WeaponsTab:AddSlider({
    Name = "Fire Rate",
    Min = 0.01,
    Max = 1,
    Default = 0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.01,
    ValueName = "Fire Rate",
    Callback = function(FireRate)
        if not WEAPON_SETTINGS[CurrentToolName] then
            return
        end
        WEAPON_SETTINGS[CurrentToolName].fireRate = FireRate
    end
})

WeaponsTab:AddSlider({
    Name = "Spread",
    Min = 0,
    Max = 1,
    Default = 0,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "Spread",
    Callback = function(Spread)
        if not WEAPON_SETTINGS[CurrentToolName] then
            return
        end
        WEAPON_SETTINGS[CurrentToolName].spread = Spread
    end
})

WeaponsTab:AddButton({
    Name = "Make Weapon Auto",
    Callback = function()
        if not WEAPON_SETTINGS[CurrentToolName] then
            return
        end
        WEAPON_SETTINGS[CurrentToolName].shootType = "Auto"
    end
})

--// Teleport Tab
local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "",
    PremiumOnly = false
})

local function GetPlayers()
    for _,Players in pairs(game.Players:GetPlayers()) do
        table.insert(PlayerTable, Players.Name)
    end
    return PlayerTable
end

local TPDropdown = TeleportTab:AddDropdown({
    Name = "Teleport to Player",
    Default = "1",
    Options = GetPlayers(),
    Callback = function(PlayerToTP)
        Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        wait(0.2)
        Character.HumanoidRootPart.CFrame = workspace:FindFirstChild(PlayerToTP).HumanoidRootPart.CFrame
    end
})

--// Initialise
OrionLib:Init()
