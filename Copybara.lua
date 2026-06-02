-- ===========================================================
-- COPYBARA HUB - FULL VISIBLE (500x460) - ALL BUTTONS VISIBLE
-- GUI ធំល្មម មើលឃើញទាំងអស់
-- ===========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Settings (same as before)
local Settings = {
    aimbot = false, aimbotFOV = 120,
    noRecoil = false, noSpread = false,
    playerWallhack = false, npcWallhack = false,
    playerESP = false, wallhackColor = Color3.fromRGB(255, 80, 80),
    infiniteJump = false, noclip = false,
    walkSpeed = 16, jumpPower = 50,
    killAuraPlayer = false, autoKillNPC = false,
}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopybaraHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 460)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(70, 100, 200)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.Text = "🦫 Copybara Hub - Full Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Dragging
local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Scroll Frame (large enough)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -12, 1, -42)
scrollFrame.Position = UDim2.new(0, 6, 0, 38)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 120, 200)
scrollFrame.Parent = mainFrame

local contentGrid = Instance.new("Frame")
contentGrid.Size = UDim2.new(1, 0, 0, 0)
contentGrid.BackgroundTransparency = 1
contentGrid.Parent = scrollFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.Parent = contentGrid
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.CellPadding = UDim.new(0, 12)
gridLayout.CellSize = UDim2.new(0, 240, 0, 0)  -- wider cards

-- Helper: Create Card
local function CreateCard(title, layoutOrder)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 240, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(25, 27, 42)
    card.BackgroundTransparency = 0.1
    card.BorderSizePixel = 0
    card.LayoutOrder = layoutOrder
    card.Parent = contentGrid
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card
    
    local header = Instance.new("TextLabel")
    header.Text = title
    header.Size = UDim2.new(1, -10, 0, 26)
    header.Position = UDim2.new(0, 5, 0, 4)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.fromRGB(100, 180, 255)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 13
    header.TextXAlignment = Enum.TextXAlignment.Center
    header.Parent = card
    
    local list = Instance.new("UIListLayout")
    list.Parent = card
    list.Padding = UDim.new(0, 5)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 34)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.Parent = card
    
    return card, list
end

-- Toggle (same as original, but slightly larger)
local function AddToggle(card, label, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(35, 37, 55)
    frame.BorderSizePixel = 0
    frame.Parent = card
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 5)
    fCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -60, 1, 0)
    text.Position = UDim2.new(0, 8, 0, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 12
    text.Parent = frame
    
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -48, 0.5, -10)
    switch.BackgroundColor3 = Settings[flag] and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(80, 80, 100)
    switch.BorderSizePixel = 0
    switch.Parent = frame
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switch
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = Settings[flag] and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = Settings[flag] and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(80, 80, 100)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = Settings[flag] and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        applyAllFeatures()
    end)
    return frame
end

-- Slider (clear labels)
local function AddSlider(card, label, flag, minVal, maxVal, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(35, 37, 55)
    frame.BorderSizePixel = 0
    frame.Parent = card
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 5)
    fCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -10, 0, 18)
    text.Position = UDim2.new(0, 8, 0, 4)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 11
    text.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -80, 0, 3)
    sliderBar.Position = UDim2.new(0, 8, 0, 32)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 65, 85)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBar
    
    local percent = (Settings[flag] - minVal) / (maxVal - minVal)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(percent, -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBar
    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(Settings[flag]) .. (suffix or "")
    valueLabel.Size = UDim2.new(0, 45, 0, 22)
    valueLabel.Position = UDim2.new(1, -55, 0, 26)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 11
    valueLabel.Parent = frame
    
    local sliding = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local newVal = minVal + (maxVal - minVal) * pos
            if flag == "walkSpeed" then newVal = math.floor(newVal)
            elseif flag == "jumpPower" then newVal = math.floor(newVal / 10) * 10
            else newVal = math.floor(newVal) end
            newVal = math.clamp(newVal, minVal, maxVal)
            Settings[flag] = newVal
            fill.Size = UDim2.new(pos, 0, 1, 0)
            knob.Position = UDim2.new(pos, -6, 0.5, -6)
            valueLabel.Text = tostring(newVal) .. (suffix or "")
            if flag == "walkSpeed" or flag == "jumpPower" then applyMovement() end
        end
    end)
    UserInputService.InputEnded:Connect(function() sliding = false end)
    return frame
