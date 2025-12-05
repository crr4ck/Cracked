-- for m-metallum
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local TweenService      = game:GetService("TweenService")
local SoundService      = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local MyCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Camera = Workspace.CurrentCamera

-- ========================= SETTINGS =========================
local AntiHitEnabled      = true    -- Main anti-hit (auto E)
local HitboxEnabled       = false   -- Hitbox expander
local HitboxSize          = 15      -- 5 ~ 17 (adjustable in UI)
local DetectionRange      = 17      -- Max distance to detect attacking player
local Cooldown            = 2       -- Anti-spam cooldown for pressing E
local AttackAnimationIDs  = {
    "rbxassetid://8986981647",
    "rbxassetid://9017185681",
    "rbxassetid://9027616415",
    "rbxassetid://5416575259",
    "rbxassetid://5424166879",
    "rbxassetid://5436059670",
    "rbxassetid://5436083192",
    "rbxassetid://3016814540",
    "rbxassetid://3016734456",
    "rbxassetid://4061495031",
    "rbxassetid://5435928313",
    "rbxassetid://5642769282",
    "rbxassetid://5642777160",
    "rbxassetid://5705126205",
    "rbxassetid://5705174594",
    "rbxassetid://5705254261"
}

-- ========================= SOUNDS =========================
local Sounds = {}
local function PlaySound(id, volume)
    spawn(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = volume or 0.5
        s.Parent = SoundService
        s:Play()
        s.Ended:Wait()
        s:Destroy()
    end)
end

pcall(function()
    Sounds.toggleOn  = "rbxassetid://83374956945112"
    Sounds.toggleOff = "rbxassetid://83374956945112"
    Sounds.uiLoaded  = "rbxassetid://8486683243"
    Sounds.click     = "rbxassetid://3570574851"
end)

-- ========================= LOADING SCREEN =========================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingUI"
LoadingGui.Parent = game:GetService("CoreGui")

local Bg = Instance.new("Frame")
Bg.Size = UDim2.new(1,0,1,0)
Bg.BackgroundColor3 = Color3.fromRGB(10,10,15)
Bg.Parent = LoadingGui

local Warn = Instance.new("TextLabel")
Warn.Size = UDim2.new(0,0,0,0)
Warn.Position = UDim2.new(0.5,0,0.4,0)
Warn.AnchorPoint = Vector2.new(0.5,0.5)
Warn.BackgroundTransparency = 1
Warn.Text = "Warning"
Warn.TextColor3 = Color3.fromRGB(255,215,0)
Warn.Font = Enum.Font.GothamBold
Warn.TextSize = 0
Warn.TextTransparency = 1
Warn.Parent = Bg

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0,0,0,0)
Title.Position = UDim2.new(0.5,0,0.5,0)
Title.AnchorPoint = Vector2.new(0.5,0.5)
Title.BackgroundTransparency = 1
Title.Text = "EZ.RU"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 0
Title.TextTransparency = 1
Title.Parent = Bg

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0,0,0,0)
SubTitle.Position = UDim2.new(0.5,0,0.58,0)
SubTitle.AnchorPoint = Vector2.new(0.5,0.5)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Anti-Hit System"
SubTitle.TextColor3 = Color3.fromRGB(180,180,200)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 0
SubTitle.TextTransparency = 1
SubTitle.Parent = Bg

-- ========================= MAIN UI =========================
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "EZRU_UI"
MainGui.Parent = game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0,250,0,220)
Container.Position = UDim2.new(0.8,10,0.1,0)
Container.BackgroundColor3 = Color3.fromRGB(25,25,35)
Container.ClipsDescendants = true
Container.Visible = false
Container.Parent = MainGui

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1,6,1,6)
Shadow.Position = UDim2.new(0,-3,0,-3)
Shadow.BackgroundColor3 = Color3.new(0,0,0)
Shadow.BackgroundTransparency = 0.8
Shadow.ZIndex = -1
Shadow.Parent = Container

