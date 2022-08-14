warn("running eb nightly build //")
print("there may be some errors, we reccomend running the normal version if you don't want any bugs or un-finished commits")

--[[

    File: eb.lua
    Written by: spec

    ~ Description: A 2016 roblox script that uses the original modules from 2016.
    // Alt: This is a more readable version of TheInvisible's script, improving on some of the things he wrote.

    CREDITS TO // TheInvisible // I got the idea from his project and wanted to touch up on it, some code used is from his project.

    2016 version: Late 2016

]]

--// loading screen
spawn(function()
    game:GetService("CoreGui"):WaitForChild("RobloxLoadingGui"):Destroy()
end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/specowos/evolve_backwards/main/CoreScripts/LoadingScript.lua"))()

--// wait for load
if not game:IsLoaded() then game.Loaded:Wait() end

--// functions taken from TheInvisible's script
oldrequire = require
getgenv().bakrequire = require

cache = {}

function IsCached(Inst)
    for i,v in next, cache do
        if v[1] == Inst then
            return true, v[2]
        end
    end
    return false
end

getgenv().require = function(inst)
    CachedStatus, Result = IsCached(inst)
    if CachedStatus == false and Result == nil then
        result = loadstring(inst.Source)()
        table.insert(cache, {inst, result})
        return result
    else
        if Result then
            return Result
        end
    end
end

getgenv().LoadLibrary = function(str)
    return loadstring(game:GetObjects("rbxassetid://9133787982")[1][str].Source)()
end

--// remove new coreguis
function ExistAndDelete(str)
    task.spawn(function()
        if game:GetService("CoreGui"):FindFirstChild(str) == nil then
            game:GetService("CoreGui"):WaitForChild(str):Destroy()
        else
            game:GetService("CoreGui")[str]:Destroy()
        end
    end)
end

ExistAndDelete("RobloxGui")
ExistAndDelete("TeleportGui")
ExistAndDelete("RobloxPromptGui")
ExistAndDelete("PlayerList")
ExistAndDelete("RobloxNetworkPauseNotification")
ExistAndDelete("PurchasePrompt")
ExistAndDelete("HeadsetDisconnectedDialog")
ExistAndDelete("ThemeProvider")
ExistAndDelete("BubbleChat")

--// Remove corescripts
for i,v in pairs(game:GetDescendants()) do
    if v.ClassName == "CoreScript" then
        v:Destroy()
    end
end

--// Chat on .chatted
game.Players.LocalPlayer.Chatted:Connect(function(msg)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest"):FireServer(msg, "All")
end)

--// Delete chat
game.Players.LocalPlayer.PlayerGui:WaitForChild("Chat"):Destroy()

--// 2016 Coregui
local RobloxGui = game:GetObjects("rbxassetid://9139773381")[1]
RobloxGui.Parent = game:GetService("CoreGui")

-- old camera

spawn(function()
    local scriptContext = game:GetService("ScriptContext")
    local touchEnabled = game:GetService("UserInputService").TouchEnabled

    local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")

    local soundFolder = Instance.new("Folder")
    soundFolder.Name = "Sounds"
    soundFolder.Parent = RobloxGui

    --// used when fflag can cause it to error
    local function safeRequire(moduleScript)
        task.spawn(function()
            local moduleReturnValue = nil
            local success, err = pcall(function() moduleReturnValue = require(moduleScript) end)
            if not success then
            warn("Failure to Start CoreScript module" ..moduleScript.Name.. ".\n" ..err)
            end
            return moduleReturnValue
        end)
    end

    --// add corescript from robloxgui
    function AddCoreScriptLocal(str)
        local Inject = [==[
            --Get names
            script.Name = script.Name..[[]==]..str..[==[]]
            --FAKE SCRIPT
            local script = Instance.new("LocalScript", game.CoreGui.RobloxGui)
            script.Name = [[CoreScripts/]==]..str..[==[]]
            script.Disabled = true
            script.Source = [[print("Doin' your mom")]]
            
        ]==]
        
        loadstring(Inject..tostring(RobloxGui.CoreScriptSyn[str].Source))()
    end

    -- TopBar
    AddCoreScriptLocal("Topbar")

    -- SettingsScript
    -- local luaControlsSuccess, luaControlsFlagValue = pcall(function() return settings():GetFFlag("UseLuaCameraAndControl") end)

    -- MainBotChatScript (the Lua part of Dialogs)
    AddCoreScriptLocal("MainBotChatScript2")

    -- In-game notifications script
    AddCoreScriptLocal("NotificationScript2")

    -- Performance Stats Management
    AddCoreScriptLocal("PerformanceStatsManagerScript")

    -- Chat script
    safeRequire(RobloxGui.Modules.ChatSelector)
    safeRequire(RobloxGui.Modules.PlayerlistModule)
    AddCoreScriptLocal("BubbleChat")

    -- Purchase Prompt Script (run both versions, they will check the relevant flag)
    AddCoreScriptLocal("PurchasePromptScript2")
    AddCoreScriptLocal("PurchasePromptScript3")

    --// backpack
    
    task.spawn(function()
        AddCoreScriptLocal("VehicleHud")
    end)
    task.spawn(function()
        AddCoreScriptLocal("GamepadMenu")
    end)
    if touchEnabled then -- touch devices don't use same control frame
        -- only used for touch device button generation
        task.spawn(function()
        AddCoreScriptLocal("ContextActionTouch")
        end)
        RobloxGui:WaitForChild("ControlFrame")
        RobloxGui.ControlFrame:WaitForChild("BottomLeftControl")
        RobloxGui.ControlFrame.BottomLeftControl.Visible = false
    end

    do
        local UserInputService = game:GetService('UserInputService')
        local function tryRequireVRKeyboard()
        if UserInputService.VREnabled then
        return safeRequire(RobloxGui.Modules.VR.VirtualKeyboard)
        end
        return nil
        end
        if not tryRequireVRKeyboard() then
        UserInputService.Changed:connect(function(prop)
        if prop == "VREnabled" then
        tryRequireVRKeyboard()
        end
        end)
        end
    end

    --// boot up vr shell
    if UserSettings().GameSettings:InStudioMode() then
        local UserInputService = game:GetService('UserInputService')
        local function onVREnabled(prop)
            if prop == "VREnabled" then
                if UserInputService.VREnabled then
                    local shellInVRSuccess, shellInVRFlagValue = pcall(function() return settings():GetFFlag("EnabledAppShell3D") end)
                    local shellInVR = (shellInVRSuccess and shellInVRFlagValue == true)
                    local modulesFolder = RobloxGui.Modules
                    local appHomeModule = modulesFolder:FindFirstChild('Shell') and modulesFolder:FindFirstChild('Shell'):FindFirstChild('AppHome')
                if shellInVR and appHomeModule then
                    safeRequire(appHomeModule)
                end
            end
        end
    end

    spawn(function()
        if UserInputService.VREnabled then
            onVREnabled("VREnabled")
        end
            UserInputService.Changed:connect(onVREnabled)
        end)
    end
end)

--/ ~ / custom remade functions

--// remove new kick
spawn(function()
    while wait() do
        game:GetService("RunService"):SetRobloxGuiFocused(false)
    end
end)

--// display name remover + bar adder
game:GetService("RunService").RenderStepped:Connect(function()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Character ~= nil then
            if v.Character:FindFirstChild("Humanoid") then
                sethiddenproperty(v.Character.Humanoid, "HealthDisplayType", Enum.HumanoidHealthDisplayType.AlwaysOn)
            end
        end
    end
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        pcall(function()
            v.Character:WaitForChild("Humanoid").DisplayName = v.Name
        end)
    end
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

--// studs (texture setup from beyond 5d's project)
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