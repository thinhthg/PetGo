local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "SlashMenu"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui
gui.Enabled = true

local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 220, 0, 600)
f.Position = UDim2.new(0.3,0,0.3,0)
f.BackgroundColor3 = Color3.fromRGB(40,40,40)
f.Active = true
f.Draggable = true
f.Visible = true

local minimizeButton = Instance.new("TextButton", f)
minimizeButton.Size = UDim2.new(0,30,0,30)
minimizeButton.Position = UDim2.new(1,-35,0,5)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255,255,255)

local targetLabel = Instance.new("TextLabel", f)
targetLabel.Size = UDim2.new(1,-10,0,30)
targetLabel.Position = UDim2.new(0,5,0,35)
targetLabel.Text = "Chưa chọn ai"
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(255,255,255)

local toggleBtn = Instance.new("TextButton", f)
toggleBtn.Size = UDim2.new(1,-10,0,40)
toggleBtn.Position = UDim2.new(0,5,1,-45)
toggleBtn.Text = "OFF Slash"
toggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)

local circleBtn = Instance.new("TextButton", gui)
circleBtn.Size = UDim2.new(0,50,0,50)
circleBtn.Position = UDim2.new(0,10,0.5,-25)
circleBtn.Text = ">"
circleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
circleBtn.Visible = false
circleBtn.Active = true
circleBtn.Draggable = true

local selectedTarget = nil
local slashing = false

local function doSlash(target)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SlapHand") then
        local args = {"slash", target.Character, Vector3.new(0,0,0)}
        LocalPlayer.Character.SlapHand.Event:FireServer(unpack(args))
    end
end

local indivList = Instance.new("ScrollingFrame", f)
indivList.Size = UDim2.new(1,-10,0,180)
indivList.Position = UDim2.new(0,5,0,70)
indivList.ScrollBarThickness = 6
indivList.AutomaticCanvasSize = Enum.AutomaticSize.Y
indivList.ClipsDescendants = true
local layout = Instance.new("UIListLayout", indivList)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

local searchBox = Instance.new("TextBox", f)
searchBox.Size = UDim2.new(1,-10,0,30)
searchBox.Position = UDim2.new(0,5,0,255)
searchBox.PlaceholderText = "Tìm player..."
searchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)

local resetBtn = Instance.new("TextButton", f)
resetBtn.Size = UDim2.new(1,-10,0,30)
resetBtn.Position = UDim2.new(0,5,0,290)
resetBtn.Text = "Reset danh sách"
resetBtn.BackgroundColor3 = Color3.fromRGB(100,60,60)
resetBtn.TextColor3 = Color3.fromRGB(255,255,255)

local function updatePlayers()
    indivList:ClearAllChildren()
    local noneBtn = Instance.new("TextButton", indivList)
    noneBtn.Size = UDim2.new(1,-10,0,30)
    noneBtn.Text = "None"
    noneBtn.BackgroundColor3 = Color3.fromRGB(100,50,50)
    noneBtn.TextColor3 = Color3.fromRGB(255,255,255)
    noneBtn.MouseButton1Click:Connect(function()
        selectedTarget = nil
        targetLabel.Text = "Chưa chọn ai"
    end)
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if searchBox.Text == "" or string.find(p.Name:lower(), searchBox.Text:lower()) then
                local btn = Instance.new("TextButton", indivList)
                btn.Size = UDim2.new(1,-10,0,30)
                btn.Text = p.Name
                btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.MouseButton1Click:Connect(function()
                    selectedTarget = p
                    targetLabel.Text = "Đã chọn: "..p.Name
                end)
            end
        end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayers)
resetBtn.MouseButton1Click:Connect(updatePlayers)
Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

toggleBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then
        targetLabel.Text = "Chưa chọn ai!"
        return
    end
    slashing = not slashing
    toggleBtn.Text = slashing and "ON Slash" or "OFF Slash"
    if slashing then
        task.spawn(function()
            while slashing and selectedTarget do
                doSlash(selectedTarget)
                task.wait(0.1)
            end
        end)
    end
end)

minimizeButton.MouseButton1Click:Connect(function()
    f.Visible = false
    circleBtn.Visible = true
end)

circleBtn.MouseButton1Click:Connect(function()
    f.Visible = true
    circleBtn.Visible = false
end)
