--[[ ▄▇▇▇▇▇▇▄▇▇▇▇▇▇▄

     ❉❉❉ ฿ᵧ ➣ @PXPP3
    
   ➥ CHANNEL ◐ @INSTAOFFICIAL
    ▄▇▇▇▇▇▇▄▇▇▇▇▇▇▄
]] 
do

local function run(msg,matches)

local reply_id = msg['id']
if is_momod(msg) and matches[1]== 'sphelp' then
  local alnaze = [[❍____↝◐sphelp◐↜____❍
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
____________MONSTERBOT♺ ]]
reply_msg(reply_id, alnaze, ok_cb, false)
end

local reply_id = msg['id']
if not is_momod(msg) then
local alnaz = "للمشرفين فقط 🖕🏿😎"
reply_msg(reply_id, alnaze, ok_cb, false)
end

end
return {
patterns ={
  "^[!#/](sphelp)$",
},
run = run
}
end