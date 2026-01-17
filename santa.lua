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

local v1 = game:GetService("ProximityPromptService")
local v3 = 0
local collecting = false

task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().KeremDaddy and game.Players.LocalPlayer.Character then
            pcall(function()
                local args = {
                    [1] = "Sky Walk2",
                    [2] = {
                        ["char"] = game.Players.LocalPlayer.Character,
                        ["cf"] = hrp.CFrame
                    }
                }
                game:GetService("ReplicatedStorage").Events.Skill:InvokeServer(unpack(args))
            end)
        end
    end
end)

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
        task.wait(0.1)
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
    if not getgenv().KeremDaddy or collecting then return end
    
    task.wait(0.2)
    
    if v17.Name == "ChristmasGift" and v17:FindFirstChild("Highlight") and v17.Highlight.FillColor ~= Color3.fromRGB(109, 0, 0) then
        collecting = true
        task.spawn(function()
            while v17.Parent and v17.Parent == workspace.Effects and getgenv().KeremDaddy do
                pcall(function()
                    hrp.CFrame = v17.Top.TopMiddle.CFrame
                end)
                
                task.wait(1)
                
                for _, v35 in pairs(workspace.Effects:GetChildren()) do
                    if v35.Name == "Present" then
                        local dist = (hrp.Position - v35.Position).Magnitude
                        if dist <= 60 then
                            if v35:FindFirstChild("ProximityPrompt") and v35.ProximityPrompt.Enabled then
                                pcall(function()
                                    hrp.CFrame = v35.CFrame
                                    task.wait(0.1)
                                    fireproximityprompt(v35.ProximityPrompt)
                                end)
                            end
                        end
                        task.wait(0.3)
                    end
                end
                task.wait(1)
            end
            collecting = false
        end)
    end
end)

task.spawn(function()
    while getgenv().KeremDaddy do
        task.wait(5)
        
        if collecting then continue end
        
        pcall(function()
            local santa = workspace.NPCs["Santa's Sleigh"]
            if santa and santa:FindFirstChild("Deer") then
                local santaPos = santa.Deer["Body.006"].CFrame
                hrp.CFrame = santaPos * CFrame.new(math.random(-20, 20), math.random(-5, 5), math.random(-20, 20))
            end
        end)
        
        for _, v21 in pairs(workspace.Effects:GetChildren()) do
            if v21.Name == "Present" and not collecting then
                local dist = (hrp.Position - v21.Position).Magnitude
                if dist <= 50 then
                    if v21:FindFirstChild("ProximityPrompt") and v21.ProximityPrompt.Enabled then
                        pcall(function()
                            hrp.CFrame = v21.CFrame
                            task.wait(0.1)
                        end)
                    end
                end
                task.wait(0.5)
            end
        end
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    getgenv().KeremDaddy = not getgenv().KeremDaddy
    
    if getgenv().KeremDaddy then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    end
end)
