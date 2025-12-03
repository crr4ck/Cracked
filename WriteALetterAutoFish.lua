
local r0_0 = game:GetService("Players")
local r1_0 = game:GetService("UserInputService")
local r2_0 = game:GetService("ReplicatedStorage")
local r3_0 = game:GetService("RunService")
local r4_0 = game:GetService("VirtualInputManager")
local r5_0 = game:GetService("ContextActionService")
local r6_0 = r0_0.LocalPlayer
local r7_0 = r6_0.Character or r6_0.CharacterAdded:Wait()
local r8_0 = {
  Enabled = false,
  CastStrength = 0.8,
  AutoCastDelay = 2,
  AutoReelDelay = 0.3,
  AutoHookDelay = 0.15,
  MinigameClickRate = 0.12,
  StrengthModes = {
    Low = 0.4,
    Medium = 0.7,
    High = 1,
  },
  CurrentMode = "High",
}
local r9_0 = false
local r10_0 = nil
local r11_0 = nil
local r12_0 = nil
local r13_0 = nil
local r14_0 = nil
local r15_0 = nil
pcall(function()
  -- line: [0, 0] id: 25
  r15_0 = require(r2_0.Modules.Game.FishMinigameUtil)
end)
local r16_0 = Instance.new("ScreenGui")
r16_0.Name = "AutoFishingUI"
r16_0.ResetOnSpawn = false
r16_0.Parent = r6_0:WaitForChild("PlayerGui")
local r17_0 = Instance.new("Frame")
r17_0.Name = "StatusFrame"
r17_0.Size = UDim2.new(0, 220, 0, 100)
r17_0.Position = UDim2.new(0, 10, 0.5, -50)
r17_0.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
r17_0.BackgroundTransparency = 0.3
r17_0.BorderSizePixel = 0
r17_0.Parent = r16_0
local r18_0 = Instance.new("UICorner")
r18_0.CornerRadius = UDim.new(0, 8)
r18_0.Parent = r17_0
local r19_0 = Instance.new("TextLabel")
r19_0.Name = "Title"
r19_0.Size = UDim2.new(1, 0, 0.3, 0)
r19_0.Position = UDim2.new(0, 0, 0, 0)
r19_0.BackgroundTransparency = 1
r19_0.Text = "AutoFishing"
r19_0.TextColor3 = Color3.fromRGB(255, 255, 255)
r19_0.TextSize = 18
r19_0.Font = Enum.Font.GothamBold
r19_0.Parent = r17_0
local r20_0 = Instance.new("TextLabel")
r20_0.Name = "Status"
r20_0.Size = UDim2.new(1, 0, 0.18, 0)
r20_0.Position = UDim2.new(0, 0, 0.28, 0)
r20_0.BackgroundTransparency = 1
r20_0.Text = "Status: OFF"
r20_0.TextColor3 = Color3.fromRGB(255, 100, 100)
r20_0.TextSize = 14
r20_0.Font = Enum.Font.Gotham
r20_0.Parent = r17_0
local r21_0 = Instance.new("TextLabel")
r21_0.Name = "CurrentState"
r21_0.Size = UDim2.new(1, 0, 0.18, 0)
r21_0.Position = UDim2.new(0, 0, 0.46, 0)
r21_0.BackgroundTransparency = 1
r21_0.Text = ""
r21_0.TextColor3 = Color3.fromRGB(255, 200, 100)
r21_0.TextSize = 12
r21_0.Font = Enum.Font.Gotham
r21_0.Parent = r17_0
local r22_0 = Instance.new("TextLabel")
r22_0.Name = "Strength"
r22_0.Size = UDim2.new(1, 0, 0.18, 0)
r22_0.Position = UDim2.new(0, 0, 0.64, 0)
r22_0.BackgroundTransparency = 1
r22_0.Text = "Strength: Loading..."
r22_0.TextColor3 = Color3.fromRGB(200, 200, 200)
r22_0.TextSize = 11
r22_0.Font = Enum.Font.Gotham
r22_0.Parent = r17_0
local r23_0 = Instance.new("TextLabel")
r23_0.Name = "Controls"
r23_0.Size = UDim2.new(1, 0, 0, 20)
r23_0.Position = UDim2.new(0, 0, 1, 5)
r23_0.BackgroundTransparency = 1
r23_0.Text = "F: Toggle | G: Strength | RCtrl: Hide"
r23_0.TextColor3 = Color3.fromRGB(150, 150, 150)
r23_0.TextSize = 10
r23_0.Font = Enum.Font.Gotham
r23_0.Parent = r17_0
local r24_0 = nil
local r25_0 = false
local r26_0 = "Idle"
local function r27_0()
  -- line: [0, 0] id: 4
  if r8_0.Enabled then
    r20_0.Text = "Status: ON"
    r20_0.TextColor3 = Color3.fromRGB(100, 255, 100)
    r21_0.Text = r26_0
    r21_0.TextColor3 = Color3.fromRGB(255, 200, 100)
  else
    r20_0.Text = "Status: OFF"
    r20_0.TextColor3 = Color3.fromRGB(255, 100, 100)
    r21_0.Text = ""
  end
  r22_0.Text = "Strength: " .. r8_0.CurrentMode
