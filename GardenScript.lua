local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ZeetaAtelierGui"

-- === 1. Membuat Tombol Ikon ===
local iconButton = Instance.new("ImageButton", screenGui)
iconButton.Size = UDim2.new(0, 60, 0, 60)
iconButton.Position = UDim2.new(0.1, 0, 0.1, 0)
iconButton.Image = "rbxassetid://0" -- GANTI ID INI
iconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
iconButton.BorderSizePixel = 0
Instance.new("UICorner", iconButton).CornerRadius = UDim.new(1, 0)

-- === 2. Membuat Menu Utama ===
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 200, 0, 300)
menuFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 8)

-- === FUNGSI DRAGGING (Dibuat lebih rapi agar bisa dipakai untuk 2 objek) ===
local function makeDraggable(object)
    local dragging, dragStart, startPos
    
    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Terapkan fungsi ke kedua elemen
makeDraggable(iconButton)
makeDraggable(menuFrame)

-- === Fungsi Buka/Tutup Menu ===
iconButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)
