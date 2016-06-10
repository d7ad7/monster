package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'

require("./bot/utils")

local f = assert(io.popen('/usr/bin/git describe --tags', 'r'))
VERSION = assert(f:read('*a'))
f:close()

-- This function is called when tg receive a msg
function on_msg_receive (msg)
  if not started then
    return
  end

  msg = backward_msg_format(msg)

  local receiver = get_receiver(msg)
  print(receiver)
  --vardump(msg)
  --vardump(msg)
  msg = pre_process_service_msg(msg)
  if msg_valid(msg) then
    msg = pre_process_msg(msg)
    if msg then
      match_plugins(msg)
      if redis:get("bot:markread") then
        if redis:get("bot:markread") == "on" then
          mark_read(receiver, ok_cb, false)
        end
      end
    end
  end
end

function ok_cb(extra, success, result)

end

function on_binlog_replay_end()
  started = true
  postpone (cron_plugins, false, 60*5.0)
  -- See plugins/isup.lua as an example for cron

  _config = load_config()

  -- load plugins
  plugins = {}
  load_plugins()
end

function msg_valid(msg)
  -- Don't process outgoing messages
  if msg.out then
    print('\27[36mNot valid: msg from us\27[39m')
    return false
  end

  -- Before bot was started
  if msg.date < os.time() - 5 then
    print('\27[36mNot valid: old msg\27[39m')
    return false
  end

  if msg.unread == 0 then
    print('\27[36mNot valid: readed\27[39m')
    return false
  end

  if not msg.to.id then
    print('\27[36mNot valid: To id not provided\27[39m')
    return false
  end

  if not msg.from.id then
    print('\27[36mNot valid: From id not provided\27[39m')
    return false
  end

  if msg.from.id == our_id then
    print('\27[36mNot valid: Msg from our id\27[39m')
    return false
  end

  if msg.to.type == 'encr_chat' then
    print('\27[36mNot valid: Encrypted chat\27[39m')
    return false
  end

  if msg.from.id == 777000 then
    --send_large_msg(*group id*, msg.text) *login code will be sent to GroupID*
    return false
  end

  return true
end

--
function pre_process_service_msg(msg)
   if msg.service then
      local action = msg.action or {type=""}
      -- Double ! to discriminate of normal actions
      msg.text = "!!tgservice " .. action.type

      -- wipe the data to allow the bot to read service messages
      if msg.out then
         msg.out = false
      end
      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end
   return msg
end

-- Apply plugin.pre_process function
function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      print('Preprocess', name)
      msg = plugin.pre_process(msg)
    end
  end
  return msg
end

-- Go over enabled plugins patterns.
function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end

-- Check if plugin is on _config.disabled_plugin_on_chat table
local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  -- Table exists and chat has disabled plugins
  if disabled_chats and disabled_chats[receiver] then
    -- Checks if plugin is disabled on this chat
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
        local warning = 'Plugin '..disabled_plugin..' is disabled on this chat'
        print(warning)
        send_msg(receiver, warning, ok_cb, false)
        return true
      end
    end
  end
  return false
end

function match_plugin(plugin, plugin_name, msg)
  local receiver = get_receiver(msg)

  -- Go over patterns. If one matches it's enough.
  for k, pattern in pairs(plugin.patterns) do
    local matches = match_pattern(pattern, msg.text)
    if matches then
      print("msg matches: ", pattern)

      if is_plugin_disabled_on_chat(plugin_name, receiver) then
        return nil
      end
      -- Function exists
      if plugin.run then
        -- If plugin is for privileged users only
        if not warns_user_not_allowed(plugin, msg) then
          local result = plugin.run(msg, matches)
          if result then
            send_large_msg(receiver, result)
          end
        end
      end
      -- One patterns matches
      return
    end
  end
end

-- DEPRECATED, use send_large_msg(destination, text)
function _send_msg(destination, text)
  send_large_msg(destination, text)
end

-- Save the content of _config to config.lua
function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config( )
  local f = io.open('./data/config.lua', "r")
  -- If config.lua doesn't exist
  if not f then
    print ("Created new config file: data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Sudo user: " .. user)
  end
  return config
