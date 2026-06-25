local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEANUP TOTAL (Mencegah Double/Triple UI)
local GUI_NAME = "ZeetaAtelierGui"
if playerGui:FindFirstChild(GUI_NAME) then
    playerGui:FindFirstChild(GUI_NAME):Destroy()
end

-- Gunakan tabel global untuk melacak koneksi agar bisa dimatikan
if getgenv().ZeetaConnections then
    for _, conn in pairs(getgenv().ZeetaConnections) do
        conn:Disconnect()
    end
end
getgenv().ZeetaConnections = {}

-- 2. MEMBUAT GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = GUI_NAME

-- Ikon Tombol
local iconButton = Instance.new("ImageButton", screenGui)
iconButton.Size = UDim2.new(0, 60, 0, 60)
iconButton.Position = UDim2.new(0.1, 0, 0.1, 0)
iconButton.Image = "rbxassetid://0" -- GANTI DENGAN ID GAMBAR ANDA
iconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
iconButton.BorderSizePixel = 0
Instance.new("UICorner", iconButton).CornerRadius = UDim.new(1, 0)

-- Menu Utama
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
menuFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.Visible = false
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 8)

-- === 2.1 Membuat Title Bar (Judul + Link) ===
local titleBar = Instance.new("Frame", menuFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

-- Nama Skrip
local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(0.6, -10, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "Zeeta Atelier" -- NAMA SKRIP ANDA
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- Link Discord (Button)
local discordBtn = Instance.new("TextButton", titleBar)
discordBtn.Size = UDim2.new(0.4, -10, 0.7, 0)
discordBtn.Position = UDim2.new(0.6, 0, 0.15, 0)
discordBtn.Text = "Discord"
discordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218) -- Warna biru Discord
discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discordBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 5)

-- Aksi Klik Link Discord
discordBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/link-anda-disini") -- Ganti dengan link Anda
    print("Link Discord disalin ke clipboard!")
end)

-- 3. FUNGSI DRAGGING (Dapat digeser)
local function makeDraggable(object)
    local dragging, dragStart, startPos
    
    local conn1 = object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
        end
    end)
    table.insert(getgenv().ZeetaConnections, conn1)

    local conn2 = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    table.insert(getgenv().ZeetaConnections, conn2)

    local conn3 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    table.insert(getgenv().ZeetaConnections, conn3)
end

makeDraggable(iconButton)
makeDraggable(menuFrame)

-- 4. FUNGSI BUKA/TUTUP
iconButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

print("ZeetaAtelier UI Berhasil Dimuat!")

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
