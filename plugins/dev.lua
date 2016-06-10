do 

local function run(msg, matches) 

if ( msg.text ) then

  if ( msg.to.type == "user" ) then

     return "للتحدث مع المطور اضغط على المعرف التالي \n @PXPP3 \n او اذا محظور اضغط هنا \n @W7ISBOT \n قنأة البوت \n @INSTAOFFICIAL 👾 "
     
  end 
   
end 

-- #DEV @PXPP3

end 

return { 
  patterns = { 
       "(.*)$"
  }, 
  run = run, 
} 

end