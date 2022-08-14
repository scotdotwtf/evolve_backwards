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
