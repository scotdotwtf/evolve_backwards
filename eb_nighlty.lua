warn("running eb nightly build 🌙")
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

function loadoldcore(From, Name)
    spawn(function()
        loadstring(game:HttpGet(from..name..".lua"))()
    end)
end

function deletecore(core)
    game:GetService("CoreGui"):FindFirstChild(core):Destroy()
end

deletecore("RobloxLoadingGui")
loadoldcore(corescripts, "LoadingScript")

--// wait for load
if not game:IsLoaded() then game.IsLoaded:Wait() end

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
