local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end

local function index_function(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

--By @saad7m
local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end

--By @saad7m
local function already_admin(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end

--By @saad7m
local function sudolist(msg)
local sudo_users = _config.sudo_users
local text = "قائمة المطورين 🗯🌝 :\n"
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end

local function adminlist(msg)
 text = '*قائمة مساعدين المطور 🌚🗯 :*\n'
		  	local compare = text
		  	local i = 1
		  	for v,user in pairs(_config.admins) do
			    text = text..i..'- '..(user[2] or '')..' ➣ ('..user[1]..')\n'
		  	i = i +1
		  	end
		  	if compare == text then
		  		text = 'لا يوجد مساعدين حاليا ☹️'
		  	end
		  	return text
    end

local function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return 'لا يوجد مجموعات حاليا'
    end
    local message = 'قائمة المجموعات:\n*Use #join (ID) to join*\n\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
        for m,n in pairsByKeys(settings) do
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				group_name_id = name .. '\n(ID: ' ..group_id.. ')\n\n'
				if name:match("[\216-\219][\128-\191]") then
					group_info = i..' - \n'..group_name_id
				else
					group_info = i..' - '..group_name_id
				end
				i = i + 1
			end
        end
		message = message..group_info
    end
	return message
end

local function run(msg, matches)
    local data = load_data(_config.moderation.data)
   if matches[1] == "المطورين" and is_sudo(msg) then
    return sudolist(msg)
   end
  if tonumber(msg.from.id) == tonumber(sudo_id) then
   if matches[1] == "رفع مطور" then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if already_sudo(tonumber(msg.reply.id)) then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` بالفعل مطور"
    else
          table.insert(_config.sudo_users, tonumber(msg.reply.id)) 
      print(msg.reply.id..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` تم رفعه مطور"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
   if not getUser(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if already_sudo(tonumber(matches[2])) then
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` بالفعل مطور"
    else
           table.insert(_config.sudo_users, tonumber(matches[2])) 
      print(matches[2]..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` تم رفعه مطور"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
   if not resolve_username(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[2])
   if already_sudo(tonumber(status.information.id)) then
    return "_المستخدم👤_ @"..check_markdown(status.information.username).." `"..status.information.id.."` بالفعل مطور"
    else
          table.insert(_config.sudo_users, tonumber(status.information.id)) 
      print(status.information.id..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
    return "_المستخدم👤_ @"..check_markdown(status.information.username).." `"..status.information.id.."` تم رفعه مطور"
     end
  end
end
   if matches[1] == "حذف مطور" then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not already_sudo(tonumber(msg.reply.id)) then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` بالفعل ليس مطور 😁"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(msg.reply.id)))
		save_config()
     reload_plugins(true) 
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` لم يعد مطور بعد الآن 😞✨"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if not already_sudo(tonumber(matches[2])) then
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` بالفعل ليس مطور 😁"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(matches[2])))
		save_config()
     reload_plugins(true) 
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` لم يعد مطور بعد الآن 😞✨"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
   if not resolve_username(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[2])
   if not already_sudo(tonumber(status.information.id)) then
    return "_المستخدم👤_ @"..check_markdown(status.information.username).." `"..status.information.id.."` بالفعل ليس مطور 😁"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(status.information.id)))
		save_config()
     reload_plugins(true) 
    return "_المستخدم👤_ @"..check_markdown(status.information.username).." `"..status.information.id.."` لم يعد مطور بعد الآن 😞✨"
          end
      end
   end
end
  if is_sudo(msg) then
   if matches[1] == "مساعد مطور" then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if already_admin(tonumber(msg.reply.id)) then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` بالفعل مساعد مطور"
    else
	    table.insert(_config.admins, {tonumber(msg.reply.id), username})
		save_config() 
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` تم رفعه مساعد مطور"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
   if not getUser(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if already_admin(tonumber(matches[2])) then
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` بالفعل مساعد مطور"
    else
	    table.insert(_config.admins, {tonumber(matches[2]), user_name})
		save_config()
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` تم رفعه مساعد مطور"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
   if not resolve_username(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[2])
   if already_admin(tonumber(status.information.id)) then
    return "_المستخدم👤_ @"..check_markdown(status.information.username).." `"..status.information.id.."` بالفعل مساعد مطور"
    else
	    table.insert(_config.admins, {tonumber(status.information.id), check_markdown(status.information.username)})
		save_config()
    return "_المستخدم👤_ @"..check_markdown(status.information.username).." `"..status.information.id.."` تم رفعه مساعد مطور"
     end
  end
end
   if matches[1] == "حذف مساعد" then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not already_admin(tonumber(msg.reply.id)) then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` ليس مساعد مطور مسبقا"
    else
	local nameid = index_function(tonumber(msg.reply.id))
		table.remove(_config.admins, nameid)
		save_config()
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _تم تنزيله من رتبة مساعد مطور"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if not already_admin(tonumber(matches[2])) then
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` ليس مساعد مطور مسبقا"
    else
	local nameid = index_function(tonumber(matches[2]))
		table.remove(_config.admins, nameid)
		save_config()
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` _تم تنزيله من رتبة مساعد مطور"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
   if not resolve_username(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[2])
   if not already_admin(tonumber(status.information.id)) then
    return "_المستخدم👤_ @"..check_markdown(status.information.username).." `"..status.information.id.."` ليس مساعد مطور مسبقا"
    else
	local nameid = index_function(tonumber(status.information.id))
		table.remove(_config.admins, nameid)
		save_config()
    return "_المستخدم👤_ @"..check_markdown(status.information.username).." `"..status.information.id.."` _تم تنزيله من رتبة مساعد مطور"
          end
      end
   end
end
  if is_sudo(msg) then
	if matches[1]:lower() == "ارسال ملف" and matches[2] and matches[3] and msg.reply_to_message then
		local send_file = "./"..matches[2].."/"..matches[3]
		sendDocument(msg.to.id, send_file, msg.id, "@kenamch")
	end
	if matches[1]:lower() == "اجلب ملف" and matches[2] then
	    local plug = "./plugins/"..matches[2]..".lua"
		sendDocument(msg.to.id, plug, msg.id, "@kenamch")
    end
	if matches[1]:lower() == "احفظ ملف" and matches[2]then
	local fn = matches[2]:gsub('(.*)/', '')
	local pt = matches[2]:gsub('/'..fn..'$', '')
if msg.reply_to_message then
if msg.reply_to_message.photo then
if msg.reply_to_message.photo[3] then
fileid = msg.reply_to_message.photo[3].file_id
elseif msg.reply_to_message.photo[2] then
fileid = msg.reply_to_message.photo[2].file_id
   else
fileid = msg.reply_to_message.photo[1].file_id
  end
elseif msg.reply_to_message.sticker then
fileid = msg.reply_to_message.sticker.file_id
elseif msg.reply_to_message.voice then
fileid = msg.reply_to_message.voice.file_id
elseif msg.reply_to_message.video then
fileid = msg.reply_to_message.video.file_id
elseif msg.reply_to_message.document then
fileid = msg.reply_to_message.document.file_id
end
downloadFile(fileid, "./"..pt.."/"..fn)
return "*ملف* `"..fn.."` _تم حفظه في_ *"..pt.."*"
  end
end
	if matches[1]:lower() == "حفظ" and matches[2] then
if msg.reply_to_message then
if msg.reply_to_message.document then
fileid = msg.reply_to_message.document.file_id
filename = msg.reply_to_message.document.file_name
if tostring(filename):match(".lua") then
downloadFile(fileid, "./plugins/"..matches[2]..".lua")
return "*ملف* `"..matches[2]..".lua` _تم حفظه_"
        end
     end
  end
end
if matches[1] == 'المساعدين' and is_admin(msg) then
return adminlist(msg)
    end
if matches[1] == 'المجموعات' and is_admin(msg) then
return chat_list(msg)
    end
		if matches[1] == 'تعطيل' and matches[2] and is_admin(msg) then
    local data = load_data(_config.moderation.data)
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
	   send_msg(matches[2], "Group has been removed by admin command", nil, 'md')
    return '_مجموعة_ *'..matches[2]..'* _تم حذفها_'
		end
     if matches[1] == 'غادر' and is_admin(msg) then
  leave_group(msg.to.id)
   end
     if matches[1] == 'رساله' and is_admin(msg) and matches[2] and matches[3] then
		local text = matches[2]
send_msg(matches[3], text)	end
 end
   if matches[1] == 'اذاعه' and is_sudo(msg) then		
  local data = load_data(_config.moderation.data)		
  local bc = matches[2]			
  for k,v in pairs(data) do				
send_msg(k, bc)			
  end	
end
     if matches[1] == 'غادر تلقائي' and is_admin(msg) then
local hash = 'AutoLeaveBot'
--Enable Auto Leave
     if matches[2] == 'تفعيل' then
    redis:del(hash)
   return 'الخروج التلقائي تم تفعيله'
--Disable Auto Leave
     elseif matches[2] == 'تعطيل' then
    redis:set(hash, true)
   return 'الخروج التلقائي تم تعطيله'
--Auto Leave Status
      elseif matches[2] == 'الحاله' then
      if not redis:get(hash) then
   return 'الخروج التلقائي مفعل'
       else
   return 'الخروج التلقائي معطل'
         end
      end
   end
---------------Help Tools----------------
  if matches[1] == "م4" and is_admin(msg) then
    local text = [[

_ﭑۇﭑمہۣۧڔٌ ﭑلہۣۧمہۣۧطہۣۧۇڔٌ لہۣۧسہۣۧۇڔٌسہۣۧ كہۣۧيہۣۧنہۣۧﭑمہۣۧ_

💎*تفعيل*

💎*تعطيل*

🚫*عام* `[للحضر عام]`

🚫*الغاء العام*
〰〰〰〰〰⛓

🏅*!رفع مطور* 

🏅*!حذف مطور* 

🏅*!المطورين *

🏅*!مساعد مطور* 

🏅*!حذف مساعد* 

🏅*!المساعدين *
〰〰〰〰〰⛓

🚹*!غادر * `[لمغادرة البوت]`

👁‍🗨*!غادر تلقائي* `[تعطيل/تفعيل]`

🎭*!المجموعات*

👁‍🗨*!تعطيل* `[id]`

🗣*!اذاعه* `[نص]`

🗣*!رساله* `[نص] [ايدي مجموعه]`
〰〰〰〰〰⛓

⭐️*!ارسال ملف* `[المجلد] [الملف]`

⭐️*!اجلب ملف* `[اسم الملف]`

⭐️*!حفظ* `[ملف مع الاسم] [بالرد]`

⭐️*!احفظ ملف* `[رابط/اسم ملف] [بالرد]`

🎭*!ترقية الكل* 👉🏻
_لرفع جميع المدراء بالمجموعه_
〰〰〰〰〰⛓

🌀الملفات `[لعرض الملفات]`
🌀ملف + `[اسم الملف]`لتفعيل ملف
🌀ملف - `[اسم الملف]`لتعطيل ملف
☯️تحديث `[لترسيت وتحديث الملفات]`
➖➖➖➖➖➖➖➖➖➖

]]
    return text
  end
end
return {
  patterns = {
    "^(م4)$",
    "^(رفع مطور)$",
    "^(حذف مطور)$",
    "^(رفع مطور) (.*)$",
    "^(حذف مطور) (.*)$",
    "^(المطورين)$",
    "^(مساعد مطور)$",
    "^(حذف مساعد)$",
    "^(مساعد مطور) (.*)$",
    "^(حذف مساعد) (.*)$",
    "^(المساعدين)$",
    "^(المجموعات)$",
    "^(ارسال ملف) (.*) (.*)$",
    "^(احفظ ملف) (.*)$",
    "^(رساله) (.*) (-%d+)$",
    "^(اذاعه) (.*)$",
    "^(اجلب ملف) (.*)$",
    "^(حفظ) (.*)$",
    "^(غادر)$",
    "^(leave)$",
    "^(الحاله)$",
    "^(غادر تلقائي) (.*)$",
    "^(تعطيل) (-%d+)$",
    },
  run = run,
  pre_process = pre_process
}
