-- =========================================================================
-- Copybara Hub VIP Edition - Optimized Compact Unified GUI Framework
-- Fixed: Click X only hides GUI, can reopen with RightShift or floating button
-- =========================================================================

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- ========== SETTINGS CONFIGURATION ==========
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
    
    -- VIP Auto-F Configurations
    autoFEnabled = false,
    autoFSpeed = 15,
    autoFPaused = false
}

local activeAutoFConnection = nil

-- Forward Declarations
local applyAllFeatures
local updatePlayerWallhack
local updateNPCWallhack
local updatePlayerESP
local modifyWeapon
local applyMovement

-- ========== SYSTEM GUI GENERATION ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopybaraVIPCompact"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 310, 0, 280)
mainFrame.Position = UDim2.new(0.5, -155, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
mainFrame.BackgroundTransparency = 0.08
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 100, 220)
mainStroke.Thickness = 1.2
mainStroke.Parent = mainFrame
mainFrame.Parent = screenGui

-- Dragging logic
local function applyWindowDragging(frame, handle)
    local dragToggle = false
    local dragStart, startPos
    local dragInput

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(22, 24, 33)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar
applyWindowDragging(mainFrame, titleBar)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "🦫 Copybara Hub - VIP"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close button (hides instead of destroy)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 10
closeBtn.Parent = titleBar
local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 4)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

-- Floating button to reopen GUI
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0.5, -25, 0.85, -25)
openBtn.Text = "🦫"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.BackgroundColor3 = Color3.fromRGB(80, 100, 220)
openBtn.BorderSizePixel = 0
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 20
openBtn.Visible = false
openBtn.Parent = screenGui
local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openBtn
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- Keybind RightShift to toggle GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
        openBtn.Visible = not mainFrame.Visible
    end
end)

-- Tab Navigation
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 28)
tabContainer.Position = UDim2.new(0, 0, 0, 32)
tabContainer.BackgroundColor3 = Color3.fromRGB(18, 19, 27)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer

local pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -12, 1, -68)
    page.Position = UDim2.new(0, 6, 0, 64)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 100, 220)
    page.Visible = false
    page.Parent = mainFrame
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 4)
    pageLayout.Parent = page
    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, 4)
    pagePadding.PaddingBottom = UDim.new(0, 4)
    pagePadding.Parent = page
    
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 10)
    end)
    
    pages[name] = page
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.333, 0, 1, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(140, 145, 170)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 10
    tabBtn.Parent = tabContainer
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, btn in ipairs(tabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.TextColor3 = Color3.fromRGB(140, 145, 170)
            end
        end
        page.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(100, 150, 255)
    end)
    return page
end

local pageMain = createPage("Cheats")
local pageAutoF = createPage("Auto-F (VIP)")
local pageConfig = createPage("Config")

pages["Cheats"].Visible = true
tabContainer:FindFirstChildOfClass("TextButton").TextColor3 = Color3.fromRGB(100, 150, 255)

-- ========== UI COMPONENTS ==========
local function CreateSection(parent, name)
    local section = Instance.new("TextLabel")
    section.Text = "-- ".. name.. " --"
    section.Size = UDim2.new(1, -10, 0, 18)
    section.BackgroundTransparency = 1
    section.TextColor3 = Color3.fromRGB(110, 140, 230)
    section.Font = Enum.Font.GothamBold
    section.TextSize = 10
    section.TextXAlignment = Enum.TextXAlignment.Center
    section.Parent = parent
end

