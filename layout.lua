local CurrentPage = PageNames[props["page_index"].Value]

local statusBarSize = { 400, 32 }

--add image banner at the top followed by the status control underneath that can be visible accross all pages
layout["Status"] = {
  PrettyName = "Status",
  Style = "Text",
  Position = { 0, 0 },
  Size = statusBarSize,
}



if CurrentPage == "Control" then
  local padding = 8
  local innerGap = 4
  local labelH = 16
  local btnW, btnH = 36,16
  local ledSize = 16

  -- Home controls group box
  local homeX = padding
  local homeY = statusBarSize[2] + padding
  local homeW = statusBarSize[1] - padding * 2
  local homeBoxH = 16 + padding + btnH + innerGap + btnH + padding

  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Home Controls",
    StrokeWidth = 1,
    Position = { homeX, homeY },
    Size = { homeW, homeBoxH },
    CornerRadius = 8,
  })

  local homeInnerY = homeY + 16 + padding
  local homeContentW = homeW - padding * 2 - ledSize - innerGap

  layout["Content Default Name"] = {
    PrettyName = "Content Default Name",
    Style = "ComboBox",
    Position = { homeX + padding, homeInnerY },
    Size = { homeContentW, btnH },
    FontSize = 10,
  }
  layout["Home Fallback Active"] = {
    PrettyName = "Home Fallback Active",
    Style = "Led",
    Position = { homeX + padding + homeContentW + innerGap, homeInnerY },
    Size = { ledSize, ledSize },
  }
  layout["Home Fallback Enable"] = {
    PrettyName = "Home Fallback Enable",
    Style = "Button",
    Legend = "Enable",
    ButtonStyle = "Toggle",
    Position = { homeX + padding, homeInnerY + btnH + innerGap },
    Size = { btnW, btnH },
  }
  layout["Content Reset"] = {
    PrettyName = "Content Reset",
    Style = "Button",
    Legend = "Reset",
    Position = { homeX + padding + btnW + innerGap, homeInnerY + btnH + innerGap },
    Size = { btnW, btnH },
  }

  -- Presets group box
  local varNumPresets = props["Number of Presets"].Value
  local rowLabelW = 56
  local ledColW   = 40  -- wide enough for "Playing" header label
  local contentNameW = homeW - padding * 2 - rowLabelW - innerGap * 4 - btnW * 2 - ledColW

  local presetsX = padding
  local presetsY = homeY + homeBoxH + padding
  local presetsW = homeW
  local presetsBoxH = 16 + padding + labelH + innerGap + varNumPresets * btnH + (varNumPresets - 1) * innerGap + padding

  -- Column X positions
  local colLabel = presetsX + padding
  local colName  = colLabel + rowLabelW + innerGap
  local colLoop  = colName + contentNameW + innerGap
  local colPlay  = colLoop + btnW + innerGap
  local colLed   = colPlay + btnW + innerGap

  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Presets",
    Position = { presetsX, presetsY },
    Size = { presetsW, presetsBoxH },
    StrokeWidth = 1,
    CornerRadius = 8,
  })

  -- Column header labels
  local headerY = presetsY + 16 + padding
  table.insert(graphics, { Type = "Label", Text = "Content",  Position = { colName, headerY }, Size = { contentNameW, labelH }, HTextAlign = "Center" })
  table.insert(graphics, { Type = "Label", Text = "Loop",     Position = { colLoop, headerY }, Size = { btnW,         labelH }, HTextAlign = "Center" })
  table.insert(graphics, { Type = "Label", Text = "Play",     Position = { colPlay, headerY }, Size = { btnW,         labelH }, HTextAlign = "Center" })
  table.insert(graphics, { Type = "Label", Text = "Playing",  Position = { colLed,  headerY }, Size = { ledColW,      labelH }, HTextAlign = "Center" })

  -- Preset rows
  local dataStartY = headerY + labelH + innerGap

  for i = 1, varNumPresets do
    local rowY = dataStartY + (i - 1) * (btnH + innerGap)

    table.insert(graphics, {
      Type = "Label",
      Text = "Preset " .. i .. ":",
      Position = { colLabel, rowY },
      Size = { rowLabelW, btnH },
      HTextAlign = "Left",
    })
    layout["Content Name " .. i] = {
      PrettyName = "Preset " .. i .. "~Content Name",
      Style = "ComboBox",
      Position = { colName, rowY },
      Size = { contentNameW, btnH },
      FontSize = 10,
    }
    layout["Content Loop Enable " .. i] = {
      PrettyName = "Preset " .. i .. "~Loop",
      Style = "Button",
      Legend = "Loop",
      ButtonStyle = "Toggle",
      Position = { colLoop, rowY },
      Size = { btnW, btnH },
    }
    layout["Content Play " .. i] = {
      PrettyName = "Preset " .. i .. "~Play",
      Style = "Button",
      ButtonStyle = "Trigger",
      Position = { colPlay, rowY },
      Size = { btnW, btnH },
    }
    layout["Content Playing " .. i] = {
      PrettyName = "Preset " .. i .. "~Playing",
      Style = "Led",
      Position = { colLed + math.floor((ledColW - ledSize) / 2), rowY + math.floor((btnH - ledSize) / 2) },
      Size = { ledSize, ledSize },
    }
  end

  -- Refresh content list: bottom right, below presets
  local refreshBtnW = 3 * btnW
  layout["Content Refresh List"] = {
    PrettyName = "Content Refresh List",
    Style = "Button",
    Legend = "Refresh Content List",
    Position = { colLoop, presetsY + presetsBoxH + padding },
    Size = { refreshBtnW, btnH },
  }



elseif CurrentPage == "Setup" then
  local labelOffsetY = statusBarSize[2] + 8
  table.insert(graphics, {
    Type = "Label",
    Text = "Select BrightSign Player to Control",
    Position = { (statusBarSize[1] - 200) / 2, labelOffsetY },
    Size = { 200, 16 },
    HTextAlign = "Center"
  })
  layout["BrightSign Name"] = {
    PrettyName = "Select BrightSign Player",
    Style = "ComboBox",
    Position = { (statusBarSize[1] - 200) / 2, labelOffsetY + 20 },
    Size = { 200, 24 },
    FontSize = 16,
  }
end