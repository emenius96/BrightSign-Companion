table.insert(ctrls, {
  Name = "Status", --reserved name
  ControlType = "Indicator",
  Count = 1,
  IndicatorType = "Status",
  UserPin = true, --Determines if the pin exposure is user configurable
  PinStyle = "Output",
})
table.insert(ctrls, {
  Name = "BrightSign Name",
  ControlType = "Text",
  Count = 1,
  UserPin = true, --Determines if the pin exposure is user configurable
  PinStyle = "Output",
})
table.insert(ctrls, {
  Name = "Content Refresh List",
  ControlType = "Button",
  ButtonType = "Trigger",
  Count = 1,
  UserPin = true,
  PinStyle = "Both",
})
table.insert(ctrls, {
  Name = "Content Reset",
  ControlType = "Button",
  ButtonType = "Trigger",
  Count = 1,
  UserPin = true,
  PinStyle = "Both",
})
table.insert(ctrls, {
  Name = "Home Fallback Enable",
  ControlType = "Button",
  ButtonType = "Toggle",
  Count = 1,
  UserPin = true,
  PinStyle = "Both",
})
table.insert(ctrls, {
  Name = "Home Fallback Active",
  ControlType = "Indicator",
  IndicatorType = "Led",
  Count = 1,
  UserPin = true,
  PinStyle = "Output",
})
table.insert(ctrls, {
  Name = "Content Default Name",
  ControlType = "Text",
  Count = 1,
  UserPin = true, --Determines if the pin exposure is user configurable
  PinStyle = "Output",
})

local varNumPresets = props["Number of Presets"].Value

table.insert(ctrls, {
  Name = "Content Name",
  ControlType = "Text",
  Count = varNumPresets,
  UserPin = false, --Determines if the pin exposure is user configurable
})
table.insert(ctrls, {
  Name = "Content Play",
  ControlType = "Button",
  ButtonType = "Trigger",
  Count = varNumPresets,
  UserPin = true,
  PinStyle = "Both",
})
table.insert(ctrls, {
  Name = "Content Loop Enable",
  ControlType = "Button",
  ButtonType = "Toggle",
  Count = varNumPresets,
  UserPin = true,
  PinStyle = "Both",
})
table.insert(ctrls, {
  Name = "Content Playing",
  ControlType = "Indicator",
  IndicatorType = "Led",
  Count = varNumPresets,
  UserPin = true,
  PinStyle = "Output",
})