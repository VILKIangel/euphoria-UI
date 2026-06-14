-- EUPHORIA UI - ПРОСТАЯ РАБОЧАЯ ВЕРСИЯ
local Library = {}

function Library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EuphoriaUI"
    screenGui.Parent = game.CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Заголовок
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Euphoria"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Контейнер для кнопок (ПРОСТОЙ, БЕЗ СЛОЖНОСТЕЙ)
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -20, 1, -60)
    buttonContainer.Position = UDim2.new(0, 10, 0, 50)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = mainFrame
    
    local uiList = Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0, 10)
    uiList.Parent = buttonContainer
    
    local tabs = {}
    local currentTabContent = nil
    
    function tabs:AddTab(tabName)
        -- Создаём контейнер для контента вкладки
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = buttonContainer
        
        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 10)
        contentList.Parent = tabContent
        
        local elements = {}
        
        -- КНОПКА (ГАРАНТИРОВАННО РАБОТАЕТ)
        function elements:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 45)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 16
            btn.Font = Enum.Font.GothamMedium
            btn.BorderSizePixel = 0
            btn.Parent = tabContent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(callback)
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(80, 80, 105)
            end)
            btn.MouseLeave:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            end)
            
            return btn
        end
        
        -- ПОЛЗУНОК
        function elements:AddSlider(name, min, max, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 60)
            container.BackgroundTransparency = 1
            container.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 25)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. tostring(default)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.GothamMedium
            label.Parent = container
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, 0, 0, 6)
            sliderBg.Position = UDim2.new(0, 0, 0, 35)
            sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = container
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(1, 0)
            sliderCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            
            local value = default
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local x = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * x
                    sliderFill.Size = UDim2.new(x, 0, 1, 0)
                    label.Text = name .. ": " .. math.floor(value * 100) / 100
                    if callback then callback(value) end
                end
            end)
        end
        
        -- ЧЕКБОКС
        function elements:AddCheckbox(name, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 35)
            container.BackgroundTransparency = 1
            container.Parent = tabContent
            
            local checkBox = Instance.new("TextButton")
            checkBox.Size = UDim2.new(0, 20, 0, 20)
            checkBox.Position = UDim2.new(0, 0, 0, 5)
            checkBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            checkBox.Text = default and "✓" or ""
            checkBox.TextColor3 = Color3.fromRGB(255, 255, 255)
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
            label.Text = name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.GothamMedium
            label.Parent = container
            
            local checked = default
            
            checkBox.MouseButton1Click:Connect(function()
                checked = not checked
                checkBox.Text = checked and "✓" or ""
                checkBox.BackgroundColor3 = checked and Color3.fromRGB(255, 100, 150) or Color3.fromRGB(60, 60, 80)
                if callback then callback(checked) end
            end)
        end
        
        -- Кнопка вкладки
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 100, 0, 35)
        tabBtn.Position = UDim2.new(0, 10, 0, 10)
        tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextSize = 14
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = mainFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn
        
        local function selectTab()
            if currentTabContent then
                currentTabContent.Visible = false
            end
            tabContent.Visible = true
            currentTabContent = tabContent
            
            -- Обновляем позиции кнопок вкладок
            local x = 10
            for _, child in pairs(mainFrame:GetChildren()) do
                if child:IsA("TextButton") and child ~= closeBtn and child ~= tabBtn then
                    child.Position = UDim2.new(0, x, 0, 10)
                    x = x + 110
                end
            end
            tabBtn.Position = UDim2.new(0, x, 0, 10)
        end
        
        tabBtn.MouseButton1Click:Connect(selectTab)
        
        if currentTabContent == nil then
            selectTab()
        end
        
        return elements
    end
    
    return tabs
end

return Library
