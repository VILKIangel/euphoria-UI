--- DOCUMENTATION ---
---------------------
-- Installation 
local Euphoria = loadstring(game:HttpGet("https://raw.githubusercontent.com/VILKIangel/euphoria-UI/refs/heads/main/UI.lua"))()
---------------------
-- Creating a Window
local UI = Euphoria:CreateWindow({
    Name = "My Script",  -- Window title
    Size = UDim2.new(0, 800, 0, 600)  -- Width, Height
})
---------------------
-- Creating a Tab |
local tab, layout = UI:CreateTab("Tab Name", "🏠")
-- Returns: tabContent (frame), tabLayout (UIListLayout)
---------------------
-- Button |
UI:Button(parent, name, icon, callback)
-- Example:
UI:Button(layout, "Click Me", "🔘", function()
    print("Button clicked!")
end)
---------------------
-- Toggle |
local toggle = UI:Toggle(parent, name, icon, defaultValue, callback)
-- Returns: {SetValue, GetValue}
-- Example:
local toggle = UI:Toggle(layout, "Feature", "⚙️", false, function(value)
    print(value and "ON" or "OFF")
end)
toggle:SetValue(true)  -- Set programmatically
print(toggle:GetValue())  -- Get current state
---------------------
-- Slider |
local slider = UI:Slider(parent, name, icon, min, max, default, suffix, callback)
-- Returns: {SetValue, GetValue}
-- Example:
local slider = UI:Slider(layout, "Volume", "🔊", 0, 100, 50, "%", function(value)
    print("Volume:", value)
end)
slider:SetValue(75)
---------------------
-- Keybind |
local keybind = UI:Keybind(parent, name, defaultKey, callback)
-- Returns: {GetKey, SetKey}
-- Example:
local bind = UI:Keybind(layout, "Teleport", Enum.KeyCode.X, function(key)
    print("Bound to:", key)
end)
print(bind:GetKey())  -- Current key
bind:SetKey(Enum.KeyCode.E)  -- Change key
---------------------
-- Label |
UI:Label(parent, text, color)  -- color is optional
-- Example:
UI:Label(layout, "Hello World")
UI:Label(layout, "Colored Text", Euphoria.Colors.Primary)
---------------------
-- Divider |
UI:Divider(parent)
-- Adds a horizontal separator line
---------------------
-- Section |
UI:Section(parent, title)
-- Adds a section header (uppercase, colored)
---------------------
-- Info Box |
UI:Info(parent, text, type)  -- type: "info", "success", "warning", "error"
-- Example:
UI:Info(layout, "This is info", "info")
UI:Info(layout, "Success!", "success")
UI:Info(layout, "Warning!", "warning")
UI:Info(layout, "Error!", "error")
---------------------
-- Notification |
UI:Notify(title, message, duration, type)
-- Example:
UI:Notify("Success", "Action completed!", 3, "success")
---------------------
-- Colors |
Euphoria.Colors = {
    Primary = Color3.fromRGB(180, 130, 255),
    Secondary = Color3.fromRGB(160, 165, 175),
    Background = Color3.fromRGB(15, 15, 20),
    Surface = Color3.fromRGB(25, 25, 35),
    Success = Color3.fromRGB(80, 200, 120),
    Error = Color3.fromRGB(230, 70, 70),
    Warning = Color3.fromRGB(250, 180, 60),
}
---------------------
-- Methods |
UI:SetAccent(color)  -- Change primary color
UI:Notify(title, msg, duration, type)  -- Show notification
---------------------
-- Complete Example --
local Euphoria = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/Euphoria/main/source.lua"))()

local UI = Euphoria:CreateWindow({
    Name = "My Script",
    Size = UDim2.new(0, 800, 0, 600)
})

local mainTab, layout = UI:CreateTab("Main", "🏠")

UI:Section(layout, "Settings")

local antiGrab = UI:Toggle(layout, "Anti-Grab", "🛡️", true, function(val)
    print("Anti-Grab:", val)
end)

local power = UI:Slider(layout, "Throw Power", "💪", 1000, 50000, 5000, "", function(val)
    print("Power:", val)
end)

UI:Divider(layout)

UI:Button(layout, "Execute", "🚀", function()
    UI:Notify("Done", "Action completed!", 2, "success")
end)

local bindsTab, bindsLayout = UI:CreateTab("Binds", "⌨️")

local tpBind = UI:Keybind(bindsLayout, "Teleport", Enum.KeyCode.X, function(key)
    print("Teleport bound to:", key)
end)

UI:Notify("Ready", "Euphoria UI loaded! Press Insert", 5)
---------------------
