local P=game:GetService("Players")
local L=P.LocalPlayer
local gui=Instance.new("ScreenGui",L:WaitForChild("PlayerGui"))
local f=Instance.new("Frame",gui)
f.Size=UDim2.new(0,220,0,700)
f.Position=UDim2.new(0.3,0,0.2,0)
f.BackgroundColor3=Color3.fromRGB(40,40,40)
f.Active=true
f.Draggable=true

local circleBtn=Instance.new("TextButton",gui)
circleBtn.Size=UDim2.new(0,50,0,50)
circleBtn.Position=UDim2.new(0,10,0.5,-25)
circleBtn.Text=">"
circleBtn.BackgroundColor3=Color3.fromRGB(100,100,100)
circleBtn.Visible=false
circleBtn.Active=true
circleBtn.Draggable=true

local minBtn=Instance.new("TextButton",f)
minBtn.Size=UDim2.new(0,30,0,30)
minBtn.Position=UDim2.new(1,-35,0,5)
minBtn.Text="-"
minBtn.MouseButton1Click:Connect(function() f.Visible=false circleBtn.Visible=true end)
circleBtn.MouseButton1Click:Connect(function() f.Visible=true circleBtn.Visible=false end)

local targetLabel=Instance.new("TextLabel",f)
targetLabel.Size=UDim2.new(1,-10,0,30)
targetLabel.Position=UDim2.new(0,5,0,35)
targetLabel.Text="Chưa chọn ai"
targetLabel.BackgroundTransparency=1
targetLabel.TextColor3=Color3.fromRGB(255,255,255)

-- Cá nhân
local indivHeader=Instance.new("TextButton",f)
indivHeader.Size=UDim2.new(1,-10,0,30)
indivHeader.Position=UDim2.new(0,5,0,70)
indivHeader.Text="- Cá nhân"
indivHeader.BackgroundColor3=Color3.fromRGB(80,80,80)
indivHeader.TextColor3=Color3.fromRGB(255,255,255)

local searchBox=Instance.new("TextBox",f)
searchBox.Size=UDim2.new(1,-10,0,30)
searchBox.Position=UDim2.new(0,5,0,105)
searchBox.PlaceholderText="Tìm player cá nhân..."
searchBox.BackgroundColor3=Color3.fromRGB(60,60,60)
searchBox.TextColor3=Color3.fromRGB(255,255,255)

local resetBtn=Instance.new("TextButton",f)
resetBtn.Size=UDim2.new(1,-10,0,30)
resetBtn.Position=UDim2.new(0,5,0,140)
resetBtn.Text="Reset danh sách"
resetBtn.BackgroundColor3=Color3.fromRGB(100,60,60)
resetBtn.TextColor3=Color3.fromRGB(255,255,255)

local indivList=Instance.new("ScrollingFrame",f)
indivList.Size=UDim2.new(1,-10,0,150)
indivList.Position=UDim2.new(0,5,0,175)
indivList.ScrollBarThickness=6
indivList.ClipsDescendants=true
local indivLayout=Instance.new("UIListLayout",indivList)
indivLayout.SortOrder=Enum.SortOrder.LayoutOrder
indivLayout.Padding=UDim.new(0,5)

local selectedTarget=nil
local slashing=false

local function doSlash(target)
    if L.Character and L.Character:FindFirstChild("SlapHand") then
        L.Character.SlapHand.Event:FireServer({"slash",target.Character,Vector3.new(0,0,0)})
    end
end

local function updateIndividualList()
    indivList:ClearAllChildren()
    local noneBtn=Instance.new("TextButton",indivList)
    noneBtn.Size=UDim2.new(1,-10,0,30)
    noneBtn.Text="None"
    noneBtn.BackgroundColor3=Color3.fromRGB(100,50,50)
    noneBtn.TextColor3=Color3.fromRGB(255,255,255)
    noneBtn.MouseButton1Click:Connect(function()
        selectedTarget=nil
        targetLabel.Text="Chưa chọn ai"
    end)
    for _,p in ipairs(P:GetPlayers()) do
        if p~=L and (searchBox.Text=="" or string.find(p.Name:lower(),searchBox.Text:lower())) then
            local btn=Instance.new("TextButton",indivList)
            btn.Size=UDim2.new(1,-10,0,30)
            btn.Text=p.Name
            btn.BackgroundColor3=Color3.fromRGB(70,70,70)
            btn.TextColor3=Color3.fromRGB(255,255,255)
            btn.MouseButton1Click:Connect(function()
                selectedTarget=p
                targetLabel.Text="Đã chọn: "..p.Name
            end)
        end
    end
end
searchBox:GetPropertyChangedSignal("Text"):Connect(updateIndividualList)
resetBtn.MouseButton1Click:Connect(updateIndividualList)
P.PlayerAdded:Connect(updateIndividualList)
P.PlayerRemoving:Connect(updateIndividualList)
updateIndividualList()

