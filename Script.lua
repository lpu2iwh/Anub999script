`BrookhavenRaelHubStyleTestScript.lua`
```lua
-- Brookhaven Rael Hub Style Test Script for Roblox  
-- Simple GUI with teleport and speed toggle  
-- Intended for testing and to share with Brookhaven owner  

local Players = game:GetService("Players")  
local LocalPlayer = Players.LocalPlayer  
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()  
local Humanoid = Character:WaitForChild("Humanoid")  

-- Create ScreenGui  
local ScreenGui = Instance.new("ScreenGui")  
ScreenGui.Name = "RaelHubTestGui"  
ScreenGui.ResetOnSpawn = false  
ScreenGui.Parent = game.CoreGui -- Use CoreGui for exploit injection, otherwise PlayerGui  

-- Create main frame  
local MainFrame = Instance.new("Frame")  
MainFrame.Size = UDim2.new(0, 320, 0, 380)  
MainFrame.Position = UDim2.new(0.7, 0, 0.15, 0)  
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  
MainFrame.BorderSizePixel = 0  
MainFrame.Parent = ScreenGui  
MainFrame.ClipsDescendants = true  
MainFrame.BackgroundTransparency = 0.05  
MainFrame.Active = true  
MainFrame.Draggable = true  

-- UI Corner for rounded edges  
local UICorner = Instance.new("UICorner")  
UICorner.CornerRadius = UDim.new(0, 10)  
UICorner.Parent = MainFrame  

-- Title label  
local TitleLabel = Instance.new("TextLabel")  
TitleLabel.Size = UDim2.new(1, 0, 0, 50)  
TitleLabel.BackgroundTransparency = 1  
TitleLabel.Text = "Rael Hub Test - Brookhaven"  
TitleLabel.Font = Enum.Font.GothamBold  
TitleLabel.TextSize = 24  
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  
TitleLabel.Parent = MainFrame  

-- Close button  
local CloseButton = Instance.new("TextButton")  
CloseButton.Size = UDim2.new(0, 35, 0, 35)  
CloseButton.Position = UDim2.new(1, -40, 0, 8)  
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)  
CloseButton.Text = "X"  
CloseButton.Font = Enum.Font.GothamBold  
CloseButton.TextSize = 20  
CloseButton.TextColor3 = Color3.new(1,1,1)  
CloseButton.Parent = MainFrame  
CloseButton.MouseButton1Click:Connect(function()  
    ScreenGui:Destroy()  
end)  

-- Info label  
local InfoLabel = Instance.new("TextLabel")  
InfoLabel.Size = UDim2.new(1, -20, 0, 20)  
InfoLabel.Position = UDim2.new(0, 10, 0, 52)  
InfoLabel.BackgroundTransparency = 1  
InfoLabel.Text = "Teleport to locations or toggle speed"  
InfoLabel.Font = Enum.Font.Gotham  
InfoLabel.TextSize = 14  
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)  
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left  
InfoLabel.Parent = MainFrame  

-- Locations table with typical Brookhaven places (coordinates approximate)  
local Locations = {  
    ["Home"] = Vector3.new(285.5, 3.5, 137.5),  
    ["School"] = Vector3.new(101, 3.5, -298),  
    ["Police Station"] = Vector3.new(-408, 3.5, 195),  
    ["Hospital"] = Vector3.new(-197, 3.5, 31),  
    ["Supermarket"] = Vector3.new(-239, 3.5, -108),  
}  

local ButtonsFrame = Instance.new("Frame")  
ButtonsFrame.Size = UDim2.new(1, -20, 0, 280)  
ButtonsFrame.Position = UDim2.new(0, 10, 0, 80)  
ButtonsFrame.BackgroundTransparency = 1  
ButtonsFrame.Parent = MainFrame  

-- Create teleport buttons  
local buttonY = 0  
for placeName, position in pairs(Locations) do  
    local btn = Instance.new("TextButton")  
    btn.Size = UDim2.new(1, 0, 0, 40)  
    btn.Position = UDim2.new(0, 0, 0, buttonY)  
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)  
    btn.Font = Enum.Font.GothamSemibold  
    btn.TextSize = 18  
    btn.Text = "Teleport to " .. placeName  
    btn.Parent = ButtonsFrame  

    btn.MouseEnter:Connect(function()  
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)  
    end)  

    btn.MouseLeave:Connect(function()  
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
    end)  

    btn.MouseButton1Click:Connect(function()  
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()  
        local hrp = char:FindFirstChild("HumanoidRootPart")  
        if hrp then  
            hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))  
        end  
    end)  

    buttonY = buttonY + 45  
end  

-- Speed toggle  
local speedToggle = false  
local SpeedButton = Instance.new("TextButton")  
SpeedButton.Size = UDim2.new(1, 0, 0, 40)  
SpeedButton.Position = UDim2.new(0, 0, 0, buttonY)  
SpeedButton.BackgroundColor3 = Color3.fromRGB(100, 50, 150)  
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)  
SpeedButton.Font = Enum.Font.GothamSemibold  
SpeedButton.TextSize = 18  
SpeedButton.Text = "Toggle WalkSpeed"  
SpeedButton.Parent = ButtonsFrame  

SpeedButton.MouseEnter:Connect(function()  
    SpeedButton.BackgroundColor3 = Color3.fromRGB(130, 70, 190)  
end)  

SpeedButton.MouseLeave:Connect(function()  
    SpeedButton.BackgroundColor3 = Color3.fromRGB(100, 50, 150)  
end)  

SpeedButton.MouseButton1Click:Connect(function()  
    if not speedToggle then  
        Humanoid.WalkSpeed = 50  
        SpeedButton.Text = "WalkSpeed: 50 (Click to reset)"  
        speedToggle = true  
    else  
        Humanoid.WalkSpeed = 16 -- default Roblox walk speed  
        SpeedButton.Text = "Toggle WalkSpeed"  
        speedToggle = false  
    end  
end)  

-- Make sure the GUI stays when the character respawns  
LocalPlayer.CharacterAdded:Connect(function(char)  
    Character = char  
    Humanoid = char:WaitForChild("Humanoid")  
end)  

print("Rael Hub Style Brookhaven Test Script loaded.")  

```
