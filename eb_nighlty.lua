warn("running eb nightly build //")
print("there may be some errors, we reccomend running the normal version if you don't want any bugs or un-finished commits")

--[[

    File: eb.lua
    Written by: spec

    ~ Description: A 2016 roblox script that uses the original modules from 2016.

    CREDITS TO // TheInvisible // I got the idea from his project and wanted to touch up on it, some code used is from his project.

    2016 version: Late 2016

]]

--// vars and funcs
local corescripts = "https://raw.githubusercontent.com/specowos/evolve_backwards/main/CoreScripts/"
local modules = "https://raw.githubusercontent.com/specowos/evolve_backwards/main/Modules/"
loadstring(game:HttpGet("https://raw.githubusercontent.caom/specowos/CONVERTWARE/main/convertware/Other/LoadLibrary%20Backup.lua"))()

function loadoldcore(from, name)
    spawn(function()
        loadstring(game:HttpGet(from..name..".lua"))()
    end)
end

function deletecore(core)
    game:GetService("CoreGui"):WaitForChild(core):Destroy()
end

deletecore("RobloxLoadingGui")
loadoldcore(corescripts, "LoadingScript")

--// wait for load
if not game:IsLoaded() then game.Loaded:Wait() end

--// remove new kick
spawn(function()
    while wait() do
        game:GetService("RunService"):SetRobloxGuiFocused(false)
    end
end)

--// health bars set to show
game:GetService("Players").PlayerAdded:Connect(function(Player)
    spawn(function()
        if Player ~= nil then
            if Player.Character == nil then
                Player.CharacterAdded:Wait()
            end
            if Player.Character:FindFirstChild("Humanoid") == nil then
                Player.Character:WaitForChild("Humanoid")
            end
            Player.Character.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
        end
        Player.CharacterAdded:Connect(function(char)
            if char:FindFirstChild("Humanoid") == nil then
                char:WaitForChild("Humanoid")
            end
            char.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
        end)
    end)
end)

--// setting up graphics to look older
local effectsafter2016 = {"DepthOfFieldEffect", "Atmosphere"}
for _, effect in pairs(game:GetService("Lighting"):GetChildren()) do
    for _, not2016effect in pairs(effectsafter2016) do
        if effect:IsA(not2016effect) then
            effectv:Destroy() 
        end
    end
end

sethiddenproperty(game:GetService("Lighting"), "Technology", Enum.Technology.Compatibility) 
settings().Rendering.QualityLevel = 21

game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
game:GetService("Lighting").Brightness = 1
game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(127, 127, 127)

--// outlines
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("BasePart") and v.Name ~= "Handle" and not v:FindFirstChildOfClass("SpecialMesh") then
        local Outlines = Instance.new("SelectionBox")
        Outlines.Adornee = v
        Outlines.Parent = v
        Outlines.Color3 = Color3.fromRGB(0, 0, 0)
        Outlines.LineThickness = 0.0001
        Outlines.Transparency = 0.9
    end
end

--// studs
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("BasePart") and v.Material == Enum.Material.Plastic and v.TopSurface == Enum.SurfaceType.Studs then
		if not v:FindFirstChildOfClass("Texture") then
    		local Studs = Instance.new("Texture")
    		Studs.Parent = v
    		Studs.Face = Enum.NormalId.Top
    		Studs.Texture = "rbxassetid://7027211371"
    		Studs.Color3 = Color3.new(v.Color.R * 2, v.Color.G * 2, v.Color.B * 2)
    		Studs.Transparency = v.Transparency
		end
    end
end

--[[
deletecore("RobloxGui")
deletecore("TeleportGui")
deletecore("RobloxPromptGui")
deletecore("RobloxLoadingGui")
deletecore("PlayerList")
deletecore("RobloxNetworkPauseNotification")
deletecore("PurchasePrompt")
deletecore("HeadsetDisconnectedDialog")
deletecore("ThemeProvider")
deletecore("BubbleChat")
]]