end

-- Create a basic config.json file and saves it.
function create_config( )
  -- A simple config with basic plugins and ourselves as privileged user
  config = {
    enabled_plugins = {
     "admin",
    "anti_spam",
    "banhammer",
    "get",
    "set",
    "help",
    "dev",
    "music",
    "antibot",
    "addbot",
    "inpv",
    "tagall",
    "invite",
    "leave_ban",
    "msg_checks",
    "owners",
    "stats",
    "whitelist",
    "Banhelp",
    "plugins",
    "onservice",
    "ingroup",
    "inrealm",
    "help",
    "sphelp",
    "lockfwd",
    "linkpv",
    "sudo",
    "upredis",
    "badword",
    "me",
    "delenum",
    "azan",
    "time",
    "bye",
    "setbye",
    "shortlink",
    "supergroup",
    "nophoto",
    "translate",
    "weather"
    },
    sudo_users = { 0,tonumber(our_id)},--Sudo users
    moderation = {data = 'data/moderation.json'},
    about_text = [[! MonsterBot Vip
The advanced administration bot based on Tg-Cli. 🌐
It was built on a platform TeleSeed after it has been modified.🔧🌐
https://github.com/devmonstervip/monsterdev
Programmer🔰
@pxpp3
my channel 😍👍🏼
@INSTAOFFICIAL 🌚🔌
the source created by only me @PXPP3
,
    help_text = [[هناك ثلاث انواع من اوامر
sphelp
او 
spban
او
dvhelp
❍____↝◐sphelp◐↜____❍
___🔕🔒___🚨___🔔🔓___
جميع الاوامر تعمل بالاشارات [!/]
___🔕🔒___🚨___🔔🔓___
  ◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐
    #Lock Commands
  ◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐

🔒 lk member : قفل الاضافة❌
🔓 un member : فتح الاضافه✔

🔒 lk links : قفل الروابط❌
🔓 un links : فتح الروابط✔

🔒 lk sticker :️ قفل الملصقات❌
🔓 un sticker :  فتح الملصقات✔

🔒 lk flood : قفل التكرار❌
🔓 un flood : فتح التكرار✔
🔂 setflood 3>30 : لتحديد التكرار ↺

🔒 lk fwd : قفل اعادة التوجيه↺❌
🔓 un fwd : فتح اعاده توجيه↻✔

🔒 bot lk : قفل البوتات❌
🔓 bot un : فتح قفل البوتاتْ✔
  ◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐
   #Silent Commands
  ◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐↯◐
🔕 silent gifs : كتم الصور المتحركة
🔔 unsilent gifs : فتح كتم المتحركة
 
🔕 silent photo : كتم الصور 
🔔 unsilent photo : فتح كتم الصور
 
🔕 silent video : كتم الفيديو
🔔 unsilent video : فتح كتم الفيديو
 
🔕 silent audio : كتم البصمات
🔔 unsilent audio : فتح البصمات
 
🔕 silent all : كتم الكل 
🔔 unsilent all :  فتح كتم الكل 
📋 muteslist : معلومات كتم 
____🔩🆔___🚨___🔧⚙____
📋Info supergroup معلومات مجموعه
____🔩🆔___🚨___🔧⚙____
⚙[!/]settings : اعدادات المجوعه
📖[!/]info : معلومات مجموعه
📑[!/]rules : قوانين مجموعه
🚫[!/]clean rules : لتنظيف قوانين
👷[!/]modlist : لاضهار الادمنية
🚫[!/]clean modlist : لتنظيف ادمنية
👮[!/]owner : مشرف المجموعه
💀[!/]bots : لاضهار بوتات مجموعه
🆔[!/]who : ايديات مجموعه
😈[!/]me : موقعك في مجموعه
____✂✏___🚨___📐📈____
 📋اوامر الوضع تغيير وتعديل المجموعه
____✂✏___🚨___📐📈____
✏[!/]setname : لتغير الاسم مجموعه
✂[!/]setrules : لوضع قوانين مجموعه
🗻[!/]setphoto : لوضع صورة لمجموعه
📋[!/]setabout : لوضع وصف لمجموعه
____🃏🔧___🚨___👮⚙____
🔷👮اوامر رفع وخفض ادمن👮🔹
🔷[!/]promote : رفع ادمن
🔹[!/]demote : خفض ادمن 

👮[!/]setowner : لوضع مشرف 
🌐[!/]public yes : لجعل مجموعه عامه
🚫[!/]public no  : لجعل مجموعه خاصه
____📎📬___🚨___📨📎____
✉Group link رابط مجموعه📨
____📎📬___🚨___📨📎____
📬[!/]link : رابط مجموعه
📩[!/]linkpv :رابط مجموعه خااص
✉[!/]setlink : لوضع الرابط
📨[!/]newlink : لوضع رابط جديد
👮👮👮🃏🃏😈😈🃏🃏👮👮👮
🚨 Dev - : @PXPP3  ◐
🌐 CHANNEL - : @INSTAOFFICIAL ◐
____________MONSTERBOT♺ 
    by @pxpp3]],
help_text_realm = [[⇒⇒⇒⇒◐superban◐↜⇐⇐⇐⇐
🚫Commands for ban users🚫
 _______🚫______✅_________
🚫وامر طرد و حضر اعضاء[مشرفين]🚫
 _______🚫______✅_________
🚫[!/]ban + لحضر العضو : معرف
✅[!/]unban + لالغاء حضر العضو : معرف
 
❌[!/]kick + لطرد العضو : معرف
❌[!/]block + لطرد العضو : معرف
🚪[!/]kickme : لمغادرة المجموعه
 
📋[!/]banlist : قائمه المحضروين
 _______🚫______✅_________
🚫Commands for ban users🚫
 _______🚫______✔_________
🚫اوامر طرد وحضر اعضاء[مطورين]🚫
 _______🚫_______✔________
❎[!/]sban + لحضر العضو عام : معرف
✔[!/]unsban  :لالغاء حضر العام 

📋[!/]gbanlist : قائمه محضورين عام
 ______🔇🔞______🔊ℹ______
  🔊اوامر لمنع كلمات صمت اعضاء🔇
 ______🔇🔞______🔊ℹ______
🔴[!/]add + لمنع الكلمه : كلمه 🚫
🔴[!/]rm + لالغاء منع كلمه : كلمه✅
📋[!/]badwords : قائمة ممنوعات
🆑[!/]cleanbadwords : لحذف الممنوعات 

🔕[!/]muteuser + لكتم العضو : معرف
📋[!/]mutelist : قائمه مكتومين
🚫[!/]clean mutelist : لتنظيف المكتومين
 ______🃏🔧____👮⚙______
🚨 Dev - : @PXPP3  ◐
🌐 CHANNEL - : @INSTAOFFICIAL ◐
__________MONSTERBOT♺
  ]],
}
  serialize_to_file(config, './data/config.lua')
  print('saved config into ./data/config.lua')
end

function on_our_id (id)
  our_id = id
end

function on_user_update (user, what)
  --vardump (user)
end

function on_chat_update (chat, what)
  --vardump (chat)
end

function on_secret_chat_update (schat, what)
  --vardump (schat)
end

function on_get_difference_end ()
end

-- Enable plugins in config.json
function load_plugins()
  for k, v in pairs(_config.enabled_plugins) do
    print("Loading plugin", v)

    local ok, err =  pcall(function()
      local t = loadfile("plugins/"..v..'.lua')()
      plugins[v] = t
    end)

    if not ok then
      print('\27[31mError loading plugin '..v..'\27[39m')
	  print(tostring(io.popen("lua plugins/"..v..".lua"):read('*all')))
      print('\27[31m'..err..'\27[39m')
    end

  end
end

-- custom add
function load_data(filename)

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

function save_data(filename, data)

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end


-- Call and postpone execution for cron plugins
function cron_plugins()

  for name, plugin in pairs(plugins) do
    -- Only plugins with cron function
    if plugin.cron ~= nil then
      plugin.cron()
    end
  end

  -- Called again in 2 mins
  postpone (cron_plugins, false, 120)
end

-- Start and load values
our_id = 0
now = os.time()
math.randomseed(now)
started = false
