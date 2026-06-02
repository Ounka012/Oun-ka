-- =========================================================================
-- Copybara Hub VIP - Ultra Compact & Smooth Mobile Edition (No-UIStroke)
-- =========================================================================

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

-- Forward Declarations
local applyAllFeatures
local updatePlayerWallhack
local updateNPCWallhack
local updatePlayerESP
local modifyWeapon
local applyMovement

-- ========== CREATE GUI CONTAINER ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopybaraHubVIP"
screenGui.ResetOnSpawn = false

-- បង្ការកំហុសពេល Parent ទៅ CoreGui លើ Mobile Executor មួយចំនួន
local successParent, _ = pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
end)
if not successParent then
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ១. ប៊ូតុងមូលអណ្តែតទឹកសម្រាប់បើក/បិទ (Floating Toggle Button 🦫)
local floatingToggle = Instance.new("TextButton")
floatingToggle.Name = "FloatingToggle"
floatingToggle.Size = UDim2.new(0, 50, 0, 50)
floatingToggle.Position = UDim2.new(0.05, 0, 0.25, 0) -- ទីតាំងដំបូងប៉ែកខាងឆ្វេង
floatingToggle.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
floatingToggle.Text = "🦫"
floatingToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingToggle.Font = Enum.Font.GothamBold
floatingToggle.TextSize = 22
floatingToggle.Active = true
floatingToggle.Draggable = true -- អាចអូសប្តូរទីតាំងបានសេរីលើទូរស័ព្ទ
floatingToggle.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0) -- ធ្វើឱ្យចេញរាងមូល
toggleCorner.Parent = floatingToggle

-- ២. ផ្ទាំងបញ្ជាមេ (Main Frame) - បង្រួមទំហំមកត្រឹម 300x250 (តូច ស្អាត ស្រួលមើល)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 24)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- អាចអូសបាន
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title Bar (ក្បាលផ្ទាំងបញ្ជា)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(24, 26, 38)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "🦫 Copybara Hub - VIP"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- ប៊ូតុងខ្វែង "✕" (លាក់បណ្ដោះអាសន្ន មិនលុបស្គ្រីប)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 10
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- ចុចបិទ "✕" គឺគ្រាន់តែលាក់ (Visible = false) ដើម្បីកុំឱ្យបាត់ស្គ្រីប
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ចុចលើរូប 🦫 ដើម្បីបើក/បិទ ផ្ទាំងបញ្ជាធំ
floatingToggle.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Scroll Frame សម្រាប់ផ្ទុកមុខងារផ្សេងៗ (តូចស្អាត)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -12, 1, -42)
scrollFrame.Position = UDim2.new(0, 6, 0, 36)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 120, 200)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4) -- ចន្លោះតូចល្មម
listLayout.Parent = scrollFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 2)
padding.PaddingBottom = UDim.new(0, 2)
padding.Parent = scrollFrame

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 15)
end)

-- ========== COMPACT UI ELEMENT BUILDERS ==========

local function CreateSection(parent, name)
    local section = Instance.new("TextLabel")
    section.Text = "── ".. name.. " ──"
    section.Size = UDim2.new(1, -10, 0, 18)
    section.BackgroundTransparency = 1
    section.TextColor3 = Color3.fromRGB(100, 180, 255)
    section.Font = Enum.Font.GothamBold
    section.TextSize = 10
    section.TextXAlignment = Enum.TextXAlignment.Center
    section.Parent = parent
end

local function CreateToggle(parent, label, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 26) -- កម្រិតកម្ពស់តូច ២៦
    frame.BackgroundColor3 = Color3.fromRGB(25, 27, 40)
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
    text.TextColor3 = Color3.fromRGB(220, 220, 255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 11
    text.Parent = frame
    
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 32, 0, 16)
    switch.Position = UDim2.new(1, -40, 0.5, -8)
    switch.BackgroundColor3 = Settings[flag] and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(80, 80, 100)
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
        TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = Settings[flag] and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(80, 80, 100)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = Settings[flag] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        applyAllFeatures()
    end)
    return frame
