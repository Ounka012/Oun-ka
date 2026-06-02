-- =============================================
-- Copybara Hub - In-Game GUI (Full Control)
-- =============================================

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ========== SETTINGS (Default) ==========
local Settings = {
    aimbot = false,
    aimbotFOV = 120,
    noRecoil = false,
    noSpread = false,
    playerWallhack = false,
    npcWallhack = false,
    playerESP = false,
    wallhackColor = Color3.fromRGB(255, 80, 80),
    infiniteJump = false,
    noclip = false,
    walkSpeed = 16,
    jumpPower = 50,
    killAuraPlayer = false,
    autoKillNPC = false,
}

-- ========== CREATE GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopybaraHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 480)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 100, 200)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 32, 48)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Text = "🦫 Copybara Hub - Control Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
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

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -55)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 120, 200)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = scrollFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 5)
padding.PaddingBottom = UDim.new(0, 5)
padding.Parent = scrollFrame

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

-- ========== HELPERS ==========
local function CreateSection(parent, name)
    local section = Instance.new("TextLabel")
    section.Text = "── " .. name .. " ──"
    section.Size = UDim2.new(1, -10, 0, 25)
    section.BackgroundTransparency = 1
    section.TextColor3 = Color3.fromRGB(100, 180, 255)
    section.Font = Enum.Font.GothamBold
    section.TextSize = 14
    section.TextXAlignment = Enum.TextXAlignment.Center
    section.Parent = parent
end

local function CreateToggle(parent, label, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 32, 48)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -70, 1, 0)
    text.Position = UDim2.new(0, 12, 0, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 14
    text.Parent = frame
    
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 45, 0, 23)
    switch.Position = UDim2.new(1, -55, 0.5, -11.5)
    switch.BackgroundColor3 = Settings[flag] and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(80, 80, 100)
    switch.BorderSizePixel = 0
    switch.Parent = frame
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 19, 0, 19)
    knob.Position = Settings[flag] and UDim2.new(1, -23, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Settings[flag] and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(80, 80, 100)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = Settings[flag] and UDim2.new(1, -23, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)}):Play()
        applyAllFeatures()
    end)
    return frame
end

local function CreateSlider(parent, label, flag, minVal, maxVal, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(30, 32, 48)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -20, 0, 20)
    text.Position = UDim2.new(0, 12, 0, 5)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 13
    text.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -90, 0, 4)
    sliderBar.Position = UDim2.new(0, 12, 0, 35)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 65, 85)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBar
    
    local fill = Instance.new("Frame")
    local percent = (Settings[flag] - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(percent, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBar
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(Settings[flag]) .. (suffix or "")
    valueLabel.Size = UDim2.new(0, 50, 0, 25)
    valueLabel.Position = UDim2.new(1, -60, 0, 28)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 12
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
            knob.Position = UDim2.new(pos, -7, 0.5, -7)
            valueLabel.Text = tostring(newVal) .. (suffix or "")
            if flag == "walkSpeed" or flag == "jumpPower" then
                applyMovement()
            end
        end
    end)
    UserInputService.InputEnded:Connect(function()
        sliding = false
    end)
    return frame
end

local function CreateColorPicker(parent, label, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 32, 48)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -70, 1, 0)
    text.Position = UDim2.new(0, 12, 0, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 14
    text.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 40, 0, 25)
    colorBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
    colorBtn.BackgroundColor3 = Settings[flag]
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = ""
    colorBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = colorBtn
    
    local colorPicker = Instance.new("ColorPicker")
    colorPicker.Title = "Pick Color"
    colorPicker.Color = Settings[flag]
    colorBtn.MouseButton1Click:Connect(function()
        colorPicker.Parent = screenGui
        colorPicker.ColorChanged:Connect(function(newColor)
            Settings[flag] = newColor
            colorBtn.BackgroundColor3 = newColor
            if flag == "wallhackColor" then
                updatePlayerWallhack()
            end
        end)
        colorPicker.Closed:Connect(function() colorPicker:Destroy() end)
    end)
    return frame
end