local function CreateToggle(parent, label, flag, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 28)
    frame.BackgroundColor3 = Color3.fromRGB(24, 26, 37)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -50, 1, 0)
    text.Position = UDim2.new(0, 8, 0, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 235)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 11
    text.Parent = frame
    
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 32, 0, 16)
    switch.Position = UDim2.new(1, -40, 0.5, -8)
    switch.BackgroundColor3 = Settings[flag] and Color3.fromRGB(70, 160, 70) or Color3.fromRGB(60, 62, 80)
    switch.BorderSizePixel = 0
    switch.Parent = frame
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = Settings[flag] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
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
        TweenService:Create(switch, TweenInfo.new(0.12), {BackgroundColor3 = Settings[flag] and Color3.fromRGB(70, 160, 70) or Color3.fromRGB(60, 62, 80)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.12), {Position = Settings[flag] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        if callback then callback() else applyAllFeatures() end
    end)
    return frame
end

local function CreateSlider(parent, label, flag, minVal, maxVal, suffix, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(24, 26, 37)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -10, 0, 16)
    text.Position = UDim2.new(0, 8, 0, 2)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 235)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 10
    text.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -65, 0, 3)
    sliderBar.Position = UDim2.new(0, 8, 0, 25)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 53, 70)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBar
    
    local fill = Instance.new("Frame")
    local percent = (Settings[flag] - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 120, 240)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new(percent, -5, 0.5, -5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBar
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(Settings[flag]).. (suffix or "")
    valueLabel.Size = UDim2.new(0, 45, 0, 16)
    valueLabel.Position = UDim2.new(1, -50, 0, 17)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(180, 185, 210)
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
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local newVal = minVal + (maxVal - minVal) * pos
        if flag == "walkSpeed" or flag == "autoFSpeed" then 
            newVal = math.floor(newVal)
        elseif flag == "jumpPower" then 
            newVal = math.floor(newVal / 10) * 10
        else 
            newVal = math.floor(newVal) 
        end
        newVal = math.clamp(newVal, minVal, maxVal)
        Settings[flag] = newVal
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -5, 0.5, -5)
        valueLabel.Text = tostring(newVal).. (suffix or "")
        if callback then callback() else applyMovement() end
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
    frame.Size = UDim2.new(1, -10, 0, 28)
    frame.BackgroundColor3 = Color3.fromRGB(24, 26, 37)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -90, 1, 0)
    text.Position = UDim2.new(0, 8, 0, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 235)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 11
    text.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 70, 0, 18)
    colorBtn.Position = UDim2.new(1, -78, 0.5, -9)
    colorBtn.BackgroundColor3 = Settings[flag]
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = "Red"
    colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.TextSize = 9
    colorBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = colorBtn
    
    local presets = {
        {Name = "Red", Color = Color3.fromRGB(255, 80, 80)},
        {Name = "Green", Color = Color3.fromRGB(80, 255, 80)},
        {Name = "Blue", Color = Color3.fromRGB(80, 150, 255)},
        {Name = "Yellow", Color = Color3.fromRGB(255, 255, 80)},
        {Name = "Purple", Color = Color3.fromRGB(180, 80, 255)},
        {Name = "Cyan", Color = Color3.fromRGB(80, 255, 255)}
    }
    local index = 1
    
    colorBtn.MouseButton1Click:Connect(function()
        index = (index % #presets) + 1
        local targetPreset = presets[index]
        Settings[flag] = targetPreset.Color
        colorBtn.BackgroundColor3 = targetPreset.Color
        colorBtn.Text = targetPreset.Name
        applyAllFeatures()
    end)
    return frame
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(50, 70, 150)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ========== BUILD UI (TABS) ==========

-- Cheats tab
CreateSection(pageMain, "Aimbot & Weapons")
CreateToggle(pageMain, "Aimbot (100% Headshot)", "aimbot")
CreateSlider(pageMain, "Aimbot FOV", "aimbotFOV", 30, 300, "°")
CreateToggle(pageMain, "No Recoil", "noRecoil")
CreateToggle(pageMain, "No Spread", "noSpread")

CreateSection(pageMain, "Visual & Wallhack")
CreateToggle(pageMain, "Player Wallhack", "playerWallhack")
CreateToggle(pageMain, "NPC Wallhack", "npcWallhack")
CreateColorPicker(pageMain, "Wallhack Color", "wallhackColor")
CreateToggle(pageMain, "Player ESP (Transparent)", "playerESP")

CreateSection(pageMain, "Movement")
CreateToggle(pageMain, "Infinite Jump", "infiniteJump")
CreateToggle(pageMain, "Noclip", "noclip")
CreateSlider(pageMain, "Walk Speed", "walkSpeed", 16, 200, "")
CreateSlider(pageMain, "Jump Power", "jumpPower", 50, 500, "")

CreateSection(pageMain, "Combat Operations")
CreateToggle(pageMain, "Kill Aura (Players)", "killAuraPlayer")
CreateToggle(pageMain, "Auto Kill NPCs", "autoKillNPC")

-- Auto-F VIP tab
CreateSection(pageAutoF, "Auto-F Injection Control")

local function dispatchKeyF()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, LocalPlayer)
        task.wait(0.015)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, LocalPlayer)
    end)
end

local function executeAutoFLoop()
    if activeAutoFConnection then return end
    activeAutoFConnection = task.spawn(function()
        while true do
            if Settings.autoFEnabled and not Settings.autoFPaused then
                dispatchKeyF()
            end
            task.wait(1 / Settings.autoFSpeed)
        end
    end)
end

CreateToggle(pageAutoF, "Enable VIP Auto-F", "autoFEnabled", function()
    if Settings.autoFEnabled then
        executeAutoFLoop()
    end
end)
CreateToggle(pageAutoF, "Pause Intermittent Press", "autoFPaused", function() end)
CreateSlider(pageAutoF, "Press Frequency", "autoFSpeed", 5, 30, "/sec", function() end)

