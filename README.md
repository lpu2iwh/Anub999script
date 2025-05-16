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
mainFrame.Size = UDim2.new(0, 300, 0, 300) -- Increased height for troll options
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
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

-- Troll Options
local trollFrame = Instance.new("Frame")
trollFrame.Size = UDim2.new(1, 0, 0, 200)
trollFrame.Position = UDim2.new(0, 0, 0, 120)
trollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
trollFrame.Parent = mainFrame

local trollTitle = Instance.new("TextLabel")
trollTitle.Text = "Opções de Troll"
trollTitle.Size = UDim2.new(1, 0, 0, 40)
trollTitle.BackgroundTransparency = 1
trollTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
trollTitle.Font = Enum.Font.GothamBold
trollTitle.TextSize = 20
trollTitle.Parent = trollFrame

-- Example Troll Button
local trollButton = Instance.new("TextButton")
trollButton.Text = "Trollar Jogador"
trollButton.Size = UDim2.new(0.8, 0, 0, 45)
trollButton.Position = UDim2.new(0.1, 0, 0, 50)
trollButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
trollButton.TextColor3 = Color3.new(1,1,1)
trollButton.Font = Enum.Font.GothamBold
trollButton.TextSize = 22
trollButton.Parent = trollFrame

trollButton.MouseButton1Click:Connect(function()
    -- Implement troll functionality here
    for _, player in pairs(
