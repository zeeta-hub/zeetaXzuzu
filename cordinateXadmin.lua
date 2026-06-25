local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)

-- Membuat Frame Utama
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.Active = true
mainFrame.Draggable = true -- Membuat UI bisa digeser

-- Tab Bar
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Tombol Tab
local tabButton = Instance.new("TextButton", tabBar)
tabButton.Size = UDim2.new(1, 0, 1, 0)
tabButton.Text = "Copy Coordinates"
tabButton.TextColor3 = Color3.new(1, 1, 1)

-- Container Koordinat
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1

local coordLabel = Instance.new("TextLabel", contentFrame)
coordLabel.Size = UDim2.new(1, 0, 0.5, 0)
coordLabel.TextColor3 = Color3.new(1, 1, 1)
coordLabel.Text = "Klik tombol untuk ambil posisi"

local copyButton = Instance.new("TextButton", contentFrame)
copyButton.Size = UDim2.new(0, 100, 0, 30)
copyButton.Position = UDim2.new(0.5, -50, 0.5, 0)
copyButton.Text = "Copy"

-- Logika Copy Koordinat
tabButton.MouseButton1Click:Connect(function()
	local pos = player.Character.HumanoidRootPart.Position
	local posText = string.format("%f, %f, %f", pos.X, pos.Y, pos.Z)
	coordLabel.Text = posText
end)

copyButton.MouseButton1Click:Connect(function()
	local pos = player.Character.HumanoidRootPart.Position
	local posText = string.format("%f, %f, %f", pos.X, pos.Y, pos.Z)
	setclipboard(posText) -- Fungsi executor standar untuk menyalin ke clipboard
	copyButton.Text = "Copied!"
	task.wait(1)
	copyButton.Text = "Copy"
end)
