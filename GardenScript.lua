--[[
    Grow A Garden 2 - Hub
    Fitur: LocalPlayer, Webhook, Settings
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- 1. Setup UI Utama
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "MainHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Visible = false -- Mulai dalam keadaan tersembunyi
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- 2. Toggle Button (Icon)
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.Image = "rbxassetid://1889770842"
ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- 3. Layout (Sidebar & Content)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -130, 1, -10)
ContentArea.Position = UDim2.new(0, 125, 0, 5)
ContentArea.BackgroundTransparency = 1

-- 4. Logika Fitur
local noclipEnabled = false
local infiniteJumpEnabled = false

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- 5. Fungsi Pembuat UI
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
end

-- 6. Navigasi Tab
local tabs = {"LocalPlayer", "Webhook", "Settings"}
for _, name in pairs(tabs) do
    createButton(Sidebar, name, function()
        print("Tab " .. name .. " terpilih")
        -- Tambahkan logika untuk menampilkan konten tab di sini
    end)
end

-- Contoh isi konten LocalPlayer
createButton(ContentArea, "Toggle NoClip", function() noclipEnabled = not noclipEnabled end)
createButton(ContentArea, "Toggle Inf Jump", function() infiniteJumpEnabled = not infiniteJumpEnabled end)

-- 7. Dragging Logic
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
