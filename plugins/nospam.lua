--[[ ▄▇▇▇▇▇▇▄▇▇▇▇▇▇▄

     ❉❉❉ ฿ᵧ ➣ @PXPP3
    
   ➥ CHANNEL ◐ @INSTAOFFICIAL
    ▄▇▇▇▇▇▇▄▇▇▇▇▇▇▄
]] 
do
local function run(msg, matches)

  delete_msg(msg.id, ok_cb, true)
    return "DON'T SEND LONG MSGS @"..msg.from.username..'\n'
 end
local function run(msg, matches)
  if ( tonumber(string.len(matches[1])) > 360 ) then
  delete_msg(msg.id, ok_cb, true)
  if (is_momod(msg)) then
      return nil
  else
     delete_msg(msg.id, ok_cb, true)
  return "لاتقم يارسال رسائل طويلة يا @"..msg.from.username..'\n'
    end
  end 
end
return {
  patterns = {
    "^(.*)",
    "^(.+)",
  },
  run = run,
}
end