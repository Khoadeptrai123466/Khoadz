-- ✅ Auto Gold + Teleport + Fast ProximityPrompt (Full Mobile GUI)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hrp = player.Character or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")

local autoCollect = false
local autoTeleport = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GoldAutoGui"
gui.ResetOnSpawn = false
if syn and syn.protect_gui then
    syn.protect_gui(gui)
    gui.Parent = game:GetService("CoreGui")
elseif gethui then
    gui.Parent = gethui()
else
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- Nút Auto Collect
local collectBtn = Instance.new("TextButton")
collectBtn.Size = UDim2.new(0, 160, 0, 40)
collectBtn.Position = UDim2.new(0, 20, 0, 60)
collectBtn.Text = "🪙 Auto Collect: OFF"
collectBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
collectBtn.TextColor3 = Color3.new(1,1,1)
collectBtn.Font = Enum.Font.SourceSansBold
collectBtn.TextSize = 18
collectBtn.Parent = gui

-- Nút Auto Teleport
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0, 160, 0, 40)
teleportBtn.Position = UDim2.new(0, 20, 0, 110)
teleportBtn.Text = "🚤 Auto Teleport: OFF"
teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
teleportBtn.TextColor3 = Color3.new(1,1,1)
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 18
teleportBtn.Parent = gui

-- Nút Fast Prompt
local fastPromptBtn = Instance.new("TextButton")
fastPromptBtn.Size = UDim2.new(0, 160, 0, 40)
fastPromptBtn.Position = UDim2.new(0, 20, 0, 160)
fastPromptBtn.Text = "⚡ Fast Prompt: ON ✅"
fastPromptBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
fastPromptBtn.TextColor3 = Color3.new(1,1,1)
fastPromptBtn.Font = Enum.Font.SourceSansBold
fastPromptBtn.TextSize = 18
fastPromptBtn.Parent = gui

-- Cập nhật giao diện
local function updateButtons()
    collectBtn.Text = "🪙 Auto Collect: " .. (autoCollect and "ON ✅" or "OFF ❌")
    collectBtn.BackgroundColor3 = autoCollect and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)

    teleportBtn.Text = "🚤 Auto Teleport: " .. (autoTeleport and "ON ✅" or "OFF ❌")
    teleportBtn.BackgroundColor3 = autoTeleport and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end

updateButtons()

-- ⚡ Fast Prompt function
local function applyFastPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = 1000
    end
end

-- Áp dụng fast prompt cho tất cả prompt hiện có
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("ProximityPrompt") then
        applyFastPrompt(v)
    end
end

-- Khi có prompt mới tạo ra
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        applyFastPrompt(obj)
    end
end)

-- 🪙 Auto Collect
local function startCollect()
    task.spawn(function()
        while autoCollect do
            for _, part in ipairs(workspace:GetDescendants()) do
                if not autoCollect then return end
                if part:IsA("Part") and part.Name == "Gold" then
                    local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        hrp.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.1)
                        fireproximityprompt(prompt)
                        task.wait(0.2)
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

-- 🚤 Auto Teleport
local function startTeleport()
    task.spawn(function()
        while autoTeleport do
            for _, part in ipairs(workspace:GetDescendants()) do
                if not autoTeleport then return end
                if part:IsA("Part") and part.Name == "BoatOrigin" then
                    hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                    break
                end
            end
            task.wait(2)
        end
    end)
end

-- Sự kiện nút
collectBtn.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    updateButtons()
    if autoCollect then startCollect() end
end)

teleportBtn.MouseButton1Click:Connect(function()
    autoTeleport = not autoTeleport
    updateButtons()
    if autoTeleport then startTeleport() end
end)
