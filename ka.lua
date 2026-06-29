local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==================== UI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "copybara_tool"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0.5, -110, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- ប៊ូតុង X
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Frame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- ប៊ូតុងលាក់/បង្ហាញ Frame
local ToggleUIBtn = Instance.new("TextButton")
ToggleUIBtn.Size = UDim2.new(0, 70, 0, 30)
ToggleUIBtn.Position = UDim2.new(0, 10, 0, -35)
ToggleUIBtn.Text = "🙈 លាក់ UI"
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(142, 68, 173)
ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIBtn.Font = Enum.Font.GothamBold
ToggleUIBtn.TextSize = 12
ToggleUIBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleUIBtn

-- ប៊ូតុង VIP Noclip
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0, 200, 0, 40)
NoclipBtn.Position = UDim2.new(0, 10, 0, 15)
NoclipBtn.Text = "ការពារបុកប៉ើង: បិទ"
NoclipBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.TextSize = 16
NoclipBtn.Parent = Frame

local NoclipCorner = Instance.new("UICorner")
NoclipCorner.CornerRadius = UDim.new(0, 8)
NoclipCorner.Parent = NoclipBtn

-- ប៊ូតុង Infinite Jump (លោតគ្មានដែន)
local JumpBtn = Instance.new("TextButton")
JumpBtn.Size = UDim2.new(0, 200, 0, 40)
JumpBtn.Position = UDim2.new(0, 10, 0, 65)
JumpBtn.Text = "ចុចលោតឲ្យជាប់ពេលធ្លាក់: បិទ"
JumpBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
JumpBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
JumpBtn.Font = Enum.Font.GothamBold
JumpBtn.TextSize = 16
JumpBtn.Parent = Frame

local JumpCorner = Instance.new("UICorner")
JumpCorner.CornerRadius = UDim.new(0, 8)
JumpCorner.Parent = JumpBtn

-- ប៊ូតុង Open (👀) សម្រាប់ទូរស័ព្ទ
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(1, -65, 0, 65)
OpenBtn.Text = "👀"
OpenBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 25
OpenBtn.Visible = false
OpenBtn.ZIndex = 100 -- ឱ្យវានៅពីលើ
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 25)
OpenCorner.Parent = OpenBtn

-- ==================== ប្រព័ន្ធអូស (Draggable System) សម្រាប់ទាំង Frame និង OpenBtn ====================
local function makeDraggable(guiObject)
    local dragging = false
    local dragInput, mousePos, objectPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            objectPos = guiObject.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            guiObject.Position = UDim2.new(
                objectPos.X.Scale,
                objectPos.X.Offset + delta.X,
                objectPos.Y.Scale,
                objectPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- អនុវត្តការអូសទៅ Frame និង OpenBtn
makeDraggable(Frame)
makeDraggable(OpenBtn)

-- ==================== Logic ====================

-- ១. លាក់/បង្ហាញ Frame
ToggleUIBtn.Activated:Connect(function()
    Frame.Visible = not Frame.Visible
    ToggleUIBtn.Text = Frame.Visible and "🙈 លាក់ UI" or "👀 បង្ហាញ UI"
    ToggleUIBtn.BackgroundColor3 = Frame.Visible and Color3.fromRGB(142, 68, 173) or Color3.fromRGB(46, 204, 113)
end)

-- ២. ចុច X ដើម្បីលាក់ Frame និងបង្ហាញ OpenBtn
CloseBtn.Activated:Connect(function()
    Frame.Visible = false
    ToggleUIBtn.Visible = false
    OpenBtn.Visible = true
end)

-- ៣. ចុច OpenBtn ដើម្បីបង្ហាញ Frame ឡើងវិញវ
OpenBtn.Activated:Connect(function()
    Frame.Visible = true
    ToggleUIBtn.Visible = true
    OpenBtn.Visible = false
end)

-- ៤. VIP Noclip
local noclipEnabled = false
NoclipBtn.Activated:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        NoclipBtn.Text = "ការពារបុកប៉ើង:បើក"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
        NoclipBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        NoclipBtn.Text = "🔥 VIP Noclip: បិទ"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled then
        pcall(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if hrp and humanoid and humanoid.MoveDirection.Magnitude == 0 then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    end
end)

-- ៥. Infinite Jump (លោតគ្មានដែន ដោយចុច Space ឬលើអេក្រង់)
local infiniteJumpEnabled = false
local infiniteJumpConnection = nil

JumpBtn.Activated:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        JumpBtn.Text = "ចុចលោតឲ្យជាប់ពេលធ្លាក់: បើក"
        JumpBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        JumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                if LocalPlayer.Character then
                    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
                        hum:ChangeState("Jumping")
                    end
                end
            end)
        end)
    else
        JumpBtn.Text = "ចុចលោតឲ្យជាប់ពេលធ្លាក់: បិទ"
        JumpBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
        JumpBtn.TextColor3 = Color3.fromRGB(0, 0, 0)

        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
    end
end)