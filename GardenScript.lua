local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Membuat ScreenGui Utama
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ZeetaAtelierGui"

-- Membuat Tombol Ikon (Pembuka)
local iconButton = Instance.new("ImageButton", screenGui)
iconButton.Size = UDim2.new(0, 60, 0, 60)
iconButton.Position = UDim2.new(0.1, 0, 0.1, 0)
iconButton.Image = "rbxassetid://0" -- Ganti dengan ID Asset gambar zpp-removebg-preview.jpg Anda
iconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
iconButton.BorderSizePixel = 0
Instance.new("UICorner", iconButton).CornerRadius = UDim.new(1, 0) -- Membuatnya bulat

-- Membuat Menu Utama
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 200, 0, 300)
menuFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false -- Awalnya tertutup

-- Fungsi Dragging (Bisa digeser)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    iconButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

iconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = iconButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Fungsi Buka/Tutup Menu
iconButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)
