local function kenamch(msg, matches)
local hashwarn = msg.to.id..':warn'
local max_warn = tonumber(redis:get('max_warn:'..msg.to.id) or 5)
		if matches[1]:lower() == 'تنظيف' and matches[2] == 'التحذيرات' then
			if not is_owner(msg) then
				return
			end
    local hash = msg.to.id..':warn'
    redis:del(hash) 
				if not lang then  
     return "قائمة التحذيرات تم حذفها 🙃‼️"
		end
 end
		if matches[1]:lower() == 'ضع تحذير' then
			if not is_mod(msg) then
				return
			end
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 20 then
	if not lang then
				return "_انتباه ‼️ يمكنك فقط وضع من _ *[1-20]*"
      end
    end
			local warn_max = matches[2]
   redis:set('max_warn:'..msg.to.id, warn_max)
     if not lang then
     return "_تم وضع عدد التحذيرات على 🚹 :_ *[ "..matches[2].." ]*"
		end
  end
   if matches[1] == "تحذير" and is_mod(msg) then
   if not matches[2] and msg.reply_to_message then
local warnhash = redis:hget(hashwarn, msg.reply.id) or 1
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
     if tonumber(msg.reply.id) == tonumber(bot.id) then
  if not lang then
  return "*لا يمكنني تحذير نفسي ☹️🖐*"
         end
     end
   if is_mod1(msg.to.id, msg.reply.id) and not is_admin1(msg.from.id)then
  
  if not lang then
  return "*لا يمكن تحذير الادمنيه والمطورين 🤕🐍*"
         end
     end
   if is_admin1(msg.reply.id) then
  if not lang then
  return "لا يمكن تحذير الادمنيه و المطورين 😕🎗"
         end
     end
if tonumber(warnhash) == tonumber(max_warn) then
   kick_user(msg.reply.id, msg.to.id)
redis:hdel(hashwarn, msg.reply.id, '0')
    
	if not lang then
    return "_المستخدم👤_ "..username.." *"..msg.reply.id.."* _تم طرده بسبب المخالفه _\nعدد التحذيرات :_ "..warnhash.."/"..max_warn..""

    end
else
redis:hset(hashwarn, msg.reply.id, tonumber(warnhash) + 1)
    if not lang then
    return "_المستخدم👤_ "..username.." *"..msg.reply.id.."*\n_انتبه لتصرفك ‼️ قد تتعرض للطرد ✨ عدد تحذيراتك_ "..warnhash.." _من_ "..max_warn.." _تحذير !_"

    end
  end
	  elseif matches[2] and matches[2]:match('^%d+') then
local warnhash = redis:hget(hashwarn, matches[2]) or 1
  if not getUser(matches[2]).result then
      if lang then
  return "المستخدم 👤 غير موجود"
      end
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
     if tonumber(matches[2]) == tonumber(bot.id) then
  if not lang then
  return "*لا يمكنني تحذير نفسي ☹️🖐*"

         end
     end
   if is_mod1(msg.to.id, tonumber(matches[2])) and not is_admin1(msg.from.id)then
  if not lang then
  return "*لا يمكن تحذير الادمنيه والمطورين 🤕🐍*"

         end
     end
   if is_admin1(tonumber(matches[2]))then
  if not lang then
  return "_You can't warn_ *bot admins*"

         end
     end
if tonumber(warnhash) == tonumber(max_warn) then
   kick_user(matches[2], msg.to.id)
redis:hdel(hashwarn, matches[2], '0')
    if not lang then
    return "_المستخدم👤_ "..user_name.." *"..matches[2].."* _تم طرده بسبب المخالفه_\nعدد التحذيرات :_ "..warnhash.."/"..max_warn..""

    end
else
redis:hset(hashwarn, matches[2], tonumber(warnhash) + 1)
	if not lang then
    return "_المستخدم👤_ "..user_name.." *"..matches[2].."*\n_انتبه لتصرفك ‼️ قد تتعرض للطرد ✨ عدد تحذيراتك_ "..warnhash.." _من_ "..max_warn.." _تحذير !_"

    end
  end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   if not lang then
  return "المستخدم 👤 غير موجود"
      end
    end
   local status = resolve_username(matches[2]).information
local warnhash = redis:hget(hashwarn, status.id) or 1
     if tonumber(status.id) == tonumber(bot.id) then
  if not lang then
  return "*لا يمكنني تحذير نفسي ☹️🖐*"

         end
     end
   if is_mod1(msg.to.id, tonumber(status.id)) and not is_admin1(msg.from.id)then
   if not lang then
  return "*لا يمكن تحذير الادمنيه والمطورين 😹*"

         end
     end
   if is_admin1(tonumber(status.id))then
  if not lang then
  return "لا يمكن تحذير الادمنيه والمطورين 🌚⭐️"

         end
     end
if tonumber(warnhash) == tonumber(max_warn) then
   kick_user(status.id, msg.to.id)