local slashBtn=Instance.new("TextButton",f)
slashBtn.Size=UDim2.new(1,-10,0,40)
slashBtn.Position=UDim2.new(0,5,1,-45)
slashBtn.Text="OFF Slash"
slashBtn.BackgroundColor3=Color3.fromRGB(80,80,80)
slashBtn.TextColor3=Color3.fromRGB(255,255,255)
slashBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then targetLabel.Text="Chưa chọn ai!" return end
    slashing=not slashing
    slashBtn.Text=slashing and "ON Slash" or "OFF Slash"
    if slashing then
        task.spawn(function()
            while slashing and selectedTarget and L.Character do
                doSlash(selectedTarget)
                task.wait(0.1)
            end
        end)
    end
end)

local indivCollapsed=false
indivHeader.MouseButton1Click:Connect(function()
    indivCollapsed=not indivCollapsed
    searchBox.Visible=not indivCollapsed
    resetBtn.Visible=not indivCollapsed
    indivList.Visible=not indivCollapsed
    indivHeader.Text=(indivCollapsed and "+" or "-").." Cá nhân"
end)

-- All loại trừ
local allHeader=Instance.new("TextButton",f)
allHeader.Size=UDim2.new(1,-10,0,30)
allHeader.Position=UDim2.new(0,5,0,330)
allHeader.Text="- All Player"
allHeader.BackgroundColor3=Color3.fromRGB(80,80,80)
allHeader.TextColor3=Color3.fromRGB(255,255,255)

local allSearchBox=Instance.new("TextBox",f)
allSearchBox.Size=UDim2.new(1,-10,0,30)
allSearchBox.Position=UDim2.new(0,5,0,365)
allSearchBox.PlaceholderText="Tìm player loại trừ..."
allSearchBox.BackgroundColor3=Color3.fromRGB(60,60,60)
allSearchBox.TextColor3=Color3.fromRGB(255,255,255)

local allResetBtn=Instance.new("TextButton",f)
allResetBtn.Size=UDim2.new(1,-10,0,30)
allResetBtn.Position=UDim2.new(0,5,0,400)
allResetBtn.Text="Reset All"
allResetBtn.BackgroundColor3=Color3.fromRGB(100,60,60)
allResetBtn.TextColor3=Color3.fromRGB(255,255,255)

local allList=Instance.new("ScrollingFrame",f)
allList.Size=UDim2.new(1,-10,0,150)
allList.Position=UDim2.new(0,5,0,435)
allList.ScrollBarThickness=6
allList.ClipsDescendants=true
local allLayout=Instance.new("UIListLayout",allList)
allLayout.SortOrder=Enum.SortOrder.LayoutOrder
allLayout.Padding=UDim.new(0,5)

local excluded={}
local slashingAll=false

local function updateAllList()
    allList:ClearAllChildren()
    local noneBtn=Instance.new("TextButton",allList)
    noneBtn.Size=UDim2.new(1,-10,0,30)
    noneBtn.Text="None"
    noneBtn.BackgroundColor3=Color3.fromRGB(100,50,50)
    noneBtn.TextColor3=Color3.fromRGB(255,255,255)
    noneBtn.MouseButton1Click:Connect(function()
        excluded={}
        updateAllList()
    end)
    for _,p in ipairs(P:GetPlayers()) do
        if p~=L and (allSearchBox.Text=="" or string.find(p.Name:lower(),allSearchBox.Text:lower())) then
            local btn=Instance.new("TextButton",allList)
            btn.Size=UDim2.new(1,-10,0,30)
            btn.Text=p.Name
            btn.BackgroundColor3=excluded[p] and Color3.fromRGB(100,50,50) or Color3.fromRGB(70,70,70)
            btn.TextColor3=Color3.fromRGB(255,255,255)
            btn.MouseButton1Click:Connect(function()
                if excluded[p] then excluded[p]=nil else excluded[p]=true end
                updateAllList()
            end)
        end
    end
end
allSearchBox:GetPropertyChangedSignal("Text"):Connect(updateAllList)
allResetBtn.MouseButton1Click:Connect(updateAllList)
P.PlayerAdded:Connect(updateAllList)
P.PlayerRemoving:Connect(updateAllList)
updateAllList()

local slashAllBtn=Instance.new("TextButton",f)
slashAllBtn.Size=UDim2.new(1,-10,0,40)
slashAllBtn.Position=UDim2.new(0,5,0,600)
slashAllBtn.Text="OFF Slash All"
slashAllBtn.BackgroundColor3=Color3.fromRGB(80,80,80)
slashAllBtn.TextColor3=Color3.fromRGB(255,255,255)
slashAllBtn.MouseButton1Click:Connect(function()
    slashingAll=not slashingAll
    slashAllBtn.Text=slashingAll and "ON Slash All" or "OFF Slash All"
    if slashingAll then
        task.spawn(function()
            while slashingAll and L.Character do
                for _,p in ipairs(P:GetPlayers()) do
                    if p~=L and not excluded[p] then
                        doSlash(p)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

local allCollapsed=false
allHeader.MouseButton1Click:Connect(function()
    allCollapsed=not allCollapsed
    allSearchBox.Visible=not allCollapsed
    allResetBtn.Visible=not allCollapsed
    allList.Visible=not allCollapsed
    allHeader.Text=(allCollapsed and "+" or "-").." All Player"
end)

L.Character:WaitForChild("Humanoid").Died:Connect(function()
    slashing=false
    slashingAll=false
    slashBtn.Text="OFF Slash"
    slashAllBtn.Text="OFF Slash All"
end)
