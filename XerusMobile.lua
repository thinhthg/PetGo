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

local allHeader=Instance.new("TextButton",f)
allHeader.Size=UDim2.new(1,-10,0,30)
allHeader.Position=UDim2.new(0,5,0,340)
allHeader.Text="- All Player"
allHeader.BackgroundColor3=Color3.fromRGB(80,80,80)
allHeader.TextColor3=Color3.fromRGB(255,255,255)

local searchAll=Instance.new("TextBox",f)
searchAll.Size=UDim2.new(1,-10,0,30)
searchAll.Position=UDim2.new(0,5,0,375)
searchAll.PlaceholderText="Tìm player All..."
searchAll.BackgroundColor3=Color3.fromRGB(60,60,60)
searchAll.TextColor3=Color3.fromRGB(255,255,255)

local resetAll=Instance.new("TextButton",f)
resetAll.Size=UDim2.new(1,-10,0,30)
resetAll.Position=UDim2.new(0,5,0,410)
resetAll.Text="Reset All"
resetAll.BackgroundColor3=Color3.fromRGB(100,60,60)
resetAll.TextColor3=Color3.fromRGB(255,255,255)

local allList=Instance.new("ScrollingFrame",f)
allList.Size=UDim2.new(1,-10,0,150)
allList.Position=UDim2.new(0,5,0,445)
allList.ScrollBarThickness=6
allList.ClipsDescendants=true
local allLayout=Instance.new("UIListLayout",allList)
allLayout.SortOrder=Enum.SortOrder.LayoutOrder
allLayout.Padding=UDim.new(0,5)

local selectedTarget=nil
local selectedAll={}
local slashing=false
local allSlashing=false

local function doSlash(target)
    if L.Character and L.Character:FindFirstChild("SlapHand") and target.Character then
        pcall(function()
            L.Character.SlapHand.Event:FireServer({"slash",target.Character,Vector3.new(-3.960314,0,0.562060)})
        end)
    end
end

local function updateIndividualList()
    indivList:ClearAllChildren()
    local noneBtn=Instance.new("TextButton",indivList)
    noneBtn.Size=UDim2.new(1,-10,0,30)
    noneBtn.Text="None"
    noneBtn.BackgroundColor3=Color3.fromRGB(100,50,50)
    noneBtn.TextColor3=Color3.fromRGB(255,255,255)
    noneBtn.MouseButton1Click:Connect(function() selectedTarget=nil targetLabel.Text="Chưa chọn ai" end)
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

local function updateAllList()
    allList:ClearAllChildren()
    for _,p in ipairs(P:GetPlayers()) do
        if p~=L then
            if searchAll.Text=="" or string.find(p.Name:lower(),searchAll.Text:lower()) then
                local btn=Instance.new("TextButton",allList)
                btn.Size=UDim2.new(1,-10,0,30)
                btn.Text=p.Name
                btn.BackgroundColor3=Color3.fromRGB(70,70,70)
                btn.TextColor3=Color3.fromRGB(255,255,255)
                btn.AutoButtonColor=true
                btn.MouseButton1Click:Connect(function()
                    if selectedAll[p] then
                        selectedAll[p]=nil
                        btn.BackgroundColor3=Color3.fromRGB(70,70,70)
                    else
                        selectedAll[p]=true
                        btn.BackgroundColor3=Color3.fromRGB(100,100,100)
                    end
                end)
            end
        end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(updateIndividualList)
resetBtn.MouseButton1Click:Connect(updateIndividualList)
searchAll:GetPropertyChangedSignal("Text"):Connect(updateAllList)
resetAll.MouseButton1Click:Connect(function()
    selectedAll={}
    updateAllList()
end)
P.PlayerAdded:Connect(function() updateIndividualList() updateAllList() end)
P.PlayerRemoving:Connect(function() updateIndividualList() updateAllList() end)
updateIndividualList()
updateAllList()

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

local allSlashBtn=Instance.new("TextButton",f)
allSlashBtn.Size=UDim2.new(1,-10,0,40)
allSlashBtn.Position=UDim2.new(0,5,1,-90)
allSlashBtn.Text="OFF Slash All"
allSlashBtn.BackgroundColor3=Color3.fromRGB(80,80,80)
allSlashBtn.TextColor3=Color3.fromRGB(255,255,255)
allSlashBtn.MouseButton1Click:Connect(function()
    allSlashing=not allSlashing
    allSlashBtn.Text=allSlashing and "ON Slash All" or "OFF Slash All"
    if allSlashing then
        task.spawn(function()
            while allSlashing and L.Character do
                for p,_ in pairs(selectedAll) do
                    if p and p.Character then
                        doSlash(p)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

local indivOriginalSize=f.Size.Y.Offset
local indivCollapsed=false
indivHeader.MouseButton1Click:Connect(function()
    indivCollapsed=not indivCollapsed
    searchBox.Visible=not indivCollapsed
    resetBtn.Visible=not indivCollapsed
    indivList.Visible=not indivCollapsed
    if indivCollapsed then
        f.Size=UDim2.new(f.Size.X.Scale,f.Size.X.Offset,0,400)
    else
        f.Size=UDim2.new(f.Size.X.Scale,f.Size.X.Offset,0,700)
    end
    indivHeader.Text=(indivCollapsed and "+" or "-").." Cá nhân"
end)

local allCollapsed=false
allHeader.MouseButton1Click:Connect(function()
    allCollapsed=not allCollapsed
    searchAll.Visible=not allCollapsed
    resetAll.Visible=not allCollapsed
    allList.Visible=not allCollapsed
    if allCollapsed then
        f.Size=UDim2.new(f.Size.X.Scale,f.Size.X.Offset,0,500)
    else
        f.Size=UDim2.new(f.Size.X.Scale,f.Size.X.Offset,0,700)
    end
    allHeader.Text=(allCollapsed and "+" or "-").." All Player"
end)

L.Character:WaitForChild("Humanoid").Died:Connect(function()
    slashing=false
    allSlashing=false
    slashBtn.Text="OFF Slash"
    allSlashBtn.Text="OFF Slash All"
end)
