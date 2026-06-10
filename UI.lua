-- ============================================
-- EUPHORIA UI LIBRARY v1.0
-- ============================================

local Euphoria = {}
Euphoria.Version = "1.0"

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Настройки анимаций
local TweenFast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenMedium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenSlow = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Цветовая схема
Euphoria.Colors = {
    Primary = Color3.fromRGB(180, 130, 255),      -- Фиолетовый акцент
    PrimaryDark = Color3.fromRGB(140, 90, 220),
    Background = Color3.fromRGB(15, 15, 20),
    Surface = Color3.fromRGB(25, 25, 35),
    SurfaceHover = Color3.fromRGB(35, 35, 48),
    Border = Color3.fromRGB(45, 45, 55),
    TextPrimary = Color3.fromRGB(235, 235, 245),
    TextSecondary = Color3.fromRGB(160, 165, 175),
    TextDisabled = Color3.fromRGB(80, 85, 95),
    Success = Color3.fromRGB(80, 200, 120),
    Error = Color3.fromRGB(230, 70, 70),
    Warning = Color3.fromRGB(250, 180, 60),
}

-- Вспомогательные функции
local function CreateCorner(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = frame
    return corner
end

local function CreateStroke(frame, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Euphoria.Colors.Border
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    return stroke
end

local function Tween(obj, props, time, callback)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    if callback then tween.Completed:Connect(callback) end
    return tween
end

-- Хранилище для биндов
Euphoria.Binds = {}
Euphoria.Keybinds = {}

-- ============================================
-- ГЛАВНОЕ ОКНО
-- ============================================
function Euphoria:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "Euphoria"
    local windowSize = options.Size or UDim2.new(0, 800, 0, 600)
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "EuphoriaUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.6
    overlay.BorderSizePixel = 0
    overlay.Parent = gui
    
    local window = Instance.new("Frame")
    window.Size = windowSize
    window.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    window.BackgroundColor3 = Euphoria.Colors.Background
    window.BackgroundTransparency = 0.05
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.Parent = gui
    CreateCorner(window, 12)
    CreateStroke(window, Euphoria.Colors.Primary, 1)
    
    -- Анимация появления
    window.BackgroundTransparency = 1
    window.Size = UDim2.new(0, windowSize.X.Offset + 50, 0, windowSize.Y.Offset + 50)
    window.Position = UDim2.new(0.5, -(windowSize.X.Offset + 50)/2, 0.5, -(windowSize.Y.Offset + 50)/2)
    Tween(window, {BackgroundTransparency = 0.05, Size = windowSize, Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)}, 0.35)
    
    -- Заголовок
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 48)
    titleBar.BackgroundColor3 = Euphoria.Colors.Surface
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window
    CreateCorner(titleBar, 12)
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 32, 0, 32)
    icon.Position = UDim2.new(0, 12, 0.5, -16)
    icon.BackgroundTransparency = 1
    icon.Text = "✨"
    icon.TextSize = 20
    icon.Font = Enum.Font.GothamBold
    icon.TextColor3 = Euphoria.Colors.Primary
    icon.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 52, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = windowName
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Euphoria.Colors.TextPrimary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 36, 1, 0)
    minimizeBtn.Position = UDim2.new(1, -72, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "─"
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.Gotham
    minimizeBtn.TextColor3 = Euphoria.Colors.TextSecondary
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 36, 1, 0)
    closeBtn.Position = UDim2.new(1, -36, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextColor3 = Euphoria.Colors.TextSecondary
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = Euphoria.Colors.Primary
    accentLine.BorderSizePixel = 0
    accentLine.Parent = titleBar
    
    -- Левая панель (вкладки)
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Size = UDim2.new(0, 200, 1, -48)
    tabsContainer.Position = UDim2.new(0, 0, 0, 48)
    tabsContainer.BackgroundColor3 = Euphoria.Colors.Surface
    tabsContainer.BackgroundTransparency = 0.5
    tabsContainer.BorderSizePixel = 0
    tabsContainer.Parent = window
    CreateCorner(tabsContainer, 0)
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.Parent = tabsContainer
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.Padding = UDim.new(0, 4)
    tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Правая панель (контент)
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -210, 1, -58)
    contentContainer.Position = UDim2.new(0, 210, 0, 58)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, 0)
    scrollFrame.Position = UDim2.new(0, 10, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Euphoria.Colors.Border
    scrollFrame.Parent = contentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = scrollFrame
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 12)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Перетаскивание окна
    local dragging = false
    local dragStart = nil
    local windowStart = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            windowStart = window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(0, windowStart.X.Offset + delta.X, 0, windowStart.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Сворачивание
    local minimized = false
    local originalSize = windowSize
    
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(window, {Size = UDim2.new(0, originalSize.X.Offset, 0, 48), Position = UDim2.new(0, window.Position.X.Offset, 0, window.Position.Y.Offset)}, 0.25)
            Tween(contentContainer, {BackgroundTransparency = 1}, 0.2)
            Tween(tabsContainer, {BackgroundTransparency = 1}, 0.2)
            task.delay(0.2, function()
                contentContainer.Visible = false
                tabsContainer.Visible = false
            end)
        else
            contentContainer.Visible = true
            tabsContainer.Visible = true
            Tween(contentContainer, {BackgroundTransparency = 0}, 0.2)
            Tween(tabsContainer, {BackgroundTransparency = 0.5}, 0.2)
            Tween(window, {Size = originalSize}, 0.25)
        end
    end)
    
    -- Закрытие
    closeBtn.MouseButton1Click:Connect(function()
        Tween(window, {BackgroundTransparency = 1, Size = UDim2.new(0, originalSize.X.Offset + 50, 0, originalSize.Y.Offset + 50), Position = UDim2.new(0.5, -(originalSize.X.Offset + 50)/2, 0.5, -(originalSize.Y.Offset + 50)/2)}, 0.3, function()
            gui:Destroy()
        end)
        Tween(overlay, {BackgroundTransparency = 1}, 0.3)
    end)
    
    -- Система вкладок
    local tabs = {}
    local activeTab = nil
    
    local function CreateTab(tabName, tabIcon)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0.9, 0, 0, 44)
        tabButton.BackgroundColor3 = Euphoria.Colors.Surface
        tabButton.BackgroundTransparency = 0.8
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabsContainer
        CreateCorner(tabButton, 8)
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 32, 1, 0)
        iconLabel.Position = UDim2.new(0, 8, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = tabIcon or "📁"
        iconLabel.TextSize = 18
        iconLabel.TextColor3 = Euphoria.Colors.TextSecondary
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = tabButton
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -48, 1, 0)
        nameLabel.Position = UDim2.new(0, 48, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = tabName
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextColor3 = Euphoria.Colors.TextSecondary
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = tabButton
        
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 3, 0, 24)
        indicator.Position = UDim2.new(0, 0, 0.5, -12)
        indicator.BackgroundColor3 = Euphoria.Colors.Primary
        indicator.BackgroundTransparency = 1
        indicator.BorderSizePixel = 0
        indicator.Parent = tabButton
        CreateCorner(indicator, 2)
        
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Visible = false
        tabContent.Parent = scrollFrame
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Parent = tabContent
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 12)
        
        tabButton.MouseButton1Click:Connect(function()
            if activeTab then
                Tween(activeTab.indicator, {BackgroundTransparency = 1}, 0.15)
                Tween(activeTab.button, {BackgroundTransparency = 0.8}, 0.15)
                Tween(activeTab.nameLabel, {TextColor3 = Euphoria.Colors.TextSecondary}, 0.15)
                Tween(activeTab.iconLabel, {TextColor3 = Euphoria.Colors.TextSecondary}, 0.15)
                activeTab.content.Visible = false
            end
            
            activeTab = {
                button = tabButton,
                indicator = indicator,
                nameLabel = nameLabel,
                iconLabel = iconLabel,
                content = tabContent,
                layout = tabLayout
            }
            
            Tween(tabButton, {BackgroundTransparency = 0.3}, 0.15)
            Tween(indicator, {BackgroundTransparency = 0}, 0.15)
            Tween(nameLabel, {TextColor3 = Euphoria.Colors.TextPrimary}, 0.15)
            Tween(iconLabel, {TextColor3 = Euphoria.Colors.Primary}, 0.15)
            tabContent.Visible = true
        end)
        
        return tabContent, tabLayout
    end
    
    -- ============================================
    -- КОМПОНЕНТЫ UI
    -- ============================================
    
    -- Секция
    function Euphoria:Section(parent, title)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, -20, 0, 36)
        section.BackgroundColor3 = Euphoria.Colors.Surface
        section.BackgroundTransparency = 0.8
        section.BorderSizePixel = 0
        section.Parent = parent
        CreateCorner(section, 6)
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -16, 1, 0)
        titleLabel.Position = UDim2.new(0, 12, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title:upper()
        titleLabel.TextSize = 11
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextColor3 = Euphoria.Colors.Primary
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = section
        
        return section
    end
    
    -- Кнопка
    function Euphoria:Button(parent, name, icon, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 44)
        button.BackgroundColor3 = Euphoria.Colors.Surface
        button.BackgroundTransparency = 0.8
        button.BorderSizePixel = 0
        button.Text = ""
        button.Parent = parent
        CreateCorner(button, 8)
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 36, 1, 0)
        iconLabel.Position = UDim2.new(0, 8, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon or "🔘"
        iconLabel.TextSize = 18
        iconLabel.TextColor3 = Euphoria.Colors.TextSecondary
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = button
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -56, 1, 0)
        nameLabel.Position = UDim2.new(0, 56, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextColor3 = Euphoria.Colors.TextPrimary
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = button
        
        local hoverColor = Euphoria.Colors.SurfaceHover
        button.MouseEnter:Connect(function()
            Tween(button, {BackgroundColor3 = hoverColor}, 0.15)
            Tween(iconLabel, {TextColor3 = Euphoria.Colors.Primary}, 0.15)
        end)
        button.MouseLeave:Connect(function()
            Tween(button, {BackgroundColor3 = Euphoria.Colors.Surface}, 0.15)
            Tween(iconLabel, {TextColor3 = Euphoria.Colors.TextSecondary}, 0.15)
        end)
        
        button.MouseButton1Click:Connect(function()
            Tween(button, {BackgroundTransparency = 0.5}, 0.05)
            task.delay(0.05, function()
                Tween(button, {BackgroundTransparency = 0.8}, 0.1)
            end)
            if callback then callback() end
        end)
        
        return button
    end
    
    -- Переключатель (Toggle)
    function Euphoria:Toggle(parent, name, icon, defaultValue, callback)
        local value = defaultValue or false
        local toggle = Instance.new("Frame")
        toggle.Size = UDim2.new(1, -20, 0, 50)
        toggle.BackgroundColor3 = Euphoria.Colors.Surface
        toggle.BackgroundTransparency = 0.8
        toggle.BorderSizePixel = 0
        toggle.Parent = parent
        CreateCorner(toggle, 8)
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 36, 1, 0)
        iconLabel.Position = UDim2.new(0, 8, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon or "⚙️"
        iconLabel.TextSize = 18
        iconLabel.TextColor3 = Euphoria.Colors.TextSecondary
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = toggle
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -80, 0, 22)
        nameLabel.Position = UDim2.new(0, 56, 0, 8)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextColor3 = Euphoria.Colors.TextPrimary
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = toggle
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -80, 0, 18)
        descLabel.Position = UDim2.new(0, 56, 0, 30)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = "Вкл/Выкл"
        descLabel.TextSize = 10
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextColor3 = Euphoria.Colors.TextDisabled
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = toggle
        
        local switchBg = Instance.new("Frame")
        switchBg.Size = UDim2.new(0, 44, 0, 22)
        switchBg.Position = UDim2.new(1, -56, 0.5, -11)
        switchBg.BackgroundColor3 = Euphoria.Colors.Border
        switchBg.BorderSizePixel = 0
        switchBg.Parent = toggle
        CreateCorner(switchBg, 11)
        
        local switchKnob = Instance.new("Frame")
        switchKnob.Size = UDim2.new(0, 18, 0, 18)
        switchKnob.Position = UDim2.new(0, 2, 0.5, -9)
        switchKnob.BackgroundColor3 = Euphoria.Colors.TextPrimary
        switchKnob.BorderSizePixel = 0
        switchKnob.Parent = switchBg
        CreateCorner(switchKnob, 9)
        
        local function UpdateSwitch()
            if value then
                Tween(switchBg, {BackgroundColor3 = Euphoria.Colors.Primary}, 0.15)
                Tween(switchKnob, {Position = UDim2.new(1, -20, 0.5, -9)}, 0.15)
            else
                Tween(switchBg, {BackgroundColor3 = Euphoria.Colors.Border}, 0.15)
                Tween(switchKnob, {Position = UDim2.new(0, 2, 0.5, -9)}, 0.15)
            end
        end
        
        UpdateSwitch()
        
        local function SetValue(newValue, silent)
            value = newValue
            UpdateSwitch()
            if not silent and callback then callback(value) end
        end
        
        toggle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                SetValue(not value, false)
            end
        end)
        
        return {
            SetValue = SetValue,
            GetValue = function() return value end
        }
    end
    
    -- Слайдер
    function Euphoria:Slider(parent, name, icon, minVal, maxVal, defaultVal, suffix, callback)
        minVal = minVal or 0
        maxVal = maxVal or 100
        defaultVal = defaultVal or 50
        suffix = suffix or ""
        
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, -20, 0, 72)
        slider.BackgroundColor3 = Euphoria.Colors.Surface
        slider.BackgroundTransparency = 0.8
        slider.BorderSizePixel = 0
        slider.Parent = parent
        CreateCorner(slider, 8)
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 36, 1, 0)
        iconLabel.Position = UDim2.new(0, 8, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon or "🎚️"
        iconLabel.TextSize = 18
        iconLabel.TextColor3 = Euphoria.Colors.TextSecondary
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = slider
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -80, 0, 22)
        nameLabel.Position = UDim2.new(0, 56, 0, 8)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextColor3 = Euphoria.Colors.TextPrimary
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = slider
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 60, 0, 22)
        valueLabel.Position = UDim2.new(1, -68, 0, 8)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(defaultVal) .. suffix
        valueLabel.TextSize = 13
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextColor3 = Euphoria.Colors.Primary
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = slider
        
        local trackBg = Instance.new("Frame")
        trackBg.Size = UDim2.new(1, -56, 0, 4)
        trackBg.Position = UDim2.new(0, 56, 0, 44)
        trackBg.BackgroundColor3 = Euphoria.Colors.Border
        trackBg.BorderSizePixel = 0
        trackBg.Parent = slider
        CreateCorner(trackBg, 2)
        
        local trackFill = Instance.new("Frame")
        trackFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
        trackFill.BackgroundColor3 = Euphoria.Colors.Primary
        trackFill.BorderSizePixel = 0
        trackFill.Parent = trackBg
        CreateCorner(trackFill, 2)
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -8, 0, -6)
        knob.BackgroundColor3 = Euphoria.Colors.TextPrimary
        knob.BorderSizePixel = 0
        knob.Parent = trackBg
        CreateCorner(knob, 8)
        
        local valueNum = defaultVal
        local dragging = false
        
        local function UpdateSlider(inputX)
            local relativeX = math.clamp((inputX - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
            valueNum = math.floor(minVal + (maxVal - minVal) * relativeX)
            trackFill.Size = UDim2.new(relativeX, 0, 1, 0)
            knob.Position = UDim2.new(relativeX, -8, 0, -6)
            valueLabel.Text = tostring(valueNum) .. suffix
            if callback then callback(valueNum) end
        end
        
        trackBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                UpdateSlider(input.Position.X)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                UpdateSlider(input.Position.X)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return {
            SetValue = function(val, silent)
                valueNum = math.clamp(val, minVal, maxVal)
                local relativeX = (valueNum - minVal) / (maxVal - minVal)
                trackFill.Size = UDim2.new(relativeX, 0, 1, 0)
                knob.Position = UDim2.new(relativeX, -8, 0, -6)
                valueLabel.Text = tostring(valueNum) .. suffix
                if not silent and callback then callback(valueNum) end
            end,
            GetValue = function() return valueNum end
        }
    end
    
    -- Бинд (Keybind)
    function Euphoria:Keybind(parent, name, defaultKey, callback)
        local keybind = Instance.new("Frame")
        keybind.Size = UDim2.new(1, -20, 0, 44)
        keybind.BackgroundColor3 = Euphoria.Colors.Surface
        keybind.BackgroundTransparency = 0.8
        keybind.BorderSizePixel = 0
        keybind.Parent = parent
        CreateCorner(keybind, 8)
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 36, 1, 0)
        iconLabel.Position = UDim2.new(0, 8, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = "⌨️"
        iconLabel.TextSize = 18
        iconLabel.TextColor3 = Euphoria.Colors.TextSecondary
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = keybind
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -120, 1, 0)
        nameLabel.Position = UDim2.new(0, 56, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextColor3 = Euphoria.Colors.TextPrimary
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = keybind
        
        local keyBg = Instance.new("Frame")
        keyBg.Size = UDim2.new(0, 80, 0, 28)
        keyBg.Position = UDim2.new(1, -92, 0.5, -14)
        keyBg.BackgroundColor3 = Euphoria.Colors.Background
        keyBg.BorderSizePixel = 0
        keyBg.Parent = keybind
        CreateCorner(keyBg, 6)
        CreateStroke(keyBg, Euphoria.Colors.Border, 1)
        
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Size = UDim2.new(1, 0, 1, 0)
        keyLabel.BackgroundTransparency = 1
        keyLabel.Text = tostring(defaultKey):gsub("Enum.KeyCode.", "")
        keyLabel.TextSize = 12
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.TextColor3 = Euphoria.Colors.Primary
        keyLabel.TextXAlignment = Enum.TextXAlignment.Center
        keyLabel.Parent = keyBg
        
        local listening = false
        local currentKey = defaultKey
        
        local function StartListening()
            listening = true
            keyLabel.Text = "..."
            keyBg.BackgroundColor3 = Euphoria.Colors.SurfaceHover
            CreateStroke(keyBg, Euphoria.Colors.Primary, 2)
        end
        
        local function StopListening(newKey)
            listening = false
            if newKey then
                currentKey = newKey
                keyLabel.Text = tostring(newKey):gsub("Enum.KeyCode.", "")
                if callback then callback(newKey) end
            else
                keyLabel.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
            end
            keyBg.BackgroundColor3 = Euphoria.Colors.Background
            CreateStroke(keyBg, Euphoria.Colors.Border, 1)
        end
        
        keyBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                StartListening()
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        StopListening(input.KeyCode)
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        return {
            GetKey = function() return currentKey end,
            SetKey = function(key) StopListening(key) end
        }
    end
    
    -- Текст (Label)
    function Euphoria:Label(parent, text, color)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 32)
        label.BackgroundColor3 = Euphoria.Colors.Surface
        label.BackgroundTransparency = 0.8
        label.BorderSizePixel = 0
        label.Text = text
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextColor3 = color or Euphoria.Colors.TextSecondary
        label.Parent = parent
        CreateCorner(label, 6)
        return label
    end
    
    -- Разделитель
    function Euphoria:Divider(parent)
        local divider = Instance.new("Frame")
        divider.Size = UDim2.new(1, -20, 0, 1)
        divider.BackgroundColor3 = Euphoria.Colors.Border
        divider.BorderSizePixel = 0
        divider.Parent = parent
        return divider
    end
    
    -- Информационный блок
    function Euphoria:Info(parent, text, infoType)
        local info = Instance.new("Frame")
        info.Size = UDim2.new(1, -20, 0, 36)
        info.BackgroundColor3 = Euphoria.Colors.Surface
        info.BackgroundTransparency = 0.8
        info.BorderSizePixel = 0
        info.Parent = parent
        CreateCorner(info, 6)
        
        local icon = infoType == "success" and "✅" or infoType == "warning" and "⚠️" or infoType == "error" and "❌" or "ℹ️"
        local color = infoType == "success" and Euphoria.Colors.Success or infoType == "warning" and Euphoria.Colors.Warning or infoType == "error" and Euphoria.Colors.Error or Euphoria.Colors.Primary
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 36, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextSize = 18
        iconLabel.TextColor3 = color
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = info
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -48, 1, 0)
        textLabel.Position = UDim2.new(0, 48, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextSize = 11
        textLabel.Font = Enum.Font.Gotham
        textLabel.TextColor3 = Euphoria.Colors.TextSecondary
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = info
        
        return info
    end
    
    -- Уведомление
    function Euphoria:Notify(title, message, duration, notifType)
        duration = duration or 3
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 320, 0, 60)
        notif.Position = UDim2.new(1, 330, 0, 10)
        notif.BackgroundColor3 = Euphoria.Colors.Surface
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.Parent = gui
        CreateCorner(notif, 8)
        CreateStroke(notif, Euphoria.Colors.Primary, 1)
        
        local icon = notifType == "success" and "✅" or notifType == "warning" and "⚠️" or notifType == "error" and "❌" or "✨"
        local iconColor = notifType == "success" and Euphoria.Colors.Success or notifType == "warning" and Euphoria.Colors.Warning or notifType == "error" and Euphoria.Colors.Error or Euphoria.Colors.Primary
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 40, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextSize = 22
        iconLabel.TextColor3 = iconColor
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = notif
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -50, 0, 22)
        titleLabel.Position = UDim2.new(0, 48, 0, 6)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextSize = 13
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextColor3 = Euphoria.Colors.TextPrimary
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notif
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -50, 0, 20)
        msgLabel.Position = UDim2.new(0, 48, 0, 30)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Text = message
        msgLabel.TextSize = 10
        msgLabel.Font = Enum.Font.Gotham
        msgLabel.TextColor3 = Euphoria.Colors.TextSecondary
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.Parent = notif
        
        notif.BackgroundTransparency = 1
        notif.Position = UDim2.new(1, 0, 0, 10)
        Tween(notif, {BackgroundTransparency = 0.1, Position = UDim2.new(1, -330, 0, 10)}, 0.35)
        
        task.delay(duration, function()
            Tween(notif, {BackgroundTransparency = 1, Position = UDim2.new(1, 0, 0, 10)}, 0.35, function()
                notif:Destroy()
            end)
        end)
    end
    
    -- Установка акцентного цвета
    function Euphoria:SetAccent(color)
        Euphoria.Colors.Primary = color
        accentLine.BackgroundColor3 = color
    end
    
    -- Создание вкладки настроек UI
    local function CreateUISettingsTab()
        local settingsTab, settingsLayout = CreateTab("UI Settings", "⚙️")
        
        Euphoria:Section(settingsLayout, "Внешний вид")
        
        -- Toggle для кастомного курсора
        local cursorEnabled = true
        Euphoria:Toggle(settingsLayout, "Кастомный курсор", "🖱️", true, function(value)
            -- Здесь можно добавить логику курсора
        end)
        
        -- Цветовая схема
        local themeOptions = {"Dark", "Midnight", "Amethyst", "Rose", "Ocean"}
        -- (тут можно добавить dropdown)
        
        Euphoria:Divider(settingsLayout)
        Euphoria:Section(settingsLayout, "Информация")
        Euphoria:Label(settingsLayout, "Euphoria UI v1.0")
        Euphoria:Label(settingsLayout, "Современная UI библиотека для Roblox")
    end
    
    -- Автоматически создаём вкладку UI Settings
    CreateUISettingsTab()
    
    return {
        CreateTab = CreateTab,
        Section = Euphoria.Section,
        Button = Euphoria.Button,
        Toggle = Euphoria.Toggle,
        Slider = Euphoria.Slider,
        Keybind = Euphoria.Keybind,
        Label = Euphoria.Label,
        Divider = Euphoria.Divider,
        Info = Euphoria.Info,
        Notify = Euphoria.Notify,
        SetAccent = Euphoria.SetAccent,
        Window = window,
        Gui = gui
    }
end

return Euphoria