-- Title bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundColor3 = Color3.fromRGB(40,40,50)
TopBar.Parent = Container

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60,60,80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,60))
}
Gradient.Rotation = 90
Gradient.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1,-60,1,0)
TitleLabel.Position = UDim2.new(0,10,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "EZ.RU"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0,50,1,0)
Version.Position = UDim2.new(1,-50,0,0)
Version.BackgroundTransparency = 1
Version.Text = "v1.0"
Version.TextColor3 = Color3.fromRGB(150,150,180)
Version.Font = Enum.Font.Gotham
Version.TextSize = 12
Version.Parent = TopBar

-- Minimize button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0,30,0,30)
MinimizeBtn.Position = UDim2.new(1,-35,0,5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,70)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(200,200,220)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0,6)

-- Content
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,0,1,-40)
ContentFrame.Position = UDim2.new(0,0,0,40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Container

-- Anti-Hit Toggle
local AntiHitRow = Instance.new("Frame")
AntiHitRow.Size = UDim2.new(0.9,0,0,60)
AntiHitRow.Position = UDim2.new(0.05,0,0.05,0)
AntiHitRow.BackgroundTransparency = 1
AntiHitRow.Parent = ContentFrame

local AntiHitLabel = Instance.new("TextLabel")
AntiHitLabel.Size = UDim2.new(0.7,0,0.5,0)
AntiHitLabel.BackgroundTransparency = 1
AntiHitLabel.Text = "Anti-Hit"
AntiHitLabel.TextColor3 = Color3.new(1,1,1)
AntiHitLabel.Font = Enum.Font.GothamBold
AntiHitLabel.TextSize = 16
AntiHitLabel.TextXAlignment = Enum.TextXAlignment.Left
AntiHitLabel.Parent = AntiHitRow

local AntiHitToggle = Instance.new("TextButton")
AntiHitToggle.Size = UDim2.new(0,50,0,25)
AntiHitToggle.Position = UDim2.new(1,-50,0.25,-12)
AntiHitToggle.BackgroundColor3 = Color3.fromRGB(60,180,80)
AntiHitToggle.Text = ""
AntiHitToggle.Parent = AntiHitRow
Instance.new("UICorner", AntiHitToggle).CornerRadius = UDim.new(0,12)

local AntiHitKnob = Instance.new("Frame")
AntiHitKnob.Size = UDim2.new(0,19,0,19)
AntiHitKnob.Position = UDim2.new(0.62,0,0.5,-9.5)
AntiHitKnob.BackgroundColor3 = Color3.new(1,1,1)
AntiHitKnob.Parent = AntiHitToggle
Instance.new("UICorner", AntiHitKnob).CornerRadius = UDim.new(0,10)

-- Hitbox Expander Toggle
local HitboxRow = Instance.new("Frame")
HitboxRow.Size = UDim2.new(0.9,0,0,60)
HitboxRow.Position = UDim2.new(0.05,0,0.28,0)
HitboxRow.BackgroundTransparency = 1
HitboxRow.Parent = ContentFrame

local HitboxLabel = Instance.new("TextLabel")
HitboxLabel.Size = UDim2.new(0.7,0,0.5,0)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.Text = "Hitbox Expander"
HitboxLabel.TextColor3 = Color3.new(1,1,1)
HitboxLabel.Font = Enum.Font.GothamBold
HitboxLabel.TextSize = 16
HitboxLabel.TextXAlignment = Enum.TextXAlignment.Left
HitboxLabel.Parent = HitboxRow

local HitboxToggle = Instance.new("TextButton")
HitboxToggle.Size = UDim2.new(0,50,0,25)
HitboxToggle.Position = UDim2.new(1,-50,0.25,-12)
HitboxToggle.BackgroundColor3 = Color3.fromRGB(180,60,60)
HitboxToggle.Text = ""
HitboxToggle.Parent = HitboxRow
Instance.new("UICorner", HitboxToggle).CornerRadius = UDim.new(0,12)

local HitboxKnob = Instance.new("Frame")
HitboxKnob.Size = UDim2.new(0,19,0,19)
HitboxKnob.Position = UDim2.new(0.1,0,0.5,-9.5)
HitboxKnob.BackgroundColor3 = Color3.new(1,1,1)
HitboxKnob.Parent = HitboxToggle
Instance.new("UICorner", HitboxKnob).CornerRadius = UDim.new(0,10)

-- Slider (only visible when hitbox enabled)
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0.9,0,0,50)
SliderFrame.Position = UDim2.new(0.05,0,0.51,0)
SliderFrame.BackgroundTransparency = 1
SliderFrame.Visible = false
SliderFrame.Parent = ContentFrame

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1,0,0,20)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Hitbox Size: 15"
SliderLabel.TextColor3 = Color3.fromRGB(200,200,220)
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextSize = 14
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = SliderFrame

