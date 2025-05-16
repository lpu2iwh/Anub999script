-- Brookhaven Hub with ESP toggle script for Roblox
-- Adapted for mobile users with a floating toggle button and troll options

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- HUB GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrookhavenHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 360) -- Increased height for troll options
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -180)
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
espToggleButton.Size = UDim2.new(0.9, 0, 0, 45)
espToggleButton.Position = UDim2.new(0.05, 0, 0, 50)
espToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
espToggleButton.TextColor3 = Color3.new(1,1,1)
espToggleButton.Font = Enum.Font.GothamBold
espToggleButton.TextSize = 22
espToggleButton.Parent = mainFrame

-- Troll Options Frame
local trollFrame = Instance.new("Frame")
trollFrame.Size = UDim2.new(1, -20, 0, 240)
trollFrame.Position = UDim2.new(0, 10, 0, 110)
trollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
trollFrame.Parent = mainFrame
trollFrame.ClipsDescendants = true

local trollTitle = Instance.new("TextLabel")
trollTitle.Text = "Opções de Troll"
trollTitle.Size = UDim2.new(1, 0, 0, 35)
trollTitle.BackgroundTransparency = 1
trollTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
trollTitle.Font = Enum.Font.GothamBold
trollTitle.TextSize = 20
trollTitle.Parent = trollFrame

-- Player Selection Dropdown
local selectedPlayer = nil

local playerDropdown = Instance.new("TextButton")
playerDropdown.Text = "Selecionar Jogador"
playerDropdown.Size = UDim2.new(0.9, 0, 0, 40)
playerDropdown.Position = UDim2.new(0.05, 0, 0, 40)
playerDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
playerDropdown.TextColor3 = Color3.new(1,1,1)
playerDropdown.Font = Enum.Font.GothamBold
playerDropdown.TextSize = 20
playerDropdown.AutoButtonColor = true
playerDropdown.Parent = trollFrame

local dropdownOpen = false
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0.9, 0, 0, 150)
dropdownFrame.Position = UDim2.new(0.05, 0, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdownFrame.Visible = false
dropdownFrame.ClipsDescendants = true
dropdownFrame.Parent = trollFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.Parent = dropdownFrame

local function updateDropdownPlayers()
    -- Clear existing buttons
    for _, child in pairs(dropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local yPos = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 18
            btn.Text = player.Name
            btn.AutoButtonColor = true
            btn.Parent = dropdownFrame

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                playerDropdown.Text = "Jogador: "..player.Name
                dropdownFrame.Visible = false
                dropdownOpen = false
            end)
            yPos = yPos + 35
        end
    end
end

playerDropdown.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    dropdownFrame.Visible = dropdownOpen
    if dropdownOpen then
        updateDropdownPlayers()
    end
end)

-- Troll Buttons

-- Utility function to get HumanRootPart safely
local function getRootPart(player)
    if player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            return root
        end
    end
    return nil
end

-- Troll: Pull Player with Sofa
local pullButton = Instance.new("TextButton")
pullButton.Text = "Puxar com Sofá"
pullButton.Size = UDim2.new(0.9, 0, 0, 40)
pullButton.Position = UDim2.new(0.05, 0, 0, 140)
pullButton.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
pullButton.TextColor3 = Color3.new(1,1,1)
pullButton.Font = Enum.Font.GothamBold
pullButton.TextSize = 20
pullButton.Parent = trollFrame

pullButton.MouseButton1Click:Connect(function()
    if selectedPlayer == nil then return end
    local root = getRootPart(selectedPlayer)
    local localRoot = getRootPart(localPlayer)
    if root and localRoot then
        -- Simulate pulling by tweening the target closer to local player
        local distance = (root.Position - localRoot.Position).Magnitude
        if distance > 50 then
            -- Too far, no action
            return
        end
        local targetPos = localRoot.Position + (localRoot.CFrame.LookVector * 2)
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
    end
end)

-- Troll: Kill player by pushing into the void
local voidKillButton = Instance.new("TextButton")
voidKillButton.Text = "Matar no Void"
voidKillButton.Size = UDim2.new(0.9, 0, 0, 40)
voidKillButton.Position = UDim2.new(0.05, 0, 0, 190)
voidKillButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
voidKillButton.TextColor3 = Color3.new(1,1,1)
voidKillButton.Font = Enum.Font.GothamBold
voidKillButton.TextSize = 20
voidKillButton.Parent = trollFrame

voidKillButton.MouseButton1Click:Connect(function()
    if selectedPlayer == nil then return end
    local root = getRootPart(selectedPlayer)
    if root then
        -- Teleport player far below in the void
        local voidPos = Vector3.new(root.Position.X, -500, root.Position.Z)
        root.CFrame = CFrame.new(voidPos)
    end
end)

-- Troll: Freeze Player
local freezeButton = Instance.new("TextButton")
freezeButton.Text = "Congelar Jogador"
freezeButton.Size = UDim2.new(0.9, 0, 0, 40)
freezeButton.Position = UDim2.new(0.05, 0, 0, 240)
freezeButton.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
freezeButton.TextColor3 = Color3.new(1,1,1)
freezeButton.Font = Enum.Font.GothamBold
freezeButton.TextSize = 20
freezeButton.Parent = trollFrame

local frozenPlayers = {}

freezeButton.MouseButton1Click:Connect(function()
    if selectedPlayer == nil then return end
    local root = getRootPart(selectedPlayer)
    if root then
        local humanoid = selectedPlayer.Character and selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and not frozenPlayers[selectedPlayer] then
            root.Anchored = true
            frozenPlayers[selectedPlayer] = true
            freezeButton.Text = "Descongelar Jogador"
        elseif frozenPlayers[selectedPlayer] then
            root.Anchored = false
            frozenPlayers[selectedPlayer] = nil
            freezeButton.Text = "Congelar Jogador"
        end
    end
end)

-- Troll: Spin Player
local spinButton = Instance.new("TextButton")
spinButton.Text = "Girar Jogador"
spinButton.Size = UDim2.new(0.9, 0, 0, 40)
spinButton.Position = UDim2.new(0.05, 0, 0, 290)
spinButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
spinButton.TextColor3 = Color3.new(1,1,1)
spinButton.Font = Enum.Font.GothamBold
spinButton.TextSize = 20
spinButton.Parent = trollFrame

local spinningPlayers = {}

spinButton.MouseButton1Click:Connect(function()
    if selectedPlayer == nil then return end
    local root = getRootPart(selectedPlayer)
    if root then
        if not spinningPlayers[selectedPlayer] then
            spinningPlayers[selectedPlayer] = true
            local spinConnection
            spinConnection = RunService.Heartbeat:Connect(function()
                if selectedPlayer == nil or not spinningPlayers[selectedPlayer] or not root or not root.Parent then
                    spinConnection:Disconnect()
                    spinningPlayers[selectedPlayer] = nil
                    return
                end
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(15), 0)
            end)
            spinButton.Text = "Parar Giro"
        else
            spinningPlayers[selectedPlayer] = nil
            spinButton.Text = "Girar Jogador"
        end
    end
end)

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
