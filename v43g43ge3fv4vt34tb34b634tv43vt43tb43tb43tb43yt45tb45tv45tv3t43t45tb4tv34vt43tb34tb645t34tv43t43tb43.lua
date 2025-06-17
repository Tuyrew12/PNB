--[DON'T SCROLL DOWN!]
RoleMVP = false
RoleMOD = false
WebhookLink2 = "https://discord.com/api/webhooks/1383886557525835806/fAjQwl4awVlIl99LpnmNuO7y65su2E53VztkezUNCjnJJ81KzAw_WGZJBvr1FPoATbSP"

DelayConvertDL = DelayConvertDL or 0
WorldName = GetWorld().name or "Unknown"
Nick = GetLocal().name:gsub("`(%S)", ""):match("%S+")
if AutoSuckGems then
end
NoGemsDrop = NoGemsDrop
PinkGems = GetItemInfo("Pink Gemstone").id
CheckIgnore = IgnoreCompletely and 1 or 0
BlackGems = GetItemInfo("Black Gems").id
DelayConvertBlack = DelayConvertDL * 50
if RoleMOD then
end
RoleMVP = RoleMVP
DelayConvertBGL = DelayConvertDL * 20
CheckGems = NoGemsDrop and 1 or 0
StartTime = os and os.time() or 0
ConsumeItemID = {}
Count = 1
Now = 1
GetRemote = false
CheatOff = false
CheatOn = false
DBlock = false
Ghost = false
MagW = false
Speed = 0
ConsumeArroz = false
ConsumeClover = false
ConsumeSongpyeon = false
IsConsuming = false
LastWebhook2Time = 0
LastWebhookTime = 0 -- Added to track first webhook last send time
RemoveHooks()

function inv(id)
  for _, item in pairs(GetInventory()) do
    if item.id == id then
      return item.amount
    end
  end
  return 0
end

local function wrenchMe()
    if GetWorld() == nil then
        Sleep(delayReconnect)
        RequestJoinWorld(worldName)
        Sleep(delayReconnect)
        nowFarm = false
    else
        if GetWorld() == nil then
            Sleep(delayReconnect)
            nowFarm = false
            return
        end
        SendPacket(2, "action|wrench\n|netid|".. GetLocal().netid)
        Sleep(300)
    end
end

adjustedSitX, adjustedSitY = SitX, SitY

-- Function to get state value based on direction
function GetStateValue()
  if StateDirection == "kiri" then
    return 48
  elseif StateDirection == "kanan" then
    return 32
  else
    return 32 -- default to kanan if invalid value
  end
end

AddHook("onvariant", "mommy", function(var)
    if var[0] == "OnDialogRequest" and var[1]:find("add_player_info") then
        if var[1]:find("|528|") then
            ConsumeClover = true
            ConsumeSongpyeon = true
        else
            ConsumeClover = false
            ConsumeSongpyeon = false
        end

        if var[1]:find("|4604|") then
            ConsumeArroz = true
        else
            ConsumeArroz = false
        end
        return true
    end
    return false
end)


function obj(id)
  local total = 0
  for _, object in pairs(GetObjectList()) do
    if object.id == id then
      total = total + object.amount
    end
  end
  return total
end

PGems = pcall(obj) and obj(PinkGems) or 0
BGems = pcall(obj) and obj(BlackGems) or 0
Songpyeon = pcall(inv) and inv(1056) or 0
Clover = pcall(inv) and inv(528) or 0
Arroz = pcall(inv) and inv(4604) or 0
BLK = pcall(inv) and inv(11550) or 0
BGL = pcall(inv) and inv(7188) or 0
DL = pcall(inv) and inv(1796) or 0
TotalLocks = tonumber(BLK .. BGL .. DL)
LockBefore = TotalLocks
BGems = pcall(obj) and obj(BlackGems) or BGems
BGemsBefore = BGems

Songpyeon = inv(1056) or Songpyeon
Clover = inv(528) or Clover
Arroz = inv(4604) or Arroz
if AutoConvertDL then
  BLK = inv(11550) or 0
  BGL = inv(7188) or 0
  DL = inv(1796) or 0
  TotalLocks = tonumber(BLK .. BGL .. DL)
  LockBefore = TotalLocks
end
if not NoGemsDrop then
  BGems = obj(BlackGems) or BGems
  BGemsBefore = BGems
end

function GetMag(a, b)
  tile = {}
  for y = b, 0, -1 do
    for x = a, 0, -1 do
      if GetTile(x, y).fg == 5638 and GetTile(x, y).bg == MagBG then
        table.insert(tile, {x = x, y = y})
      end
    end
  end
  return tile
end

function PathMag(x, y)
  SendPacketRaw(false, {
    state = GetStateValue(),
    x = x * 32,
    y = y * 32
  })
end

function getSitXYForPath()
  if Mode == "mneck" then
    return SitX, SitY
  elseif Mode == "vertical" then
    return SitX - 1, SitY
  elseif Mode == "horizontal" then
    return SitX - 1, SitY - 1
  else
    return SitX, SitY
  end
end

function getSitXYForConsume()
  if Mode == "mneck" then
    return SitX + 1, SitY
  elseif Mode == "vertical" then
    return SitX - 1, SitY
  elseif Mode == "horizontal" then
    return SitX - 1, SitY - 1
  else
    return SitX, SitY
  end
end

function PathSit()
  local x, y = getSitXYForPath()
  SendPacketRaw(false, {
    state = GetStateValue(),
    x = x * 32 - 1,
    y = y * 32 - 1
  })
end

if GetTile(209, 0) then
  Mag = GetMag(209, 209)
elseif GetTile(199, 0) then
  Mag = GetMag(199, 199)
elseif GetTile(149, 0) then
  Mag = GetMag(149, 149)
elseif GetTile(99, 0) then
  Mag = GetMag(99, 59)
elseif GetTile(29, 0) then
  Mag = GetMag(29, 29)
end

function Wrench(x, y)
  SendPacketRaw(false, {
    type = 3,
    state = GetStateValue(),
    value = 32,
    px = x,
    py = y,
    x = x * 32,
    y = y * 32
  })
end

function SendWebhook(url, data)
  MakeRequest(url, "POST", {
    ["Content-Type"] = "application/json"
  }, data)
end

function onvariant(var)
  if "OnSDBroadcast" == var[0] then
    if RoleMVP then SendPacket(2, [[action|input|text|/radio]]) end
    return true
  elseif "OnTalkBubble" == var[0] and var[2]:find("You received a MAGPLANT 5000 Remote") then
    GetRemote = true
    CheatOn = true
    DBlock = true
    Count = 1
  elseif "OnTalkBubble" == var[0] and var[2]:find("The MAGPLANT 5000 is empty") and not CheatOff then
    GetRemote = false
    CheatOff = true
    MagW = false
    Count = 1
  elseif "OnConsoleMessage" == var[0] and var[1]:find("Where would you like to go") then
    MagW = false
    GetRemote = false
    SendPacket(3, "action|join_request|name|" .. WorldName .. "|invitedWorld|0")
  elseif "OnConsoleMessage" == var[0] and var[1]:find("World Locked") then
    if var[1]:find(WorldName) then
      Count = 1
      MagW = false
      GetRemote = false
    else
      MagW = false
      GetRemote = false
      if not RoleMOD then Ghost = true end
      SendPacket(3, "action|join_request|name|" .. WorldName .. "|invitedWorld|0")
    end
  elseif "OnDialogRequest" == var[0] and GetRemote then
    if var[1]:find("Wow, that's fast delivery.") then
      return true
    elseif var[1]:find("Welcome back") then
      return true
    elseif var[1]:find("add_player_info") and DBlock then
      DBlock = false
      return true
    end
  elseif "OnDialogRequest" == var[0] and not GetRemote then
    if var[1]:find("ACTIVE") and var[1]:find(Mag[Now].x .. "\n") and var[1]:find(Mag[Now].y .. "\n") then
      if var[1]:find("DISABLED") then
        Now = Now == #Mag and 1 or Now + 1
        PathMag(Mag[Now].x, Mag[Now].y - 1)
      else
        SendPacket(2, "action|dialog_return|dialog_name|magplant_edit|x|" .. Mag[Now].x .. "|y|" .. Mag[Now].y .. "|buttonClicked|getRemote")
        if Mode == "horizontal" then
          local x, y = SitX, SitY
          FindPath(x - 1, y - 1)
        else
          PathSit()
        end
      end
    elseif var[1]:find("DISABLED") and var[1]:find(Mag[Now].x .. "\n") and var[1]:find(Mag[Now].y .. "\n") then
      if WebhookPNB and Now == #Mag then
        SendWebhook(WebhookLink, "{\"content\": \"<@" .. DiscordID .. "> PNB Magplants is Empty!\"}")
      end
      Now = Now == #Mag and 1 or Now + 1
      PathMag(Mag[Now].x, Mag[Now].y - 1)
    end
    return true
  elseif "OnConsoleMessage" == var[0] and var[1]:find("Radio disabled,") and not RoleMVP then
    SendPacket(2, [[action|input|text|/radio]])
    return true
  elseif "OnConsoleMessage" == var[0] and var[1]:find("Spam detected!") and not RoleMVP then
    SendPacket(2, [[action|input|text|/radio]])
    return true
  elseif not (not ("OnConsoleMessage" == var[0] and var[1]:find("from")) or RoleMVP) or "OnNameChanged" == var[0] and RoleMVP then
    if GetRemote then
      if CheatOn then
        if 0 == Count % (DelayRemote * 2) then
          CheatOn = false
          SendPacket(2, "action|dialog_return|dialog_name|cheats|check_autofarm|1|check_bfg|1|check_gems|" .. CheckGems .. "|check_lonely|" .. CheckIgnore .. "|check_ignoreo|" .. CheckIgnore .. "|check_ignoref|" .. CheckIgnore)
        end
        Count = Count + 1
      elseif AutoConvertDL then
        if 0 == Count % DelayConvertBlack then
          SendPacket(2, "action|dialog_return|dialog_name|info_box|buttonClicked|make_bgl")
        end
        Count = Count + 1
      end
    elseif CheatOff then
      if 0 == Count % (DelayRemote * 2) then
        CheatOff = false
        SendPacket(2, "action|dialog_return|dialog_name|cheats|check_autofarm|0|check_bfg|0|check_gems|1|check_lonely|" .. CheckIgnore .. "|check_ignoreo|" .. CheckIgnore .. "|check_ignoref|" .. CheckIgnore)
      end
      Count = Count + 1
    elseif MagW then
      Wrench(Mag[Now].x, Mag[Now].y)
    else
      if 0 == Count % (DelayRemote * 3) and not Ghost then
        PathMag(Mag[Now].x, Mag[Now].y - 1)
        MagW = true
      elseif 0 == Count % (DelayRemote * 2) and Ghost then
        Ghost = false
        SendPacket(2, "action|input|text|/ghost")
      end
      Count = Count + 1
    end
  end
end

function FNum(num)
  num = tonumber(num)
  if num >= 1.0E9 then
    return string.format("%.2fB", num / 1.0E9)
  elseif num >= 1000000.0 then
    return string.format("%.1fM", num / 1000000.0)
  elseif num >= 1000.0 then
    return string.format("%.0fK", num / 1000.0)
  else
    return tostring(num)
  end
end

function FTime(sec)
  days = math.floor(sec / 86400)
  hours = math.floor(sec % 86400 / 3600)
  minutes = math.floor(sec % 3600 / 60)
  seconds = math.floor(sec % 60)
  if days > 0 then
    return string.format("%sd %sh %sm %ss", days, hours, minutes, seconds)
  elseif hours > 0 then
    return string.format("%sh %sm %ss", hours, minutes, seconds)
  elseif minutes > 0 then
    return string.format("%sm %ss", minutes, seconds)
  elseif seconds >= 0 then
    return string.format("%ss", seconds)
  end
end

function SendInfoPNB()
  local currentTime = os.time()
  if currentTime - LastWebhookTime < 300 then return end -- 5 minutes
  LastWebhookTime = currentTime

  math.randomseed(currentTime)
  PGems = pcall(obj) and obj(PinkGems) or PGems
  BGems = pcall(obj) and obj(BlackGems) or BGems
  Songpyeon = pcall(inv) and inv(1056) or Songpyeon
  Clover = pcall(inv) and inv(528) or Clover
  Arroz = pcall(inv) and inv(4604) or Arroz
  BLK = pcall(inv) and inv(11550) or BLK
  BGL = pcall(inv) and inv(7188) or BGL
  DL = pcall(inv) and inv(1796) or DL

  if NoGemsDrop then
    if AutoConvertDL then
      TotalLocks = tonumber(BLK .. BGL .. DL)
      Speed = string.format("%.2f DL", (TotalLocks - LockBefore) / 30)
      LockBefore = TotalLocks
    end
  else
    if BGems >= BGemsBefore * 1.5 then
      Speed = string.format("%.2f BG", (BGems - BGemsBefore) / 30)
    else
      Speed = string.format("%.2f BG", BGems / 30)
    end
    BGemsBefore = BGems
  end

  local color = math.random(0, 16777215)
  Payload = [[
{
  "embeds": [{
    "author": {
      "name": "PNB LOGS #REBANA",
      "icon_url": "https://cdn.discordapp.com/attachments/1349225845402894339/1380592004693622857/AAAAA.gif"
    },
    "fields": [
      {"name": "<:AchievementSprites:1373112887203069972> Account", "value": "]] .. Nick .. [[", "inline": true},
      {"name": "<:growglobe:1382535597087785071> World", "value": "]] .. WorldName .. [[", "inline": true},
      {"name": "<:magplant:1368981774138605668> Magplant", "value": "]] .. Now .. " of " .. #Mag .. [[", "inline": true},
      {"name": "<:award:1373113752127537193> Consumables", "value": "]] .. Songpyeon .. " <:songpyeon:1368980154579157174> " .. Clover .. " <:clover:1368979672083464395> " .. Arroz .. [[ <:arroz:1368979942007902238>", "inline": true},
      {"name": "<:fwl:1373113385016758363> Total Locks", "value": "]] .. BLK .. " <a:irengb:1381540201955852359>  " .. BGL .. " <a:bglb:1381540210206314566>  " .. DL .. [[ <a:dlb:1381540213071024228>", "inline": true},
      {"name": "<:gemz:1382534859343401031> Gems Drop", "value": "]] .. FNum(BGems) .. "**<:blackgems:1376711562827534448>** " .. FNum(PGems) .. [[ **<:pinkgems:1376711581383131157>**", "inline": true}
    ],
    "footer": {"text": "Total PNB Time : ]] .. FTime(currentTime - StartTime) .. [["},
    "color": ]] .. color .. [[
  }]
}]]

  if WebhookLink then SendWebhook(WebhookLink, Payload) end
  if WebhookLink2 then SendWebhook(WebhookLink2, Payload) end
end

if AutoSuckGems then
  for i = 1, 3 do
    SendPacket(2, "action|dialog_return|dialog_name|popup|buttonClicked|bgem_suckall")
    Sleep(250)
  end
end

function Overlay(text)
  local var = {}
  var[0] = "OnTextOverlay"
  var[1] = "`w[`p@Rebana`w] `9" .. text
  SendVariantList(var)
end

if os or not WebhookPNB then
  if #Mag == 0 then
    Overlay("`7Please Set Magplant Background")
  else
    Overlay("`2Script is working!")
    Sleep(1000)

    AddHook("onvariant", "onvariant", onvariant)
    Sleep(1000)

    if HideAnimation then
      AddHook("onprocesstankupdatepacket", "OnIncomingRawPacket", function(pkt)
        if pkt.type == 3 or pkt.type == 8 or pkt.type == 14 or pkt.type == 17 then
          return true
        end
      end)
      Sleep(1000)
    end
    SendPacket(2, "action|dialog_return|dialog_name|cheats|check_autofarm|0|check_bfg|0|check_gems|1|check_lonely|" .. CheckIgnore .. "|check_ignoreo|" .. CheckIgnore .. "|check_ignoref|" .. CheckIgnore)
    Sleep(1000)
    end


function AutoConvertDLCheck()
  if AutoConvertDL and not IsConsuming then
    BGL = inv(7188) or 0
    DL = inv(1796) or 0
    local gemThreshold = EvadeTax and 100000 or 1000000
    if GetPlayerInfo().gems > gemThreshold then
      SendPacket(2, "action|dialog_return\ndialog_name|telephone\nnum|53785\nx|" .. (TelX - 1) .. "\ny|" .. (TelY - 1) .. "\nbuttonClicked|dlconvert")
      Sleep(700)
    end
    if BGL >= 100 then
      SendPacket(2, "action|dialog_return\ndialog_name|info_box\nbuttonClicked|make_bgl")
      Sleep(700)
    end
    if DL >= 100 then
      SendPacket(2, "action|dialog_return\ndialog_name|telephone\nnum|53785\nx|" .. (TelX - 1) .. "\ny|" .. (TelY - 1) .. "\nbuttonClicked|bglconvert")
      Sleep(700)
    end
  end
end

function ConsumeItem(consumeFlag, useFlag, itemID)
  wrenchMe()
  if not consumeFlag then
    Sleep(100)
    for i = 1, 1 do
      if useFlag then
        local x, y = getSitXYForConsume()
        SendPacketRaw(false, {
          type = 3,
          value = itemID,
          px = x,
          py = y,
          x = x * 32,
          y = y * 32
        })
        break
      end
    end
  end
end

while true do
  Sleep(250)
  ConsumeItem(ConsumeArroz, UseArroz, 4604)
  ConsumeItem(ConsumeClover, UseClover, 528)
  ConsumeItem(ConsumeSongpyeon, UseSongpyeon, 1056)
  Sleep(250)
  AutoConvertDLCheck()
  Sleep(250)
  if WebhookPNB then
  SendInfoPNB()
end
end
end