local Track = Instance.new("Frame")
Track.Size = UDim2.new(1,0,0,6)
Track.Position = UDim2.new(0,0,0.6,0)
Track.BackgroundColor3 = Color3.fromRGB(50,50,70)
Track.Parent = SliderFrame
Instance.new("UICorner", Track).CornerRadius = UDim.new(0,3)

local Fill = Instance.new("Frame")
Fill.Size = UDim2.new(0.588,0,1,0)
Fill.BackgroundColor3 = Color3.fromRGB(80,120,200)
Fill.Parent = Track
Instance.new("UICorner", Fill).CornerRadius = UDim.new(0,3)

local Knob = Instance.new("Frame")
Knob.Size = UDim2.new(0,20,0,20)
Knob.Position = UDim2.new(0.588,-10,0.5,-10)
Knob.BackgroundColor3 = Color3.new(1,1,1)
Knob.ZIndex = 2
Knob.Parent = Track
Instance.new("UICorner", Knob).CornerRadius = UDim.new(0,10)

-- ========================= LOGIC =========================
local LastEPress = 0

local function PressE()
    if tick() - LastEPress < Cooldown then return end
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    LastEPress = tick()
end

local function IsEnemyAttacking(char)
    if not char or char == MyCharacter then return false end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return false end
    
    local distance = (root.Position - MyCharacter:WaitForChild("HumanoidRootPart").Position).Magnitude
    if distance > DetectionRange then return false end

    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        if track.Animation and table.find(AttackAnimationIDs, track.Animation.AnimationId) then
            return true
        end
    end
    return false
end

-- Anti-Hit Loop
local AntiHitConnection
local function StartAntiHit()
    if AntiHitConnection then AntiHitConnection:Disconnect() end
    AntiHitConnection = RunService.Heartbeat:Connect(function()
        if not AntiHitEnabled then return end
        MyCharacter = LocalPlayer.Character
        if not MyCharacter or not MyCharacter:FindFirstChild("HumanoidRootPart") then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                if IsEnemyAttacking(plr.Character) then
                    PressE()
                    task.wait(0.3)
                    break
                end
            end
        end
    end)
end

local function StopAntiHit()
    if AntiHitConnection then AntiHitConnection:Disconnect() end
end

-- Hitbox Expander Loop
local HitboxConnection
local function StartHitbox()
    if HitboxConnection then HitboxConnection:Disconnect() end
    HitboxConnection = RunService.RenderStepped:Connect(function()
        if not HitboxEnabled then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    head.Transparency = 0.6
                    head.BrickColor = BrickColor.new("Red")
                    head.Material = Enum.Material.Neon
                    head.CanCollide = false
                    head.Massless = true
                end
            end
        end
    end)
end

local function StopHitbox()
    if HitboxConnection then HitboxConnection:Disconnect() end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                head.Size = Vector3.new(1,1,1)
                head.Transparency = 0
                head.CanCollide = true
                head.Massless = false
            end
        end
    end
end

-- Update Slider
local function UpdateSlider()
    SliderLabel.Text = "Hitbox Size: " .. math.floor(HitboxSize)
    local ratio = math.clamp((HitboxSize - 5) / 12, 0, 1)
    Fill.Size = UDim2.new(ratio, 0, 1, 0)
    Knob.Position = UDim2.new(ratio, -10, 0.5, -10)
end

