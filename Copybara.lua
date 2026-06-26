```lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    aimbot = false, aimbotFOV = 120, silentAim = false, triggerbot = false, visibleCheck = false,
    noRecoil = false, noSpread = false,
    playerWallhack = false, npcWallhack = false,
    wallhackColor = Color3.fromRGB(220,150,200),
    boxESP = false, tracers = false, nameESP = false, healthBar = false,
    infiniteJump = false, noclip = false, fly = false,
    walkSpeed = 16, jumpPower = 50,
    killAuraPlayer = false, autoKillNPC = false, giantTool = false,
    antiAfk = false, spamSounds = false,
}
local followTarget = nil
local followConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil

local Keybinds = { aimbot = nil, wallhack = nil, fly = nil, triggerbot = nil }
local awaitingKeybind = nil

local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "ESP_Folder"
ESPContainer.Parent = CoreGui

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 40, 0, 60)
    box.BackgroundTransparency = 0.5
    box.BackgroundColor3 = Settings.wallhackColor
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.fromRGB(255,255,255)
    box.Visible = Settings.boxESP
    box.Parent = ESPContainer

    local tracer = Instance.new("Frame")
    tracer.Size = UDim2.new(0, 2, 0, 100)
    tracer.BackgroundColor3 = Color3.fromRGB(255,0,0)
    tracer.BackgroundTransparency = 0.4
    tracer.Visible = Settings.tracers
    tracer.Parent = ESPContainer

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.TextScaled = true
    nameLabel.Size = UDim2.new(0, 80, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Visible = Settings.nameESP
    nameLabel.Parent = ESPContainer

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(0, 40, 0, 4)
    healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthBar.BackgroundTransparency = 0.2
    healthBar.Visible = Settings.healthBar
    healthBar.Parent = ESPContainer

    return { box = box, tracer = tracer, name = nameLabel, health = healthBar, player = player }
end

local ESPList = {}

local function UpdateESP()
    local viewport = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
    for player, data in pairs(ESPList) do
        if not player.Character then
            for _, obj in pairs({data.box, data.tracer, data.name, data.health}) do
                if obj then obj:Destroy() end
            end
            ESPList[player] = nil
        else
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            local hum = player.Character:FindFirstChild("Humanoid")
            if hrp and head and hum and Camera then
                local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                local headPos, headOnScreen = Camera:WorldToScreenPoint(head.Position)
                if onScreen and headOnScreen then
                    local pos2 = Vector2.new(pos.X, pos.Y)
                    local scale = 200 / (Camera.CFrame.Position - hrp.Position).Magnitude
                    local boxSize = Vector2.new(scale * 1.2, scale * 2)

                    data.box.Position = UDim2.new(0, pos2.X - boxSize.X/2, 0, pos2.Y - boxSize.Y/2)
                    data.box.Size = UDim2.new(0, boxSize.X, 0, boxSize.Y)
                    data.box.Visible = Settings.boxESP

                    data.tracer.Position = UDim2.new(0, viewport.X/2, 0, viewport.Y)
                    data.tracer.Size = UDim2.new(0, 2, 0, viewport.Y - pos2.Y)
                    data.tracer.Visible = Settings.tracers

                    data.name.Position = UDim2.new(0, pos2.X - 40, 0, pos2.Y - boxSize.Y/2 - 20)
                    data.name.Visible = Settings.nameESP

                    local healthPercent = hum.Health / hum.MaxHealth
                    data.health.Position = UDim2.new(0, pos2.X - boxSize.X/2, 0, pos2.Y + boxSize.Y/2 + 2)
                    data.health.Size = UDim2.new(0, boxSize.X * healthPercent, 0, 4)
                    data.health.BackgroundColor3 = (healthPercent > 0.5) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
                    data.health.Visible = Settings.healthBar
                else
                    data.box.Visible = false
                    data.tracer.Visible = false
                    data.name.Visible = false
                    data.health.Visible = false
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if not ESPList[player] then
            ESPList[player] = CreateESPForPlayer(player)
        end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        ESPList[player] = CreateESPForPlayer(player)
    end
end

RunService.RenderStepped:Connect(UpdateESP)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopybaraHubVIP_Mobile"
screenGui.ResetOnSpawn = false

local function setupGUI()
    local success = pcall(function()
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 2)
    end)
    if not success then
        pcall(function() screenGui.Parent = CoreGui end)
    end
    if not screenGui.Parent then
        warn("GUI creation failed")
        return false
    end
    return true
end
if not setupGUI() then return end

local BG = Color3.fromRGB(18,16,24)
local Panel = Color3.fromRGB(28,24,36)
local Accent = Color3.fromRGB(165,95,200)
local Soft = Color3.fromRGB(220,150,200)
local Button = Color3.fromRGB(90,60,140)

local floatingToggle = Instance.new("TextButton")
floatingToggle.Size = UDim2.new(0, 46, 0, 46)
floatingToggle.Position = UDim2.new(0.06, 0, 0.24, 0)
floatingToggle.BackgroundColor3 = Panel
floatingToggle.Text = "🌹"
floatingToggle.TextColor3 = Color3.fromRGB(255,255,255)
floatingToggle.Font = Enum.Font.GothamBold
floatingToggle.TextSize = 20
floatingToggle.AutoButtonColor = false
floatingToggle.Parent = screenGui
Instance.new("UICorner", floatingToggle).CornerRadius = UDim.new(1,0)
pcall(function()
    local stroke = Instance.new("UIStroke", floatingToggle)
    stroke.Color = Accent
    stroke.Thickness = 1
end)

local dragStartPos = nil
local dragOffset = Vector2.zero
local isDragging = false
local dragThreshold = 20

floatingToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStartPos = input.Position
        dragOffset = floatingToggle.AbsolutePosition - input.Position
        isDragging = false
    end
end)

floatingToggle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStartPos = nil
        isDragging = false
    end
end)

local mainFrame = nil
floatingToggle.MouseButton1Click:Connect(function()
    if mainFrame then mainFrame.Visible = not mainFrame.Visible end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStartPos then
        if not isDragging then
            local delta = (input.Position - dragStartPos).Magnitude
            if delta > dragThreshold then isDragging = true end
        end
        if isDragging then
            local newPos = input.Position + dragOffset
            local screenSize = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
            local btnSize = floatingToggle.AbsoluteSize
            newPos = Vector2.new(
                math.clamp(newPos.X, 0, screenSize.X - btnSize.X),
                math.clamp(newPos.Y, 0, screenSize.Y - btnSize.Y)
            )
            floatingToggle.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
        end
    end
end)

mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = BG
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,8)
pcall(function()
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Accent
    stroke.Thickness = 1
end)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,28)
titleBar.BackgroundColor3 = Panel
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,8)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,-48,1,0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.Text = "🪷 Copybara (Mobile)"
titleLabel.TextColor3 = Soft
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,18,0,18)
closeBtn.Position = UDim2.new(1,-26,0.5,-9)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,70,100)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 10
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,4)
closeBtn.MouseButton1Click:Connect(function() if mainFrame then mainFrame.Visible = false end end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1,-10,1,-36)
scrollFrame.Position = UDim2.new(0,5,0,32)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.Parent = mainFrame
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0,6)
listLayout.Parent = scrollFrame
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0,4)
padding.PaddingBottom = UDim.new(0,4)
padding.Parent = scrollFrame
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y+8)
end)

local function CreateSection(parent, name)
    local section = Instance.new("TextLabel")
    section.Text = "── "..name.." ──"
    section.Size = UDim2.new(1,-10,0,16)
    section.BackgroundTransparency = 1
    section.TextColor3 = Soft
    section.Font = Enum.Font.GothamBold
    section.TextSize = 10
    section.TextXAlignment = Enum.TextXAlignment.Center
    section.Parent = parent
end

local function CreateToggle(parent, label, flag, keybindFlag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,24)
    frame.BackgroundColor3 = Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1,-100,1,0)
    text.Position = UDim2.new(0,8,0,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(230,230,240)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 11
    text.Parent = frame

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0,28,0,14)
    switch.Position = UDim2.new(1,-36,0.5,-7)
    switch.BackgroundColor3 = Settings[flag] and Soft or Color3.fromRGB(80,80,100)
    switch.BorderSizePixel = 0
    switch.Parent = frame
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,10,0,10)
    knob.Position = Settings[flag] and UDim2.new(1,-16,0.5,-5) or UDim2.new(0,4,0.5,-5)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        TweenService:Create(switch, TweenInfo.new(0.12), {BackgroundColor3 = Settings[flag] and Soft or Color3.fromRGB(80,80,100)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.12), {Position = Settings[flag] and UDim2.new(1,-16,0.5,-5) or UDim2.new(0,4,0.5,-5)}):Play()
        applyAllFeatures()
    end)

    if keybindFlag then
        local keyBtn = Instance.new("TextButton")
        keyBtn.Size = UDim2.new(0,40,0,16)
        keyBtn.Position = UDim2.new(1,-80,0.5,-8)
        keyBtn.Text = "Bind"
        keyBtn.BackgroundColor3 = Color3.fromRGB(60,50,80)
        keyBtn.TextColor3 = Color3.fromRGB(255,255,255)
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.TextSize = 9
        keyBtn.BorderSizePixel = 0
        keyBtn.Parent = frame
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,4)
        keyBtn.MouseButton1Click:Connect(function()
            awaitingKeybind = keybindFlag
            keyBtn.Text = "..."
            local connection
            connection = UserInputService.InputBegan:Connect(function(input, processed)
                if processed then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local key = input.KeyCode.Name
                    Keybinds[keybindFlag] = key
                    keyBtn.Text = key
                    awaitingKeybind = nil
                    connection:Disconnect()
                    pcall(function()
                        StarterGui:SetCore("SendNotification", {Title = "Keybind", Text = key .. " bound", Duration = 1})
                    end)
                end
            end)
            task.wait(5)
            if awaitingKeybind == keybindFlag then
                awaitingKeybind = nil
                keyBtn.Text = "Bind"
                if connection then connection:Disconnect() end
            end
        end)
    end
    return frame
end

local function CreateSlider(parent, label, flag, minVal, maxVal, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,34)
    frame.BackgroundColor3 = Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1,-10,0,12)
    text.Position = UDim2.new(0,8,0,2)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(230,230,240)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 10
    text.Parent = frame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1,-70,0,3)
    sliderBar.Position = UDim2.new(0,8,0,22)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60,65,85)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1,0)

    local range = maxVal - minVal
    local percent = (range > 0) and ((Settings[flag] - minVal) / range) or 0.5
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(percent,0,1,0)
    fill.BackgroundColor3 = Accent
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,8,0,8)
    knob.Position = UDim2.new(percent, -4, 0.5, -4)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(Settings[flag])..(suffix or "")
    valueLabel.Size = UDim2.new(0,44,0,12)
    valueLabel.Position = UDim2.new(1,-54,0,18)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(200,200,220)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 10
    valueLabel.Parent = frame

    local sliding = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
        end
    end)
    local function updateSlider(input)
        if not sliderBar or not sliderBar.AbsoluteSize or sliderBar.AbsoluteSize.X == 0 then return end
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local newVal = minVal + (maxVal - minVal) * pos
        if flag == "walkSpeed" then newVal = math.floor(newVal)
        elseif flag == "jumpPower" then newVal = math.floor(newVal/10)*10
        else newVal = math.floor(newVal) end
        newVal = math.clamp(newVal, minVal, maxVal)
        Settings[flag] = newVal
        fill.Size = UDim2.new(pos,0,1,0)
        knob.Position = UDim2.new(pos, -4, 0.5, -4)
        valueLabel.Text = tostring(newVal)..(suffix or "")
        if flag == "walkSpeed" or flag == "jumpPower" then applyMovement() end
    end
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    return frame
end

local function CreateColorPicker(parent, label, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,24)
    frame.BackgroundColor3 = Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1,-80,1,0)
    text.Position = UDim2.new(0,8,0,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(230,230,240)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 11
    text.Parent = frame

    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0,56,0,16)
    colorBtn.Position = UDim2.new(1,-66,0.5,-8)
    colorBtn.BackgroundColor3 = Settings[flag]
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = "Lotus"
    colorBtn.TextColor3 = Color3.fromRGB(255,255,255)
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.TextSize = 9
    colorBtn.Parent = frame
    Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0,6)

    local presets = {
        {Name="Lotus", Color=Color3.fromRGB(220,150,200)},
        {Name="Violet", Color=Color3.fromRGB(165,95,200)},
        {Name="SoftPink", Color=Color3.fromRGB(255,180,200)},
        {Name="Cyan", Color=Color3.fromRGB(120,200,200)},
    }
    local index = 1
    colorBtn.MouseButton1Click:Connect(function()
        index = (index % #presets) + 1
        local target = presets[index]
        Settings[flag] = target.Color
        colorBtn.BackgroundColor3 = target.Color
        colorBtn.Text = target.Name
        applyAllFeatures()
    end)
    return frame
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,22)
    btn.BackgroundColor3 = Button
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateDropdown(parent, label, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,40)
    frame.BackgroundColor3 = Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1,-10,0,14)
    text.Position = UDim2.new(0,8,0,3)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(230,230,240)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 10
    text.Parent = frame

    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(1,-16,0,18)
    dropdownBtn.Position = UDim2.new(0,8,0,20)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(35,37,50)
    dropdownBtn.Text = "Select..."
    dropdownBtn.TextColor3 = Color3.fromRGB(200,200,220)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 10
    dropdownBtn.Parent = frame
    Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0,6)

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1,-16,0,0)
    list.Position = UDim2.new(0,8,0,40)
    list.BackgroundColor3 = BG
    list.Visible = false
    list.Parent = frame
    Instance.new("UICorner", list).CornerRadius = UDim.new(0,6)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,4)
    layout.Parent = list

    dropdownBtn.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
        if list.Visible then
            for _, child in ipairs(list:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            local opts = options
            if type(options) == "function" then opts = options() end
            for _, opt in ipairs(opts) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,-6,0,20)
                btn.Position = UDim2.new(0,3,0,0)
                btn.Text = opt
                btn.BackgroundColor3 = Panel
                btn.TextColor3 = Color3.fromRGB(240,240,245)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 10
                btn.Parent = list
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
                btn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = opt
                    list.Visible = false
                    callback(opt)
                end)
            end
            list.Size = UDim2.new(1,-16,0, math.min(#opts*24, 96))
        end
    end)
    return frame
end

CreateSection(scrollFrame, "Aimbot")
CreateToggle(scrollFrame, "Aimbot (Head)", "aimbot", "aimbot")
CreateToggle(scrollFrame, "Silent Aim", "silentAim")
CreateToggle(scrollFrame, "Triggerbot", "triggerbot", "triggerbot")
CreateToggle(scrollFrame, "Visible Check", "visibleCheck")
CreateSlider(scrollFrame, "FOV", "aimbotFOV", 30, 300, "°")
CreateToggle(scrollFrame, "No Recoil", "noRecoil")
CreateToggle(scrollFrame, "No Spread", "noSpread")
CreateToggle(scrollFrame, "Giant Weapon", "giantTool")

CreateSection(scrollFrame, "Visual")
CreateToggle(scrollFrame, "Player Wallhack", "playerWallhack", "wallhack")
CreateToggle(scrollFrame, "NPC Wallhack", "npcWallhack")
CreateColorPicker(scrollFrame, "Wallhack Color", "wallhackColor")
CreateToggle(scrollFrame, "Box ESP", "boxESP")
CreateToggle(scrollFrame, "Tracers", "tracers")
CreateToggle(scrollFrame, "Name ESP", "nameESP")
CreateToggle(scrollFrame, "Health Bar", "healthBar")

CreateSection(scrollFrame, "Movement")
CreateToggle(scrollFrame, "Infinite Jump", "infiniteJump")
CreateToggle(scrollFrame, "Noclip", "noclip")
CreateToggle(scrollFrame, "Fly", "fly", "fly")
CreateSlider(scrollFrame, "Walk Speed", "walkSpeed", 16, 200, "")
CreateSlider(scrollFrame, "Jump Power", "jumpPower", 50, 500, "")

CreateSection(scrollFrame, "Combat")
CreateToggle(scrollFrame, "Kill Aura (Players)", "killAuraPlayer")
CreateToggle(scrollFrame, "Auto Kill NPCs", "autoKillNPC")
CreateToggle(scrollFrame, "Anti-AFK", "antiAfk")
CreateToggle(scrollFrame, "Spam Sounds", "spamSounds")

CreateSection(scrollFrame, "Follow / Teleport")
local function updatePlayerList()
    local out = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then table.insert(out, plr.Name) end
    end
    return out
end
local followDropdown = CreateDropdown(scrollFrame, "Select Player", updatePlayerList, function(selected)
    local target = Players:FindFirstChild(selected)
    if not target then return end
    if followConnection then followConnection:Disconnect() end
    followTarget = target
    followConnection = RunService.Heartbeat:Connect(function()
        if not followTarget or not followTarget.Character or not LocalPlayer.Character then return end
        local targetHRP = followTarget.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and myHRP and (targetHRP.Position - myHRP.Position).Magnitude > 8 then
            targetHRP.CFrame = CFrame.new(myHRP.Position + (targetHRP.Position - myHRP.Position).Unit * 4, myHRP.Position)
        end
    end)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = "Copybara", Text = "Following ".. selected, Duration = 2})
    end)
end)
CreateButton(scrollFrame, "🚀 Teleport", function()
    if not followTarget or not followTarget.Character then
        pcall(function() StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Select a player!", Duration = 2}) end)
        return
    end
    local targetHRP = followTarget.Character:FindFirstChild("HumanoidRootPart")
    local myChar = LocalPlayer.Character
    if targetHRP and myChar then
        local hrp = myChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 2, 0)
            pcall(function() StarterGui:SetCore("SendNotification", {Title = "Copybara", Text = "Teleported!", Duration = 2}) end)
        end
    end
end)
CreateButton(scrollFrame, "Stop", function()
    if followConnection then followConnection:Disconnect(); followConnection = nil end
    followTarget = nil
end)

CreateButton(scrollFrame, "💾 Apply All", function()
    applyAllFeatures()
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = "Copybara", Text = "Applied!", Duration = 2})
    end)
end)

function applyMovement()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        pcall(function()
            char.Humanoid.WalkSpeed = Settings.walkSpeed
            char.Humanoid.JumpPower = Settings.jumpPower
        end)
    end
end

local function createHighlight(parent, name, fillColor, fillTrans, outlineColor, outlineTrans)
    local hl = parent:FindFirstChild(name)
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = name
        hl.Parent = parent
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
    hl.FillColor = fillColor
    hl.FillTransparency = fillTrans
    hl.OutlineColor = outlineColor
    hl.OutlineTransparency = outlineTrans
    hl.Enabled = true
    return hl
end

function updatePlayerWallhack()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if Settings.playerWallhack then
                pcall(function()
                    createHighlight(player.Character, "PlayerWH", Settings.wallhackColor, 0.3, Color3.fromRGB(255,255,255), 0.2)
                end)
            else
                local hl = player.Character:FindFirstChild("PlayerWH")
                if hl then hl:Destroy() end
            end
        end
    end
end

local npcHighlighted = {}
function updateNPCWallhack()
    if Settings.npcWallhack then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") then
                local parent = obj.Parent
                if parent and not Players:GetPlayerFromCharacter(parent) and not npcHighlighted[parent] then
                    pcall(function()
                        createHighlight(parent, "NPCWH", Color3.fromRGB(255,255,150), 0.3, Color3.fromRGB(255,255,255), 0.2)
                        npcHighlighted[parent] = true
                    end)
                end
            end
        end
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Highlight") and obj.Name == "NPCWH" then obj:Destroy() end
        end
        npcHighlighted = {}
    end
end

function toggleFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if Settings.fly then
        if not flyBodyVelocity then
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.Parent = hrp

            flyBodyGyro = Instance.new("BodyGyro")
            flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            flyBodyGyro.CFrame = hrp.CFrame
            flyBodyGyro.Parent = hrp
        end
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = true end
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if not Settings.fly or not flyBodyVelocity then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local speed = 50
    local vel = flyBodyVelocity.Velocity
    local cam = Camera
    if not cam then return end

    if input.KeyCode == Enum.KeyCode.W then
        vel = vel + cam.CFrame.LookVector * speed
    elseif input.KeyCode == Enum.KeyCode.S then
        vel = vel - cam.CFrame.LookVector * speed
    elseif input.KeyCode == Enum.KeyCode.A then
        vel = vel - cam.CFrame.RightVector * speed
    elseif input.KeyCode == Enum.KeyCode.D then
        vel = vel + cam.CFrame.RightVector * speed
    elseif input.KeyCode == Enum.KeyCode.Space then
        vel = vel + Vector3.new(0, speed, 0)
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        vel = vel - Vector3.new(0, speed, 0)
    end
    flyBodyVelocity.Velocity = vel
end)

local antiAfkTimer = 0
RunService.Heartbeat:Connect(function(dt)
    if Settings.antiAfk then
        antiAfkTimer = antiAfkTimer + dt
        if antiAfkTimer > 60 then
            antiAfkTimer = 0
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:MoveTo(char.HumanoidRootPart.Position + Vector3.new(math.random(-1,1), 0, math.random(-1,1)) * 2)
            end
            pcall(function()
                local mouse = UserInputService:GetMouseLocation()
                UserInputService:SetMouseLocation(Vector2.new(mouse.X + math.random(-5,5), mouse.Y + math.random(-5,5)))
            end)
        end
    else
        antiAfkTimer = 0
    end
end)

RunService.RenderStepped:Connect(function()
    if not Settings.triggerbot then return end
    local mouse = UserInputService:GetMouseLocation()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head and Camera then
                local pos, onScreen = Camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if dist < 15 then
                        pcall(function()
                            VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, true, game:GetService("RunService").Heartbeat:Wait(), game)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, false, game:GetService("RunService").Heartbeat:Wait(), game)
                        end)
                        break
                    end
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not Settings.aimbot then return end
    local cam = Camera
    if not cam then return end
    local mouse = UserInputService:GetMouseLocation()
    local closest, shortest = nil, Settings.aimbotFOV
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                if Settings.visibleCheck and myPos then
                    local direction = (head.Position - cam.CFrame.Position).Unit
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    local result = workspace:Raycast(cam.CFrame.Position, direction * 500, rayParams)
                    if result and not result.Instance:IsDescendantOf(player.Character) then
                        continue
                    end
                end
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
        if Settings.silentAim then
            local screenPos, onScreen = cam:WorldToScreenPoint(closest.Position)
            if onScreen then
                pcall(function()
                    UserInputService:SetMouseLocation(Vector2.new(screenPos.X, screenPos.Y))
                end)
            end
        else
            cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position)
        end
    end
end)

function modifyWeapon(tool)
    if not tool then return end
    if Settings.noRecoil then
        for _, prop in pairs({"Recoil", "RecoilAmount", "CameraRecoil"}) do
            local p = tool:FindFirstChild(prop)
            if p and p.ClassName ~= "RemoteEvent" then
                pcall(function() p.Value = 0 end)
            end
        end
    end
    if Settings.noSpread then
        for _, prop in pairs({"Spread", "MaxSpread", "MinSpread"}) do
            local p = tool:FindFirstChild(prop)
            if p and p.ClassName ~= "RemoteEvent" then
                pcall(function() p.Value = 0 end)
            end
        end
    end
end

function resizeTools()
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, part in ipairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then
                    if Settings.giantTool then
                        if not part:GetAttribute("OriginalSize") then
                            part:SetAttribute("OriginalSize", part.Size)
                        end
                        local orig = part:GetAttribute("OriginalSize") or part.Size
                        part.Size = orig * 8
                        part.Massless = true
                        part.CanCollide = false
                    else
                        local orig = part:GetAttribute("OriginalSize")
                        if orig then
                            part.Size = orig
                            part.Massless = false
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
end

local spamSoundObject = nil
function updateSpamSounds()
    if Settings.spamSounds then
        if not spamSoundObject then
            local char = LocalPlayer.Character
            if char then
                spamSoundObject = Instance.new("Sound")
                spamSoundObject.Name = "SpamSound"
                spamSoundObject.SoundId = "rbxassetid://82628393182263"
                spamSoundObject.Volume = 1
                spamSoundObject.Looped = true
                spamSoundObject.Parent = char
                pcall(function() spamSoundObject:Play() end)
            end
        end
    else
        if spamSoundObject then
            pcall(function() spamSoundObject:Stop(); spamSoundObject:Destroy() end)
            spamSoundObject = nil
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
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local target = player.Character:FindFirstChild("HumanoidRootPart")
                    if target and (target.Position - myPos.Position).Magnitude < 20 then
                        local hum = player.Character:FindFirstChild("Humanoid")
                        if hum and hum.Health > 0 then hum.Health = 0 end
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

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        if awaitingKeybind then return end
        if Keybinds.aimbot and key == Keybinds.aimbot then
            Settings.aimbot = not Settings.aimbot; applyAllFeatures()
        elseif Keybinds.wallhack and key == Keybinds.wallhack then
            Settings.playerWallhack = not Settings.playerWallhack; applyAllFeatures()
        elseif Keybinds.fly and key == Keybinds.fly then
            Settings.fly = not Settings.fly; applyAllFeatures()
        elseif Keybinds.triggerbot and key == Keybinds.triggerbot then
            Settings.triggerbot = not Settings.triggerbot; applyAllFeatures()
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    applyMovement()
    if spamSoundObject then pcall(function() spamSoundObject:Stop(); spamSoundObject:Destroy() end); spamSoundObject = nil end
    if Settings.spamSounds then updateSpamSounds() end
    if Settings.fly then toggleFly() end
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            modifyWeapon(child)
            task.wait(0.08)
            resizeTools()
        end
    end)
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then modifyWeapon(tool) end
    end
    task.wait(0.08)
    resizeTools()
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        updatePlayerWallhack()
        ESPList[player] = CreateESPForPlayer(player)
    end)
end)

workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("Humanoid") then
        task.wait(0.18)
        updateNPCWallhack()
    end
end)

function applyAllFeatures()
    applyMovement()
    updatePlayerWallhack()
    updateNPCWallhack()
    updateSpamSounds()
    resizeTools()
    toggleFly()
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then modifyWeapon(tool) end
        end
    end
end

if LocalPlayer.Character then
    applyAllFeatures()
else
    LocalPlayer.CharacterAdded:Wait()
    applyAllFeatures()
end

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "🪷 Copybara Mobile",
        Text = "Loaded! Tap 🌹 to toggle menu.",
        Duration = 3
    })
end)

game:BindToClose(function()
    for _, data in pairs(ESPList) do
        for _, obj in pairs({data.box, data.tracer, data.name, data.health}) do
            if obj then obj:Destroy() end
        end
    end
    ESPContainer:Destroy()
end)
```