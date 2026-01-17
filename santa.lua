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
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
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

getgenv().FarmActive = false
local giftCount = 0
local isMoving = false

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local function GetChar()
    return player.Character
end

local function GetHRP()
    local char = GetChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function SendWebhook(count)
    if not getgenv().Webhook or getgenv().Webhook == "" then return end
    pcall(function()
        local data = {
            embeds = {{
                title = "Gift Collected",
                description = "Total gifts: " .. count,
                color = 3066993,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
            }}
        }
        request({
            Url = getgenv().Webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)
end

local skyWalkLoop
local function StartSkyWalk()
    if skyWalkLoop then return end
    skyWalkLoop = task.spawn(function()
        while getgenv().FarmActive do
            task.wait(0.8)
            pcall(function()
                local char = GetChar()
                local hrp = GetHRP()
                if char and hrp then
                    local args = {
                        [1] = "Sky Walk2",
                        [2] = {
                            ["char"] = char,
                            ["cf"] = hrp.CFrame
                        }
                    }
                    game:GetService("ReplicatedStorage").Events.Skill:InvokeServer(unpack(args))
                end
            end)
        end
    end)
end

local function StopSkyWalk()
    if skyWalkLoop then
        task.cancel(skyWalkLoop)
        skyWalkLoop = nil
    end
end

ProximityPromptService.PromptShown:Connect(function(prompt)
    if getgenv().FarmActive then
        task.wait(0.05)
        pcall(function()
            fireproximityprompt(prompt)
        end)
    end
end)

workspace.Effects.ChildRemoved:Connect(function(child)
    if child.Name == "Present" and getgenv().FarmActive then
        giftCount = giftCount + 1
        StatusLabel.Text = "Total: " .. giftCount
        SendWebhook(giftCount)
    end
end)

local function TeleportTo(cframe)
    local hrp = GetHRP()
    if not hrp then return false end
    hrp.CFrame = cframe
    return true
end

workspace.Effects.ChildAdded:Connect(function(gift)
    if not getgenv().FarmActive or isMoving then return end
    
    task.wait(0.1)
    
    if gift.Name == "ChristmasGift" and gift:FindFirstChild("Highlight") then
        if gift.Highlight.FillColor == Color3.fromRGB(109, 0, 0) then return end
        
        isMoving = true
        task.spawn(function()
            while gift.Parent == workspace.Effects and getgenv().FarmActive do
                pcall(function()
                    if gift:FindFirstChild("Top") and gift.Top:FindFirstChild("TopMiddle") then
                        TeleportTo(gift.Top.TopMiddle.CFrame)
                    end
                end)
                
                task.wait(0.5)
                
                for _, present in pairs(workspace.Effects:GetChildren()) do
                    if present.Name == "Present" then
                        local hrp = GetHRP()
                        if hrp then
                            local distance = (hrp.Position - present.Position).Magnitude
                            if distance <= 50 then
                                if present:FindFirstChild("ProximityPrompt") and present.ProximityPrompt.Enabled then
                                    TeleportTo(present.CFrame)
                                    task.wait(0.1)
                                end
                            end
                        end
                        task.wait(0.2)
                    end
                end
                
                task.wait(0.5)
            end
            isMoving = false
        end)
    end
end)

local mainLoop
local function StartMainLoop()
    if mainLoop then return end
    mainLoop = task.spawn(function()
        while getgenv().FarmActive do
            task.wait(3)
            
            if isMoving then continue end
            
            pcall(function()
                local santa = workspace.NPCs:FindFirstChild("Santa's Sleigh")
                if santa and santa:FindFirstChild("Deer") and santa.Deer:FindFirstChild("Body.006") then
                    local santaPos = santa.Deer["Body.006"].Position
                    local offset = Vector3.new(
                        math.random(-25, 25),
                        math.random(-10, 10),
                        math.random(-25, 25)
                    )
                    TeleportTo(CFrame.new(santaPos + offset))
                end
            end)
            
            task.wait(1)
            
            for _, present in pairs(workspace.Effects:GetChildren()) do
                if present.Name == "Present" and not isMoving then
                    local hrp = GetHRP()
                    if hrp then
                        local distance = (hrp.Position - present.Position).Magnitude
                        if distance <= 40 and distance > 5 then
                            if present:FindFirstChild("ProximityPrompt") and present.ProximityPrompt.Enabled then
                                TeleportTo(present.CFrame)
                                task.wait(0.1)
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end
        end
    end)
end

local function StopMainLoop()
    if mainLoop then
        task.cancel(mainLoop)
        mainLoop = nil
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    getgenv().FarmActive = not getgenv().FarmActive
    
    if getgenv().FarmActive then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        StartSkyWalk()
        StartMainLoop()
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        StopSkyWalk()
        StopMainLoop()
    end
end)
