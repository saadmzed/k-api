	
local function BeyondTeam(msg, matches)
local data = load_data(_config.moderation.data)
----------------kick by replay ----------------
if matches[1] == 'طرد' and is_mod(msg) then
   if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "I can't kick my self"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "You can't kick mods, owners, bot admins"
    else
	kick_user(msg.reply.id, msg.to.id) 
 end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "User not found"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "I can't kick my self"
    end
if is_mod1(msg.to.id, User.id) then
   return "You can't kick mods, owners, bot admins"
     else
	kick_user(User.id, msg.to.id) 
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "I can't kick my self"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "You can't kick mods, owners, bot admins"
   else
     kick_user(tonumber(matches[2]), msg.to.id) 
        end
     end
   end 

---------------Ban-------------------      
                   
if matches[1] == 'حضر' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "I can't ban my self"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "You can't ban mods, owners, bot admins"
    end
  if is_banned(msg.reply.id, msg.to.id) then
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." is already banned"
    else
ban_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id)
     kick_user(msg.reply.id, msg.to.id) 
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." has been banned"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "User not found"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "I can't ban my self"
    end
if is_mod1(msg.to.id, User.id) then
   return "You can't ban mods, owners, bot admins"
    end
  if is_banned(User.id, msg.to.id) then
    return "User "..check_markdown(User.username).." "..User.id.." is already banned"
    else
   ban_user(check_markdown(User.username), User.id, msg.to.id)
     kick_user(User.id, msg.to.id) 
    return "User "..check_markdown(User.username).." "..User.id.." has been banned"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "I can't ban my self"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "You can't ban mods, owners, bot admins"
    end
  if is_banned(tonumber(matches[2]), msg.to.id) then
    return "User "..matches[2].." is already banned"
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
    return "User "..matches[2].." has been banned"
        end
     end
   end

---------------Unban-------------------                         

if matches[1] == 'الغاء حضر' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "I can't silent my self"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "You can't ban mods, owners, bot admins"
    end
  if not is_banned(msg.reply.id, msg.to.id) then
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." is already banned"
    else
unban_user(msg.reply.id, msg.to.id)
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." has been unbanned"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "User not found"
    end
	local User = resolve_username(matches[2]).information
  if not is_banned(User.id, msg.to.id) then
    return "User @"..check_markdown(User.username).." "..User.id.." is not banned"
    else
   unban_user(User.id, msg.to.id)
    return "User @"..check_markdown(User.username).." "..User.id.." has been unbanned"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_banned(tonumber(matches[2]), msg.to.id) then
    return "User "..matches[2].." is not banned"
    else
   unban_user(matches[2], msg.to.id)
    return "User "..matches[2].." has been unbanned"
        end
     end
   end

------------------------Silent-------------------------------------

if matches[1] == 'كتم' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "I can't silent my self"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "You can't silent mods, owners, bot admins"
    end
  if is_silent_user(msg.reply.id, msg.to.id) then
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." is already silent"
    else
silent_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id)
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." added to silent users list"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "User not found"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "I can't silent my self"
    end
if is_mod1(msg.to.id, User.id) then
   return "You can't silent mods, owners, bot admins"
    end
  if is_silent_user(User.id, msg.to.id) then
    return "User @"..check_markdown(User.username).." "..User.id.." is already silent"
    else
   silent_user("@"..check_markdown(User.username), User.id, msg.to.id)
    return "User @"..check_markdown(User.username).." "..User.id.." added to silent users list"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "I can't silent my self"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "You can't silent mods, owners, bot admins"
    end
  if is_silent_user(tonumber(matches[2]), msg.to.id) then
    return "User "..matches[2].." is already silent"
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
    return "User "..matches[2].." added to silent users list"
        end
     end
   end

------------------------Unsilent----------------------------
if matches[1] == 'الغاء الكتم' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "I can't silent my self"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "You can't ban mods, owners, bot admins"
    end
  if not is_silent_user(msg.reply.id, msg.to.id) then
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." is not silent"
    else
unsilent_user(msg.reply.id, msg.to.id)
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." removed from silent users list"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "User not found"
    end
	local User = resolve_username(matches[2]).information
  if not is_silent_user(User.id, msg.to.id) then
    return "User @"..check_markdown(User.username).." "..User.id.." is not silent"
    else
   unsilent_user(User.id, msg.to.id)
    return "User @"..check_markdown(User.username).." "..User.id.." removed from silent users list"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_silent_user(tonumber(matches[2]), msg.to.id) then
    return "User "..matches[2].." is not silent"
    else
   unsilent_user(matches[2], msg.to.id)
    return "User "..matches[2].." removed from silent users list"
        end
     end
   end
