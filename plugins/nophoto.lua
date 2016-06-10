--[[ ▄▇▇▇▇▇▇▄▇▇▇▇▇▇▄

     ❉❉❉ ฿ᵧ ➣ @PXPP3
    
   ➥ CHANNEL ◐ @INSTAOFFICIAL
    ▄▇▇▇▇▇▇▄▇▇▇▇▇▇▄
]] 
do
function run(msg, matches)
if  msg.media and not is_momod(msg)  then
return "ممنوع ارسال الصور في هذا المجموعة يا @"..msg.from.username..'\n' 
else 
return msg 
end
end
return {
  patterns = {
"%[(photo)%]"

      
  },
run = run 
}
end