-- [[ Copybara Hub VIP - Lotus Edition (កែសម្រួលចុងក្រោយ) ]]
-- ចុច 🪷 ដើម្បីបង្ហាញ/លាក់ Menu
-- អូស 🪷 ដើម្បីផ្លាស់ទីទីតាំងវាលើអេក្រង់
-- មុខងារ៖ Aimbot, Wallhack, ESP, Movement, Combat, Follow Player, Giant Weapon, Spam Sounds

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ========== ការកំណត់ ==========
local Settings = {
    aimbot = false, aimbotFOV = 120, noRecoil = false, noSpread = false,
    playerWallhack = false, npcWallhack = false, playerESP = false,
    wallhackColor = Color3.fromRGB(220,150,200), infiniteJump = false, noclip = false,
    walkSpeed = 16, jumpPower = 50, killAuraPlayer = false, autoKillNPC = false,
    giantTool = false,
    spamSounds = false,
}
local followTarget = nil
local followConnection = nil

-- ========== បង្កើត GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopybaraHubVIP_Lotus"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then
    pcall(function() screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
end
if not screenGui.Parent then return warn("មិនអាចបង្កើត GUI") end

-- ពណ៌ចម្រុះ
local BG = Color3.fromRGB(18,16,24)
local Panel = Color3.fromRGB(28,24,36)
local Accent = Color3.fromRGB(165,95,200)
local Soft = Color3.fromRGB(220,150,200)
local Button = Color3.fromRGB(90,60,140)

-- ប៊ូតុងបិទ/បើកអណ្ដែត
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
local toggleStroke = Instance.new("UIStroke", floatingToggle)
toggleStroke.Color = Accent; toggleStroke.Thickness = 1

-- [[[ កែថ្មី ]]] ធ្វើឲ្យប៊ូតុងអូសបាន + ចុចដើម្បីបិទ/បើក Menu
local dragStartPos = nil
local dragOffset = Vector2.zero
local isDragging = false
local dragThreshold = 20  -- ចម្ងាយ 20px ឡើងទៅចាត់ទុកជាការអូស

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

-- ការចុចធម្មតា (បិទ/បើក Menu) ប្រើ MouseButton1Click ដើម្បីភាពជាក់លាក់
floatingToggle.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStartPos then
        if not isDragging then
            local delta = (input.Position - dragStartPos).Magnitude
            if delta > dragThreshold then
                isDragging = true
            end
        end
        if isDragging then
            local newPos = input.Position + dragOffset
            local screenSize = workspace.CurrentCamera.ViewportSize
            local btnSize = floatingToggle.AbsoluteSize
            newPos = Vector2.new(
                math.clamp(newPos.X, 0, screenSize.X - btnSize.X),
                math.clamp(newPos.Y, 0, screenSize.Y - btnSize.Y)
            )
            floatingToggle.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
        end
    end
end)

-- ស៊ុមមេ
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 260)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -130)
mainFrame.BackgroundColor3 = BG
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", mainFrame).Color = Accent; mainFrame.UIStroke.Thickness = 1

-- របារចំណងជើង
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,28)
titleBar.BackgroundColor3 = Panel
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,8)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,-48,1,0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.Text = "🪷 Copybara VIP"
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
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- ស៊ុមរំកិល
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

-- ========== ជំនួយការបង្កើត UI ==========
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

local function CreateToggle(parent, label, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,24)
    frame.BackgroundColor3 = Panel
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1,-60,1,0)
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

    local percent = (Settings[flag] - minVal) / (maxVal - minVal)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(percent,0,1,0)
    fill.BackgroundColor3 = Accent
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,8,0,8)
    knob.Position = UDim2.new(percent,-4,0.5,-4)
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
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local newVal = minVal + (maxVal - minVal) * pos
        if flag == "walkSpeed" then newVal = math.floor(newVal)
        elseif flag == "jumpPower" then newVal = math.floor(newVal/10)*10
        else newVal = math.floor(newVal) end
        newVal = math.clamp(newVal, minVal, maxVal)
        Settings[flag] = newVal
        fill.Size = UDim2.new(pos,0,1,0)
        knob.Position = UDim2.new(pos,-4,0.5,-4)
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

local function CreateJSONArea(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-10,0,64)
    frame.BackgroundColor3 = Color3.fromRGB(12,12,18)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local title = Instance.new("TextLabel")
    title.Text = "📋 Config Backup"
    title.Size = UDim2.new(1,-10,0,12)
    title.Position = UDim2.new(0,8,0,2)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(170,180,210)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.Gotham
    title.TextSize = 10
    title.Parent = frame

    local jsonBox = Instance.new("TextBox")
    jsonBox.Size = UDim2.new(1,-16,0,30)
    jsonBox.Position = UDim2.new(0,8,0,18)
    jsonBox.BackgroundColor3 = Color3.fromRGB(6,6,10)
    jsonBox.TextColor3 = Color3.fromRGB(200,210,240)
    jsonBox.Font = Enum.Font.Code
    jsonBox.TextSize = 10
    jsonBox.TextWrapped = true
    jsonBox.ClearTextOnFocus = false
    jsonBox.Parent = frame
    Instance.new("UICorner", jsonBox).CornerRadius = UDim.new(0,6)

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0,56,0,18)
    copyBtn.Position = UDim2.new(1,-66,0,38)
    copyBtn.Text = "📋 Copy"
    copyBtn.BackgroundColor3 = Button
    copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 10
    copyBtn.BorderSizePixel = 0
    copyBtn.Parent = frame
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,6)
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(jsonBox.Text)
        elseif toclipboard then toclipboard(jsonBox.Text)
        else print(jsonBox.Text) end
    end)

    local function update()
        local export = {}
        for k,v in pairs(Settings) do
            if k == "wallhackColor" and typeof(v) == "Color3" then
                export[k] = string.format("#%02x%02x%02x", math.floor(v.R*255), math.floor(v.G*255), math.floor(v.B*255))
            else
                export[k] = v
            end
        end
        jsonBox.Text = HttpService:JSONEncode(export)
    end
    update()
    return update
