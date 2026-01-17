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
local v3 = 0
local v5 = false
local collecting = false

local oldPos = hrp.CFrame
local oldVelocity = Vector3.new(0, 0, 0)

local platform
local function CreatePlatform()
    if platform then platform:Destroy() end
    platform = Instance.new("Part")
    platform.Size = Vector3.new(10, 0.5, 10)
    platform.Transparency = 1
    platform.Anchored = true
    platform.CanCollide = true
    platform.Parent = workspace
end

local function MovePlatform(pos)
    if not platform then CreatePlatform() end
    platform.CFrame = CFrame.new(pos.X, pos.Y - 3.5, pos.Z)
end

local function BypassMove(targetCFrame, duration)
    if collecting then return end
    collecting = true
    
    duration = duration or math.random(15, 25) / 10
    
    local startCFrame = hrp.CFrame
    local distance = (targetCFrame.Position - startCFrame.Position).Magnitude
    
    if distance > 200 then
        collecting = false
        return
    end
    
    local RunService = game:GetService("RunService")
    local connection
    
    connection = RunService.Heartbeat:Connect(function()
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    local startTime = tick()
    while tick() - startTime < duration do
        if not getgenv().KeremDaddy then break end
        
        local elapsed = tick() - startTime
        local alpha = elapsed / duration
        alpha = alpha * alpha * (3 - 2 * alpha)
        
        local newCFrame = startCFrame:Lerp(targetCFrame, alpha)
        
        hrp.CFrame = newCFrame
        MovePlatform(newCFrame.Position)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        
        task.wait()
    end
    
    hrp.CFrame = targetCFrame
    MovePlatform(targetCFrame.Position)
    
    connection:Disconnect()
    task.wait(0.1)
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end
    
    collecting = false
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
        task.wait(math.random(10, 30) / 100)
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
                footer = {icon_url = "", text = "(" .. os.date("%X") .. ")"}
            }}
        }
        v9(v23)
    end
end)

workspace.Effects.ChildAdded:Connect(function(v17)
    if not getgenv().KeremDaddy or v5 then return end
    
    task.wait(math.random(15, 35) / 100)
    
    if v17.Name == "ChristmasGift" and v17:FindFirstChild("Highlight") and v17.Highlight.FillColor ~= Color3.fromRGB(109, 0, 0) then
        v5 = true
        task.spawn(function()
            while v17.Parent and v17.Parent == workspace.Effects and getgenv().KeremDaddy do
                pcall(function()
                    local giftPos = v17.Top.TopMiddle.CFrame
                    BypassMove(giftPos, math.random(15, 25) / 10)
                end)
                
                task.wait(math.random(10, 20) / 10)
                
                for _, v35 in pairs(workspace.Effects:GetChildren()) do
                    if v35.Name == "Present" and not collecting then
                        local dist = (hrp.Position - v35.Position).Magnitude
                        if dist <= 60 then
                            if v35:FindFirstChild("ProximityPrompt") and v35.ProximityPrompt.Enabled then
                                pcall(function()
                                    BypassMove(v35.CFrame, math.random(10, 20) / 10)
                                    task.wait(math.random(20, 40) / 100)
                                    fireproximityprompt(v35.ProximityPrompt)
                                end)
                            end
                        end
                        task.wait(math.random(40, 70) / 100)
                    end
                end
                task.wait(1.5)
            end
            v5 = false
        end)
    end
end)

local lastCheck = 0
local function MainLoop()
    while getgenv().KeremDaddy do
        task.wait(math.random(50, 150) / 100)
        
        if collecting or v5 then continue end
        
        local currentTime = tick()
        if currentTime - lastCheck >= math.random(40, 70) / 10 then
            lastCheck = currentTime
            
            pcall(function()
                local santa = workspace.NPCs["Santa's Sleigh"]
                if santa and santa:FindFirstChild("Deer") then
                    local santaPos = santa.Deer["Body.006"].CFrame
                    local offset = CFrame.new(
                        math.random(-25, 25),
                        math.random(-8, 8),
                        math.random(-25, 25)
                    )
                    BypassMove(santaPos * offset, math.random(20, 35) / 10)
                end
            end)
        end
        
        for _, v21 in pairs(workspace.Effects:GetChildren()) do
            if v21.Name == "Present" and not collecting then
                local dist = (hrp.Position - v21.Position).Magnitude
                if dist <= 50 and dist > 5 then
                    if v21:FindFirstChild("ProximityPrompt") and v21.ProximityPrompt.Enabled then
                        pcall(function()
                            BypassMove(v21.CFrame, math.random(20, 40) / 10)
                            task.wait(math.random(15, 35) / 100)
                        end)
                    end
                end
                task.wait(math.random(50, 100) / 100)
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
        task.spawn(MainLoop)
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        if platform then platform:Destroy() platform = nil end
    end
end)
