local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Bersihkan GUI lama jika ada
local oldGui = playerGui:FindFirstChild("ZeetaAtelierGui")
if oldGui then
    oldGui:Destroy()
end

-- 2. Buat GUI baru
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ZeetaAtelierGui"

-- === PENTING: Gunakan tabel untuk menyimpan koneksi agar bisa dimatikan jika perlu ===
local connections = {}
-- Lanjutkan ke pembuatan GUI yang baru (kode Anda di bawah ini)
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ZeetaAtelierGui"
-- ... (dan seterusnya)
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

-- 3. Fungsi Dragging (Gunakan fungsi lokal agar tidak menumpuk)
local function makeDraggable(object)
    local dragging, dragStart, startPos
    
    local conn1 = object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
        end
    end)
    table.insert(connections, conn1)

    local conn2 = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    table.insert(connections, conn2)

    local conn3 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    table.insert(connections, conn3)
end

-- Terapkan fungsi
makeDraggable(iconButton)
makeDraggable(menuFrame)

-- 4. Jika skrip di-destroy, pastikan semua koneksi mati
screenGui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        for _, conn in pairs(connections) do
            conn:Disconnect()
        end
    end
end)

-- === Fungsi Buka/Tutup Menu ===
iconButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- === 3. Membuat Daftar Pilihan di dalam menuFrame ===
local scrollingFrame = Instance.new("ScrollingFrame", menuFrame)
scrollingFrame.Size = UDim2.new(1, -10, 1, -50) -- Mengambil hampir seluruh area menu
scrollingFrame.Position = UDim2.new(0, 5, 0, 45)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 5

-- Fungsi untuk menambah pilihan ke daftar
local function addOption(name, callback)
    local btn = Instance.new("TextButton", scrollingFrame)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, (#scrollingFrame:GetChildren() - 1) * 45) -- Posisi otomatis
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(callback)
end

-- === MENGGUNAKAN PILIHAN ===
addOption("Farming Mode", function()
    print("Farming diaktifkan!")
end)

addOption("Auto Shovel", function()
    print("Auto Shovel diaktifkan!")
end)

addOption("Webhook Settings", function()
    print("Membuka pengaturan Webhook...")
end)

-- Update CanvasSize agar bisa di-scroll
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #scrollingFrame:GetChildren() * 45)