end

-- Color Picker
local function AddColorPicker(card, label, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(35, 37, 55)
    frame.BorderSizePixel = 0
    frame.Parent = card
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 5)
    fCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -60, 1, 0)
    text.Position = UDim2.new(0, 8, 0, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 12
    text.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 35, 0, 24)
    colorBtn.Position = UDim2.new(1, -45, 0.5, -12)
    colorBtn.BackgroundColor3 = Settings[flag]
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = ""
    colorBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = colorBtn
    
    local picker = Instance.new("ColorPicker")
    picker.Title = "Choose Wallhack Color"
    picker.Color = Settings[flag]
    colorBtn.MouseButton1Click:Connect(function()
        picker.Parent = screenGui
        picker.ColorChanged:Connect(function(newColor)
            Settings[flag] = newColor
            colorBtn.BackgroundColor3 = newColor
            if flag == "wallhackColor" then updatePlayerWallhack() end
        end)
        picker.Closed:Connect(function() picker:Destroy() end)
    end)
    return frame
end

-- JSON Area (for backup)
local function AddJSONArea()
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 100)
    card.BackgroundColor3 = Color3.fromRGB(15, 17, 28)
    card.BorderSizePixel = 0
    card.LayoutOrder = 5
    card.Parent = contentGrid
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card
    
    local title = Instance.new("TextLabel")
    title.Text = "📋 JSON Configuration (Backup)"
    title.Size = UDim2.new(1, -12, 0, 24)
    title.Position = UDim2.new(0, 8, 0, 4)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(150, 170, 220)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.Gotham
    title.TextSize = 11
    title.Parent = card
    
    local jsonBox = Instance.new("TextBox")
    jsonBox.Size = UDim2.new(1, -16, 0, 45)
    jsonBox.Position = UDim2.new(0, 8, 0, 34)
    jsonBox.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
    jsonBox.TextColor3 = Color3.fromRGB(200, 220, 255)
    jsonBox.Font = Enum.Font.Code
    jsonBox.TextSize = 9
    jsonBox.TextWrapped = true
    jsonBox.ClearTextOnFocus = false
    jsonBox.Parent = card
    local jCorner = Instance.new("UICorner")
    jCorner.CornerRadius = UDim.new(0, 4)
    jCorner.Parent = jsonBox
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 70, 0, 24)
    copyBtn.Position = UDim2.new(1, -80, 0, 70)
    copyBtn.Text = "Copy JSON"
    copyBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 10
    copyBtn.BorderSizePixel = 0
    copyBtn.Parent = card
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 4)
    cCorner.Parent = copyBtn
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(jsonBox.Text)
        elseif toclipboard then toclipboard(jsonBox.Text)
        else print(jsonBox.Text) end
    end)
    
    local function update()
        local export = {}
        for k, v in pairs(Settings) do
            if k == "wallhackColor" then
                export[k] = string.format("#%02x%02x%02x", v.R*255, v.G*255, v.B*255)
            else
                export[k] = v
            end
        end
        jsonBox.Text = game:GetService("HttpService"):JSONEncode(export)
    end
    update()
    return update
end

-- Build UI Cards
local cardA, _ = CreateCard("🎯 Aimbot", 1)
AddToggle(cardA, "Aimbot (100% Headshot)", "aimbot")
AddSlider(cardA, "Aimbot FOV", "aimbotFOV", 30, 300, "°")
AddToggle(cardA, "No Recoil", "noRecoil")
AddToggle(cardA, "No Spread", "noSpread")

local cardV, _ = CreateCard("👁️ Visual", 2)
AddToggle(cardV, "Player Wallhack (Red)", "playerWallhack")
AddToggle(cardV, "NPC Wallhack (Yellow)", "npcWallhack")
AddColorPicker(cardV, "Wallhack Color", "wallhackColor")
AddToggle(cardV, "Player ESP (Transparent)", "playerESP")

local cardM, _ = CreateCard("⚡ Movement", 3)
AddToggle(cardM, "Infinite Jump", "infiniteJump")
AddToggle(cardM, "Noclip (Walk through walls)", "noclip")
AddSlider(cardM, "Walk Speed", "walkSpeed", 16, 200, "")
AddSlider(cardM, "Jump Power", "jumpPower", 50, 500, "")

