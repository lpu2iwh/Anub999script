-- Brookhaven Hub with ESP toggle script for Roblox
-- Adapted for mobile users with a floating toggle button

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- HUB GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrookhavenHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = ScreenGui
mainFrame.Visible = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "Brookhaven Hub"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ESP Toggle Button
local espToggleButton = Instance.new("TextButton")
espToggleButton.Text = "Ativar ESP"
espToggleButton.Size = UDim2.new(0.8, 0, 0, 45)
espToggleButton.Position = UDim2.new(0.1, 0, 0, 60)
espToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
espToggleButton.TextColor3 = Color3.new(1,1,1)
espToggleButton.Font = Enum.Font.GothamBold
espToggleButton.TextSize = 22
espToggleButton.Parent = mainFrame

-- Floating Button for mobile (and desktop) to toggle hub visibility
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleHubButton"
toggleButton.Text = "Hub"
toggleButton.Size = UDim2.new(0, 60, 0, 40)
toggleButton.Position = UDim2.new(1, -65, 1, -50) -- bottom-right corner with margin
toggleButton.AnchorPoint = Vector2.new(0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 22
toggleButton.AutoButtonColor = true
toggleButton.Parent = ScreenGui

-- ================ ESP Section ===================
local espEnabled = false
local espFolder = nil
local espObjects = {}

local function createESPBox(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 4)
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(0, 255, 0) -- verde
    box.Parent = espFolder

    local nameTag = Instance.new("TextLabel")
    nameTag.BackgroundTransparency = 1
    nameTag.TextColor3 = Color3.new(1, 1, 1)
    nameTag.TextStrokeTransparency = 0
    nameTag.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameTag.Text = player.Name
    nameTag.Size = UDim2.new(0, 100, 0, 20)
    nameTag.Font = Enum.Font.SourceSansBold
    nameTag.TextScaled = true
    nameTag.Parent = espFolder

    return {
        box = box,
        nameTag = nameTag
    }
end

local function updateESP()
    if not espEnabled then return end
    for player, objects in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localPlayer then
            local rootPart = player.Character.HumanoidRootPart
            objects.box.Adornee = rootPart

            local head = player.Character:FindFirstChild("Head")
            if head then
                local headPos, onScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                objects.nameTag.Position = UDim2.new(0, headPos.X - 50, 0, headPos.Y - 20)
                objects.nameTag.Visible = onScreen and headPos.Z > 0
            else
                objects.nameTag.Visible = false
            end
        else
            if objects.box then
                objects.box.Adornee = nil
            end
            if objects.nameTag then
                objects.nameTag.Visible = false
            end
        end
    end
end

local function addPlayerESP(player)
    if player == localPlayer then return end
    player.CharacterAdded:Connect(function(character)
        wait(1)
        if not espEnabled then return end
        if character and character:FindFirstChild("HumanoidRootPart") then
            if not espObjects[player] then
                espObjects[player] = createESPBox(player)
            end
            espObjects[player].box.Adornee = character.HumanoidRootPart
            espObjects[player].nameTag.Visible = true
        end
    end)
end

local function removePlayerESP(player)
    if espObjects[player] then
        if espObjects[player].box then
            espObjects[player].box:Destroy()
        end
        if espObjects[player].nameTag then
            espObjects[player].nameTag:Destroy()
        end
        espObjects[player] = nil
    end
end

local function enableESP()
    if espEnabled then return end
    espEnabled = true
    espFolder = Instance.new("Folder")
    espFolder.Name = "ESP"
    espFolder.Parent = ScreenGui

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            espObjects[player] = createESPBox(player)
        end
        addPlayerESP(player)
    end

    Players.PlayerAdded:Connect(function(player)
        if espEnabled then
            addPlayerESP(player)
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        removePlayerESP(player)
    end)

    RunService.RenderStepped:Connect(updateESP)
end

local function disableESP()
    espEnabled = false
    if espFolder then
        espFolder:Destroy()
        espFolder = nil
    end
    espObjects = {}
end

espToggleButton.MouseButton1Click:Connect(function()
    if not espEnabled then
        enableESP()
        espToggleButton.Text = "Desativar ESP"
        espToggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    else
        disableESP()
        espToggleButton.Text = "Ativar ESP"
        espToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end)

-- Floating button toggles hub visibility
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Atalho teclado para desktop ainda permanece (F6)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F6 then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

print("Brookhaven Hub carregado. Use o botão 'Hub' na tela para abrir o menu no mobile ou pressione F6 no desktop.")