end
local function r28_0()
  -- line: [0, 0] id: 21
  r7_0 = r6_0.Character
  if not r7_0 then
    return nil
  end
  for r3_21, r4_21 in pairs(r7_0:GetChildren()) do
    if r4_21:IsA("Tool") and (r4_21.Name:lower():find("fishing") or r4_21.Name:lower():find("rod") or r4_21.Name:lower():find("caÃ±a")) then
      return r4_21
    end
  end
  local r0_21 = r6_0:FindFirstChild("Backpack")
  if r0_21 then
    for r4_21, r5_21 in pairs(r0_21:GetChildren()) do
      if r5_21:IsA("Tool") and (r5_21.Name:lower():find("fishing") or r5_21.Name:lower():find("rod") or r5_21.Name:lower():find("caÃ±a")) then
        return r5_21
      end
    end
  end
  return nil
end
local function r29_0(r0_15)
  -- line: [0, 0] id: 15
  if not r0_15 then
    return false
  end
  local r1_15 = r7_0 and r7_0:FindFirstChild("Humanoid")
  if not r1_15 then
    return false
  end
  if r0_15.Parent == r7_0 then
    return true
  end
  r1_15:EquipTool(r0_15)
  task.wait(0.5)
  return r0_15.Parent == r7_0
end
local function r30_0()
  -- line: [0, 0] id: 19
  local r0_19 = r7_0 and r7_0:FindFirstChild("Humanoid")
  if not r0_19 then
    return 
  end
  r0_19:UnequipTools()
  task.wait(0.3)
end
local function r31_0(r0_3)
  -- line: [0, 0] id: 3
  if not r0_3 then
    return false
  end
  r26_0 = "Resetting rod..."
  r27_0()
  r30_0()
  task.wait(0.5)
  return r29_0(r0_3)
end
local function r32_0(r0_16)
  -- line: [0, 0] id: 16
  if r0_16 and r0_16:IsA("Tool") then
    r0_16:Activate()
  end
end
local function r33_0()
  -- line: [0, 0] id: 24
  local r0_24 = {
    moveDirection = Vector3.zero,
    isInSuccessZone = false,
    targetDistance = 1,
    offsetX = 0,
    offsetY = 0,
  }
  local r1_24 = r6_0:FindFirstChild("PlayerGui")
  if not r1_24 then
    return r0_24
  end
  local r2_24 = r1_24:FindFirstChild("FishMinigame")
  if not r2_24 then
    return r0_24
  end
  local r3_24 = r2_24:FindFirstChild("OuterRing")
  if not r3_24 then
    return r0_24
  end
  local r4_24 = r3_24:FindFirstChild("Target")
  local r5_24 = r3_24:FindFirstChild("InnerRing")
  if not r4_24 then
    return r0_24
  end
  local r6_24 = r4_24.Position
  local r7_24 = r6_24.X.Scale - 0.5
  local r8_24 = r6_24.Y.Scale - 0.5
  r0_24.offsetX = r7_24
  r0_24.offsetY = r8_24
  local r9_24 = math.sqrt(r7_24 * r7_24 + r8_24 * r8_24)
  r0_24.targetDistance = r9_24
  local r10_24 = 0.3
  if r5_24 then
    r10_24 = r5_24.Size.X.Scale / 2
  end
  r0_24.isInSuccessZone = r9_24 < r10_24
  return r0_24
end
local r34_0 = {
  W = false,
  A = false,
  S = false,
  D = false,
}
local function r35_0(r0_20, r1_20)
  -- line: [0, 0] id: 20
  local r2_20 = game:GetService("VirtualInputManager")
  if r1_20 then
    r2_20:SendKeyEvent(true, r0_20, false, game)
  else
    r2_20:SendKeyEvent(false, r0_20, false, game)
  end
