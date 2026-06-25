local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- 1. Setup UI Utama
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "MainHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- 2. Tombol Buka/Tutup (Ikon)
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.Image = "rbxassetid://1889770842" -- Ganti dengan ID gambar Anda
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

-- Logika Buka/Tutup
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 3. Fungsi Dragging (Ditingkatkan)
local dragging, dragInput, dragStart, startPos
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

-- [Tambahkan kode fungsi createToggleButton dari jawaban sebelumnya di sini]

-- 4. Logika Fitur
local noclipEnabled = false
local infiniteJumpEnabled = false

-- Infinite Jump Logic
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- NoClip Logic
RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- 5. Fungsi Pembuat Tombol
local function createButton(text, callback)
    local btn = Instance.new("TextButton", ContentArea)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(callback)
end

-- Fungsi Pembuat Tombol Toggle
local function createToggleButton(text, callback)
    local btn = Instance.new("TextButton", ContentArea)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local enabled = false
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        -- Ubah warna untuk indikator visual (Hijau jika ON)
        btn.BackgroundColor3 = enabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 60)
        btn.Text = enabled and (text .. " [ON]") or (text .. " [OFF]")
        
        callback(enabled) -- Menjalankan fungsi dengan status true/false
    end)
    
    btn.Text = text .. " [OFF]" -- Inisialisasi awal
end

-- 6. Implementasi Fitur dengan Toggle
createToggleButton("Infinite Jump", function(enabled)
    infiniteJumpEnabled = enabled
end)

createToggleButton("NoClip", function(enabled)
    noclipEnabled = enabled
end)

-- Untuk Speed Walk, mungkin lebih baik tombol biasa saja, 
-- tapi ini contoh jika ingin pakai toggle juga:
createToggleButton("Speed Walk (50)", function(enabled)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = enabled and 50 or 16 -- 16 adalah speed normal
    end
end)

-- 7. Fitur Drag (Agar UI bisa digeser)
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
