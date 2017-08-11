-- groupmanager.lua by @kenamch
local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return '_انت لست ادمن 🐝_'
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
   return '_مجموعة_* ['..msg.to.title..']*_ بالفعل تم اضافتها ☹️_'
end
local status = getChatAdministrators(msg.to.id).result
for k,v in pairs(status) do
if v.status == "creator" then
if v.user.username then
creator_id = v.user.id
user_name = '@'..check_markdown(v.user.username)
else
user_name = check_markdown(v.user.first_name)
end
end
end
        -- create data array in moderation.json
      data[tostring(msg.to.id)] = {
              owners = {[tostring(creator_id)] = user_name},
      mods ={},
      banned ={},
      is_silent_users ={},
      filterlist ={},
      settings = {
          set_name = msg.to.title,
          lock_link = 'yes',
          lock_tag = 'yes',
          lock_spam = 'yes',
          lock_edit = 'no',
          lock_mention = 'no',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes',
          lock_pin = 'no',
          welcome = 'no',
		  lock_join = 'no',
		  lock_arabic = 'no',
		  num_msg_max = '5',
		  set_char = '40',
		  time_check = '2',
          },
   mutes = {
                  mute_forward = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photo = 'no',
                  mute_gif = 'no',
                  mute_location = 'no',
                  mute_document = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                   mute_all = 'no',
				   mute_tgservice = 'no',
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
  return '*مجموعة ['..msg.to.title..'] تم اضافتها ضمن مجموعاتي 👁‍🗨*\n💎〰〰〰〰〰〰〰\nøяđeявч :'..msg.from.first_name
end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        return '_انت لست ادمن 🐝_'
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
    return '_مجموعة ليست مضافه 😣_'
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
  return '*تم حذف المجموعه 🤓*\n💎〰〰〰〰〰〰〰\nøяđeявч :'..msg.from.first_name
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return "_مجموعة ليست مضافه 😣_"
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
    return "المجموعه خاليه من المدراء 😩\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
   message = '*قائمة المدراء 🤓 :*\n'
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return "_مجموعة ليست مضافه 😣_"
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
    return "_المجموعه خاليه من المشرفين 😣_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
   message = '*List of owners :*\n'
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function filter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][(word)] then
        return "_كلمة_ *"..word.."* _بالفعل ممنوعه 😆_"
      end
    data[tostring(msg.to.id)]['filterlist'][(word)] = true
    save_data(_config.moderation.data, data)
      return "_كلمة_ *"..word.."* _تم اضافتها للمنع 🚫_"
    end

local function unfilter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
      save_data(_config.moderation.data, data)
        return "_كلمة_ *"..word.."* _تم حذفها من المنع 🙂_"
    else
        return "_كلمة_ *"..word.."* _ليست ممنوعه مسبقا 😩_"
    end
  end

local function lock_link(msg, data, target)
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
 return "*الروابط 🎗* _` بالفعل مقفوله_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
 return "*الروابط 🎗* تم القفل\n〰〰〰〰〰〰〰〰\n*øяđeявч* : "..msg.from.first_name
end
end

local function unlock_link(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
return "*الروابط 🎗* _` بالفعل مفتوحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name 
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
return "*الروابط*  تم الفتح \n〰〰〰〰〰〰〰〰\n*øяđeявч* : "..msg.from.first_name
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
 return "*التاك#/@* _` بالفعل مقفول_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
 return "*التاك#/@* تم القفل\n〰〰〰〰〰〰〰〰\n*øяđeявч* : "..msg.from.first_name
end
end

local function unlock_tag(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
return "*التاك#/@* _` بالفعل مفتوح_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name 
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
return "*التاك#/@* تم الفتح\n〰〰〰〰〰〰〰〰\n*øяđeявч*: "..msg.from.first_name
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
 return "*المنشن 👀* _` بالفعل مقفول_"
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
 return "*المنشن 👀* تم القفل\n〰〰〰〰〰〰〰〰\n*øяđeявч* : "..msg.from.first_name
end
end

local function unlock_mention(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
return "*المنشن 👀* _` بالفعل مفتوح_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
return "*المنشن 👀* تم الفتح\n〰〰〰〰〰〰〰〰\n*øяđeявч*: "..msg.from.first_name
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
 return "*العربيه 🎩* _` بالفعل مقفوله_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
 return "*العربيه 🎩* تم القفل\n〰〰〰〰〰〰〰〰\n*øяđeявч* : "..msg.from.first_name
end
end

local function unlock_arabic(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
return "*العربيه 🎩* _` بالفعل مفتوحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
return "*العربيه 🎩* تم الفتح\n〰〰〰〰〰〰〰〰\n*øяđeявч*: "..msg.from.first_name
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
 return "*التعديل ✍🏻* _بالفعل مقفول_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
 return "*التعديل ✍🏻* _تم قفله_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unlock_edit(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
return "*التعديل ✍🏻* _بالفعل مفتوح_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
return "*التعديل ✍🏻* _تم فتحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
 return "*الكلايش 🔖* _بالفعل مقفوله_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
 return "*الكلايش 🔖* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unlock_spam(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
return "*الكلايش 🔖* _ بالفعل مفتوحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data)
return "*الكلايش 🔖* تم الفتح\n〰〰〰〰〰〰〰〰\n*øяđeявч*: "..msg.from.first_name
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_flood = data[tostring(target)]["settings"]["lock_flood"] 
if lock_flood == "yes" then
 return "*التكرار 🗣* _بالفعل مقفول_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["settings"]["lock_flood"] = "yes"
save_data(_config.moderation.data, data) 
 return "*التكرار 🗣* _تم قفله_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unlock_flood(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local lock_flood = data[tostring(target)]["settings"]["lock_flood"]
 if lock_flood == "no" then
return "*التكرار 🗣* _بالفعل مفتوح_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["settings"]["lock_flood"] = "no" save_data(_config.moderation.data, data) 
return "*التكرار 🗣* _تم فتحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
 return "*البوتات 🚀* _` بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
 return "*البوتات 🚀* _` تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unlock_bots(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
return "*البوتات 🚀* _بالفعل مفتوحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
return "*البوتات 🚀* _` تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

---------------Lock Join-------------------
local function lock_join(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "yes" then
 return "*الدخول ⛹🏻* _بالفعل مقفول_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["settings"]["lock_join"] = "yes"
save_data(_config.moderation.data, data) 
 return "*الدخول ⛹🏻* _تم قفله_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unlock_join(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"]
 if lock_join == "no" then
return "*الدخول ⛹🏻* _بالفعل مفتوح_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["settings"]["lock_join"] = "no"
save_data(_config.moderation.data, data) 
return "*الدخول ⛹🏻* _تم فتحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
 return "*الماركدون 〰* _` بالفعل مقفول_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
 return "*الماركدون 〰* تم القفل\n〰〰〰〰〰〰〰〰\n*øяđeявч* : "..msg.from.first_name
end
end

local function unlock_markdown(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
return "*الماركدون 〰* _بالفعل مفتوح_"
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
return "*الماركدون 〰* تم الفتح\n〰〰〰〰〰〰〰〰\n*øяđeявч*: "..msg.from.first_name
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
 return "*الصفحات 🌍* _بالفعل مقفوله_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
 return "*الصفحات 🌍* _تم قفلها_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unlock_webpage(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
return "*الصفحات 🌍* _بالفعل مفتوحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
return "*الصفحات 🌍* _تم فتحها_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
 return "*التثبيت 👁‍🗨* _بالفعل مقفول_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
 return "*التثبيت 👁‍🗨* _تم قفله_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unlock_pin(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
return "*التثبيت 👁‍🗨* _بالفعل مفتوح_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
return "*التثبيت 👁‍🗨* _تم فتحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

function group_settings(msg, target) 	
if not is_mod(msg) then
 	return "_انت لست ادمن _ *😐😒*"
end
local data = load_data(_config.moderation.data)
local settings = data[tostring(target)]["settings"] 
text = "*❌ تعني مفتوح \n✅ تعني مقفول :*\n\n_التعديل ✍🏻 :_ *"..settings.lock_edit.."*\n_الروابط 🎗:_ *"..settings.lock_link.."*\n_التاك #@/ :_ *"..settings.lock_tag.."*\n_الدخول 🚶🏻:_ *"..settings.lock_join.."*\n_التكرار 🗯:_ *"..settings.flood.."*\n_الكلايش ☠️ :_ *"..settings.lock_spam.."*\n_المنشن 🤝 :_ *"..settings.lock_mention.."*\n_العربيه 🚹 :_ *"..settings.lock_arabic.."*\n_الصفحات 🌍 :_ *"..settings.lock_webpage.."*\n_الماركدون 〰 :_ *"..settings.lock_markdown.."*\n_الترحيب 💎:_ *"..settings.welcome.."*\n_التثبيت ⭐️ :_ *"..settings.lock_pin.."*\n_البوتات 🤖 :_ *"..settings.lock_bots.."*\n_عدد التكرار🗯:_ *"..settings.num_msg_max.."*\n_حساسية الاحرف® :_ *"..settings.set_char.."*\n_فحص زمن التكرار👁‍🗨 :_ *"..settings.time_check.."*\n*➖➖➖➖➖➖➖➖*\n*قناة البوت 💭*: @kenamch"
text = string.gsub(text, 'yes', '✅')
text = string.gsub(text, 'no', '❌')
text = string.gsub(text, '0', '0⃣')
text = string.gsub(text, '1', '1⃣')
text = string.gsub(text, '2', '2️⃣')
text = string.gsub(text, '3', '3️⃣')
text = string.gsub(text, '4', '4️⃣')
text = string.gsub(text, '5', '5️⃣')
text = string.gsub(text, '6', '6️⃣')
text = string.gsub(text, '7', '7️⃣')
text = string.gsub(text, '8', '8️⃣')
text = string.gsub(text, '9', '9️⃣')
return text
end

--------Mute all--------------------------
local function mute_all(msg, data, target) 
if not is_mod(msg) then 
return "_انت لست ادمن _ *😐😒*" 
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
return "*الكل 👥* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
return "*الكل 👥* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_all(msg, data, target) 
if not is_mod(msg) then 
return "_انت لست ادمن _ *😐😒*" 
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
return "*الكل 👥* _بالفعل مفتوحه _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
return "*الكل 👥* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
 return "*المتحركه 👻* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*المتحركه 👻* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_gif(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
return "*المتحركه 👻* _بالفعل مفتوحه _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
return "*المتحركه 👻* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
 return "*النصوص ✍🏻* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*النصوص ✍🏻* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_text(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
return "*النصوص ✍🏻* _بالفعل مفتوحه _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
return "*النصوص ✍🏻* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
 return "*الصور 🎩* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*الصور 🎩* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_photo(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
return "*الصور 🎩* _بالفعل مفتوحه _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
return "*الصور 🎩* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
 return "*الفديو 🎬* _بالفعل مقفول_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
 return "*الفديو 🎬* _تم قفله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
return "*الفديو 🎬* _بالفعل مفتوح _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
return "*الفديو 🎬* _تم فتحه _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
 return "*الصوت 🎤* _بالفعل مقفول_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*الصوت 🎤* _تم قفله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_audio(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
return "*الصوت 🎤* _بالفعل مفتوح _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
return "*الصوت 🎤* _تم فتحه _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
 return "*البصمات 🗣* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*البصمات 🗣* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_voice(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
return "*البصمات 🗣* _بالفعل مفتوحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
return "*البصمات 🗣* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
 return "*الملسقات 👄* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*الملسقات 👄* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_sticker(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
return "*الملسقات 👄* _بالفعل مفتوحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
return "*الملسقات 👄* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
 return "*الجهات 📲* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*الجهات 📲* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_contact(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
return "*الجهات 📲* _بالفعل مفتوحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
return "*الجهات 📲* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
 return "*التوجيه 🌀* _بالفعل مقفول _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*التوجيه 🌀* _تم قفله_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_forward(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
return "*التوجيه 🌀* _بالفعل مفتوح _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
return "*التوجيه 🌀* _تم فتحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
 return "*المواقع 🌐* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
 return "*المواقع 🌐* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_location(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
return "*المواقع 🌐* _بالفعل مفتوحه_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
return "*المواقع 🌐* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
 return "*الملفات 📚* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*الملفات 📚* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_document(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
return "*الملفات 📚* _بالفعل مفتوحه _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
return "*الملفات 📚* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
if not is_mod(msg) then
 return "_انت لست ادمن _ *😐😒*"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
 return "*الاشعارات 📌* _بالفعل مقفوله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*الاشعارات 📌* _تم قفلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

local function unmute_tgservice(msg, data, target)
 if not is_mod(msg) then
return "_انت لست ادمن _ *😐😒*"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
return "*الاشعارات 📌* _بالفعل مفتوحه _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
return "*الاشعارات 📌* _تم فتحها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end

----------MuteList---------
local function mutes(msg, target) 	
if not is_mod(msg) then
 	return "_انت لست ادمن _ *😐😒*"	
end
local data = load_data(_config.moderation.data)
local mutes = data[tostring(target)]["mutes"] 
 text = " *❌ تعني مفتوح\n ✅ تعني مقفول* : \n\n_الكل 👥 : _ *"..mutes.mute_all.."*\n_المتحركه 👻 :_ *"..mutes.mute_gif.."*\n_النصوص ✍🏻:_ *"..mutes.mute_text.."*\n_الصور 🎩 :_ *"..mutes.mute_photo.."*\n_الفديو 🎬 :_ *"..mutes.mute_video.."*\n_الصوت 🎤 :_ *"..mutes.mute_audio.."*\n_البصمات 🗣 :_ *"..mutes.mute_voice.."*\n_الملسقات 👄 :_ *"..mutes.mute_sticker.."*\n_الجهات 📲 :_ *"..mutes.mute_contact.."*\n_التوجيه 🌀 :_ *"..mutes.mute_forward.."*\n_المواقع 🌐 :_ *"..mutes.mute_location.."*\n_الملفات 📚 :_ *"..mutes.mute_document.."*\n_الاشعارات 📌 :_ *"..mutes.mute_tgservice.."*\n*➖➖➖➖➖➖➖➖*\n*قناة البوت 💭*: @kenamch"
text = string.gsub(text, 'yes', '✅')
text = string.gsub(text, 'no', '❌')
 return text
end

local function kenamch(msg, matches)
local data = load_data(_config.moderation.data)
local target = msg.to.id
----------------Begin Msg Matches--------------
if matches[1] == "تفعيل" and is_admin(msg) then
return modadd(msg)
   end
if matches[1] == "تعطيل" and is_admin(msg) then
return modrem(msg)
   end
if matches[1] == "المشرفين" and is_mod(msg) then
return ownerlist(msg)
   end
if matches[1] == "الكلمات الممنوعه" and is_mod(msg) then
return filter_list(msg)
   end
if matches[1] == "المدراء" and is_mod(msg) then
return modlist(msg)
   end
if matches[1] == "البيضاء" and is_mod(msg) then
return whitelist(msg.to.id)
   end
if matches[1] == "تدقيق" and matches[2] and is_mod(msg) then
		local user = getUser(matches[2])
		if not user.result then
			return 'المستخدم👤 غير موجود'
		end
		user = user.information
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		local text = 'المعرف 🎗 : @'..(check_markdown(user.username) or '')..' \nالاسم الاول🗯: '..escape_markdown(user.firstname)..' \nالاسم الثاني💡: '..lst_name..' \nالبايو 💎: '..(escape_markdown(user.bio) or '')
		return text
end
if matches[1] == "فحص" and matches[2] and is_mod(msg) then
		local user = resolve_username(matches[2])
		if not user.result then
			return 'المستخدم👤 غير موجود'
		end
		user = user.information
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		local text = 'المعرف 🎗 : @'..(check_markdown(user.username) or '')..' \nالاسم الاول🗯: '..escape_markdown(user.firstname)..' \nالاسم الثاني💡: '..lst_name..' \nالبايو 💎: '..(escape_markdown(user.bio) or '')
		return text
end
if matches[1] == 'المطور' or matches[1] == "كينام" or matches[1] == "السورس" then
return _config.info_text
end
if matches[1] == "ايدي" then
   if not matches[2] and not msg.reply_to_message then
local status = getUserProfilePhotos(msg.from.id, 0, 0)
   if status.result.total_count ~= 0 then
	sendPhotoById(msg.to.id, status.result.photos[1][1].file_id, msg.id, 'المجموعه💎: '..msg.to.id..'\nالمستخدم🚹: '..msg.from.id..'\nاسمك💡:'..msg.from.first_name)
	else
   return "*المجموعه💎 :* `"..tostring(msg.to.id).."`\n*المستخدم🚹 :* `"..tostring(msg.from.id).."`"
   end
   elseif msg.reply_to_message and not msg.reply.fwd_from and is_mod(msg) then
     return "`"..msg.reply.id.."`"
   elseif not string.match(matches[2], '^%d+$') and matches[2] ~= "from" and is_mod(msg) then
    local status = resolve_username(matches[2])
		if not status.result then
			return 'المستخدم👤 غير موجود'
		end
     return "`"..status.information.id.."`"
   elseif matches[2] == "from" and msg.reply_to_message and msg.reply.fwd_from then
     return "`"..msg.reply.fwd_from.id.."`"
   end
end
if matches[1] == "تثبيت" and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "*تم تثبيت الرساله*\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "*تم تثبيت الرساله*\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
if matches[1] == 'الغاء تثبيت' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
unpinChatMessage(msg.to.id)
return "*تم الغاء تثبيت الرساله*\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
unpinChatMessage(msg.to.id)
return "*تم الغاء تثبيت الرساله*\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
end
if matches[1] == 'اعدادات2' then
return mutes(msg, target)
end
if matches[1] == 'اعدادات' then
return group_settings(msg, target)
end
   if matches[1] == "رفع مشرف" and is_admin(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _بالفعل_ *مشرف المجموعه*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _الآن_ *مشرف المجموعه*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` _بالفعل_ *مشرف المجموعه*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` _الآن_ *مشرف المجموعه*"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _بالفعل_ *مشرف المجموعه*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _الآن_ *مشرف المجموعه*"
   end
end
end
   if matches[1] == "حذف مشرف" and is_admin(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _بالفعل ليس_ *مشرف المجموعه*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _لم يعد_ *مشرف المجموعه*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` _بالفعل ليس_ *مشرف المجموعه*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` _لم يعد_ *مشرف المجموعه*"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _بالفعل ليس_ *مشرف المجموعه*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _لم يعد_ *مشرف المجموعه*"
      end
end
end
   if matches[1] == "رفع مدير" and is_owner(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _بالفعل_ *مدير المجموعه*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _الآن_ *مدير المجموعه*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` _بالفعل_ *مدير المجموعه*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` _الآن_ *مدير المجموعه*"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['mods'][tostring(user_id)] then
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _بالفعل_ *مدير المجموعه*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _الآن_ *مدير المجموعه*"
   end
end
end
   if matches[1] == "حذف مدير" and is_owner(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _بالفعل ليس_ *مدير المجموعه*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _لم يعد_ *مدير المجموعه*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` _بالفعل ليس_ *مدير المجموعه*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..user_name.." `"..matches[2].."` _لم يعد_ *مدير المجموعه*"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['mods'][tostring(status.id)] then
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _بالفعل ليس_ *مدير المجموعه*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _لم يعد_ *مدير المجموعه*"
      end
end
end
   if matches[1] == "البيضاء" and matches[2] == "+" and is_mod(msg) then
   if not matches[3] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _بالفعل _ *مميز*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _اصبح_ *مميز*"
      end
	  elseif matches[3] and matches[3]:match('^%d+') then
  if not getUser(matches[3]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[3]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[3]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] then
    return "_المستخدم👤_ "..user_name.." `"..matches[3].."` _بالفعل _ *مميز*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] = user_name
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..user_name.." `"..matches[3].."` _اصبح_ *مميز*"
   end
   elseif matches[3] and not matches[3]:match('^%d+') then
  if not resolve_username(matches[3]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[3]).information
   if data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _بالفعل _ *مميز*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _اصبح_ *مميز*"
   end
end
end
   if matches[1] == "البيضاء" and matches[2] == "-" and is_mod(msg) then
      if not matches[3] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _بالفعل ليس _ *مميز*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..username.." `"..msg.reply.id.."` _لم يعد_ *مميز*"
      end
	  elseif matches[3] and matches[3]:match('^%d+') then
  if not getUser(matches[3]).result then
   return "*المستخدم👤 غير موجود*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[3]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[3]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] then
    return "_المستخدم👤_ "..user_name.." `"..matches[3].."` _بالفعل ليس _ *مميز*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] = nil
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ "..user_name.." `"..matches[3].."` _لم يعد_ *مميز*"
      end
   elseif matches[3] and not matches[3]:match('^%d+') then
  if not resolve_username(matches[3]).result then
   return "*المستخدم👤 غير موجود*"
    end
   local status = resolve_username(matches[3]).information
   if not data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _بالفعل ليس _ *مميز*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "_المستخدم👤_ @"..check_markdown(status.username).." `"..status.id.."` _removed_ *مميز*"
      end
end
end
if matches[1]:lower() == "قفل" and is_mod(msg) then
if matches[2] == "الروابط" then
return lock_link(msg, data, target)
end
if matches[2] == "التاك" then
return lock_tag(msg, data, target)
end
if matches[2] == "المنشن" then
return lock_mention(msg, data, target)
end
if matches[2] == "العربيه" then
return lock_arabic(msg, data, target)
end
if matches[2] == "التعديل" then
return lock_edit(msg, data, target)
end
if matches[2] == "الكلايش" then
return lock_spam(msg, data, target)
end
if matches[2] == "التكرار" then
return lock_flood(msg, data, target)
end
if matches[2] == "البوتات" then
return lock_bots(msg, data, target)
end
if matches[2] == "الماركدون" then
return lock_markdown(msg, data, target)
end
if matches[2] == "الصفحات" then
return lock_webpage(msg, data, target)
end
if matches[2] == "التثبيت" and is_owner(msg) then
return lock_pin(msg, data, target)
end
if matches[2] == "الدخول" then
return lock_join(msg, data, target)
end
end
if matches[1]:lower() == "فتح" and is_mod(msg) then
if matches[2] == "الروابط" then
return unlock_link(msg, data, target)
end
if matches[2] == "التاك" then
return unlock_tag(msg, data, target)
end
if matches[2] == "المنشن" then
return unlock_mention(msg, data, target)
end
if matches[2] == "العربيه" then
return unlock_arabic(msg, data, target)
end
if matches[2] == "التعديل" then
return unlock_edit(msg, data, target)
end
if matches[2] == "الكلايش" then
return unlock_spam(msg, data, target)
end
if matches[2] == "التكرار" then
return unlock_flood(msg, data, target)
end
if matches[2] == "البوتات" then
return unlock_bots(msg, data, target)
end
if matches[2] == "الماركدون" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "الصفحات" then
return unlock_webpage(msg, data, target)
end
if matches[2] == "التثبيت" and is_owner(msg) then
return unlock_pin(msg, data, target)
end
if matches[2] == "الدخول" then
return unlock_join(msg, data, target)
end
end
if matches[1]:lower() == "قفل" and is_mod(msg) then
if matches[2] == "المتحركه" then
return mute_gif(msg, data, target)
end
if matches[2] == "النصوص" then
return mute_text(msg ,data, target)
end
if matches[2] == "الصور" then
return mute_photo(msg ,data, target)
end
if matches[2] == "الفديو" then
return mute_video(msg ,data, target)
end
if matches[2] == "الصوت" then
return mute_audio(msg ,data, target)
end
if matches[2] == "البصمات" then
return mute_voice(msg ,data, target)
end
if matches[2] == "الملسقات" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "الجهات" then
return mute_contact(msg ,data, target)
end
if matches[2] == "التوجيه" then
return mute_forward(msg ,data, target)
end
if matches[2] == "المواقع" then
return mute_location(msg ,data, target)
end
if matches[2] == "الملفات" then
return mute_document(msg ,data, target)
end
if matches[2] == "الاشعارات" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == 'الكل' then
return mute_all(msg ,data, target)
end
end
if matches[1]:lower() == "فتح" and is_mod(msg) then
if matches[2] == "المتحركه" then
return unmute_gif(msg, data, target)
end
if matches[2] == "النصوص" then
return unmute_text(msg, data, target)
end
if matches[2] == "الصور" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "الفديو" then
return unmute_video(msg ,data, target)
end
if matches[2] == "الصوت" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "البصمات" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "الملسقات" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "الجهات" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "التوجيه" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "المواقع" then
return unmute_location(msg ,data, target)
end
if matches[2] == "الملفات" then
return unmute_document(msg ,data, target)
end
if matches[2] == "الاشعارات" then
return unmute_tgservice(msg ,data, target)
end
 if matches[2] == 'الكل' then
return unmute_all(msg ,data, target)
end
end
  if matches[1] == 'منع' and matches[2] and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'سماح' and matches[2] and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
		if matches[1] == 'ضع رابط' and is_owner(msg) then
		data[tostring(target)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '_جيد 💡 الآن قم بارسال الرابط _'
	   end
		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(target)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(target)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
				return "ممتاز 💎 تم حفظ رابط جديد\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
       end
		end
    if matches[1] == 'الرابط' and is_mod(msg) then
      local linkgp = data[tostring(target)]['settings']['linkgp']
      if not linkgp then
        return "_انا لست صانع المجموعه يجب ارسال امر_ /ضع رابط"
      end
       text = "[اضغط هنا لدخول مجموعة ➣ { "..msg.to.title.." }]("..check_markdown(linkgp)..")"
        return text
     end
  if matches[1] == "ضع قوانين" and matches[2] and is_mod(msg) then
    data[tostring(target)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
    return "تم وضع قوانين المجموعه\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
  end
  if matches[1] == "القوانين" then
 if not data[tostring(target)]['rules'] then
      rules = "ℹ️ القوانين الافتراضيه:\n1️⃣ عدم تكرار الرسائل لتجنب الطرد.\n2️⃣ الكلايش الطويله ممنوعه.\n3️⃣ السب والشتم ممنوع.\n4️⃣ الاعلانات والروابط ممنوعه.\n5️⃣ الزحف ومضايقة الاعضاء طرد.\n➡️ احترم تحترم واخلاقك تعكس تربيتك.\n@kenamch"
        else
     rules = "*قوانين المجموعه 👁‍🗨 :*\n"..data[tostring(target)]['rules']
      end
    return rules
  end
		if matches[1]:lower() == 'حساسية الاحرف' then
			if not is_mod(msg) then
				return
			end
			local chars_max = matches[2]
			data[tostring(msg.to.id)]['settings']['set_char'] = chars_max
			save_data(_config.moderation.data, data)
     return "*حساسية الاحرف* _تم وضعها على العدد :_ *[ "..matches[2].." ]*"
  end
  if matches[1]:lower() == 'ضع تكرار' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "🚹 لا يمكن وضع عدد اكثر من *[2-50]*"
      end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "🚹 تم ضبط التكرار على العدد  : *[ "..matches[2].." ]*"
       end
  if matches[1]:lower() == 'ضع زمن التكرار' and is_mod(msg) then
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 10 then
				return "🚹 لا يمكن وضع عدد اكثر من *[2-10]*"
      end
			local time_max = matches[2]
			data[tostring(msg.to.id)]['settings']['time_check'] = time_max
			save_data(_config.moderation.data, data)
    return "🚹 تم وضع زمن التكرار على : *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'تنظيف' and is_owner(msg) then
			if matches[2] == 'المدراء' then
				if next(data[tostring(msg.to.id)]['mods']) == nil then
					return "لا يوجد مدراء سابقا 😑\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
            end
				for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
					data[tostring(msg.to.id)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "تم تنظيف قائمة المدراء 😄\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
         end
			if matches[2] == 'الكلمات الممنوعه' then
				if next(data[tostring(msg.to.id)]['filterlist']) == nil then
					return "قائمة الكلمات الممنوعه خاليه 😑\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
				end
				for k,v in pairs(data[tostring(msg.to.id)]['filterlist']) do
					data[tostring(msg.to.id)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "تم تنظيف قائمة الكلمات الممنوعه ✨\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
			end
			if matches[2] == 'القوانين' then
				if not data[tostring(msg.to.id)]['rules'] then
					return "لم يتم وضع قوانين مسبقا \n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
				end
					data[tostring(msg.to.id)]['rules'] = nil
					save_data(_config.moderation.data, data)
				return "*قوانين المجموعه 👁‍🗨*تم تنظيف\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
       end
			if matches[2] == 'الترحيب' then
				if not data[tostring(msg.to.id)]['setwelcome'] then
					return "*رسالة الترحيب 👋🏻 لم يتم وضع*\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
				end
					data[tostring(msg.to.id)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
				return "*رسالة الترحيب 👋🏻*تم تنظيف\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
       end
			if matches[2] == 'الوصف' then
        if msg.to.type == "group" then
				if not data[tostring(msg.to.id)]['about'] then
					return "لم يتم وضع وصف للمجموعه 🙌🏻\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
				end
					data[tostring(msg.to.id)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, "")
             end
				return "*وصف المجموعه ✨*تم تنظيف\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
		   	end
        end
		if matches[1]:lower() == 'تنظيف' and is_admin(msg) then
			if matches[2] == 'المشرفين' then
				if next(data[tostring(msg.to.id)]['owners']) == nil then
					return "لا يوجد مشرفين في المجموعه😅\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
				end
				for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
					data[tostring(msg.to.id)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "تم تنظيف قائمة المشرفين ✨\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
			end
     end
if matches[1] == "ضع اسم" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
setChatTitle(msg.to.id, gp_name)
end
if matches[1] == 'ضع صوره' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
     if not msg.caption and not msg.reply_to_message then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '_Please send the new group_ *photo* _now_'
     elseif not msg.caption and msg.reply_to_message then
if msg.reply_to_message.photo then
if msg.reply_to_message.photo[3] then
fileid = msg.reply_to_message.photo[3].file_id
elseif msg.reply_to_message.photo[2] then
fileid = msg.reply_to_message.photo[2].file_id
   else
fileid = msg.reply_to_message.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "*تم حفظ الصوره*"
     elseif msg.caption and not msg.reply_to_message then
if msg.photo then
if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "*تم حفظ الصوره*"
		end
  end
if matches[1] == "احذف الصوره" and is_mod(msg) then
deleteChatPhoto(msg.to.id)
  return "*Group Photo* _has been_ *removed*\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
  if matches[1] == "ضع وصف" and matches[2] and is_mod(msg) then
     if msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, matches[2])
    elseif msg.to.type == "group" then
    data[tostring(msg.to.id)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
    return "*وصف المجموعه ✨* _تم وضع_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
  end
  if matches[1] == "الوصف" and msg.to.type == "group" then
 if not data[tostring(msg.to.id)]['about'] then
     about = "لم يتم وضع وصف للمجموعه 🙌🏻\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
        else
     about = "*وصف المجموعه ✨ :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
if matches[1] == "مسح" and is_mod(msg) then
del_msg(msg.to.id, msg.reply_id)
del_msg(msg.to.id, msg.id)
   end
if matches[1] == "ترقية الكل" and is_owner(msg) then
local status = getChatAdministrators(msg.to.id).result
for k,v in pairs(status) do
if v.status == "administrator" then
if v.user.username then
admins_id = v.user.id
user_name = '@'..check_markdown(v.user.username)
else
user_name = escape_markdown(v.user.first_name)
      end
  data[tostring(msg.to.id)]['mods'][tostring(admins_id)] = user_name
    save_data(_config.moderation.data, data)
    end
  end
    return "جميع الاداريون تم ترقيتهم في البوت\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
end
if matches[1] == 'امسح' and matches[2] and is_owner(msg) then
local num = matches[2]
if 100 < tonumber(num) then
return "*انتباه ‼️*\n*يمكنني المسح من * 1-100 *كحد اقصى*"
end
print(num)
for i=1,tonumber(num) do
del_msg(msg.to.id,msg.id - i)
end
end
--------------------- Welcome -----------------------
	if matches[1] == "الترحيب" and is_mod(msg) then
		if matches[2] == "تفعيل" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "yes" then
				return "رسالة الترحيب _بالفعل تم نفعيلها_\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				return "رسالة الترحيب _تم تفعيلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
			end
		end
		
		if matches[2] == "تعطيل" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "no" then
				return "رسالة الترحيب _بالفعل معطله _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				return "رسالة الترحيب _تم تعطيلها _\n💎〰〰〰〰〰〰〰\nøяđeявч :"..msg.from.first_name
			end
		end
	end
	if matches[1] == "ضع ترحيب" and matches[2] and is_mod(msg) then
		data[tostring(msg.to.id)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
		return "_رسالة الترحيب 👋🏻 تم وضعها على :_\n*"..matches[2].."*\n\n*كما يمكنك وضع:*\n_{gpname} اسم المجموعه 🎗_\n_{rules} ➣ اضهار القوانين 👋🏻_\n_{time} ➣ عرض الوقت 🕒 _\n_{date} ➣ عرض التاريخ 📆 _\n_{name} ➣ اسم مستخدم جديد_\n_{username} ➣ معرف المستخدم 🚹_"
	end
-------------Help-------------
  if matches[1] == "مساعده" or matches[1] == "الاوامر" and is_mod(msg) then
    local text = [[
*آۄآمہٰ۪۫ږ سہٰ۪۫ۄږسہٰ۪۫ كہٰ۪۫يہٰ۪۫نہٰ۪۫آمہٰ۪۫*

💎*!رفع مشرف* 

💎*!حذف مشرف* 

💎*!رفع مدير*

💎*!حذف مدير* 

🗯*!ضع تكرار* `[1-50]`

🗯*!حساسية الاحرف* `[العدد]`

🗯*!ضع زمن التكرار* `[1-10]`

🔇*!كتم* 

🔉*!الغاء الكتم* 

🔕*!طرد* 

🔕*!حضر* 

🔕*!الغاء حضر* 

🔕*!البيضاء* [+-] 

🚹الاوامر تعمل `[بالايدي بالرد بالمعرف]`
〰〰〰〰〰⛓

👁‍🗨*!فحص* `[بالمعرف]`

👁‍🗨*!ايدي* `[بالرد | بالمعرف]`

👁‍🗨*!تدقيق* `[id]`

🔝*!ضع*`[قوانين | اسم | صوره[بالرد ] | رابط | وصف | ترحيب]`

🔝*!تنظيف* `[المحضورين | المدراء | البوتات | القوانين | الوصف | المكتومين | الكلمات الممنوعه | الترحيب]`   
〰〰〰〰〰⛓

🎗*!احذف الصوره*

🎗*!منع* `[كلمه]`

🎗*!سماح* `[الكلمه]`

🎭*!تثبيت* `[بالرد]`

🎭*!الغاء تثبيت* 

🎭*!الترحيب تفعيل/تعطيل*
〰〰〰〰〰⛓

🎭*!اعدادات*

🎭*!اعدادات2*

🎗*!المكتومين*

🎗*!الكلمات الممنوعه*

🎗*!المحضورين*

💎*!المشرفين*

💎*!المدراء* 

💎*!البيضاء* 

💎*!القوانين*

⭐️*!الوصف*

⭐️*!ايدي*

⭐️*!الرابط*

⭐️*!ضع ترحيب [النص]*

👁‍🗨*م2* 👉🏻
_لآضهار اوامر القفل _
➖➖➖➖➖➖➖➖➖➖
]]
    return text
  end

if matches[1] == "م2" and is_mod(msg) then
    local text = [[
#اوامر القفل (2) 👁‍🗨

🔇قفل مع الاوامر ادناه 👇للقفل

🔊فتح مع الاوامر ادناه 👇للفتح
〰〰〰〰〰⛓

 `[🔹الروابط🔹][🔹التاك @-#-/ 🔹]`
 
 `[🔹التعديل🔹][🔹العربيه🔹][🔹الصفحات🔹]`
 
 `[🔹البوتات🔹][🔹الكلايش🔹][🔹التكرار🔹]`
 
 `[🔹الماركدون🔹][🔹المنشن🔹][🔹الدخول🔹]`
 
⌨️ *م3*
_لآضهار اوامر القفل2_
➖➖➖➖➖➖➖➖➖➖➖➖ 
]]
    return text
  end
if matches[1] == "م3" and is_mod(msg) then
    local text = [[
#اوامر القفل (3) 👁‍🗨

🔇قفل مع الاوامر ادناه 👇للقفل

🔊فتح مع الاوامر ادناه 👇للفتح
〰〰〰〰〰⛓

 `[🔹المتحركه🔹][🔹الصور🔹][🔹الملفات🔹]`
 
 `[🔹الملسقات🔹][🔹الفديو🔹][🔹النصوص🔹]`
 
 `[🔹التوجيه🔹][🔹المواقع🔹][🔹الصوت🔹]`
 
 `[🔹البصمات🔹][🔹الجهات🔹][🔹الاشعارات🔹]`
 
                `[�[🔹الكل🔹]`
 
⌨️ *م4*
_لآضهار اوامر المطور_
➖➖➖➖➖➖➖➖➖➖➖➖
]]
    return text
  end
----------------End Msg Matches--------------
end
local function pre_process(msg)
-- print(serpent.block(msg, {comment=false}))
local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
    if msg.photo then
  if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
     end
		send_msg(msg.to.id, "*تم حفظ الصوره*", msg.id, "md")
  end
	local url , res = http.request('http://api.beyond-dev.ir/time/')
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
		local data = load_data(_config.moderation.data)
 if msg.newuser then
	if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] then
		wlc = data[tostring(msg.to.id)]['settings']['welcome']
		if wlc == "yes" and tonumber(msg.newuser.id) ~= tonumber(bot.id) then
    if data[tostring(msg.to.id)]['setwelcome'] then
     welcome = data[tostring(msg.to.id)]['setwelcome']
      else
     welcome = "*ﭑهہۣۧلہۣۧﭑ ۇسہۣۧهہۣۧلہۣۧﭑ بہۣۧكہۣۧمہۣۧ🤗*"
     end
 if data[tostring(msg.to.id)]['rules'] then
rules = data[tostring(msg.to.id)]['rules']
else
      rules = "ℹ️ القوانين الافتراضيه:\n1️⃣ عدم تكرار الرسائل لتجنب الطرد.\n2️⃣ الكلايش الطويله ممنوعه.\n3️⃣ السب والشتم ممنوع.\n4️⃣ الاعلانات والروابط ممنوعه.\n5️⃣ الزحف ومضايقة الاعضاء طرد.\n➡️ احترم تحترم واخلاقك تعكس تربيتك.\n@kenamch"
end
if msg.newuser.username then
user_name = "@"..check_markdown(msg.newuser.username)
else
user_name = ""
end
		welcome = welcome:gsub("{rules}", rules)
		welcome = welcome:gsub("{name}", escape_markdown(msg.newuser.print_name))
		welcome = welcome:gsub("{username}", user_name)
		welcome = welcome:gsub("{time}", jdat.ENtime)
		welcome = welcome:gsub("{date}", jdat.ENdate)
		welcome = welcome:gsub("{timefa}", jdat.FAtime)
		welcome = welcome:gsub("{datefa}", jdat.FAdate)
		welcome = welcome:gsub("{gpname}", msg.to.title)
		send_msg(msg.to.id, welcome, msg.id, "md")
        end
		end
	end
 if msg.newuser then
 if msg.newuser.id == bot.id and is_admin(msg) then
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
   modadd(msg)
   send_msg(msg.to.id, '*مجموعة ['..msg.to.title..'] تم اضافتها تلقائيا ضمن مجموعاتي🛡*\n〰〰〰〰〰〰〰〰\n*øяđeявч* : [@'..msg.from.username..']', msg.id, "md")
      end
    end
  end
end
return {
  patterns = {
 "^(مساعده)$",
 "^(الاوامر)$",
 "^(م2)$",
 "^(م3)$",
 "^(تفعيل)$",
 "^(تعطيل)$",
 "^(ترقية الكل)$",
 "^(رفع مشرف)$",
 "^(حذف مشرف)$",
 "^(رفع مشرف) (.*)$",
 "^(حذف مشرف) (.*)$",
 "^(رفع مدير)$",
 "^(حذف مدير)$",
 "^(رفع مدير) (.*)$",
	"^(حذف مدير) (.*)$",
	"^(البيضاء) ([+-])$",
	"^(البيضاء) ([+-]) (.*)$",
	"^(البيضاء)$",
	"^(قفل) (.*)$",
	"^(فتح) (.*)$",
	"^(mute) (.*)$",
	"^(unmute) (.*)$",
	"^(اعدادات)$",
	"^(اعدادات2)$",
	"^(منع) (.*)$",
	"^(سماح) (.*)$",
 "^(الكلمات الممنوعه)$",
 "^(المشرفين)$",
 "^(المدراء)$",
 "^(مسح)$",
	"^(ضع قوانين) (.*)$",
 "^(القوانين)$",
 "^(ضع رابط)$",
 "^(الرابط)$",
 "^(ضع صوره)$",
 "^(احذف الصوره)$",
 "^(ايدي)$",
 "^(ايدي) (.*)$",
	"^(فحص) (.*)$",
	"^(تنظيف) (.*)$",
	"^(ضع اسم) (.*)$",
	"^(الترحيب) (.*)$",
	"^(ضع ترحيب) (.*)$",
	"^(تثبيت)$",
 "^(الغاء تثبيت)$",
 "^(الوصف)$",
	"^(ضع وصف) (.*)$",
 "^(حساسية الاحرف) (%d+)$",
 "^(ضع تكرار) (%d+)$",
 "^(ضع زمن التكرار) (%d+)$",
 "^(تدقيق) (%d+)$",
 "^(امسح) (%d+)$",
	"^(المطور)$",
	"^(كينام)$",
	"^(السورس)$",
	"^([https?://w]*.?telegram.me/joinchat/%S+)$",
	"^([https?://w]*.?t.me/joinchat/%S+)$"
    },
  run = kenamch,
  pre_process = pre_process
}
