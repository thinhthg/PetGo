local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 400)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.Text = "-"

local targetLabel = Instance.new("TextLabel", frame)
targetLabel.Size = UDim2.new(1, -10, 0, 30)
targetLabel.Position = UDim2.new(0, 5, 0, 35)
targetLabel.Text = "Chưa chọn ai"
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(255,255,255)

local searchBox = Instance.new("TextBox", frame)
searchBox.Size = UDim2.new(1, -10, 0, 30)
searchBox.Position = UDim2.new(0, 5, 0, 70)
searchBox.PlaceholderText = "Tìm player..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)

local resetButton = Instance.new("TextButton", frame)
resetButton.Size = UDim2.new(1, -10, 0, 30)
resetButton.Position = UDim2.new(0, 5, 0, 110)
resetButton.Text = "Reset danh sách"
resetButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
resetButton.TextColor3 = Color3.fromRGB(255,255,255)

local list = Instance.new("ScrollingFrame", frame)
list.Size = UDim2.new(1, -10, 0, 180)
list.Position = UDim2.new(0, 5, 0, 150)
list.ScrollBarThickness = 6
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.ClipsDescendants = true

local layout = Instance.new("UIListLayout", list)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(1, -10, 0, 40)
toggleButton.Position = UDim2.new(0, 5, 1, -45)
toggleButton.Text = "OFF Slash"
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)

local selectedTarget = nil
local slashing = false

local function doSlash(target)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SlapHand") then
        local args = {
            "slash",
            target.Character,
            Vector3.new(0,0,0)
        }
        LocalPlayer.Character.SlapHand.Event:FireServer(unpack(args))
    end
end

local function updatePlayers()
    list:ClearAllChildren()

    local noneBtn = Instance.new("TextButton", list)
    noneBtn.Size = UDim2.new(1, -10, 0, 30)
    noneBtn.Text = "None"
    noneBtn.BackgroundColor3 = Color3.fromRGB(100,50,50)
    noneBtn.TextColor3 = Color3.fromRGB(255,255,255)
    noneBtn.MouseButton1Click:Connect(function()
        selectedTarget = nil
        targetLabel.Text = "Chưa chọn ai"
    end)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if searchBox.Text == "" or string.find(p.Name:lower(), searchBox.Text:lower()) then
                local btn = Instance.new("TextButton", list)
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Text = p.Name
                btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.MouseButton1Click:Connect(function()
                    selectedTarget = p
                    targetLabel.Text = "Đã chọn: " .. p.Name
                end)
            end
        end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayers)
resetButton.MouseButton1Click:Connect(updatePlayers)
Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

toggleButton.MouseButton1Click:Connect(function()
    if not selectedTarget then
        targetLabel.Text = "Chưa chọn ai!"
        return
    end
    slashing = not slashing
    toggleButton.Text = slashing and "ON Slash" or "OFF Slash"
    if slashing then
        task.spawn(function()
            while slashing and selectedTarget do
                doSlash(selectedTarget)
                task.wait(0.1)
            end
        end)
    end
end)

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        frame.Size = UDim2.new(0, 220, 0, 400)
        minimizeButton.Text = "-"
    else
        frame.Size = UDim2.new(0, 60, 0, 60)
        minimizeButton.Text = "+"
    end
    minimized = not minimized
end)