end

local function CreateSlider(parent, label, flag, minVal, maxVal, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36) -- កម្ពស់តូច ៣៦ មិនបាំងកន្លែងផ្សេង
    frame.BackgroundColor3 = Color3.fromRGB(25, 27, 40)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -10, 0, 14)
    text.Position = UDim2.new(0, 8, 0, 2)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 10
    text.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -65, 0, 3)
    sliderBar.Position = UDim2.new(0, 8, 0, 24)
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
    knob.Size = UDim2.new(0, 9, 0, 9)
    knob.Position = UDim2.new(percent, -4, 0.5, -4)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBar
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(Settings[flag]).. (suffix or "")
    valueLabel.Size = UDim2.new(0, 45, 0, 16)
    valueLabel.Position = UDim2.new(1, -50, 0, 16)
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
        if flag == "walkSpeed" then newVal = math.floor(newVal)
        elseif flag == "jumpPower" then newVal = math.floor(newVal / 10) * 10
        else newVal = math.floor(newVal) end
        newVal = math.clamp(newVal, minVal, maxVal)
        Settings[flag] = newVal
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -4, 0.5, -4)
        valueLabel.Text = tostring(newVal).. (suffix or "")
        if flag == "walkSpeed" or flag == "jumpPower" then
            applyMovement()
        end
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

-- មុខងារប្តូរពណ៌ Preset (លុបចោល UIStroke និង ColorPicker ការពារ Error ១០០%)
local function CreateColorPicker(parent, label, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 26)
    frame.BackgroundColor3 = Color3.fromRGB(25, 27, 40)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Text = label
    text.Size = UDim2.new(1, -80, 1, 0)
    text.Position = UDim2.new(0, 8, 0, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220, 220, 255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Font = Enum.Font.Gotham
    text.TextSize = 11
    text.Parent = frame
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 60, 0, 16)
    colorBtn.Position = UDim2.new(1, -68, 0.5, -8)
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

-- មុខងារបង្កើតប៊ូតុងធម្មតា (កាលពីមុនអត់មានកូដនេះ ធ្វើឱ្យគាំង)
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 24)
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

-- មុខងារបង្កើត JSON Area តូចល្មមស្អាត
local function CreateJSONArea(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Text = "📋 Config System"
    title.Size = UDim2.new(1, -10, 0, 16)
    title.Position = UDim2.new(0, 8, 0, 2)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(130, 140, 180)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.Gotham
    title.TextSize = 9
    title.Parent = frame
    
    local jsonBox = Instance.new("TextBox")
    jsonBox.Size = UDim2.new(1, -16, 0, 30)
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
        if success then
            jsonBox.Text = result
        end
    end
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 50, 0, 16)
    copyBtn.Position = UDim2.new(1, -58, 0, 52)
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

-- ========== BUILD COMPACT UI LAYOUTS ==========
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

CreateSection(scrollFrame, "Combat Operations")
CreateToggle(scrollFrame, "Kill Aura (Players)", "killAuraPlayer")
CreateToggle(scrollFrame, "Auto Kill NPCs", "autoKillNPC")

local updateJSON = CreateJSONArea(scrollFrame)
CreateButton(scrollFrame, "💾 Save & Apply Modifications", function()
    applyAllFeatures()
    updateJSON()
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Copybara", Text = "Saved & Applied", Duration = 2})
end)

-- ========== UNDER-THE-HOOD CHEAT SYSTEMS ==========

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

-- Aimbot Math Module
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

-- Weapon Modification Function
function modifyWeapon(tool)
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
    task.wait(0.5)
    applyMovement()
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then modifyWeapon(child) end
    end)
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then modifyWeapon(tool) end
    end
end)

-- Workspace Event Hooks
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
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then modifyWeapon(tool) end
        end
    end
end

-- Initialize Loop
applyAllFeatures()

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Copybara Hub VIP",
        Text = "GUI Loaded! Drag 🦫 to toggle.",
        Duration = 3
    })
end)