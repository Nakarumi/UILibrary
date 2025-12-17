# Roblox GUI Library v3.1 - Documentation

## Table of Contents
- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Window Creation](#window-creation)
- [Tabs](#tabs)
- [UI Elements](#ui-elements)
- [Configuration System](#configuration-system)
- [Theme System](#theme-system)
- [Notifications](#notifications)
- [Complete Example](#complete-example)

---

## Installation

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nakarumi/UILibrary/refs/heads/main/Library.luau"))()
```

---

## Basic Usage

### Creating a Window

```lua
local Window = Library:CreateWindow({
    Title = "My GUI",
    Size = UDim2.new(0, 500, 0, 400),
    ToggleKey = Enum.KeyCode.RightControl,
    ConfigFolder = "MyScriptConfigs"
})
```

**Parameters:**
- `Title` (string) - Window title
- `Size` (UDim2) - Window size
- `ToggleKey` (KeyCode) - Key to show/hide GUI (default: RightControl)
- `ConfigFolder` (string) - Folder name for saving configs (default: "LibraryConfigs")

**OR Simple Version:**
```lua
local Window = Library:CreateWindow("My GUI")
```

---

## Window Creation

### CreateWindow
Creates the main GUI window.

**Returns:** Window object

**Methods Available:**
- `CreateTab(name)` - Creates a new tab
- `CreateButton(...)` - Creates UI elements (must select tab first)
- `SaveConfig(name)` - Saves current configuration
- `LoadConfig(name)` - Loads saved configuration
- `DeleteConfig(name)` - Deletes a configuration
- `GetConfigs()` - Returns array of config names

---

## Tabs

### CreateTab
Creates a new tab in the window.

```lua
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")
```

**Note:** After creating a tab, set it as active container:
```lua
Window.Container = MainTab.Container
```

---

## UI Elements

All elements must be created after setting the active container.

### Button

```lua
Window:CreateButton("Click Me", function()
    print("Button clicked!")
end)
```

**Parameters:**
- `name` (string) - Button text
- `callback` (function) - Function called on click

---

### Toggle

```lua
Window:CreateToggle("Enable Feature", false, function(state)
    print("Toggle is now:", state)
end)
```

**Parameters:**
- `name` (string) - Toggle label
- `default` (boolean) - Initial state
- `callback` (function) - Function called with new state

**Config Support:** ✓ (Saves state)

---

### Slider

```lua
Window:CreateSlider("Speed", 0, 100, 50, function(value)
    print("Slider value:", value)
end)
```

**Parameters:**
- `name` (string) - Slider label
- `min` (number) - Minimum value
- `max` (number) - Maximum value
- `default` (number) - Starting value
- `callback` (function) - Function called with new value

**Config Support:** ✓ (Saves value)

---

### Keybind

```lua
Window:CreateKeybind("Teleport Key", Enum.KeyCode.E, function()
    print("Keybind pressed!")
end)
```

**Parameters:**
- `name` (string) - Keybind label
- `default` (KeyCode) - Default key
- `callback` (function) - Function called when key is pressed

**Config Support:** ✓ (Saves key name)

**Usage:** Click the keybind button to rebind, press any key to set new bind.

---

### Textbox

```lua
Window:CreateTextbox("Player Name", "Enter name...", function(text)
    print("Entered text:", text)
end)
```

**Parameters:**
- `name` (string) - Textbox label
- `placeholder` (string) - Placeholder text
- `callback` (function) - Function called when Enter is pressed

**Config Support:** ✗

---

### Dropdown

```lua
Window:CreateDropdown("Select Mode", {"Option 1", "Option 2", "Option 3"}, function(selected)
    print("Selected:", selected)
end)
```

**Parameters:**
- `name` (string) - Dropdown label
- `options` (table) - Array of options
- `callback` (function) - Function called with selected option

**Config Support:** ✓ (Saves selection)

---

### Color Picker

```lua
Window:CreateColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Selected color:", color)
end)
```

**Parameters:**
- `name` (string) - Color picker label
- `default` (Color3) - Default color
- `callback` (function) - Function called with new color

**Config Support:** ✓ (Saves RGB values)

**Features:**
- Color wheel for hue selection
- RGB sliders for precise control
- Click color box to open/close picker

---

## Configuration System

The library automatically saves the state of all configurable elements (toggles, sliders, keybinds, dropdowns, color pickers).

### Creating Config Manager

```lua
local ConfigTab = Window:CreateTab("Config")
Window.Container = ConfigTab.Container
Window:CreateConfiguration()
```

This creates a complete configuration manager with:
- Text input for config name
- Dropdown to select existing configs
- Save button - Creates new config
- Load button - Loads selected config
- Overwrite button - Updates selected config
- Delete button - Removes selected config

### Manual Config Operations

```lua
Window:SaveConfig("MyConfig")

Window:LoadConfig("MyConfig")

Window:DeleteConfig("MyConfig")

local configs = Window:GetConfigs()
for _, configName in pairs(configs) do
    print(configName)
end
```

### Config File Location

Configs are saved as JSON files in:
```
workspace/{ConfigFolder}/{ConfigName}.json
```

### Config Data Format

```json
{
  "Toggle_Feature Name": true,
  "Slider_Speed": 75,
  "Keybind_Teleport": "E",
  "Dropdown_Mode": "Option 2",
  "ColorPicker_Color": {"R": 1, "G": 0, "B": 0}
}
```

---

## Theme System

### Setting Custom Theme

```lua
Library:SetTheme({
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(85, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180)
})
```

### Theme Editor

```lua
Library:CreateThemeEditor()
```

Creates a separate window with:
- Color pickers for all theme colors
- 6 preset themes
- Live preview of changes

**Preset Themes:**
- Dark Blue (default)
- Purple Dream
- Green Matrix
- Red Danger
- Cyan Wave
- Orange Sunset

---

## Notifications

### Basic Notification

```lua
Library:Notify("Operation completed!")
```

### Advanced Notification

```lua
Library:Notify({
    Title = "Success",
    Description = "Config saved successfully",
    Duration = 3
})
```

**Parameters:**
- `Title` (string) - Notification title
- `Description` (string) - Notification message
- `Duration` (number) - Display time in seconds

**Features:**
- Auto-stacking (multiple notifications push up)
- Smooth animations
- Accent color bar
- Shadow effects

---

## Complete Example

```lua
local Library = loadstring(game:HttpGet("YOUR_URL"))()

local Window = Library:CreateWindow({
    Title = "My Script Hub",
    Size = UDim2.new(0, 550, 0, 450),
    ToggleKey = Enum.KeyCode.RightControl,
    ConfigFolder = "MyScriptConfigs"
})

local MainTab = Window:CreateTab("Main")
Window.Container = MainTab.Container

Window:CreateButton("Test Button", function()
    Library:Notify("Button clicked!")
end)

Window:CreateToggle("Auto Farm", false, function(state)
    print("Auto Farm:", state)
end)

Window:CreateSlider("Walk Speed", 16, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

Window:CreateKeybind("Fly", Enum.KeyCode.F, function()
    print("Fly activated!")
end)

Window:CreateDropdown("Weapon", {"Sword", "Gun", "Bow"}, function(weapon)
    print("Selected weapon:", weapon)
end)

Window:CreateColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("ESP Color changed")
end)

local ConfigTab = Window:CreateTab("Config")
Window.Container = ConfigTab.Container
Window:CreateConfiguration()

local ThemeTab = Window:CreateTab("Theme")
Window.Container = ThemeTab.Container

Window:CreateButton("Open Theme Editor", function()
    Library:CreateThemeEditor()
end)

Library:Notify({
    Title = "Script Loaded",
    Description = "Press RightControl to toggle GUI",
    Duration = 5
})
```

---

## Tips & Best Practices

1. **Always set Window.Container** before creating elements
2. **Create config tab last** so all elements are registered
3. **Use descriptive names** for toggles/sliders for better config organization
4. **Test config save/load** before distributing your script
5. **Provide default keybinds** that don't conflict with game controls
6. **Use notifications** to provide feedback to users
7. **Custom config folders** prevent conflicts with other scripts

---

## Troubleshooting

**Elements not appearing:**
- Ensure `Window.Container = Tab.Container` is set before creating elements

**Configs not saving:**
- Check if your executor supports `makefolder`, `writefile`, `readfile`
- Verify ConfigFolder name doesn't contain invalid characters

**GUI not toggling:**
- Make sure the ToggleKey isn't being used by the game
- Try a different key like `Enum.KeyCode.Insert`

**Theme not applying:**
- Call `SetTheme()` before creating window
- Or use Theme Editor for live preview

---

## API Reference Summary

### Library Methods
- `CreateWindow(config)` - Main window
- `Notify(config)` - Show notification
- `SetTheme(theme)` - Apply custom theme
- `CreateThemeEditor()` - Theme customization window

### Window Methods
- `CreateTab(name)` - New tab
- `CreateButton(name, callback)` - Button element
- `CreateToggle(name, default, callback)` - Toggle element
- `CreateSlider(name, min, max, default, callback)` - Slider element
- `CreateKeybind(name, default, callback)` - Keybind element
- `CreateTextbox(name, placeholder, callback)` - Textbox element
- `CreateDropdown(name, options, callback)` - Dropdown element
- `CreateColorPicker(name, default, callback)` - Color picker element
- `CreateConfiguration()` - Config manager UI
- `SaveConfig(name)` - Save config file
- `LoadConfig(name)` - Load config file
- `DeleteConfig(name)` - Delete config file
- `GetConfigs()` - List all configs

---

## License

Free to use for personal and commercial projects.

## Support

For issues or questions, contact the developer or check the documentation.
