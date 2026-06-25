local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEANUP TOTAL
local GUI_NAME = "ZeetaAtelierGui"
if playerGui:FindFirstChild(GUI_NAME) then playerGui:FindFirstChild(GUI_NAME):Destroy() end

-- 2. GUI BASE
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false

-- Icon Pembuka
local iconButton = Instance.new("ImageButton", screenGui)
iconButton.Size = UDim2.new(0, 60, 0, 60); iconButton.Position = UDim2.new(0.1, 0, 0.1, 0)
iconButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
iconButton.Active = true; iconButton.Draggable = true
Instance.new("UICorner", iconButton).CornerRadius = UDim.new(1, 0)

-- Menu Utama
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0.5, 0, 0.5, 0); menuFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 40)
menuFrame.Visible = false; menuFrame.Active = true
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 8)

-- Tab Bar (Header - Biru)
local header = Instance.new("Frame", menuFrame)
header.Size = UDim2.new(1, 0, 0, 40); header.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)
local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0); title.Text = "Zeeta Atelier Hub"; title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold; title.TextSize = 18; title.BackgroundTransparency = 1

-- Layout Tab
local leftFrame = Instance.new("Frame", menuFrame)
leftFrame.Size = UDim2.new(0.3, 0, 1, -40); leftFrame.Position = UDim2.new(0, 0, 0, 40); leftFrame.BackgroundTransparency = 1
Instance.new("UIListLayout", leftFrame).Padding = UDim.new(0, 5)

local rightFrame = Instance.new("Frame", menuFrame)
rightFrame.Size = UDim2.new(0.7, 0, 1, -40); rightFrame.Position = UDim2.new(0.3, 0, 0, 40); rightFrame.BackgroundTransparency = 1

local pages = {}
local function addTab(name)
    local tabBtn = Instance.new("TextButton", leftFrame)
    tabBtn.Size = UDim2.new(1, 0, 0, 40); tabBtn.Text = name; tabBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150); tabBtn.TextColor3 = Color3.new(1, 1, 1)
    local page = Instance.new("ScrollingFrame", rightFrame)
    page.Size = UDim2.new(1, 0, 1, 0); page.Visible = false; page.BackgroundTransparency = 1
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    pages[name] = page
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
end

addTab("Local"); addTab("ESP"); addTab("Teleport")

-- Helper UI
local function createToggle(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(120, 0, 120); btn.Text = name .. " : OFF"; btn.TextColor3 = Color3.new(1, 1, 1)
    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn; btn.Text = name .. (isOn and " : ON" or " : OFF"); callback(isOn)
    end)
    return btn
end

-- Konten Local
local lpPage = pages["Local"]
createToggle(lpPage, "Infinite Jump", function(v) _G.InfJump = v end)
UserInputService.JumpRequest:Connect(function() if _G.InfJump and player.Character then player.Character.Humanoid:ChangeState("Jumping") end end)

-- Slider Speed
local sliderBg = Instance.new("Frame", lpPage)
sliderBg.Size = UDim2.new(1, -10, 0, 40); sliderBg.BackgroundColor3 = Color3.fromRGB(80, 0, 80)
local sliderBar = Instance.new("Frame", sliderBg)
sliderBar.Size = UDim2.new(0.16, 0, 1, 0); sliderBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
local sliderLabel = Instance.new("TextLabel", sliderBg)
sliderLabel.Size = UDim2.new(1, 0, 1, 0); sliderLabel.Text = "Walkspeed: 16"; sliderLabel.BackgroundTransparency = 1
sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = player:GetMouse()
        local conn; conn = RunService.RenderStepped:Connect(function()
            local relX = math.clamp((mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderBar.Size = UDim2.new(relX, 0, 1, 0); local speed = math.floor(relX * 100)
            sliderLabel.Text = "Walkspeed: " .. speed
            if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = speed end
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end end)
    end
end)

-- Konten ESP (Player, Fruit, Seed)
local espPage = pages["ESP"]
local function addESP(name, targetName, color)
    createToggle(espPage, "ESP " .. name, function(v)
        _G[name.."ESP"] = v
        RunService.RenderStepped:Connect(function()
            if not _G[name.."ESP"] then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == targetName and obj:IsA("BasePart") and not obj:FindFirstChild("EspTag") then
                    local bill = Instance.new("BillboardGui", obj); bill.Name = "EspTag"; bill.Size = UDim2.new(0, 100, 0, 50)
                    local label = Instance.new("TextLabel", bill); label.Size = UDim2.new(1,0,1,0); label.Text = name; label.TextColor3 = color
                elseif not _G[name.."ESP"] and obj:FindFirstChild("EspTag") then obj.EspTag:Destroy() end
            end
        end)
    end)
end
addESP("Player", "HumanoidRootPart", Color3.new(1, 0, 0))
addESP("Fruit", "Fruit", Color3.new(0, 1, 0))
addESP("Seed", "Seed", Color3.new(1, 1, 0))

-- Konten Teleport
local tpPage = pages["Teleport"]
local dropdownBtn = Instance.new("TextButton", tpPage); dropdownBtn.Size = UDim2.new(1, -10, 0, 35); dropdownBtn.Text = "Pilih Lokasi ▼"; dropdownBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 120)
local listFrame = Instance.new("ScrollingFrame", dropdownBtn); listFrame.Size = UDim2.new(1, 0, 0, 150); listFrame.Position = UDim2.new(0, 0, 1, 0); listFrame.Visible = false
dropdownBtn.MouseButton1Click:Connect(function() listFrame.Visible = not listFrame.Visible end)
local locs = {["Seed"] = Vector3.new(265.64, 146.56, -147.83), ["Gears"] = Vector3.new(243.08, 146.56, -144.90), ["Props"] = Vector3.new(237.62, 146.56, -123.65), ["Sell"] = Vector3.new(271.91, 146.56, -125.33), ["Guilds"] = Vector3.new(255.86, 146.56, -113.30)}
for name, pos in pairs(locs) do
    local btn = Instance.new("TextButton", listFrame); btn.Size = UDim2.new(1, 0, 0, 30); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(150, 50, 150); btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function() if player.Character then player.Character.HumanoidRootPart.CFrame = CFrame.new(pos) end end)
end

iconButton.MouseButton1Click:Connect(function() menuFrame.Visible = not menuFrame.Visible end)
