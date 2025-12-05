-- FileName: _E2.lua
-- FileSize: N/A
-- TimeTaken: 5.2s (average load)
-- Variables: 
-- Functions: 

local HttpService       = game:GetService("HttpService") -- [Service] HttpService
local TweenService      = game:GetService("TweenService") -- [Service] TweenService
local StarterGui        = game:GetService("StarterGui") -- [Service] StarterGui
local UserInputService  = game:GetService("UserInputService") -- [Service] UserInputService
local Players           = game:GetService("Players") -- [Service] Players
local MarketplaceService = game:GetService("MarketplaceService") -- [Service] MarketplaceService
local Lighting          = game:GetService("Lighting") -- [Service] Lighting
local LocalPlayer       = Players.LocalPlayer -- [Player] LocalPlayer

local HUB_URL = "https://raw.githubusercontent.com/x2Zeroo/XEPHEXHUB/main/aimbot" -- [URL] Main Script Source

-- Function.CreateBlurEffect
local blur = Instance.new("BlurEffect") -- [Instance] BlurEffect
blur.Size = 8
blur.Parent = Lighting
blur.Name = "XEPHEXHUB_BLUR"

-- Function.NotifyCore
local function Notify(title, text, duration) -- [Function] NotifyCore
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "XEPHEX HUB",
            Text = text or "Loaded successfully!",
            Duration = duration or 4,
        })
    end)
end

-- Function.PopupNotification
local function PopupNotify(iconText, message) -- [Function] PopupNotification
    local screenGui = Instance.new("ScreenGui", game.CoreGui) -- [Instance] TempScreenGui
    screenGui.Name = "XEPHEXHUB_TEMP"

    local frame = Instance.new("Frame", screenGui) -- [Instance] NotifyFrame
    frame.Size = UDim2.new(0, 280, 0, 52)
    frame.Position = UDim2.new(1, -300, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", frame) -- [Instance] CornerRadius
    corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", frame) -- [Instance] BorderStroke
    stroke.Color = Color3.fromRGB(0, 255, 200)
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    local icon = Instance.new("ImageLabel", frame) -- [Instance] IconLabel
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 15, 0.5, -14)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://80283328189076"
    icon.ImageTransparency = 1

    local label = Instance.new("TextLabel", frame) -- [Instance] MessageLabel
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 55, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTransparency = 1

    local sound = Instance.new("Sound") -- [Instance] NotifySound
    sound.SoundId = "rbxassetid://6026984224"
    sound.Volume = 1
    sound.Parent = workspace
    sound:Play()
    game.Debris:AddItem(sound, 3)

    -- Animate.In
    TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()

    task.wait(3.5)

    -- Effect.Particles
    for i = 1, 12 do
        local particle = Instance.new("Frame", screenGui) -- [Instance] ParticleEffect
        particle.Size = UDim2.new(0, math.random(4,8), 0, math.random(4,8))
        particle.Position = UDim2.new(1, -300 + math.random(0,260), 0, 40 + math.random(0,40))
        particle.BackgroundColor3 = Color3.fromRGB(255, math.random(50,80), math.random(50,80))
        particle.BorderSizePixel = 0
        Instance.new("UICorner", particle).CornerRadius = UDim.new(1,0)

        TweenService:Create(particle, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = particle.Position + UDim2.new(0, math.random(-20,20), 0, -math.random(20,50)),
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,0)
        }):Play()
        game.Debris:AddItem(particle, 1)
    end

    -- Animate.Out
    TweenService:Create(frame, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    TweenService:Create(label, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(icon, TweenInfo.new(0.8), {ImageTransparency = 1}):Play()

    task.wait(0.9)
    screenGui:Destroy()
end

-- Execute.Popup
PopupNotify("Success", "XEPHEX HUB Loading...")

-- Execute.BypassNotify
Notify("XEPHEX HUB", "Key system bypassed • Instant load", 5)

task.wait(1)

-- Execute.MainScript
_G.PASSWORD = "xephexbyzero" -- [Global] AuthToken (required by original)
loadstring(game:HttpGet(HUB_URL))() -- [Loadstring] Main Hub

-- Cleanup.Effects
task.delay(1, function()
    _G.PASSWORD = nil
    if blur and blur.Parent then
        blur:Destroy() -- [Destroy] BlurEffect
    end
end)

-- Final.Notify
Notify("XEPHEX HUB", "Free version loaded • No key needed", 6)
print("XEPHEX HUB | Status: Active | Key: Bypassed | Mode: Free")