-- Config tab
local function CreateJSONArea(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 75)
    frame.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Text = "📋 Backup String Data"
    title.Size = UDim2.new(1, -10, 0, 16)
    title.Position = UDim2.new(0, 8, 0, 2)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(130, 140, 180)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.Gotham
    title.TextSize = 9
    title.Parent = frame
    
    local jsonBox = Instance.new("TextBox")
    jsonBox.Size = UDim2.new(1, -16, 0, 32)
    jsonBox.Position = UDim2.new(0, 8, 0, 18)
    jsonBox.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
    jsonBox.TextColor3 = Color3.fromRGB(180, 200, 240)
    jsonBox.Font = Enum.Font.Code
    jsonBox.TextSize = 8
    jsonBox.TextWrapped = true
    jsonBox.ClearTextOnFocus = false
    jsonBox.Text = ""
    jsonBox.Parent = frame
    local jsonCorner = Instance.new("UICorner")
    jsonCorner.CornerRadius = UDim.new(0, 4)
    jsonCorner.Parent = jsonBox
    
    local updateJSON = function()
        local export = {}
        for k, v in pairs(Settings) do
            if k == "wallhackColor" then
                export[k] = string.format("#%02x%02x%02x", math.floor(v.R*255), math.floor(v.G*255), math.floor(v.B*255))
            else
                export[k] = v
            end
        end
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONEncode(export)
        end)
        if success then jsonBox.Text = result end
    end
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 50, 0, 16)
    copyBtn.Position = UDim2.new(1, -58, 0, 54)
    copyBtn.Text = "📋 Copy"
    copyBtn.BackgroundColor3 = Color3.fromRGB(45, 60, 110)
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 8
    copyBtn.BorderSizePixel = 0
    copyBtn.Parent = frame
    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 3)
    copyCorner.Parent = copyBtn
    
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(jsonBox.Text)
        elseif toclipboard then
            toclipboard(jsonBox.Text)
        end
    end)
    
    updateJSON()
    return updateJSON
end

local updateConfigDisplay = CreateJSONArea(pageConfig)
CreateButton(pageConfig, "💾 Save & Apply Modifications", function()
    applyAllFeatures()
    updateConfigDisplay()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Copybara VIP",
            Text = "Active profiles updated successfully.",
            Duration = 2
        })
    end)
end)

-- ========== FEATURE IMPLEMENTATIONS ==========
function applyMovement()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Settings.walkSpeed
            hum.JumpPower = Settings.jumpPower
        end
    end
end

function updatePlayerWallhack()
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
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineTransparency = 0.2
                hl.Enabled = true
            else
                local hl = player.Character:FindFirstChild("PlayerWH")
                if hl then hl:Destroy() end
            end
        end
    end
end

function updateNPCWallhack()
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
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
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

function updatePlayerESP()
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

UserInputService.JumpRequest:Connect(function()
    if Settings.infiniteJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if Settings.noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then 
                part.CanCollide = false 
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Settings.killAuraPlayer then
        local myChar = LocalPlayer.Character
        local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if myPos then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local target = player.Character:FindFirstChild("HumanoidRootPart")
                    if target and (target.Position - myPos.Position).Magnitude < 20 then
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if hum then hum.Health = 0 end
                    end
                end
            end
        end
    end
end)

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

function modifyWeapon(tool)
    if not tool then return end
    if Settings.noRecoil then
        for _, prop in ipairs({"Recoil", "RecoilAmount", "CameraRecoil"}) do
            local p = tool:FindFirstChild(prop)
            if p then p.Value = 0 end
        end
    end
    if Settings.noSpread then
        for _, prop in ipairs({"Spread", "MaxSpread", "MinSpread"}) do
            local p = tool:FindFirstChild(prop)
            if p then p.Value = 0 end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    applyMovement()
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then modifyWeapon(child) end
    end)
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then modifyWeapon(tool) end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        updatePlayerWallhack()
        updatePlayerESP()
    end)
end)

workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("Humanoid") then
        task.wait(0.2)
        updateNPCWallhack()
    end
end)

function applyAllFeatures()
    applyMovement()
    updatePlayerWallhack()
    updateNPCWallhack()
    updatePlayerESP()
    if LocalPlayer.Character then
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then modifyWeapon(tool) end
        end
    end
end

applyAllFeatures()

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Copybara Hub VIP",
        Text = "Interface successfully compiled.\nPress RightShift to show/hide GUI",
        Duration = 4
    })
end)
