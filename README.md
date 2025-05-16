-- Brookhaven Hub with ESP toggle script for Roblox
-- Adapted for mobile users with a floating toggle button and troll options
-- Improved dropdown with scrolling and fixed pull/kill functionality, plus ZIndex fixes

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
mainFrame.Size = UDim2.new(0, 320, 0, 360) -- Height for troll options
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
title.ZIndex = 10
title.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.ZIndex = 11
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
espToggleButton.ZIndex = 10
espToggleButton.Parent = mainFrame

-- Troll Options Frame
local trollFrame = Instance.new("Frame")
trollFrame.Size = UDim2.new(1, -20, 0, 240)
trollFrame.Position = UDim2.new(0, 10, 0, 110)
trollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
trollFrame.Parent = mainFrame
trollFrame.ClipsDescendants = true
trollFrame.ZIndex = 10

local trollTitle = Instance.new("TextLabel")
trollTitle.Text = "Opções de Troll"
trollTitle.Size = UDim2.new(1, 0, 0, 35)
trollTitle.BackgroundTransparency = 1
trollTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
trollTitle.Font = Enum.Font.GothamBold
trollTitle.TextSize = 20
trollTitle.ZIndex = 10
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
playerDropdown.ZIndex = 11
playerDropdown.Parent = trollFrame

local dropdownOpen = false

-- Use ScrollingFrame for player list to allow scrolling if list is long
local dropdownFrame = Instance.new("ScrollingFrame")
dropdownFrame.Size = UDim2.new(0.9, 0, 0, 150)
dropdownFrame.Position = UDim2.new(0.05, 0, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdownFrame.Visible = false
dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownFrame.ScrollBarThickness = 6
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ZIndex = 20 -- High ZIndex to be on top of buttons
dropdownFrame.Parent = trollFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = dropdownFrame

local function updateDropdownPlayers()
    -- Clear existing buttons
    for _, child in pairs(dropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local count = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 18
            btn.Text = player.Name
            btn.AutoButtonColor = true
            btn.LayoutOrder = count + 1
            btn.Parent = dropdownFrame

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                playerDropdown.Text = "Jogador: " .. player.Name
                dropdownFrame.Visible = false
                dropdownOpen = false
            end)
            count = count + 1
        end
    end
    -- Update CanvasSize to fit contents
    dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

playerDropdown.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    dropdownFrame.Visible = dropdownOpen
    if dropdownOpen then
        updateDropdownPlayers()
    end
end)

-- Troll Buttons

local function getRootPart(player)
    if player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            return root
        end
    end
    return nil
end

-- Pull Player with Sofa troll
local pullButton = Instance.new("TextButton")
pullButton.Text = "Puxar com Sofá"
pullButton.Size = UDim2.new(0.9, 0, 0, 40)
pullButton.Position = UDim2.new(0.05, 0, 0, 140)
pullButton.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
pullButton.TextColor3 = Color3.new(1,1,1)
pullButton.Font = Enum.Font.GothamBold
pullButton.TextSize = 20
pullButton.ZIndex = 11
pullButton.Parent = trollFrame

local pulling = false
pullButton.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    if pulling then
        pulling = false
        pullButton.Text = "Puxar com Sofá"
        return
    end
    local root = getRootPart(selectedPlayer)
    local localRoot = getRootPart(localPlayer)
    if root and localRoot then
        -- Create BodyPosition to pull player towards local player
        if selectedPlayer.Character and not root:FindFirstChild("PullBodyPosition") then
            local bp = Instance.new("BodyPosition")
            bp.Name = "PullBodyPosition"
            bp.MaxForce = Vector3.new(1e5,1e5,1e5)
            bp.P = 1e4
            bp.D = 500
            bp.Parent = root
            pulling = true
            pullButton.Text = "Parar puxar"
            -- Update target position continuously
            local pullConnection
            pullConnection = RunService.Heartbeat:Connect(function()
                if not pulling or not selectedPlayer or not selectedPlayer.Character or not root.Parent then
                    if bp and bp.Parent then
                        bp:Destroy()
                    end
                    pullConnection:Disconnect()
                    pulling = false
                    pullButton.Text = "Puxar com Sofá"
                    return
                end
                local targetPos = localRoot.Position + (localRoot.CFrame.LookVector * 3)
                bp.Position = targetPos
            end)
        end
    end
end)

-- Kill player by pushing into the void
local voidKillButton = Instance.new("TextButton")
voidKillButton.Text = "Matar no Void"
voidKillButton.Size = UDim2.new(0.9, 0, 0, 40)
voidKillButton.Position = UDim2.new(0.05, 0, 0, 190)
voidKillButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
voidKillButton.TextColor3 = Color3.new(1,1,1)
voidKillButton.Font = Enum.Font.GothamBold
voidKillButton.TextSize = 20
voidKillButton.ZIndex = 11
voidKillButton.Parent = trollFrame