-------------------------Banall-------------------------------------
                   
if matches[1] == 'عام' and is_admin(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "I can't global ban my self"
    end
if is_admin1(msg.reply.id) then
   return "You can't global ban other admins"
    end
  if is_gbanned(msg.reply.id) then
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." is already globally banned"
    else
banall_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id)
     kick_user(msg.reply.id, msg.to.id) 
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." has been globally banned"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "User not found"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "I can't global ban my self"
    end
if is_admin1(User.id) then
   return "You can't global ban other admins"
    end
  if is_gbanned(User.id) then
    return "User @"..check_markdown(User.username).." "..User.id.." is already globally banned"
    else
   banall_user("@"..check_markdown(User.username), User.id)
     kick_user(User.id, msg.to.id) 
    return "User @"..check_markdown(User.username).." "..User.id.." has been globally banned"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if is_admin1(tonumber(matches[2])) then
if tonumber(matches[2]) == tonumber(our_id) then
   return "I can't global ban my self"
    end
   return "You can't global ban other admins"
    end
  if is_gbanned(tonumber(matches[2])) then
    return "User "..matches[2].." is already globally banned"
    else
   banall_user('', matches[2])
     kick_user(tonumber(matches[2]), msg.to.id)
    return "User "..matches[2].." has been globally banned"
        end
     end
   end
--------------------------Unbanall-------------------------

if matches[1] == 'الغاء العام' and is_admin(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "I can't silent my self"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "You can't ban mods, owners, bot admins"
    end
  if not is_gbanned(msg.reply.id) then
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." is already globally banned"
    else
unbanall_user(msg.reply.id)
    return "User "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." has been globally unbanned"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "User not found"
    end
	local User = resolve_username(matches[2]).information
  if not is_gbanned(User.id) then
    return "User @"..check_markdown(User.username).." "..User.id.." is not globally banned"
    else
   unbanall_user(User.id)
    return "User @"..check_markdown(User.username).." "..User.id.." has been globally unbanned"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_gbanned(tonumber(matches[2])) then
    return "User "..matches[2].." is not globally banned"
    else
   unbanall_user(matches[2])
    return "User "..matches[2].." has been globally unbanned"
        end
     end
   end
   -----------------------------------LIST---------------------------
   if matches[1] == 'المحضورين' and is_mod(msg) then
   return banned_list(msg.to.id)
   end
   if matches[1] == 'المكتومين' and is_mod(msg) then
   return silent_users_list(msg.to.id)
   end
   if matches[1] == 'المحضورين عام' and is_admin(msg) then
   return gbanned_list(msg)
   end
   ---------------------------clean---------------------------
   if matches[1] == 'تنظيف' and is_mod(msg) then
	if matches[2] == 'المحضورين' then
		if next(data[tostring(msg.to.id)]['banned']) == nil then
			return "_No_ *banned* _users in this group_"
		end
		for k,v in pairs(data[tostring(msg.to.id)]['banned']) do
			data[tostring(msg.to.id)]['banned'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "_All_ *banned* _users has been unbanned_"
	end
	if matches[2] == 'المكتومين' then
		if next(data[tostring(msg.to.id)]['is_silent_users']) == nil then
			return "_No_ *silent* _users in this group_"
		end
		for k,v in pairs(data[tostring(msg.to.id)]['is_silent_users']) do
			data[tostring(msg.to.id)]['is_silent_users'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "*Silent list* _has been cleaned_"
	end
	if matches[2] == 'المحضورين عام' and is_admin(msg) then
		if next(data['gban_users']) == nil then
			return "_No_ *globally banned* _users available_"
		end
		for k,v in pairs(data['gban_users']) do
			data['gban_users'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "_All_ *globally banned* _users has been unbanned_"
	end
   end

end
return {
	patterns = {
"^(حضر) (.*)$",
"^(حضر)$",
"^(الغاء حضر) (.*)$",
"^(الغاء حضر)$",
"^(طرد) (.*)$",
"^(طرد)$",
"^(عام) (.*)$",
"^(عام)$",
"^(الغاء العام) (.*)$",
"^(الغاء العام)$",
"^(الغاء الكتم) (.*)$",
"^(الغاء الكتم)$",
"^(كتم) (.*)$",
"^(كتم)$",
"^(المكتومين)$",
"^(المحضورين)$",
"^(المحضورين عام)$",
"^(تنظيف) (.*)$",
	},
	run = BeyondTeam,

}