-- ========================= TOGGLES =========================
AntiHitToggle.MouseButton1Click:Connect(function()
    PlaySound(Sounds.click, 0.4)
    AntiHitEnabled = not AntiHitEnabled
    AntiHitToggle.BackgroundColor3 = AntiHitEnabled and Color3.fromRGB(60,180,80) or Color3.fromRGB(180,60,60)
    TweenService:Create(AntiHitKnob, TweenInfo.new(0.2), {Position = UDim2.new(AntiHitEnabled and 0.62 or 0.1, 0, 0.5, -9.5)}):Play()
    if AntiHitEnabled then StartAntiHit() else StopAntiHit() end
end)

HitboxToggle.MouseButton1Click:Connect(function()
    PlaySound(Sounds.click, 0.4)
    HitboxEnabled = not HitboxEnabled
    HitboxToggle.BackgroundColor3 = HitboxEnabled and Color3.fromRGB(60,180,80) or Color3.fromRGB(180,60,60)
    TweenService:Create(HitboxKnob, TweenInfo.new(0.2), {Position = UDim2.new(HitboxEnabled and 0.62 or 0.1, 0, 0.5, -9.5)}):Play()
    SliderFrame.Visible = HitboxEnabled
    Container.Size = HitboxEnabled and UDim2.new(0,250,0,220) or UDim2.new(0,250,0,180)
    if HitboxEnabled then StartHitbox() else StopHitbox() end
end)

-- Slider Dragging
local dragging = false
Track.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)
Track.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local relX = mousePos.X - Track.AbsolutePosition.X
        local ratio = math.clamp(relX / Track.AbsoluteSize.X, 0, 1)
        HitboxSize = 5 + math.floor(ratio * 12)
        UpdateSlider()
    end
end)

-- Minimize / Expand
MinimizeBtn.MouseButton1Click:Connect(function()
    PlaySound(Sounds.click, 0.4)
    ContentFrame.Visible = not ContentFrame.Visible
    if ContentFrame.Visible then
        Container.Size = HitboxEnabled and UDim2.new(0,250,0,220) or UDim2.new(0,250,0,180)
        MinimizeBtn.Text = "−"
    else
        Container.Size = UDim2.new(0,250,0,40)
        MinimizeBtn.Text = "+"
    end
end)

-- Draggable UI
local draggingUI = false
local dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingUI = true
        dragStart = input.Position
        startPos = Container.Position
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingUI and input == dragInput then
        local delta = input.Position - dragStart
        Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- F6 Toggle UI
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.F6 then
        PlaySound(Sounds.click, 0.4)
        ContentFrame.Visible = not ContentFrame.Visible
        if ContentFrame.Visible then
            Container.Size = HitboxEnabled and UDim2.new(0,250,0,220) or UDim2.new(0,250,0,180)
            MinimizeBtn.Text = "−"
        else
            Container.Size = UDim2.new(0,250,0,40)
            MinimizeBtn.Text = "+"
        end
    end
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
    MyCharacter = char
end)

-- ========================= STARTUP ANIMATION =========================
spawn(function()
    wait(0.5)
    TweenService:Create(Warn, TweenInfo.new(0.8), {TextSize = 80, TextTransparency = 0}):Play()
    wait(0.8)
    TweenService:Create(Warn, TweenInfo.new(0.5), {TextSize = 100}):Play()
    wait(0.5)
    TweenService:Create(Warn, TweenInfo.new(0.3), {TextSize = 60}):Play()
    wait(0.3)
    TweenService:Create(Title, TweenInfo.new(0.7), {TextSize = 36, TextTransparency = 0}):Play()
    wait(0.5)
    TweenService:Create(SubTitle, TweenInfo.new(0.5), {TextSize = 18, TextTransparency = 0}):Play()
    wait(1.5)

    -- Fade out loading
    TweenService:Create(Bg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Warn, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(Title, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(SubTitle, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    wait(0.9)

    PlaySound(Sounds.uiLoaded, 0.4)
    LoadingGui:Destroy()

    -- Show main UI
    Container.Visible = true
    Container.Position = UDim2.new(0.8,10,0,-200)
    TweenService:Create(Container, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.8,10,0.1,0)
    }):Play()

    UpdateSlider()
    if AntiHitEnabled then StartAntiHit() end
end)

-- deobfuscated in 6.3s
