
local function isBotAllowed (userId, chatId) 
  local hash = 'anti-bot:allowed:'..chatId..':'..userId 
  local banned = redis:get(hash) 
  return banned 
end 

local function allowBot (userId, chatId) 
  local hash = 'anti-bot:allowed:'..chatId..':'..userId 
  redis:set(hash, true) 
end 

local function disallowBot (userId, chatId) 
  local hash = 'anti-bot:allowed:'..chatId..':'..userId 
  redis:del(hash) 
end 

-- Is anti-bot enabled on chat 
local function isAntiBotEnabled (chatId) 
  local hash = 'anti-bot:enabled:'..chatId 
  local enabled = redis:get(hash) 
  return enabled 
end 

local function enableAntiBot (chatId) 
  local hash = 'anti-bot:enabled:'..chatId 
  redis:set(hash, true) 
end 

local function disableAntiBot (chatId) 
  local hash = 'anti-bot:enabled:'..chatId 
  redis:del(hash) 
end 

local function isABot (user) 
  -- Flag its a bot 0001000000000000 
  local binFlagIsBot = 4096 
  local result = bit32.band(user.flags, binFlagIsBot) 
  return result == binFlagIsBot 
end 

local function isABotBadWay (user) 
  local username = user.username or '' 
  return username:match("[Bb]ot$") 
end 

local function kickUser(userId, chatId) 
  local chat = 'chat#id'..chatId 
  local user = 'user#id'..userId 
  chat_del_user(chat, user, function (data, success, result) 
    if success ~= 1 then 
      print('I can\'t kick '..data.user..' but should be kicked') 
    end 
  end, {chat=chat, user=user}) 
end 

local function run (msg, matches) 

  -- We wont return text if is a service msg 
  if matches[1] ~= 'chat_add_user' and matches[1] ~= 'chat_add_user_link' then 
    if msg.to.type ~= 'chat' and msg.to.type ~= 'channel' then 
      return 'Anti bot works only on SuperGroup' 
    end 
  end 

  local chatId = msg.to.id 
  if matches[1] == 'lk' then 
    enableAntiBot(chatId) 
    return 'Anti bot lock on SuperGroup' 
  end 
  if matches[1] == 'un' then 
    disableAntiBot(chatId) 
    return 'Anti bot unlock on SuperGroup' 
  end 
  if matches[1] == 'skip' then 
    local userId = matches[2] 
    allowBot(userId, chatId) 
    return 'Bot '..userId..' skip' 
  end 
  if matches[1] == 'unskip' then 
    local userId = matches[2] 
    disallowBot(userId, chatId) 
    return 'Bot '..userId..' unskip' 
  end 
  if matches[1] == 'chat_add_user' or matches[1] == 'chat_add_user_link' then 
    local user = msg.action.user or msg.from 
    if isABotBadWay(user) then 
      print('It\'s a bot!') 
      if isAntiBotEnabled(chatId) then 
        print('Anti bot is enabled') 
        local userId = user.id 
        if not isBotAllowed(userId, chatId) then 
          kickUser("user#id"..userId, "channel#id"..chatId) 
         --chat_del_user(userId, chatId) 
          channel_kick_user("channel#id"..msg.to.id, 'user#id'..userId, ok_cb, false) 
        return "غير مسموح للبوتات هنا " 
          else 
          print('This bot is allowed') 
        end 
      end 
    end 
  end 
end 

return { 
  description = 'When bot enters group kick it.', 
  usage = { 
    '/antibot lock: Enable Anti-bot on current chat', 
    '/antibot unlock: Disable Anti-bot on current chat', 
    '/antibot skip <botId>: Allow <botId> on this chat', 
    '/antibot unskip <botId>: Disallow <botId> on this chat' 
  }, 
  patterns = { 
    '^/antibot (skip) (%d+)$', 
    '^/antibot (unskip) (%d+)$', 
    '^/bot (lk)$', 
    '^/bot (un)$', 
    '^!!tgservice (chat_add_user)$', 
    '^!!tgservice (chat_add_user_link)$' 
  }, 
  run = run 
} 
