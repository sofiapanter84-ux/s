-- SERVICIOS
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- CONTENEDOR (CoreGui o gethui)
local guiParent = (gethui and gethui()) or game:GetService("CoreGui")

-- LIMPIAR GUI ANTERIOR
local old = guiParent:FindFirstChild("JJS_02Farm")
if old then old:Destroy() end

-- SCREENGUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JJS_02Farm"
screenGui.Parent = guiParent
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 2147483647
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- FRAME PRINCIPAL
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 140)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- BARRA DE TÍTULO
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
titleBar.ZIndex = 2

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "0.2 FARM"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar
titleLabel.ZIndex = 3

-- BOTÓN X (OCULTAR)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar
closeBtn.ZIndex = 3

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- BOTÓN FARM
local farmBtn = Instance.new("TextButton")
farmBtn.Name = "FarmButton"
farmBtn.Size = UDim2.new(0.8, 0, 0, 50)
farmBtn.Position = UDim2.new(0.1, 0, 0.5, -10)
farmBtn.Text = "0.2 FARM"
farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
farmBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
farmBtn.Font = Enum.Font.SourceSansBold
farmBtn.TextSize = 20
farmBtn.Parent = mainFrame
farmBtn.ZIndex = 2

local farmCorner = Instance.new("UICorner")
farmCorner.CornerRadius = UDim.new(0, 6)
farmCorner.Parent = farmBtn

-- CÍRCULO FLOTANTE (OCULTO)
local circleBtn = Instance.new("TextButton")
circleBtn.Name = "CircleButton"
circleBtn.Size = UDim2.new(0, 50, 0, 50)
circleBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
circleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
circleBtn.Text = "0.2"
circleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
circleBtn.Font = Enum.Font.SourceSansBold
circleBtn.TextSize = 14
circleBtn.Parent = screenGui
circleBtn.Visible = false
circleBtn.ZIndex = 10

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = circleBtn

-- ARRASTRE GENÉRICO
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(mainFrame)
makeDraggable(circleBtn)

-- OCULTAR / MOSTRAR
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    circleBtn.Visible = true
end)

circleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    circleBtn.Visible = false
end)

-- SIMULAR TECLA
local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

-- RECOLECTAR OBJETIVOS (jugadores + dummies)
local function getTargets()
    local targets = {}
    local lp = Players.LocalPlayer

    -- jugadores reales
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                table.insert(targets, hrp)
            end
        end
    end

    -- dummies / NPCs en workspace
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= lp.Character then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local lowerName = string.lower(obj.Name)
                if string.find(lowerName, "dummy") then
                    table.insert(targets, hrp)
                end
            end
        end
    end

    return targets
end

-- FARM
local function farm()
    pressKey(Enum.KeyCode.G)
    pressKey(Enum.KeyCode.R)
    task.wait(0.5)

    local lp = Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targets = getTargets()
    if #targets == 0 then
        return
    end

    for _, targetPart in ipairs(targets) do
        if targetPart and targetPart.Parent then
            local goal = targetPart.CFrame * CFrame.new(0, 3, 0)
            char:PivotTo(goal)
            task.wait(0.08)
        end
    end
end

farmBtn.MouseButton1Click:Connect(farm)