end
local function r36_0(r0_2, r1_2)
  -- line: [0, 0] id: 2
  local r2_2 = 0.05
  if math.sqrt(r0_2 * r0_2 + r1_2 * r1_2) < r2_2 then
    if r34_0.W then
      r35_0(Enum.KeyCode.W, false)
      r34_0.W = false
    end
    if r34_0.A then
      r35_0(Enum.KeyCode.A, false)
      r34_0.A = false
    end
    if r34_0.S then
      r35_0(Enum.KeyCode.S, false)
      r34_0.S = false
    end
    if r34_0.D then
      r35_0(Enum.KeyCode.D, false)
      r34_0.D = false
    end
    return 
  end
  local r4_2 = r2_2 < r1_2
  local r5_2 = r1_2 < -r2_2
  local r6_2 = r2_2 < r0_2
  local r7_2 = r0_2 < -r2_2
  if r4_2 and not r34_0.W then
    r35_0(Enum.KeyCode.W, true)
    r34_0.W = true
  elseif not r4_2 and r34_0.W then
    r35_0(Enum.KeyCode.W, false)
    r34_0.W = false
  end
  if r5_2 and not r34_0.S then
    r35_0(Enum.KeyCode.S, true)
    r34_0.S = true
  elseif not r5_2 and r34_0.S then
    r35_0(Enum.KeyCode.S, false)
    r34_0.S = false
  end
  if r6_2 and not r34_0.A then
    r35_0(Enum.KeyCode.A, true)
    r34_0.A = true
  elseif not r6_2 and r34_0.A then
    r35_0(Enum.KeyCode.A, false)
    r34_0.A = false
  end
  if r7_2 and not r34_0.D then
    r35_0(Enum.KeyCode.D, true)
    r34_0.D = true
  elseif not r7_2 and r34_0.D then
    r35_0(Enum.KeyCode.D, false)
    r34_0.D = false
  end
end
local function r37_0()
  -- line: [0, 0] id: 23
  if r34_0.W then
    r35_0(Enum.KeyCode.W, false)
    r34_0.W = false
  end
  if r34_0.A then
    r35_0(Enum.KeyCode.A, false)
    r34_0.A = false
  end
  if r34_0.S then
    r35_0(Enum.KeyCode.S, false)
    r34_0.S = false
  end
  if r34_0.D then
    r35_0(Enum.KeyCode.D, false)
    r34_0.D = false
  end
end
local function r38_0()
  -- line: [0, 0] id: 1
  r9_0 = false
  if r10_0 then
    r10_0:Disconnect()
    r10_0 = nil
  end
  if r11_0 then
    task.cancel(r11_0)
    r11_0 = nil
  end
  if r12_0 then
    task.cancel(r12_0)
    r12_0 = nil
  end
  r37_0()
  r27_0()
end
local function r39_0(r0_12)
  -- line: [0, 0] id: 12
  if r9_0 then
    return 
  end
  r9_0 = true
  r13_0 = r0_12
  r14_0 = tick()
  r26_0 = "Minigame Active"
  r27_0()
  r12_0 = task.spawn(function()
    -- line: [0, 0] id: 14
    local r0_14 = 0
    while r9_0 do
      local r1_14 = r8_0.Enabled
      if r1_14 then
        r1_14 = r33_0()
        r36_0(r1_14.offsetX, r1_14.offsetY)
        local r2_14 = tick()
        if r1_14.isInSuccessZone and r8_0.MinigameClickRate <= r2_14 - r0_14 and r24_0 and r24_0.Parent == r7_0 then
          r32_0(r24_0)
          r0_14 = r2_14
        end
        task.wait(0.03)
      else
        break
      end
    end
    r37_0()
  end)
  r10_0 = r3_0.RenderStepped:Connect(function()
    -- line: [0, 0] id: 13
    local r0_13 = r6_0:FindFirstChild("PlayerGui")
    if not r0_13 then
      return 
    end
    if not r0_13:FindFirstChild("FishMinigame") then
      r38_0()
    end
  end)
