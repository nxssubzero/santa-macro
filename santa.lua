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

local v0 = Instance.new("VirtualInputManager")
local v1 = game:GetService("ProximityPromptService")
local v2 = false
local v3 = 0
local v5 = false
local v6 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
local v7 = true
local v8 = workspace.CurrentCamera
local v11

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
                footer = {icon_url = "", text = "KEREM THE KING (" .. os.date("%X") .. ")"}
            }}
        }
        v9(v23)
    end
end)

workspace.Effects.ChildAdded:Connect(function(v17)
    if not getgenv().KeremDaddy then return end
    task.wait(0.1)
    if v17.Name == "ChristmasGift" and v17:FindFirstChild("Highlight") and v17.Highlight.FillColor ~= Color3.fromRGB(109, 0, 0) then
        if v5 then return end
        v5 = true
        task.spawn(function()
            while v17.Parent and v17.Parent == workspace.Effects and getgenv().KeremDaddy do
                if v11 then pcall(function() v11:Disconnect() end) end
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid:MoveTo(v17.Top.TopMiddle.Position)
                end)
                v11 = game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Connect(function()
                    for _, v35 in pairs(workspace.Effects:GetChildren()) do
                        if v35.Name == "Present" then
                            local v38 = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v35.Position).Magnitude
                            if v38 <= 50 then
                                if v35:FindFirstChild("ProximityPrompt") and v35.ProximityPrompt.Enabled then
                                    pcall(function()
                                        fireproximityprompt(v35.ProximityPrompt)
                                    end)
                                end
                            end
                            task.wait(0.35)
                        end
                    end
                end)
                task.wait(1)
            end
            v5 = false
        end)
    end
end)

local function MainLoop()
    while getgenv().KeremDaddy do
        task.wait()
        if v5 then continue end
        
        pcall(function()
            local v4 = workspace.NPCs["Santa's Sleigh"].Deer["Body.006"]
            local v18 = v8.CFrame.Position
            v8.CFrame = CFrame.lookAt(v18, v4.Position)
        end)
        
        if v7 and not v2 then
            task.wait(1)
            v2 = true
            task.spawn(function()
                v7 = false
                v0:SendKeyEvent(true, Enum.KeyCode.X, false, game)
                task.delay(13, function()
                    v0:SendKeyEvent(false, Enum.KeyCode.X, false, game)
                    task.wait(1)
                    
                    for _, v21 in pairs(workspace.Effects:GetChildren()) do
                        if v21.Name == "Present" then
                            local v26 = (v6 - v21.Position).Magnitude
                            if v26 <= 30 then
                                if v21:FindFirstChild("ProximityPrompt") and v21.ProximityPrompt.Enabled then
                                    pcall(function()
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v21.CFrame
                                    end)
                                end
                            end
                            task.wait(0.5)
                        end
                    end
                    
                    pcall(function()
                        game.Players.LocalPlayer.Character.Humanoid:MoveTo(v6)
                    end)
                    
                    local v32 = game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Connect(function()
                        v7 = true
                        pcall(function() v32:Disconnect() end)
                    end)
                    
                    task.delay(19, function()
                        v2 = false
                        pcall(function() v32:Disconnect() end)
                    end)
                end)
            end)
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
    end
end)
