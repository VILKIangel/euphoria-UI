-- Euphoria UI Library for Roblox
-- Modern, scalable, draggable, resizable GUI

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuration
local Config = {
    Theme = {
        Background = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(255, 100, 150),
        AccentDark = Color3.fromRGB(200, 70, 120),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 195),
        Border = Color3.fromRGB(45, 45, 60),
        Button = Color3.fromRGB(55, 55, 75),
        ButtonHover = Color3.fromRGB(70, 70, 95),
        TabInactive = Color3.fromRGB(40, 40, 55),
        TabActive = Color3.fromRGB(255, 100, 150),
        SliderBg = Color3.fromRGB(45, 45, 60),
        InputBg = Color3.fromRGB(35, 35, 50)
    },
    Rounding = 8,
    AnimationSpeed = 0.2
}

-- Utility: Tween
local function Tween(obj, properties, style)
    local tween = TweenService:Create(obj, TweenInfo.new(Config.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- Create a draggable frame
local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            frame.Position = newPos
        end
    end)
end

-- Create resizable handles
local function MakeResizable(frame)
    local resizeSize = 8
    local corners = {"BottomRight"}
    
    for _, corner in pairs(corners) do
        local handle = Instance.new("Frame")
        handle.Size = UDim2.new(0, resizeSize, 0, resizeSize)
        handle.BackgroundColor3 = Config.Theme.Accent
        handle.BorderSizePixel = 0
        handle.AnchorPoint = Vector2.new(1, 1)
        handle.Position = UDim2.new(1, -2, 1, -2)
        handle.Parent = frame
        
        local dragging = false
        local startMousePos, startSize
        
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                startMousePos = input.Position
                startSize = frame.AbsoluteSize
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - startMousePos
                local newWidth = math.clamp(startSize.X + delta.X, 400, 900)
                local newHeight = math.clamp(startSize.Y + delta.Y, 300, 700)
                frame.Size = UDim2.new(0, newWidth, 0, newHeight)
            end
        end)
    end
end

-- Main Window
function Library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EuphoriaUI"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    mainFrame.BackgroundColor3 = Config.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Shadow
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.6
    shadow.BorderSizePixel = 0
    shadow.Parent = mainFrame
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Config.Rounding)
    corner.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, Config.Rounding)
    shadowCorner.Parent = shadow
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Config.Theme.Accent
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, Config.Rounding)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Euphoria"
    titleLabel.TextColor3 = Config.Theme.Text
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Parent = titleBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Config.Theme.Text
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 150, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = Config.Theme.Background
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.Parent = tabContainer
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -160, 1, -50)
    contentContainer.Position = UDim2.new(0, 160, 0, 45)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame
    
    -- Make window draggable and resizable
    MakeDraggable(mainFrame, titleBar)
    MakeResizable(mainFrame)
    
    local tabs = {}
    local currentTab = nil
    
    -- Tab creation
    function tabs:AddTab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -20, 0, 40)
        tabBtn.Position = UDim2.new(0, 10, 0, 0)
        tabBtn.BackgroundColor3 = Config.Theme.TabInactive
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Config.Theme.TextSecondary
        tabBtn.TextSize = 14
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.BorderSizePixel = 0
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabContainer
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, Config.Rounding)
        btnCorner.Parent = tabBtn
        
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentContainer
        
        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 12)
        contentList.Parent = tabContent
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.Parent = tabContent
        
        local elements = {}
        
        -- Button
        function elements:AddButton(btnText, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = Config.Theme.Button
            btn.Text = btnText
            btn.TextColor3 = Config.Theme.Text
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamMedium
            btn.BorderSizePixel = 0
            btn.Parent = tabContent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, Config.Rounding)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(callback)
            
            btn.MouseEnter:Connect(function()
                Tween(btn, {BackgroundColor3 = Config.Theme.ButtonHover})
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, {BackgroundColor3 = Config.Theme.Button})
            end)
        end
        
        -- Slider
        function elements:AddSlider(sliderName, min, max, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 60)
            container.BackgroundTransparency = 1
            container.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = sliderName .. ": " .. tostring(default)
            label.TextColor3 = Config.Theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.GothamMedium
            label.Parent = container
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, 0, 0, 6)
            sliderBg.Position = UDim2.new(0, 0, 0, 30)
            sliderBg.BackgroundColor3 = Config.Theme.SliderBg
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = container
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(1, 0)
            sliderCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Config.Theme.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sliderFill
            
            local value = default
            local dragging = false
            
            local function update(input)
                local x = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                value = min + (max - min) * x
                value = math.floor(value * 100) / 100
                sliderFill.Size = UDim2.new(x, 0, 1, 0)
                label.Text = sliderName .. ": " .. tostring(value)
                if callback then callback(value) end
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end
        
        -- Checkbox
        function elements:AddCheckbox(checkboxName, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 35)
            container.BackgroundTransparency = 1
            container.Parent = tabContent
            
            local checkBox = Instance.new("TextButton")
            checkBox.Size = UDim2.new(0, 20, 0, 20)
            checkBox.Position = UDim2.new(0, 0, 0, 5)
            checkBox.BackgroundColor3 = Config.Theme.Button
            checkBox.Text = default and "✓" or ""
            checkBox.TextColor3 = Config.Theme.Text
            checkBox.TextSize = 14
            checkBox.BorderSizePixel = 0
            checkBox.Parent = container
            
            local checkCorner = Instance.new("UICorner")
            checkCorner.CornerRadius = UDim.new(0, 4)
            checkCorner.Parent = checkBox
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -30, 1, 0)
            label.Position = UDim2.new(0, 30, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = checkboxName
            label.TextColor3 = Config.Theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.GothamMedium
            label.Parent = container
            
            local checked = default
            
            checkBox.MouseButton1Click:Connect(function()
                checked = not checked
                checkBox.Text = checked and "✓" or ""
                Tween(checkBox, {BackgroundColor3 = checked and Config.Theme.Accent or Config.Theme.Button})
                if callback then callback(checked) end
            end)
            
            if default then
                Tween(checkBox, {BackgroundColor3 = Config.Theme.Accent})
            end
        end
        
        -- TextBox
        function elements:AddTextBox(boxName, placeholder, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 65)
            container.BackgroundTransparency = 1
            container.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = boxName
            label.TextColor3 = Config.Theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.GothamMedium
            label.Parent = container
            
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 35)
            box.Position = UDim2.new(0, 0, 0, 25)
            box.BackgroundColor3 = Config.Theme.InputBg
            box.PlaceholderText = placeholder
            box.Text = ""
            box.TextColor3 = Config.Theme.Text
            box.PlaceholderColor3 = Config.Theme.TextSecondary
            box.TextSize = 14
            box.Font = Enum.Font.GothamMedium
            box.BorderSizePixel = 0
            box.Parent = container
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, Config.Rounding)
            boxCorner.Parent = box
            
            box.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    if callback then callback(box.Text) end
                end
            end)
        end
        
        -- Switch tab
        tabBtn.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
                currentTabBtn.BackgroundColor3 = Config.Theme.TabInactive
                currentTabBtn.TextColor3 = Config.Theme.TextSecondary
            end
            tabContent.Visible = true
            tabBtn.BackgroundColor3 = Config.Theme.TabActive
            tabBtn.TextColor3 = Config.Theme.Text
            currentTab = tabContent
            currentTabBtn = tabBtn
        end)
        
        if #tabs == 0 then
            tabBtn.MouseButton1Click:Fire()
        end
        
        return elements
    end
    
    return tabs
end

return Library