end

-- ========== សាងសង់ UI ==========
CreateSection(scrollFrame, "Aimbot & Weapons")
CreateToggle(scrollFrame, "Aimbot (Head)", "aimbot")
CreateSlider(scrollFrame, "Aimbot FOV", "aimbotFOV", 30, 300, "°")
CreateToggle(scrollFrame, "No Recoil", "noRecoil")
CreateToggle(scrollFrame, "No Spread", "noSpread")
CreateToggle(scrollFrame, "Giant Weapon (យក្ស)", "giantTool")

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

CreateSection(scrollFrame, "Misc")
CreateToggle(scrollFrame, "Spam Sounds (រំខាន)", "spamSounds")

-- FOLLOW SYSTEM
CreateSection(scrollFrame, "Follow System")
local function updatePlayerList()
    local out = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then table.insert(out, plr.Name) end
    end
    return out
end
local followDropdown = CreateDropdown(scrollFrame, "Select Player to Follow", updatePlayerList, function(selected)
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
        CoreGui:SetCore("SendNotification", {Title = "Copybara", Text = "កំពុងតាម ".. selected, Duration = 2})
    end)
end)
CreateButton(scrollFrame, "Stop Following", function()
    if followConnection then followConnection:Disconnect(); followConnection = nil end
    followTarget = nil
    pcall(function()
        CoreGui:SetCore("SendNotification", {Title = "Copybara", Text = "បានបញ្ឈប់ការតាម", Duration = 2})
    end)
end)

-- Config Section
local updateJSON = CreateJSONArea(scrollFrame)
CreateButton(scrollFrame, "💾 Save & Apply", function()
    applyAllFeatures()
    updateJSON()
    pcall(function()
        CoreGui:SetCore("SendNotification", {Title = "Copybara", Text = "បានរក្សាទុកនិងអនុវត្ត", Duration = 2})
    end)
end)

-- ========== មុខងារទាំងអស់ ==========
function applyMovement()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Settings.walkSpeed
        char.Humanoid.JumpPower = Settings.jumpPower
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
                    hl.FillColor = Color3.fromRGB(255,255,150)
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

-- Combat loops
RunService.Heartbeat:Connect(function()
    if Settings.killAuraPlayer then
        local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myPos then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local target = player.Character:FindFirstChild("HumanoidRootPart")
                    if target and (target.Position - myPos.Position).Magnitude < 20 then
                        local hum = player.Character:FindFirstChild("Humanoid")
                        if hum and hum.Health > 0 then
                            hum.Health = 0
                        end
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

-- Aimbot
RunService.RenderStepped:Connect(function()
    if not Settings.aimbot then return end
    local camera = workspace.CurrentCamera
    if not camera then return end
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

-- ការកែប្រែអាវុធ
function modifyWeapon(tool)
    if not tool then return end
    if Settings.noRecoil then
        for _, prop in pairs({"Recoil", "RecoilAmount", "CameraRecoil"}) do
            local p = tool:FindFirstChild(prop)
            if p and p.ClassName ~= "RemoteEvent" then
                p.Value = 0
            end
        end
    end
    if Settings.noSpread then
        for _, prop in pairs({"Spread", "MaxSpread", "MinSpread"}) do
            local p = tool:FindFirstChild(prop)
            if p and p.ClassName ~= "RemoteEvent" then
                p.Value = 0
            end
        end
    end
end

-- Giant tool
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
                        local originalSize = part:GetAttribute("OriginalSize")
                        if originalSize then
                            part.Size = originalSize
                            part.Massless = false
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
end

-- Spam Sounds
local spamSoundObject = nil
local function updateSpamSounds()
    if Settings.spamSounds then
        if not spamSoundObject then
            if LocalPlayer.Character then
                spamSoundObject = Instance.new("Sound")
                spamSoundObject.Name = "SpamSound"
                spamSoundObject.SoundId = "rbxassetid://82628393182263" -- សំឡេង ding ត្រឹមត្រូវ
                spamSoundObject.Volume = 1
                spamSoundObject.Looped = true
                spamSoundObject.Parent = LocalPlayer.Character
                spamSoundObject:Play()
            end
        end
    else
        if spamSoundObject then
            spamSoundObject:Stop()
            spamSoundObject:Destroy()
            spamSoundObject = nil
        end
    end
end

-- ព្រឹត្តិការណ៍នៅពេលតួអក្សរផ្លាស់ប្តូរ
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    applyMovement()
    if spamSoundObject then
        spamSoundObject:Stop()
        spamSoundObject:Destroy()
        spamSoundObject = nil
    end
    if Settings.spamSounds then
        updateSpamSounds()
    end
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
        updatePlayerESP()
    end)
end)

workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("Humanoid") then
        task.wait(0.18)
        updateNPCWallhack()
    end
end)

-- អនុវត្តគ្រប់មុខងារ
function applyAllFeatures()
    applyMovement()
    updatePlayerWallhack()
    updateNPCWallhack()
    updatePlayerESP()
    updateSpamSounds()
    resizeTools()
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then modifyWeapon(tool) end
        end
    end
end

-- អនុវត្តដំបូង
applyAllFeatures()

-- ការជូនដំណឹង
pcall(function()
    CoreGui:SetCore("SendNotification", {
        Title = "🪷 Copybara VIP",
        Text = "Loaded — Lotus mode active. Tap 🪷 to toggle, drag to move.",
        Duration = 3
    })
end)