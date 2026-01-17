local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Frame.Position = UDim2.new(0.4, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Active = true
Frame.Draggable = true

UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 10)

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Gift Auto Farm"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16

UICorner2.Parent = ToggleButton
UICorner2.CornerRadius = UDim.new(0, 8)

StatusLabel.Parent = Frame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Total: 0"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14

if not getgenv().KeremDaddy then
    getgenv().KeremDaddy = true
end

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local v1 = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")
local v3 = 0
local v5 = false
local collecting = false
local platform

local function CreateInvisiblePlatform()
    if platform then pcall(function() platform:Destroy() end) end
    platform = Instance.new("Part")
    platform.Name = "FloorBypass"
    platform.Size = Vector3.new(8, 0.2, 8)
    platform.Transparency = 1
    platform.Anchored = true
    platform.CanCollide = true
    platform.Material = Enum.Material.SmoothPlastic
    platform.Parent = workspace
end

local function UpdatePlatform(pos)
    if not platform then CreateInvisiblePlatform() end
    platform.CFrame = CFrame.new(pos.X, pos.Y - 3.2, pos.Z)
end

local antiDetectConnection
local function StartAntiDetect()
    if antiDetectConnection then antiDetectConnection:Disconnect() end
    antiDetectConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().KeremDaddy then return end
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end)
end

local function StopAntiDetect()
    if antiDetectConnection then 
        antiDetectConnection:Disconnect() 
        antiDetectConnection = nil
    end
    pcall(function()
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end)
end

local function SmoothWalk(targetPos, speed)
    if collecting then return false end
    collecting = true
    
    local startPos = hrp.Position
    local distance = (targetPos - startPos).Magnitude
    
    if distance > 250 then
        collecting = false
        return false
    end
    
    speed = speed or math.random(12, 18)
    local duration = distance / speed
    
    StartAntiDetect()
    
    local startTime = tick()
    local lastUpdate = 0
    
    while tick() - startTime < duration do
        if not getgenv().KeremDaddy then break end
        
        local elapsed = tick() - startTime
        local progress = elapsed / duration
        progress = math.sin(progress * math.pi * 0.5)
        
        local currentPos = startPos:Lerp(targetPos, progress)
        
        local wobble = Vector3.new(
            math.sin(elapsed * 2) * 0.3,
            math.sin(elapsed * 3) * 0.2,
            math.cos(elapsed * 2) * 0.3
        )
        
        hrp.CFrame = CFrame.new(currentPos + wobble)
        UpdatePlatform(currentPos)
        
        if tick() - lastUpdate > 0.1 then
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            lastUpdate = tick()
        end
        
        RunService.Heartbeat:Wait()
    end
    
    hrp.CFrame = CFrame.new(targetPos)
    UpdatePlatform(targetPos)
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    
    task.wait(math.random(5, 15) / 100)
    StopAntiDetect()
    collecting = false
    return true
end

local function v9(v14)
    if getgenv().Webhook and getgenv().Webhook ~= "" then
        pcall(function()
            request({
                Url = getgenv().Webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = game:GetService("HttpService"):JSONEncode(v14)
            })
        end)
    end
end

v1.PromptShown:Connect(function(v13)
    if getgenv().KeremDaddy then
        task.wait(math.random(8, 20) / 100)
        pcall(function()
            fireproximityprompt(v13, 10)
        end)
    end
end)

workspace.Effects.ChildRemoved:Connect(function(v16)
    if v16.Name == "Present" and getgenv().KeremDaddy then
        v3 = v3 + 1
        StatusLabel.Text = "Total: " .. v3
        local v23 = {
            content = "",
            embeds = {{
                title = "Grand Piece Online",
                description = "Gift Wrapped",
                type = "rich",
                color = tonumber(47103),
                fields = {{name = "Total Wrapped Gift:", value = tostring(v3), inline = false}},
                footer = {icon_url = "", text = "Farm (" .. os.date("%X") .. ")"}
            }}
        }
        v9(v23)
    end
end)

workspace.Effects.ChildAdded:Connect(function(v17)
    if not getgenv().KeremDaddy or v5 then return end
    
    task.wait(math.random(10, 25) / 100)
    
    if v17.Name == "ChristmasGift" and v17:FindFirstChild("Highlight") and v17.Highlight.FillColor ~= Color3.fromRGB(109, 0, 0) then
        v5 = true
        task.spawn(function()
            while v17.Parent and v17.Parent == workspace.Effects and getgenv().KeremDaddy do
                pcall(function()
                    local giftPos = v17.Top.TopMiddle.Position
                    SmoothWalk(giftPos, math.random(10, 14))
                end)
                
                task.wait(math.random(12, 20) / 10)
                
                for _, v35 in pairs(workspace.Effects:GetChildren()) do
                    if v35.Name == "Present" and not collecting then
                        local dist = (hrp.Position - v35.Position).Magnitude
                        if dist <= 65 then
                            if v35:FindFirstChild("ProximityPrompt") and v35.ProximityPrompt.Enabled then
                                pcall(function()
                                    SmoothWalk(v35.Position, math.random(14, 20))
                                    task.wait(math.random(10, 25) / 100)
                                    fireproximityprompt(v35.ProximityPrompt)
                                end)
                            end
                        end
                        task.wait(math.random(30, 60) / 100)
                    end
                end
                task.wait(math.random(15, 25) / 10)
            end
            v5 = false
        end)
    end
end)

local lastCheck = 0
local function MainLoop()
    while getgenv().KeremDaddy do
        task.wait(math.random(80, 150) / 100)
        
        if collecting or v5 then continue end
        
        local currentTime = tick()
        if currentTime - lastCheck >= math.random(50, 80) / 10 then
            lastCheck = currentTime
            
            pcall(function()
                local santa = workspace.NPCs["Santa's Sleigh"]
                if santa and santa:FindFirstChild("Deer") then
                    local santaPos = santa.Deer["Body.006"].Position
                    local offsetX = math.random(-30, 30)
                    local offsetY = math.random(-5, 5)
                    local offsetZ = math.random(-30, 30)
                    local targetPos = santaPos + Vector3.new(offsetX, offsetY, offsetZ)
                    SmoothWalk(targetPos, math.random(8, 12))
                end
            end)
        end
        
        for _, v21 in pairs(workspace.Effects:GetChildren()) do
            if v21.Name == "Present" and not collecting then
                local dist = (hrp.Position - v21.Position).Magnitude
                if dist <= 55 and dist > 8 then
                    if v21:FindFirstChild("ProximityPrompt") and v21.ProximityPrompt.Enabled then
                        pcall(function()
                            SmoothWalk(v21.Position, math.random(15, 22))
                            task.wait(math.random(8, 18) / 100)
                        end)
                    end
                end
                task.wait(math.random(40, 80) / 100)
            end
        end
    end
end

task.spawn(MainLoop)

ToggleButton.MouseButton1Click:Connect(function()
    getgenv().KeremDaddy = not getgenv().KeremDaddy
    
    if getgenv().KeremDaddy then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        CreateInvisiblePlatform()
        task.spawn(MainLoop)
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        StopAntiDetect()
        if platform then 
            pcall(function() platform:Destroy() end)
            platform = nil 
        end
    end
end)

CreateInvisiblePlatform()
