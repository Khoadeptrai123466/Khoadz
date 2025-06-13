local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hrp = player.Character:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "GoldCollectorUI"
gui.ResetOnSpawn = false

-- Khung chính chứa nút (có thể kéo được)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 110)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true -- 🔥 Cho phép kéo bằng chuột hoặc tay (trên mobile)

-- Nút Auto Collect
local collectBtn = Instance.new("TextButton", frame)
collectBtn.Size = UDim2.new(1, -20, 0, 40)
collectBtn.Position = UDim2.new(0, 10, 0, 10)
collectBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
collectBtn.TextColor3 = Color3.new(1, 1, 1)
collectBtn.Text = "🪙 Auto Collect: OFF"
collectBtn.Font = Enum.Font.SourceSansBold
collectBtn.TextSize = 16
collectBtn.BorderSizePixel = 0

-- Nút Teleport
local teleportBtn = Instance.new("TextButton", frame)
teleportBtn.Size = UDim2.new(1, -20, 0, 40)
teleportBtn.Position = UDim2.new(0, 10, 0, 60)
teleportBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Text = "🚤 Về thuyền"
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 16
teleportBtn.BorderSizePixel = 0

-- Logic Auto Collect
local autoCollect = false
local MAX_DISTANCE = 1000

local function startCollect()
    task.spawn(function()
        while autoCollect do
            for _, part in ipairs(workspace:GetDescendants()) do
                if not autoCollect then break end
                if part:IsA("Part") and part.Name == "Gold" then
                    local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        local distance = (hrp.Position - part.Position).Magnitude
                        if distance <= MAX_DISTANCE then
                            if distance < 10 then
                                prompt.HoldDuration = 0
                            end
                            hrp.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.1)
                            fireproximityprompt(prompt)
                            task.wait(0.2)
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

collectBtn.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    collectBtn.Text = autoCollect and "🪙 Auto Collect: ON ✅" or "🪙 Auto Collect: OFF ❌"
    if autoCollect then
        startCollect()
    end
end)

teleportBtn.MouseButton1Click:Connect(function()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("Part") and part.Name == "BoatOrigin" then
            hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
            break
        end
    end
end)
