--[[ ▄▇▇▇▇▇▇▄▇▇▇▇▇▇▄

     ❉❉❉ ฿ᵧ ➣ @PXPP3
    
   ➥ CHANNEL ◐ @INSTAOFFICIAL
    ▄▇▇▇▇▇▇▄▇▇▇▇▇▇▄
]] 
local function returnids(cb_extra, success, result) 
   local receiver = cb_extra.receiver 
   local get_cmd = cb_extra.get_cmd 
   local text = cb_extra.text 
   local chat_id = result.id 
   local chatname = result.print_name 
   local username = '' 
   if get_cmd == 'tagall' then 
      for k,v in pairs(result.members) do 
         if v.username then 
            username = username..' @'..v.username 
         else 
            username = username..' '..v.first_name 
         end 
      end 
      local text = username..text 
      send_large_msg(receiver, text) 
   end 
end 

local function run(msg, matches) 
   local receiver = get_receiver(msg) 
   if not is_chat_msg(msg) then 
      return 'This function only works on group' 
   end 
   local get_cmd = matches[1] 
   if matches[1] == 'tagall' then 
      if matches[2] then 
         local text = '\n\n=>'..matches[2] 
         chat_info(receiver, returnids, {receiver=receiver, get_cmd=get_cmd, text=text}) 
      else 
         local text = '' 
         chat_info(receiver, returnids, {receiver=receiver, get_cmd=get_cmd, text=text}) 
      end 
   end 
end 

return { 
   description = "Mention a message to all group participant.", 
   usage = { 
         moderator = { 
      "!tagall <message> : Mention all group members with custom message", 
      "!tagall : Mention all group members"}, 
   }, 
   patterns = { 
      "^[!/](tagall) +(.+)$", 
      "^[!/](tagall)$", 
   }, 
   run = run, 
   moderated = true 
}