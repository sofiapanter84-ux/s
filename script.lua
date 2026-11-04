-- olliE JJS 0.2 FARM GUI
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local parent = pcall(function() return gethui() end) and gethui() or game:GetService("CoreGui")

local sg = Instance.new("ScreenGui")
sg.Name = "olliE_JJS"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999999
sg.Parent = parent

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 180)
main.Position = UDim2.new(0.7, 0, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "olliE | JJS 0.2 FARM"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(200,50,50)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255,255,255)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 18
close.Parent = main
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

local farm = Instance.new("TextButton")
farm.Size = UDim2.new(1, -20, 0, 50)
farm.Position = UDim2.new(0, 10, 0, 50)
farm.BackgroundColor3 = Color3.fromRGB(80,180,80)
farm.Text = "0.2 FARM"
farm.TextColor3 = Color3.fromRGB(255,255,255)
farm.Font = Enum.Font.SourceSansBold
farm.TextSize = 20
farm.Parent = main
Instance.new("UICorner", farm).CornerRadius = UDim.new(0, 8)

local circle = Instance.new("TextButton")
circle.Size = UDim2.new(0, 50, 0, 50)
circle.Position = UDim2.new(0.8, 0, 0.2, 0)
circle.BackgroundColor3 = Color3.fromRGB(80,180,80)
circle.Text = "O"
circle.TextColor3 = Color3.fromRGB(255,255,255)
circle.Font = Enum.Font.SourceSansBold
circle.TextSize = 24
circle.Visible = false
circle.Active = true
circle.Draggable = true
circle.Parent = sg
Instance.new("UICorner", circle).CornerRadius = UDim.new(0.5, 0)

local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(main)
makeDraggable(circle)

close.MouseButton1Click:Connect(function()
    main.Visible = false
    circle.Visible = true
end)
circle.MouseButton1Click:Connect(function()
    circle.Visible = false
    main.Visible = true
end)

local function farmPlayers()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    VIM:SendKeyEvent(true, Enum.KeyCode.G, false, game)
    VIM:SendKeyEvent(true, Enum.KeyCode.R, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode.G, false, game)
    VIM:SendKeyEvent(false, Enum.KeyCode.R, false, game)
    task.wait(0.2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local tChar = plr.Character
            local tHrp = tChar:FindFirstChild("HumanoidRootPart")
            local tHum = tChar:FindFirstChildOfClass("Humanoid")
            if tHrp and tHum and tHum.Health > 0 then
                hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 2)
                task.wait(0.15)
            end
        end
    end
end

farm.MouseButton1Click:Connect(farmPlayers)