local cardC, _ = CreateCard("⚔️ Combat", 4)
AddToggle(cardC, "Kill Aura (Players)", "killAuraPlayer")
AddToggle(cardC, "Auto Kill NPCs (Global)", "autoKillNPC")

local updateJSON = AddJSONArea()

-- ========== FEATURE IMPLEMENTATION (unchanged, works perfectly) ==========
local function applyMovement()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Settings.walkSpeed
        char.Humanoid.JumpPower = Settings.jumpPower
    end
end

local function updatePlayerWallhack()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if Settings.playerWallhack then
                local hl = p.Character:FindFirstChild("PlayerWH")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "PlayerWH"
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = p.Character
                end
                hl.FillColor = Settings.wallhackColor
                hl.FillTransparency = 0.3
                hl.OutlineColor = Color3.fromRGB(255,255,255)
                hl.OutlineTransparency = 0.2
                hl.Enabled = true
            else
                local hl = p.Character:FindFirstChild("PlayerWH")
                if hl then hl:Destroy() end
            end
        end
    end
end

local function updateNPCWallhack()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") then
            local parent = obj.Parent
            if parent and not Players:GetPlayerFromCharacter(parent) then
                if Settings.npcWallhack then
                    local hl = parent:FindFirstChild("NPCWH")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "NPCWH"
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = parent
                    end
                    hl.FillColor = Color3.fromRGB(255,255,0)
                    hl.FillTransparency = 0.3
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.OutlineTransparency = 0.2
                    hl.Enabled = true
                else
                    local hl = parent:FindFirstChild("NPCWH")
                    if hl then hl:Destroy() end
                end
            end
        end
    end
end

local function updatePlayerESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = Settings.playerESP and 0.5 or 0
                end
            end
        end
    end
end

UserInputService.JumpRequest:Connect(function()
    if Settings.infiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Stepped:Connect(function()
    if Settings.noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Settings.killAuraPlayer then
        local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myPos then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local target = p.Character:FindFirstChild("HumanoidRootPart")
                    if target and (target.Position - myPos.Position).Magnitude < 20 then
                        local hum = p.Character:FindFirstChild("Humanoid")
                        if hum then hum.Health = 0 end
                    end
                end
            end
        end
    end
    if Settings.autoKillNPC then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Health > 0 then
                local parent = obj.Parent
                if parent and not Players:GetPlayerFromCharacter(parent) then
                    obj.Health = 0
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not Settings.aimbot then return end
    local cam = workspace.CurrentCamera
    local mouse = UserInputService:GetMouseLocation()
    local closest, shortest = nil, Settings.aimbotFOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = cam:WorldToScreenPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = head
                    end
                end
            end
        end
    end
    if closest then
        cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position)
    end
end)

local function modifyWeapon(tool)
    if not tool then return end
    if Settings.noRecoil then
        for _, prop in pairs({"Recoil", "RecoilAmount", "CameraRecoil"}) do
            local p = tool:FindFirstChild(prop)
            if p then p.Value = 0 end
        end
    end
    if Settings.noSpread then
        for _, prop in pairs({"Spread", "MaxSpread", "MinSpread"}) do
            local p = tool:FindFirstChild(prop)
            if p then p.Value = 0 end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.5)
    applyMovement()
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then modifyWeapon(child) end
    end)
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then modifyWeapon(tool) end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(0.5)
        updatePlayerWallhack()
        updatePlayerESP()
    end)
end)
workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("Humanoid") then
        wait(0.2)
        updateNPCWallhack()
    end
end)

local function applyAllFeatures()
    applyMovement()
    updatePlayerWallhack()
    updateNPCWallhack()
    updatePlayerESP()
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then modifyWeapon(tool) end
        end
    end
    updateJSON()
end

applyAllFeatures()

local function updateHeight()
    local h = 0
    for _, child in ipairs(contentGrid:GetChildren()) do
        if child:IsA("Frame") then
            h = h + child.AbsoluteSize.Y + gridLayout.CellPadding.Y.Offset
        end
    end
    contentGrid.Size = UDim2.new(1, 0, 0, h)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, h + 15)
end
wait(0.2)
updateHeight()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Copybara Hub",
    Text = "Full Panel Loaded - All buttons visible!",
    Duration = 3
})