end
local r40_0 = nil
local function r41_0()
  -- line: [0, 0] id: 5
  if r40_0 then
    return 
  end
  r25_0 = true
  r40_0 = task.spawn(function()
    -- line: [0, 0] id: 6
    while r8_0.Enabled do
      local r0_6 = r25_0
      if r0_6 then
        r7_0 = r6_0.Character
        r0_6 = r7_0
        local r1_6 = nil	-- notice: implicit variable refs by block#[4]
        if r0_6 then
          r0_6 = r7_0:FindFirstChild("Humanoid")
          if not r0_6 then
            ::label_19::
            r1_6 = 1
            task.wait(r1_6)
          end
        else
          goto label_19	-- block#4 is visited secondly
        end
        r24_0 = r28_0()
        r0_6 = r24_0
        if not r0_6 then
          r26_0 = "Searching for rod..."
          r27_0()
          task.wait(1)
        else
          r0_6 = r24_0.Parent
          r1_6 = r7_0
          if r0_6 ~= r1_6 then
            r29_0(r24_0)
            task.wait(0.5)
          end
          r0_6 = r24_0:FindFirstChild("ClassEvent")
          local r2_6 = nil	-- notice: implicit variable refs by block#[20]
          if r0_6 then
            r1_6 = false
            r2_6 = false
            local r3_6 = nil
            r3_6 = r0_6.OnClientEvent:Connect(function(r0_7)
              -- line: [0, 0] id: 7
              if not r8_0.Enabled then
                return 
              end
              if r0_7.type == "BITE" then
                r26_0 = "Bite! Hooking..."
                r27_0()
                task.delay(r8_0.AutoHookDelay, function()
                  -- line: [0, 0] id: 8
                  if r24_0 and r24_0.Parent == r7_0 then
                    r32_0(r24_0)
                  end
                end)
              elseif r0_7.type == "MINIGAME" then
                r26_0 = "Starting Minigame..."
                r27_0()
                r2_6 = true
                task.delay(0.1, function()
                  -- line: [0, 0] id: 10
                  r39_0(r0_7.seed)
                end)
              elseif r0_7.type == "LAND" then
                r26_0 = "Caught: " .. (r0_7.name or "Fish") .. "!"
                r27_0()
                r38_0()
                r1_6 = true
                task.delay(0.5, function()
                  -- line: [0, 0] id: 9
                  r31_0(r24_0)
                end)
              elseif r0_7.type == "BITE_ESCAPE" then
                r26_0 = "Fish escaped..."
                r27_0()
                r38_0()
              elseif r0_7.type == "RESET" then
                r26_0 = "Resetting..."
                r27_0()
                r38_0()
              end
            end)
            r26_0 = "Casting..."
            r27_0()
            r32_0(r24_0)
            task.wait(r8_0.CastStrength)
            r26_0 = "Waiting for fish..."
            r27_0()
            local r4_6 = tick()
            local r5_6 = 90
            while r8_0.Enabled do
              local r6_6 = tick() - r4_6
              if r6_6 < r5_6 and not r1_6 then
                task.wait(0.5)
              else
                break
              end
            end
            if r3_6 then
              r3_6:Disconnect()
            end
            r38_0()
            if r1_6 then
              r26_0 = "Preparing next..."
              r27_0()
            end
            task.wait(r8_0.AutoCastDelay)
            -- close: r1_6
          else
            r1_6 = "Basic mode..."
            r26_0 = r1_6
            r1_6 = r27_0
            r1_6()
            r1_6 = r32_0
            r2_6 = r24_0
            r1_6(r2_6)
            r1_6 = task
            r1_6 = r1_6.wait
            r2_6 = 3
            r1_6(r2_6)
          end
        end
      else
        break
      end
    end
  end)
end
local function r42_0()
  -- line: [0, 0] id: 17
  r25_0 = false
  r26_0 = "Idle"
  r38_0()
  if r40_0 then
    task.cancel(r40_0)
    r40_0 = nil
  end
  r27_0()
end
local function r43_0()
  -- line: [0, 0] id: 22
  local r0_22 = {
    "Low",
    "Medium",
    "High"
  }
  r8_0.CurrentMode = r0_22[(table.find(r0_22, r8_0.CurrentMode) or 3) % #r0_22 + 1]
  r8_0.CastStrength = r8_0.StrengthModes[r8_0.CurrentMode]
  r27_0()
end
r1_0.InputBegan:Connect(function(r0_18, r1_18)
  -- line: [0, 0] id: 18
  if r1_18 then
    return 
  end
  if r0_18.KeyCode == Enum.KeyCode.F then
    r8_0.Enabled = not r8_0.Enabled
    if r8_0.Enabled then
      r41_0()
    else
      r42_0()
    end
    r27_0()
  elseif r0_18.KeyCode == Enum.KeyCode.G then
    r43_0()
  elseif r0_18.KeyCode == Enum.KeyCode.RightControl then
    r17_0.Visible = not r17_0.Visible
  end
end)
r6_0.CharacterAdded:Connect(function(r0_11)
  -- line: [0, 0] id: 11
  r7_0 = r0_11
  r38_0()
  if r8_0.Enabled then
    task.wait(2)
    r41_0()
  end
end)
r27_0()
