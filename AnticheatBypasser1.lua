-- [[ random notification lib I found ]] --

-- Import the Library
local fnl = loadstring(game:HttpGetAsync 'https://raw.githubusercontent.com/Code1Tech/utils/main/notification.lua')()

-- Make a Notification function
function notify(title, text, duration)
  title = title or "Notification"
  text = text or "No text provided."
  duration = duration or 5
  
  fnl:MakeNotification({
    Title = title,
    Text = text,
    Duration = duration
  })
end

-- Use the func
notify("ACR:Started", "AntiCheat Removal Started\n⚠️: Only Works On Some Games\nℹ️: Made By @hmmm5650", 3.5)

pcall(function()
local ACRunning = false
local ACRemovalInterval = 0.1 -- seconds between scans
local LastScanTime = 0

-- Improved non-blocking wait function with better yielding
local function SecureWait(duration)
    local start = tick()
    while tick() - start < duration and ACRunning do
        -- Use smaller increments for smoother yielding
        task.wait(math.min(0.05, duration - (tick() - start)))
    end
end

-- Optimized iterative deep scan to avoid stack overflow and improve performance
local function DeepScan(parent)
    local results = {}
    local stack = {parent}
    local count = 0
    
    while #stack > 0 and ACRunning do
        local current = table.remove(stack)
        local children = current:GetChildren()
        
        for i = 1, #children do
            table.insert(results, children[i])
            table.insert(stack, children[i])
            
            -- Yield every 50 items to prevent freezing
            count = count + 1
            if count % 50 == 0 then
                task.wait()
            end
        end
    end
    
    return results
end

-- Enhanced detection with better performance and more checks
local function DetectAntiCheatComponents()
    local foundAC = {}
    local acStrength = 0
    local totalPossibleStrength = 0
    
    -- Expanded list of anti-cheat identifiers with categories
    local commonACNames = {
        -- General AC terms
        "AntiCheat", "AntiExploit", "AC_", "SecurityModule", "AntiHack",
        "ExploitProtection", "CheatDetection", "HackShield", "VAC", "MoonSec",
        "SimpleSpy", "Synapse", "Kick", "Ban", "AntiExploit", "ExploitDetection",
        "AntiExploitScrpit", "AntiExploitScript", "banscript",
        
        -- Protection terms
        "AntiInject", "ScriptProtection", "ScriptShield", "AntiTamper",
        "MemoryProtect", "Guardian", "Sentinel", "Watchdog", "Defender",
        "Shield", "Protector", "Fortify", "Bulwark", "GProtect", "KillExp",
        "BanWave", "byfron", "byfronbypass", "Anti", "AntiHack",
        "FOREST", "AntiCheat",
        
        -- Commercial AC systems
        "DarkStar", "Elysian", "Vanguard", "FairFight", "EasyAntiCheat",
        "BattlEye", "Nexus", "Polaris", "CheatEngine", "CheatPunch",
        "GameGuard", "XignCode", "nProtect", "HSHIELD", "PunkBuster",
        "Equ8", "Ricochet", "VACnet", "FAC", "SAC", "Warden", "Denuvo", "Citadel Anti-Cheat",
        
        -- Mythological references (common in custom AC)
        "Aegis", "RiotShield", "Ironclad", "Sentry", "Valkyrie", "Hyperion",
        "Artemis", "Apollo", "Athena", "Zeus", "Odin", "Thor", "Fenrir",
        "Jormungandr", "Typhon", "Cerberus", "ByeBye", "Exploiter",
        "Minerva", "Aspect",
        
        -- Obfuscation markers
        "Secure", "Encrypted", "Protected", "Obfuscated", "Bytecode", "XOR",
        
        -- Common module names
        "Detector", "Scanner", "Validator", "Checker", "Monitor", "Logger", "Aspect", "Minerva",

        -- More stuff
        "Crystal", "Redone", "SuperAC", "Flight", "NoAir", "HyperionAC",
        "RAC", "OPA", "UntitledAC", "Seeking", "Identify", "GL", "Gate",
        "Goodbye", "PowerfulAC", "Hitbox", "Bannisher", "SOS", "BadHacker",
        "Tracker", "InfiniteYield", "DarkHub", "Hydrogen", "OxygenU",
        "VapeV4", "ScriptWare", "Krnl", "Fluxus", "Electron", "Comet",
        "Delta", "Eclipse", "Celestial", "SirHurt", "Nihon", "Valyse",
        "Trigon", "Elysian", "Acheron", "Vortex", "Paradox", "Nebula",
        "Phantom", "Specter", "Ghost", "Wraith", "Revenant", "Doppelganger",
        "Ethereal", "Arcane", "Mystic", "Occult", "Enigma", "Cipher",
        "Cryptic", "Shadow", "Veil", "Cloak", "Shroud", "Obfuscator",
        "Deobfuscator", "JJSploit", "ProtoSmasher", "ScriptDumper",
        "HookGen", "Bytecode", "LuaC", "Luau", "Decompiler", "AntiDump",
        "AntiTamper", "AntiDebug", "AntiAttach", "AntiRead", "AntiWrite",
        "AntiLeak", "AntiReverse", "AntiDecompile", "AntiDisassemble",
        "AntiAnalysis", "AntiResearch", "AntiDevelopment", "AntiCreation",
        "AntiDelete", "AntiClone", "AntiCopy", "AntiPaste", "AntiSteal",
        "AntiAttach", "AntiRead", "AntiWrite", "AntiExec", "AntiCall",
        "AntiHook", "AntiInject", "AntiModify", "AntiDelete", "AntiClone",
        "AntiCopy", "AntiPaste", "AntiSteal", "AntiLeak", "AntiReverse",
        "AntiDecompile", "AntiDisassemble", "AntiAnalysis", "AntiResearch",
        "AntiDevelopment", "AntiCreation", "AntiMod", "AntiScript", "AntiLua",
        "AntiRoblox", "AntiExploit", "AntiHack", "AntiCheat", "AntiInject",
        "AntiTamper", "AntiDebug", "AntiAttach", "AntiRead", "AntiWrite",
        "AntiExec", "AntiCall", "AntiHook", "AntiInject", "AntiModify",
        "AntiDelete", "AntiClone", "AntiCopy", "AntiPaste", "AntiSteal",
        "AntiHack", "AntiCheat", "AntiInject", "AntiTamper", "AntiDebug",
        "AntiAttach", "AntiRead", "AntiWrite", "AntiExec", "AntiCall",
        "AntiHook", "AntiInject", "AntiModify", "AntiDelete", "AntiClone",
        "AntiCopy", "AntiPaste", "AntiSteal", "AntiLeak", "AntiReverse",
        "AntiDecompile", "AntiDisassemble", "AntiAnalysis", "AntiResearch",
        "AntiDevelopment", "AntiCreation", "AntiMod", "AntiScript", "AntiLua",
        "AntiRoblox", "AntiExploit", "AntiHack", "AntiCheat", "AntiInject",
        "AntiTamper", "AntiDebug", "AntiAttach", "AntiRead", "AntiWrite",
        "AntiExec", "AntiCall", "AntiHook", "AntiInject", "AntiModify",
        "AntiDelete", "AntiClone", "AntiCopy", "AntiPaste", "AntiSteal",
        "AntiLeak", "AntiReverse", "AntiDecompile", "AntiDisassemble",
        "AntiAnalysis", "AntiResearch", "AntiDevelopment", "AntiCreation",
        "AntiMod", "AntiScript", "AntiLua", "AntiRoblox", "AntiExploit",
        "AntiHack", "AntiCheat", "AntiInject", "AntiTamper", "AntiDebug",
        "AntiAttach", "AntiRead", "AntiWrite", "AntiExec", "AntiCall",
        "AntiHook", "AntiInject", "AntiModify", "AntiDelete", "AntiClone",
        "AntiCopy", "AntiPaste", "AntiSteal", "AntiLeak", "AntiReverse",
        "AntiDecompile", "AntiDisassemble", "AntiAnalysis", "AntiResearch",
        "AntiDevelopment", "AntiCreation", "AntiMod", "AntiScript", "AntiLua",
        "AntiRoblox", "AntiExploit", "AntiHack", "AntiCheat", "AntiInject",
        "AntiTamper", "AntiDebug", "AntiAttach", "AntiRead", "AntiWrite",
        "AntiExec", "AntiCall", "AntiHook", "AntiInject", "AntiModify",
        "AntiDelete", "AntiClone", "AntiCopy", "AntiPaste", "AntiSteal",
        "AntiLeak", "AntiReverse", "AntiDecompile", "AntiDisassemble",
        "AntiAnalysis", "AntiResearch", "AntiDevelopment", "AntiCreation",
        "AntiMod", "AntiScript", "AntiLua", "AntiRoblox", "AntiExploit",
        "AntiHack", "AntiCheat", "AntiInject", "AntiTamper", "AntiDebug",
        "AntiAttach", "AntiRead", "AntiWrite", "AntiExec", "AntiCall", "DllFiles",
        "AntiHook", "AntiInject", "AntiModify", "AntiDelete", "AntiClone",
        "AntiCopy", "AntiPaste", "AntiSteal", "AntiLeak", "AntiReverse",
        "AntiDecompile", "AntiDisassemble", "AntiAnalysis", "AntiResearch",
        "AntiDevelopment", "AntiCreation", "AntiMod", "AntiScript", "AntiLuau",
        "AntiRoblox", "AntiExploit", "AntiHack", "AntiCheat", "AntiInject",
        "AntiTamper", "AntiDebug", "GoodLuck", "NoMod", "AntiSpeedHack"
    }

    -- Services to check for AC components (prioritized by likelihood)
    local servicesToCheck = {
        game:GetService("ServerScriptService"),
        game:GetService("ReplicatedStorage"),
        game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"),
        game:GetService("Workspace"),
        game:GetService("StarterPlayer").StarterPlayerScripts,
        game:GetService("Lighting"),
        game:GetService("StarterPack"),
        game:GetService("StarterGui")
    }
    
    -- Pre-compiled patterns for faster matching
    local suspiciousPatterns = {
        "hook", "inject", "exploit", "cheat", "bypass", "tamper",
        "detect", "monitor", "scan", "validate", "check", "secure", "hitbox",
        "protect", "shield", "guard", "ban", "kick", "report", "fairplay", "debug",
        "guard", "exploit", "fairfight", "nohacks", "aspect", "minerva", "exec",
        "citadel", "anti-cheat", "azure", "infinity", "roblox", "elizabeth", "decompile",
        "warden", "coda", "axon", "mef", "nullify", "byfron", "redfox", "dll",
        "crystal", "redone", "ac", "anticheat", "game guard", "dex",
        "hyperion", "rac", "anti", "opa", "undetected", "unnamed anticheat", "prevention",
        "untitled anticheat", "seeking", "identify", "id", "look", "1ac", "state", "safemode" ,
        "inspect", "examining", "surveying", "scrutinizing", "reviewing", "mod", "nocheat",
        "browsing", "analyzing", "observing", "viewing", "assessing", "tracking", "rat",
        "gg", "gl", "goodluck", "faironly", "antimodification", "speedhack", "esp", "pests",
        
        -- More stuff
        "Crystal", "Redone", "SuperAC", "Flight", "NoAir", "HyperionAC",
        "RAC", "OPA", "UntitledAC", "Seeking", "Identify", "GL", "Gate",
        "Goodbye", "PowerfulAC", "Hitbox", "Bannisher", "SOS", "BadHacker",
        "Tracker", "InfiniteYield", "DarkHub", "Hydrogen", "OxygenU",
        "VapeV4", "ScriptWare", "Krnl", "Fluxus", "Electron", "Comet",
        "Delta", "Eclipse", "Celestial", "SirHurt", "Nihon", "Valyse",
        "Trigon", "Elysian", "Acheron", "Vortex", "Paradox", "Nebula",
        "Phantom", "Specter", "Ghost", "Wraith", "Revenant", "Doppelganger",
        "Ethereal", "Arcane", "Mystic", "Occult", "Enigma", "Cipher",
        "Cryptic", "Shadow", "Veil", "Cloak", "Shroud", "Obfuscator",
        "Deobfuscator", "JJSploit", "ProtoSmasher", "ScriptDumper",
        "HookGen", "Bytecode", "LuaC", "Luau", "Decompiler", "AntiDump",
        "AntiTamper", "AntiDebug", "AntiAttach", "AntiRead", "AntiWrite",
        "AntiLeak", "AntiReverse", "AntiDecompile", "AntiDisassemble",
        "AntiAnalysis", "AntiResearch", "AntiDevelopment", "AntiCreation",
        "AntiDelete", "AntiClone", "AntiCopy", "AntiPaste", "AntiSteal",
        "AntiAttach", "AntiRead", "AntiWrite", "AntiExec", "AntiCall",
        "AntiHook", "AntiInject", "AntiModify", "AntiDelete", "AntiClone",
        "AntiCopy", "AntiPaste", "AntiSteal", "AntiLeak", "AntiReverse",
        "AntiDecompile", "AntiDisassemble", "AntiAnalysis", "AntiResearch",
        "AntiDevelopment", "AntiCreation", "AntiMod", "AntiScript", "AntiLua",
        "AntiRoblox", "AntiExploit", "AntiHack", "AntiCheat", "AntiInject",
        "AntiTamper", "AntiDebug", "AntiAttach", "AntiRead", "AntiWrite",
        "AntiExec", "AntiCall", "AntiHook", "AntiInject", "AntiModify",
        "AntiDelete", "AntiClone", "AntiCopy", "AntiPaste", "AntiSteal",
        "AntiHack", "AntiCheat", "AntiInject", "AntiTamper", "AntiDebug",
        "AntiAttach", "AntiRead", "AntiWrite", "AntiExec", "AntiCall",
        "AntiHook", "AntiInject", "AntiModify", "AntiDelete", "AntiClone",
        "AntiCopy", "AntiPaste", "AntiSteal", "AntiLeak", "AntiReverse",
        "AntiDecompile", "AntiDisassemble", "AntiAnalysis", "AntiResearch",
        "AntiDevelopment", "AntiCreation", "AntiMod", "AntiScript", "AntiLua",
        "AntiRoblox", "AntiExploit", "AntiHack", "AntiCheat", "AntiInject",
        "AntiTamper", "AntiDebug", "AntiAttach", "AntiRead", "AntiWrite",
        "AntiExec", "AntiCall", "AntiHook", "AntiInject", "AntiModify",
        "AntiDelete", "AntiClone", "AntiCopy", "AntiPaste", "AntiSteal",
        "AntiLeak", "AntiReverse", "AntiDecompile", "AntiDisassemble",
        "AntiAnalysis", "AntiResearch", "AntiDevelopment", "AntiCreation",
        "AntiMod", "AntiScript", "AntiLua", "AntiRoblox", "AntiExploit",
        "AntiHack", "AntiCheat", "AntiInject", "AntiTamper", "AntiDebug",
        "AntiAttach", "AntiRead", "AntiWrite", "AntiExec", "AntiCall",
        "AntiHook", "AntiInject", "AntiModify", "AntiDelete", "AntiClone",
        "AntiCopy", "AntiPaste", "AntiSteal", "AntiLeak", "AntiReverse",
        "AntiDecompile", "AntiDisassemble", "AntiAnalysis", "AntiResearch",
        "AntiDevelopment", "AntiCreation", "AntiMod", "AntiScript", "AntiLua",
        "AntiRoblox", "AntiExploit", "AntiHack", "AntiCheat", "AntiInject",
        "AntiTamper", "AntiDebug", "AntiAttach", "AntiRead", "AntiWrite",
        "AntiExec", "AntiCall", "AntiHook", "AntiInject", "AntiModify",
        "AntiDelete", "AntiClone", "AntiCopy", "AntiPaste", "AntiSteal",
        "AntiLeak", "AntiReverse", "AntiDecompile", "AntiDisassemble",
        "AntiAnalysis", "AntiResearch", "AntiDevelopment", "AntiCreation",
        "AntiMod", "AntiScript", "AntiLua", "AntiRoblox", "AntiExploit",
        "AntiHack", "AntiCheat", "AntiInject", "AntiTamper", "AntiDebug",
        "AntiAttach", "AntiRead", "AntiWrite", "AntiExec", "AntiCall", "DllFiles",
        "AntiHook", "AntiInject", "AntiModify", "AntiDelete", "AntiClone",
        "AntiCopy", "AntiPaste", "AntiSteal", "AntiLeak", "AntiReverse",
        "AntiDecompile", "AntiDisassemble", "AntiAnalysis", "AntiResearch",
        "AntiDevelopment", "AntiCreation", "AntiMod", "AntiScript", "AntiLuau",
        "AntiRoblox", "AntiExploit", "AntiHack", "AntiCheat", "AntiInject",
        "AntiTamper", "AntiDebug", "GoodLuck", "NoMod", "AntiSpeedHack"
    }
    
    -- Check for specific AC names and components with optimized yielding
    for serviceIndex, service in ipairs(servicesToCheck) do
        if not ACRunning then break end
        
        -- Yield every service to ensure smooth operation
        task.wait()
        
        local success, descendants = pcall(function()
            return service:GetDescendants()
        end)
        
        if not success then
            warn("Failed to get descendants for: " .. service:GetFullName())
            continue
        end
        
        for itemIndex, item in ipairs(descendants) do
            if not ACRunning then break end
            
            -- Yield every 100 items to prevent freezing
            if itemIndex % 100 == 0 then
                task.wait()
            end
            
            -- Check name matches first (fastest check)
            local itemNameLower = string.lower(item.Name)
            for _, acName in ipairs(commonACNames) do
                if string.find(itemNameLower, string.lower(acName)) then
                    local strength = 1 -- Base strength
                    local detectionType = "Name Match"
                    
                    -- Type-based strength adjustments
                    if item:IsA("RemoteEvent") then
                        strength = strength + 3
                        detectionType = "RemoteEvent"
                    elseif item:IsA("RemoteFunction") then
                        strength = strength + 4
                        detectionType = "RemoteFunction"
                    elseif item:IsA("Script") or item:IsA("ModuleScript") then
                        strength = strength + (item:IsA("ModuleScript") and 3 or 2)
                        detectionType = item.ClassName
                    elseif item:IsA("BindableEvent") or item:IsA("BindableFunction") then
                        strength = strength + 1.5
                        detectionType = "Bindable"
                    elseif item:IsA("LocalScript") then
                        strength = strength + 1.5
                        detectionType = "LocalScript"
                    end
                    
                    -- Source code analysis (only for script objects)
                    if (item:IsA("Script") or item:IsA("LocalScript") or item:IsA("ModuleScript")) and item:IsDescendantOf(service) then
                        local success, source = pcall(function()
                            return item.Source
                        end)
                        
                        if success and source then
                            local sourceLower = string.lower(source)
                            
                            -- Check for obfuscation patterns
                            local obfuscationPatterns = {
                                "getfenv", "setfenv", "loadstring", "bytecode", 
                                "xor", "encrypt", "secure", "protected", "hidden"
                            }
                            
                            for _, pattern in ipairs(obfuscationPatterns) do
                                if string.find(sourceLower, pattern) then
                                    strength = strength + 1
                                    detectionType = detectionType.." | Obfuscated"
                                    break
                                end
                            end
                            
                            -- Check for suspicious function patterns
                            for _, pattern in ipairs(suspiciousPatterns) do
                                if string.find(sourceLower, pattern) then
                                    strength = strength + 0.5
                                    detectionType = detectionType.." | Suspicious Code"
                                    break
                                end
                            end
                        end
                    end
                    
                    table.insert(foundAC, {
                        object = item,
                        name = item.Name,
                        path = item:GetFullName(),
                        type = item.ClassName,
                        strength = strength,
                        detection = detectionType
                    })
                    acStrength = acStrength + strength
                    totalPossibleStrength = totalPossibleStrength + 6 -- Max per item
                    break -- No need to check other names if we found a match
                end
            end
        end
    end
    
    -- Check for hidden or protected scripts (with proper error handling)
    if ACRunning then
        local success, nilInstances = pcall(getnilinstances)
        if success and nilInstances then
            for i, v in ipairs(nilInstances) do
                if not ACRunning then break end
                
                -- Yield every 25 nil instances to prevent freezing
                if i % 25 == 0 then
                    task.wait()
                end
                
                local itemNameLower = string.lower(v.Name)
                for _, acName in ipairs(commonACNames) do
                    if string.find(itemNameLower, string.lower(acName)) then
                        table.insert(foundAC, {
                            object = v,
                            name = v.Name,
                            path = "Hidden Instance",
                            type = v.ClassName,
                            strength = 6, -- Highest strength for hidden AC
                            detection = "Hidden Instance"
                        })
                        acStrength = acStrength + 6
                        totalPossibleStrength = totalPossibleStrength + 6
                        break
                    end
                end
            end
        end
    end
    
    -- Check for memory protection and other system-level AC
    if ACRunning then
        pcall(function()
            -- Check for protected core scripts
            local coreScripts = game:GetService("ScriptContext"):GetScripts()
            for i, script in ipairs(coreScripts) do
                if not ACRunning then break end
                
                -- Yield every 50 scripts to prevent freezing
                if i % 50 == 0 then
                    task.wait()
                end
                
                if script.ClassName == "LocalScript" and not script:IsDescendantOf(game:GetService("Players").LocalPlayer) then
                    table.insert(foundAC, {
                        object = script,
                        name = "Suspicious Core Script",
                        path = script:GetFullName(),
                        type = "LocalScript",
                        strength = 4,
                        detection = "Unusual Core Behavior"
                    })
                    acStrength = acStrength + 4
                    totalPossibleStrength = totalPossibleStrength + 6
                end
            end
            
            -- Check for protected stats
            if not pcall(function() return game:GetService("Stats").PerformanceStats:GetChildren() end) then
                table.insert(foundAC, {
                    name = "Memory Protection",
                    path = "Game Stats",
                    type = "System",
                    strength = 5,
                    detection = "Memory Protection"
                })
                acStrength = acStrength + 5
                totalPossibleStrength = totalPossibleStrength + 6
            end
        end)
    end
    
    -- Final pass for suspicious script behavior
    if ACRunning then
        pcall(function()
            local playerScripts = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts")
            if playerScripts then
                local scripts = playerScripts:GetDescendants()
                for i, script in ipairs(scripts) do
                    if not ACRunning then break end
                    
                    -- Yield every 150 descendants to prevent freezing
                    if i % 150 == 0 then
                        task.wait()
                    end
                    
                    if script:IsA("LocalScript") then
                        local success, source = pcall(function()
                            return script.Source
                        end)
                        
                        if success and source then
                            local sourceLower = string.lower(source)
                            for _, pattern in ipairs(suspiciousPatterns) do
                                if string.find(sourceLower, pattern) then
                                    table.insert(foundAC, {
                                        object = script,
                                        name = "Exploit Detection",
                                        path = script:GetFullName(),
                                        type = "LocalScript",
                                        strength = 5,
                                        detection = "Pattern Match: "..pattern
                                    })
                                    acStrength = acStrength + 5
                                    totalPossibleStrength = totalPossibleStrength + 6
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    
    return {
        components = foundAC,
        strength = acStrength,
        maxStrength = totalPossibleStrength,
        percentage = totalPossibleStrength > 0 and (acStrength / totalPossibleStrength) * 100 or 0,
        lastUpdate = os.time()
    }
end

local function RemoveAntiCheats()
    -- Random delay pattern with better distribution
    SecureWait(math.random() * 0.5 + 0.15) -- Between 0.15 and 0.65
    
    local success, err = pcall(function()
        if not ACRunning then return "Scan aborted" end
        
        -- Use the advanced detection system
        local acData = DetectAntiCheatComponents()
        local deletedCount = 0
        
        -- Remove all detected components with yield points
        for i, ac in ipairs(acData.components) do
            if not ACRunning then break end
            
            -- Yield every 25 deletions to prevent freezing
            if i % 25 == 0 then
                task.wait()
            end
            
            if ac.object and ac.object.Parent then
                pcall(function()
                    ac.object.Parent = nil -- Safer than Destroy
                    deletedCount = deletedCount + 1
                end)
            end
        end
        
        -- Check for common anti-cheat containers
        if ACRunning then
            local suspectFolders = {"Security", "AntiCheat", "Protection", "Shield", "Guard"}
            for i, folderName in ipairs(suspectFolders) do
                if not ACRunning then break end
                
                -- Yield every folder check
                task.wait()
                
                local folder = game:FindFirstChild(folderName)
                if folder and folder:IsA("Folder") then
                    pcall(function()
                        folder:Destroy()
                        deletedCount = deletedCount + 1
                    end)
                end
            end
        end
        
        -- Post-deletion cleanup with better garbage collection
        if deletedCount > 0 and ACRunning then
            -- Gradual garbage collection with yields
            for i = 1, 3 do 
                SecureWait(0.1)
                collectgarbage("step", 100) -- Incremental collection
                task.wait()
            end
            
            return ("Operation completed: %d items processed"):format(deletedCount)
        end
        
    end)
    
    if success then
        LastScanTime = tick()
        print("Scan result: " .. err)
    else
        warn("AC Detection Error: " .. tostring(err):sub(1, 100))
    end
    
    return ACRunning
end

function ACRStart()
    if ACRunning then
        warn("AC Detection already running")
        return
    end
    
    ACRunning = true
    print("Starting advanced security scan")
    
    -- Initial notifications with better timing
    task.spawn(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ACR:Warn",
            Text = "⚠️: This May Lag Alot",
            Duration = 0.9,
            Icon = "rbxassetid://0"
        })

        SecureWait(0.5)

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ACR:System",
            Text = "ACR:HRP Is Active",
            Duration = 0.9,
            Icon = "rbxassetid://0"
        })
    end)
    
    -- Create the removal loop with proper yielding
    task.spawn(function()
        while ACRunning do
            -- Randomize interval slightly to avoid pattern detection
            local scanTime = ACRemovalInterval * (0.9 + math.random() * 0.2)
            SecureWait(scanTime)
            
            if not RemoveAntiCheats() then 
                break 
            end
        end
    end)
end

function ACRStop()
    if not ACRunning then
        warn("AC Detection not active")
        return
    end
    
    ACRunning = false
    print("Scan terminated")
    
    -- Clear any pending operations
    task.wait()
    collectgarbage("collect")
end

function ACSetInterval(seconds)
    if type(seconds) == "number" and seconds > 0 then
        ACRemovalInterval = math.max(0.001, seconds) -- Minimum 1ms interval
        print("Scan interval updated to " .. ACRemovalInterval)
    else
        warn("Invalid interval value")
    end
end

function HrpACR()
      pcall(function()
      local player= game:GetServices('Player').LocalPlayer
      local character = player.Character
      character.Parent = nil
      character.HumanoidRootPart:Destroy()
      character.Parent = workspace
      end)
      print("HrpAcR Is Active")
end

HrpACR()

-- [ LoadsScriptResources ]
pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/hm5650/LoadResources/refs/heads/main/ResSourcesLoaderSource", true))()
warn("StartedScript")
end)

-- Start with random delay and better initialization
task.delay(math.random(1, 3), function()
    if not ACRunning then -- Only start if not already running
        ACRStart()
    end
end)

end)
