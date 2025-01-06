-- Tạo GUI cơ bản
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ToggleEggsRollButton = Instance.new("TextButton")
local ToggleAttack8Button = Instance.new("TextButton")
local ToggleAttack2Button = Instance.new("TextButton")
local ToggleAttack1Button = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")

-- Thuộc tính GUI
ScreenGui.Parent = game:GetService("CoreGui")  -- Đảm bảo GUI hiển thị trên CoreGui (Roblox Studio)

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.Active = true
MainFrame.Draggable = true -- Cho phép kéo thả menu

TitleLabel.Parent = MainFrame
TitleLabel.Text = "BF Trade Scam"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSans
TitleLabel.TextSize = 18

ToggleEggsRollButton.Parent = MainFrame
ToggleEggsRollButton.Text = "Eggs Roll: OFF"
ToggleEggsRollButton.Size = UDim2.new(1, -20, 0, 30)
ToggleEggsRollButton.Position = UDim2.new(0, 10, 0, 40)
ToggleEggsRollButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleEggsRollButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleEggsRollButton.Font = Enum.Font.SourceSans
ToggleEggsRollButton.TextSize = 16

ToggleAttack8Button.Parent = MainFrame
ToggleAttack8Button.Text = "Attack 8: OFF"
ToggleAttack8Button.Size = UDim2.new(1, -20, 0, 30)
ToggleAttack8Button.Position = UDim2.new(0, 10, 0, 75)
ToggleAttack8Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleAttack8Button.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAttack8Button.Font = Enum.Font.SourceSans
ToggleAttack8Button.TextSize = 16

ToggleAttack2Button.Parent = MainFrame
ToggleAttack2Button.Text = "Attack 2: OFF"
ToggleAttack2Button.Size = UDim2.new(1, -20, 0, 30)
ToggleAttack2Button.Position = UDim2.new(0, 10, 0, 110)
ToggleAttack2Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleAttack2Button.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAttack2Button.Font = Enum.Font.SourceSans
ToggleAttack2Button.TextSize = 16

ToggleAttack1Button.Parent = MainFrame
ToggleAttack1Button.Text = "Attack 1: OFF"
ToggleAttack1Button.Size = UDim2.new(1, -20, 0, 30)
ToggleAttack1Button.Position = UDim2.new(0, 10, 0, 145)
ToggleAttack1Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleAttack1Button.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAttack1Button.Font = Enum.Font.SourceSans
ToggleAttack1Button.TextSize = 16

ToggleButton.Parent = MainFrame
ToggleButton.Text = "▼"
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -40, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.TextSize = 18

-- Chức năng thu gọn/mở rộng menu
local isCollapsed = false
ToggleButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        MainFrame.Size = UDim2.new(0, 200, 0, 30)  -- Thu gọn chỉ còn tiêu đề
        ToggleButton.Text = "▲"
        -- Ẩn các chức năng
        ToggleEggsRollButton.Visible = false
        ToggleAttack8Button.Visible = false
        ToggleAttack2Button.Visible = false
        ToggleAttack1Button.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 200, 0, 150)  -- Mở rộng để hiển thị tất cả chức năng
        ToggleButton.Text = "▼"
        -- Hiển thị lại các chức năng
        ToggleEggsRollButton.Visible = true
        ToggleAttack8Button.Visible = true
        ToggleAttack2Button.Visible = true
        ToggleAttack1Button.Visible = true
    end
end)

-- Các biến trạng thái
local eggsRollActive = false
local attack8Active = false
local attack2Active = false
local attack1Active = false

-- Vòng lặp để thực thi các chức năng
local function startLoop()
    while task.wait() do
        if eggsRollActive then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_Roll"):InvokeServer()
            end)
            wait(1) -- Tạm dừng 1 giây
        end

        if attack8Active then
            local args = { [1] = 8 }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mining_Attack"):InvokeServer(unpack(args))
            end)
            wait(0.1) -- Tạm dừng ngắn
        end

        if attack2Active then
            local args = { [1] = 2 }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mining_Attack"):InvokeServer(unpack(args))
            end)
            wait(2) -- Tạm dừng trước vòng lặp tiếp theo
        end

        if attack1Active then
            local args = { [1] = 1 }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mining_Attack"):InvokeServer(unpack(args))
            end)
            wait(3) -- Tạm dừng trước vòng lặp tiếp theo
        end
    end
end

-- Sự kiện cho các nút
ToggleEggsRollButton.MouseButton1Click:Connect(function()
    eggsRollActive = not eggsRollActive
    ToggleEggsRollButton.Text = eggsRollActive and "Eggs Roll: ON" or "Eggs Roll: OFF"
end)

ToggleAttack8Button.MouseButton1Click:Connect(function()
    attack8Active = not attack8Active
    ToggleAttack8Button.Text = attack8Active and "Attack 8: ON" or "Attack 8: OFF"
end)

ToggleAttack2Button.MouseButton1Click:Connect(function()
    attack2Active = not attack2Active
    ToggleAttack2Button.Text = attack2Active and "Attack 2: ON" or "Attack 2: OFF"
end)

ToggleAttack1Button.MouseButton1Click:Connect(function()
    attack1Active = not attack1Active
    ToggleAttack1Button.Text = attack1Active and "Attack 1: ON" or "Attack 1: OFF"
end)

-- Bắt đầu vòng lặp
spawn(startLoop)
