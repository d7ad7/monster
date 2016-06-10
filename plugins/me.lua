do

local function run(msg, matches)
if is_sudo(msg) then 
        return "(انت مطور 😻🔕)".."\n".."(ايديك 🆔) "..msg.from.id.."\n".."(اسمك ♐️ ): "..msg.from.first_name.."\n".."(معرفك ♒️) @"..msg.from.username.."\n".."(اسم المجموعة 💟)  "..msg.to.title
end

if is_momod(msg) then 
        return "(انت مساعد المطور 💕😻) ".."\n".."( ايديك 🆔)  "..msg.from.id.."\n".."(اسمك ♐️ ): "..msg.from.first_name.."\n".."(معرفك ♒️) @"..msg.from.username.."\n".."(اسم المجموعة 💟) "..msg.to.title   
end
if not is_momod(msg) then 
        return "(انت عضو 😚😂)".."\n".."(ايديك 🆔) "..msg.from.id.."\n".."(اسمك ⛎ ): "..msg.from.first_name.."\n".."(معرفك ♒️) @"..msg.from.username.."\n".."(اسم المجموعة 💟) "..msg.to.title  
end
if is_owner(msg) then 
        return "(انت مدير الكروب 😚💕)".."\n".."(ايديك 🆔) "..msg.from.id.."\n".."(اسمك ⛎ ): "..msg.from.first_name.."\n".."(معرفك ♒️) @"..msg.from.username.."\n".."(اسم المجموعة 💟) "..msg.to.title
end
end

return {  
  patterns = {
       "^[!#/]([Mm]e)$"
  },
  run = run,
}

end