local function CreateJSONArea(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 120)
    frame.BackgroundColor3 = Color3.fromRGB(15, 17, 25)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Text = "📋 JSON Configuration (Copy for backup)"
    title.Size = UDim2.new(1, -10, 0, 25)
    title.Position = UDim2.new(0, 8, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(150, 170, 220)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.Gotham
    title.TextSize = 12
    title.Parent = frame
    
    local jsonBox = Instance.new("TextBox")
    jsonBox.Size = UDim2.new(1, -20, 0, 70)
    jsonBox.Position = UDim2.new(0, 10, 0, 35)
    jsonBox.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
    jsonBox.TextColor3 = Color3.fromRGB(200, 220, 255)
    jsonBox.Font = Enum.Font.Code
    jsonBox.TextSize = 11
    jsonBox.TextWrapped = true
    jsonBox.ClearTextOnFocus = false
    jsonBox.Parent = frame
    local jsonCorner = Instance.new("UICorner")
    jsonCorner.CornerRadius = UDim.new(0, 6)
    jsonCorner.Parent = jsonBox
    
    local updateJSON = function()
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
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 80, 0, 25)
    copyBtn.Position = UDim2.new(1, -90, 0, 85)
    copyBtn.Text = "📋 Copy"
    copyBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 11
    copyBtn.BorderSizePixel = 0
    copyBtn.Parent = frame
    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 6)
    copyCorner.Parent = copyBtn
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(jsonBox.Text)
        elseif toclipboard then
            toclipboard(jsonBox.Text)
        else
            print(jsonBox.Text)
        end
    end)
    updateJSON()
    return updateJSON
end

-- ========== BUILD UI ==========
CreateSection(scrollFrame, "Aimbot & Weapons")
CreateToggle(scrollFrame, "Aimbot (100% Headshot)", "aimbot")
CreateSlider(scrollFrame, "Aimbot FOV", "aimbotFOV", 30, 300, "°")
CreateToggle(scrollFrame, "No Recoil", "noRecoil")
CreateToggle(scrollFrame, "No Spread", "noSpread")

CreateSection(scrollFrame, "Visual & Wallhack")
CreateToggle(scrollFrame, "Player Wallhack", "playerWallhack")
CreateToggle(scrollFrame, "NPC Wallhack", "npcWallhack")
CreateColorPicker(scrollFrame, "Wallhack Color", "wallhackColor")
CreateToggle(scrollFrame, "Player ESP (Transparent)", "playerESP")

CreateSection(scrollFrame, "Movement")
CreateToggle(scrollFrame, "Infinite Jump", "infiniteJump")
CreateToggle(scrollFrame, "Noclip", "noclip")
CreateSlider(scrollFrame, "Walk Speed", "walkSpeed", 16, 200, "")
CreateSlider(scrollFrame, "Jump Power", "jumpPower", 50, 500, "")

CreateSection(scrollFrame, "Combat")
CreateToggle(scrollFrame, "Kill Aura (Players)", "killAuraPlayer")
CreateToggle(scrollFrame, "Auto Kill NPCs", "autoKillNPC")

local updateJSON = CreateJSONArea(scrollFrame)
CreateButton(scrollFrame, "💾 Save & Apply", function()
    applyAllFeatures()
    updateJSON()
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Copybara", Text = "Saved & Applied", Duration = 2})
end)

-- ========== FEATURE IMPLEMENTATION ==========
local function applyMovement()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Settings.walkSpeed
        char.Humanoid.JumpPower = Settings.jumpPower
    end
end

local function updatePlayerWallhack()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if Settings.playerWallhack then
                local hl = player.Character:FindFirstChild("PlayerWH")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "PlayerWH"
                    hl.Parent = player.Character
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                hl.FillColor = Settings.wallhackColor
                hl.FillTransparency = 0.3
                hl.OutlineColor = Color3.fromRGB(255,255,255)
                hl.OutlineTransparency = 0.2
                hl.Enabled = true
            else
                local hl = player.Character:FindFirstChild("PlayerWH")
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
                        hl.Parent = parent
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    hl.FillColor = Color3.fromRGB(255, 255, 0)
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
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = Settings.playerESP and 0.5 or 0
                end
            end
        end
    end
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.infiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Settings.noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Kill Aura Player
RunService.Heartbeat:Connect(function()
    if Settings.killAuraPlayer then
        local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myPos then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local target = player.Character:FindFirstChild("HumanoidRootPart")
                    if target and (target.Position - myPos.Position).Magnitude < 20 then
                        local hum = player.Character:FindFirstChild("Humanoid")
                        if hum then hum.Health = 0 end
                    end
                end
            end
        end
    end
end)

-- Auto Kill NPCs
RunService.Heartbeat:Connect(function()
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

-- Aimbot
RunService.RenderStepped:Connect(function()
    if not Settings.aimbot then return end
    local camera = workspace.CurrentCamera
    local mouse = UserInputService:GetMouseLocation()
    local closest, shortest = nil, Settings.aimbotFOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = camera:WorldToScreenPoint(head.Position)
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
        camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Position)
    end
end)

-- No Recoil / No Spread
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

-- Events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
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
end

applyAllFeatures()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Copybara Hub",
    Text = "GUI Loaded! Drag to move.",
    Duration = 3
})