redis:hdel(hashwarn, status.id, '0')
    
	if not lang then
    return "_المستخدم👤_ "..check_markdown(status.username).." *"..status.id.."* _تم طرده بسبب المخالفه_\nعدد التحذيرات :_ "..warnhash.."/"..max_warn..""

    end
else
redis:hset(hashwarn, status.id, tonumber(warnhash) + 1)
	if not lang then
    return "_المستخدم👤_ @"..check_markdown(status.username).." *"..status.id.."*\n_انتبه لتصرفك ‼️ قد تتعرض للطرد ✨ عدد تحذيراتك_ "..warnhash.." _من_ "..max_warn.." _تحذير !_"

    end
    end
  end
end
   if matches[1] == "الغاء تحذير" and is_mod(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
-- local warnhash = redis:hget(hashwarn, msg.reply.id) or 1	-- if needed
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
if not redis:hget(hashwarn, msg.reply.id) then
	if not lang then
    return "_المستخدم👤_ "..username.." *"..msg.reply.id.."* لم يتم تحذيره مسبقا 🚫"

    end
  else
redis:hdel(hashwarn, msg.reply.id, '0')
	if not lang then
    return "_جميع تحذيرات ‼️_ "..username.." *"..msg.reply.id.."*  قد تم حذفها    "

    end
   end
	  elseif matches[2] and matches[2]:match('^%d+') then
-- local warnhash = redis:hget(hashwarn, matches[2]) or 1	-- if needed
  if not getUser(matches[2]).result then
   if lang then
  return "المستخدم 👤 غير موجود"
      end
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
if not redis:hget(hashwarn, matches[2]) then
    if not lang then
    return "_المستخدم👤_ "..user_name.." *"..matches[2].."* لم يتم تحذيره مسبقا 🚫"

    end
  else
redis:hdel(hashwarn, matches[2], '0')
    if not lang then
    return "_جميع تحذيرات ‼️_ "..user_name.." *"..matches[2].."*   قد تم حذفها    "

    end
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   if lang then

  return "المستخدم 👤 غير موجود"
      end
    end
   local status = resolve_username(matches[2]).information
-- local warnhash = redis:hget(hashwarn, status.id) or 1	-- if needed
if not redis:hget(hashwarn, status.id) then
    if not lang then
    return "_المستخدم👤_ @"..check_markdown(status.username).." *"..status.id.."* لم يتم تحذيره سابقا 🚫"

    end
  else
redis:hdel(hashwarn, status.id, '0')
    if not lang then
    return "_جميع تحذيرات ‼️_ @"..check_markdown(status.username).." *"..status.id.."*  قد تم حذفها    "

    end
    end
  end
end
-----------
if matches[1] == "م5" or matches[1] == "اوامر التحذير" and is_mod(msg) then
    local text = [[
#5 آهہٰ۪۫لہٰ۪۫آ بہٰ۪۫كہٰ۪۫مہٰ۪۫ فہٰ۪۫يہٰ۪۫ آۄآمہٰ۪۫ږ آلہٰ۪۫تہٰ۪۫حہٰ۪۫ڐيہٰ۪۫ږ‼️✨

〰〰〰〰〰⛓
🚹 ضع تحذير `[1 - 20]`

🚹 تحذير `[بالايدي بالرد بالمعرف]`
🚹 الغاء تحذير `[بالايدي بالرد بالمعرف]`

🚹 قائمة التحذير 

🚹 تنظيف التحذيرات

➖➖➖➖➖➖➖➖➖➖➖➖ 
]]
    return text
  end    
-----------
	if matches[1] == "قائمة التحذير" and is_mod(msg) then
		if not lang then
		list = 'قائمة التحذيرات 🚫:\n'
		end
		local empty = list
		for k,v in pairs (redis:hkeys(msg.to.id..':warn')) do
			local user_info = redis:hgetall('user:'..v)
			local cont = redis:hget(msg.to.id..':warn', v)
		if user_info and user_info.user_name then
		list = list..k..'- '..user_info.user_name..' ['..v..'] Warn : '..(cont - 1)..'\n'
       else
		list = list..k..'- '..v..' Warn : '..(cont - 1)..'\n'
      end
    end
		if list == empty then
		if not lang then
		return 'قائمة التحذيرات خاليه 😕🚫'
		end
		else
		 send_msg(msg.to.id, list)
		end
	end
end
local function pre_process(msg)
    local hash = 'user:'..msg.from.id
    if msg.from.username then
     user_name = '@'..msg.from.username
  else
     user_name = msg.from.print_name
    end
      redis:hset(hash, 'user_name', user_name)
end

return {
  patterns = {
 "^(تحذير)$",
 "^(تحذير) (.*)$",
 "^(الغاء تحذير)$",
 "^(الغاء تحذير) (.*)$",
 "^(ضع تحذير) (%d+)$",
 "^(تنظيف) (التحذيرات)$",
 "^(قائمة التحذير)$",
 "^(م5)$",
  "^(اوامر التحذير)$",

  },
  run = kenamch,
	pre_process = pre_process
}

