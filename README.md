-- Brookhaven Hub with ESP toggle script for Roblox
-- Adapted for mobile users with a floating toggle button and troll options
-- Improved dropdown with scrolling and fixed pull/kill functionality, plus ZIndex fixes and toggle button visibility fix

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- HUB GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "hub 999"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 360)
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

local dropdownFrame = Instance.new("ScrollingFrame")
dropdownFrame.Size = UDim
