--Utility Functions
function SetStatus(code, msg)
  Controls["Status"].Value = code
  Controls["Status"].String = msg or ""
end 

function SetLoopLegends()
  for _,ctl in pairs(Controls["Content Loop Enable"]) do
    ctl.Legend = "Loop"
  end
end 

function DisableControls(bool)
  Controls["Content Refresh List"].IsDisabled = bool
  Controls["Content Reset"].IsDisabled = bool
  Controls["Content Default Name"].IsDisabled = bool
  Controls["Home Fallback Active"].IsDisabled = bool
  Controls["Home Fallback Enable"].IsDisabled = bool
  for i = 1, #Controls["Content Name"] do
    Controls["Content Name"][i].IsDisabled = bool
    Controls["Content Play"][i].IsDisabled = bool 
    Controls["Content Loop Enable"][i].IsDisabled = bool
    Controls["Content Playing"][i].IsDisabled = bool
  end   
end 

function ResetControls()
  Controls["Content Default Name"].String = ""
  Controls["Home Fallback Active"].Boolean = false
  for i = 1, #Controls["Content Name"] do
    Controls["Content Name"][i].String = ""
    Controls["Content Loop Enable"][i].Boolean = false
    Controls["Content Playing"][i].Boolean = false
  end  
end 
--Operational Functions

function HandlePlayOrLoop(idx)
  if Controls["Content Loop Enable"][idx].Boolean then 
    currentlyLooping = true --loops restart themselves, so ignore the gaps between iterations
    compBSN["Loop"]:Trigger()
  else 
    currentlyLooping = false --one-shot play; falling back to home when it ends is desired
    compBSN["Play"]:Trigger()
  end 
end 

function ReturnToHomeFallback()
  if not (compBSN and compBSN["Status"]) then return end
  if currentlyLooping then return end --looping content restarts on its own, don't fall back between loops
  if not Controls["Home Fallback Enable"].Boolean then return end --only fall back when enabled

  ResetContent()
end

function ResetContent() 
  if Controls["Home Fallback Enable"].Boolean then 
    if Controls["Content Default Name"].String == "" then --additional condition whereby we check if the file does indeed exist?
      SetStatus(2, "Please Select a Default Video to Play") 
      return 
    end 
    compBSN["File"].String = Controls["Content Default Name"].String
    currentlyLooping = true --the home fallback loops, so ignore its loop gaps too
    Timer.CallAfter(function() compBSN["Loop"]:Trigger() end, 0.2)
  else
    currentlyLooping = false
    compBSN["StopClear"]:Trigger()
  end 
end 

--BrightSign Components

function GetBrightSigns()
  local compList = Component.GetComponents()
  local bsnChoices = {""}

  for _,comp in pairs(compList) do
    if comp.Type == '%PLUGIN%_a612f376-8e9f-4570-926c-faa41e4c4b33_%FP%_0eea11544914cb225448faed810577d1' then
      table.insert(bsnChoices, comp.Name)
    end
  end

  table.sort(bsnChoices)
  Controls["BrightSign Name"].Choices = bsnChoices
end 

function GetContentList()
  -- compBSN["RefreshFileList"]:Trigger()
  local fileList = {""}

  for _,file in pairs(compBSN["FileListBox"].Choices) do
    table.insert(fileList, file)
  end

  table.sort(fileList)

  Controls["Content Default Name"].Choices = fileList
  for _,ctl in pairs(Controls["Content Name"]) do
    ctl.Choices = fileList
  end
end 

function PollFileList()
  if not (compBSN and compBSN["Status"]) then return end --nothing to poll without a valid BrightSign

  compBSN["RefreshFileList"]:Trigger() --ask the BrightSign to rescan its files
  Timer.CallAfter(GetContentList, 0.5) --give the device a moment to repopulate before pulling the list
end 

function SetComponent()
  compBSN = Component.New(Controls["BrightSign Name"].String)

  if not compBSN["Status"] then
    SetStatus(2, "Couldn't find BrightSign")
    return 
  end 

  SetStatus(0, "BrightSign Connected")
  GetContentList()
  SetPluginEventHandlers() --monitor the play button on the BSN plugin so that if it plays any content we can keep companion in sync
  DisableControls(false)
  GetContentList()
end

function CheckPlayingFile()
  if not (compBSN and compBSN["Status"]) then return end --no valid BrightSign to compare against
  local str = compBSN["DeviceResponse"].String

  if str == "STPC" or str == "Stopped" or str == "ENDP" then 
    Controls["Home Fallback Active"].Boolean = false
    for _,ctl in pairs(Controls["Content Playing"]) do
      ctl.Boolean = false
    end
    SetStatus(0, "Content has stopped")
  end 

  if (string.find(str, "Playing: ") == nil) and (string.find(str, "Looping: ") == nil) then
    return
  end 

  local filename = string.lower(string.sub(str, 10, #str))
  
  Controls["Home Fallback Active"].Boolean = (string.lower(Controls["Content Default Name"].String) == filename)

  for i,ctl in pairs(Controls["Content Name"]) do
    Controls["Content Playing"][i].Boolean = (string.lower(Controls["Content Name"][i].String) == filename)
  end

  SetStatus(0)
end 

--BSN Plugin EventHandlers (and resets for when changing)

function SetPluginEventHandlers()
  compBSN["DeviceResponse"].EventHandler = nil
  compBSN["DeviceResponse"].EventHandler = function(ctl)
    CheckPlayingFile()
  end 

  compBSN["PlayStatus"].EventHandler = nil
  compBSN["PlayStatus"].EventHandler = function(ctl)
    if not ctl.Boolean then --playback has stopped/ended on the BrightSign
      ReturnToHomeFallback()
    end
  end 

  compBSN["Status"].EventHandler = nil
  compBSN["Status"].EventHandler = function(ctl)
    if ctl.Value ~= 0 then --BrightSign's Status has gone missing/faulted
      SetStatus(4, "BrightSign Missing")
    else
      SetStatus(0, "BrightSign Connected")
    end
  end 
end 

--Controls EventHandlers

Controls["BrightSign Name"].EventHandler = function()
  SetComponent()
  ResetControls()
end 
Controls["Content Refresh List"].EventHandler = GetContentList
Controls["Content Reset"].EventHandler = ResetContent

Controls["Content Default Name"].EventHandler = function() --re-check against what's playing when the selection changes
  CheckPlayingFile()
end

for i,ctl in pairs(Controls["Content Name"]) do
  ctl.EventHandler = function() --light the LED if the newly selected file is already playing/looping
    CheckPlayingFile()
  end
end

for i,ctl in pairs(Controls["Content Play"]) do
  ctl.EventHandler = function()
    if not compBSN["File"].String then
      SetStatus(2, "No Valid BrightSign")
      return 
    end 

    if Controls["Content Name"][i].String == "" then 
      SetStatus(2, "Please Select a valid video to play")
      return
    end 

    compBSN["File"].String = Controls["Content Name"][i].String
    SetStatus(5, "Trying to play")
    HandlePlayOrLoop(i)
  end 
end

--Initialise

function Init()
  GetBrightSigns()

  if #Controls["BrightSign Name"].String > 0 then --does BSN have a name
    DisableControls(false)
    SetComponent()
    return
  end 

  DisableControls(true)
end 

Timer.CallAfter( --Allow for BSN Plugins to Initialise in the Design before starting up
  function() Init() end, 1
)

TimerFileListPoll = Timer.New() 
TimerFileListPoll.EventHandler = PollFileList
TimerFileListPoll:Start(30)   