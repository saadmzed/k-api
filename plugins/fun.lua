
--Begin Fun.lua By @kenamch
--Special Thx To @ToOfan
--------------------------------

local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
--------------------------------
local api_key = nil
local base_api = "https://maps.googleapis.com/maps/api"
--------------------------------
local function get_latlong(area)
	local api      = base_api .. "/geocode/json?"
	local parameters = "address=".. (URL.escape(area) or "")
	if api_key ~= nil then
		parameters = parameters .. "&key="..api_key
	end
	local res, code = https.request(api..parameters)
	if code ~=200 then return nil  end
	local data = json:decode(res)
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		lat  = data.results[1].geometry.location.lat
		lng  = data.results[1].geometry.location.lng
		acc  = data.results[1].geometry.location_type
		types= data.results[1].types
		return lat,lng,acc,types
	end
end
--------------------------------
local function get_staticmap(area)
	local api        = base_api .. "/staticmap?"
	local lat,lng,acc,types = get_latlong(area)
	local scale = types[1]
	if scale == "locality" then
		zoom=8
	elseif scale == "country" then 
		zoom=4
	else 
		zoom = 13 
	end
	local parameters =
		"size=600x300" ..
		"&zoom="  .. zoom ..
		"&center=" .. URL.escape(area) ..
		"&markers=color:red"..URL.escape("|"..area)
	if api_key ~= nil and api_key ~= "" then
		parameters = parameters .. "&key="..api_key
	end
	return lat, lng, api..parameters
end
--------------------------------
local function get_weather(msg, location)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
	print("Finding weather in ", location)
	local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
	local url = BASE_URL
	url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
	url = url..'&units=metric'
	local b, c, h = http.request(url)
	if c ~= 200 then return nil end
	local weather = json:decode(b)
	local city = weather.name
	local country = weather.sys.country
   if not lang then
 temp = 'درجة الحراره 🌞 '..city..' المتوقعه الآن '..weather.main.temp..' ° C\n____________________'

 end
   if not lang then
	 conditions = 'الظروف الجوية الحالية : '

 end
	if weather.weather[1].main == 'Clear' then
   if not lang then
		conditions = conditions .. 'مشرق☀'

  end
	elseif weather.weather[1].main == 'Clouds' then
   if not lang then
		conditions = conditions .. 'غائم ☁☁'

  end
	elseif weather.weather[1].main == 'Rain' then
   if not lang then
		conditions = conditions .. 'ممطر ☔'

 end
	elseif weather.weather[1].main == 'Thunderstorm' then
   if not lang then
		conditions = conditions .. 'عواصف ☔☔☔☔'

  end
	elseif weather.weather[1].main == 'Mist' then
   if not lang then
		conditions = conditions .. 'ضباب 💨'

      end
	end
	return temp .. '\n' .. conditions..'\n@kenamch'
end
--------------------------------
local function calc(msg, exp)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
	url = 'http://api.mathjs.org/v1/'
	url = url..'?expr='..URL.escape(exp)
	b,c = http.request(url)
	text = nil
	if c == 200 then
 if not lang then
    text = '👁‍🗨 النتيجه = '..b..'\n____________________\n@kenamch'

 end
	elseif c == 400 then
		text = b
	else
		text = 'Unexpected error\n'
		..'Is api.mathjs.org up?'
	end
	return text
end
--------------------------------
function run(msg, matches) 
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
	if matches[1]:lower() == 'ناتج' and matches[2] then 
		if msg.to.type == "private" then 
			return 
       end
		return calc(msg, matches[2])
	end
--------------------------------
	if matches[1]:lower() == 'صلاة' then
		if matches[2] then
			city = matches[2]
		elseif not matches[2] then
			city = 'Tehran'
		end
		local lat,lng,url	= get_staticmap(city)
		local dumptime = run_bash('date +%s')
		local code = http.request('http://api.aladhan.com/timings/'..dumptime..'?latitude='..lat..'&longitude='..lng..'&timezonestring=Asia/Tehran&method=7')
		local jdat = json:decode(code)
		local data = jdat.data.timings
   if not lang then
		 text = 'المدينه ❤️ : '..city
		text = text..'\nاذان الفجر 🍃: '..data.Fajr
		text = text..'\nطلوع الشمس 🌞: '..data.Sunrise
		text = text..'\nاذان الضهر 🍁: '..data.Dhuhr
		text = text..'\nاذان العصر ❄️: '..data.Sunset
		text = text..'\nاذان المغرب 🌤: '..data.Maghrib
		text = text..'\nاذان العشاء 😴: '..data.Isha
		text = text.."\n@kenamch"

    end
		return text
	end
--------------------------------
if matches[1] == 'تحويل ملسق' then
if msg.reply_to_message then
if msg.reply_to_message.photo then
if msg.reply_to_message.photo[3] then
fileid = msg.reply_to_message.photo[3].file_id
elseif msg.reply_to_message.photo[2] then
fileid = msg.reply_to_message.photo[2].file_id
   else
fileid = msg.reply_to_message.photo[1].file_id
  end
downloadFile(fileid, "./download_path/"..msg.to.id..".webp")
sleep(1)
sendDocument(msg.to.id, "./download_path/"..msg.to.id..".webp", msg.id, "@kenamch")
        end
     end
  end
-------------------------------- 
if matches[1] == 'تحويل صوره' then
if msg.reply_to_message then
if msg.reply_to_message.sticker then
downloadFile(msg.reply_to_message.sticker.file_id, "./download_path/"..msg.to.id..".jpg")
sleep(1)
sendPhoto(msg.to.id, "./download_path/"..msg.to.id..".jpg", "@kenamch", msg.id)
        end
     end
  end
--------------------------------
	if matches[1]:lower() == 'طقس' then
		city = matches[2]:lower()
		local wtext = get_weather(msg, city)
		if not wtext then
   if not lang then
			wtext = 'الموقع المستورد غير صحيح'

        end
		end
		return wtext
	end
--------------------------------
	if matches[1]:lower() == 'الوقت' then
		local url , res = http.request('http://api.beyond-dev.ir/time/')
		if res ~= 200 then
			return "No connection"
		end
		local colors = {'blue','green','yellow','magenta','Orange','DarkOrange','red'}
		local fonts = {'mathbf','mathit','mathfrak','mathrm'}
		local jdat = json:decode(url)
		local url = 'http://latex.codecogs.com/png.download?'..'\\dpi{600}%20\\huge%20\\'..fonts[math.random(#fonts)]..'{{\\color{'..colors[math.random(#colors)]..'}'..jdat.ENtime..'}}'
		local file = download_to_file(url,'time.webp')
sendDocument(msg.to.id, file, msg.id, "@kenamch")

	end
--------------------------------
	if matches[1]:lower() == 'صوت' then
 local text = matches[2]
    textc = text:gsub(' ','.')
    
  if msg.to.type == 'private' then 
      return nil
      else
  local url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text="..textc
  local file = download_to_file(url,'SAAD7M.mp3')
sendDocument(msg.to.id, file, msg.id, "@kenamch")
   end
end

 --------------------------------
	if matches[1]:lower() == 'ترجم' then 
	local to = matches[2]
		local res, url = http.request('http://api.beyond-dev.ir/translate?from=.&to='..to..'&text='..URL.escape(matches[3])..'&simple=json')
		data = json:decode(res)
  if not lang then
		return 'اللغه 🙃 : '..data.to..'\nالترجمه ✨ : '..data.translate..'\n____________________\n@kenamch'

      end
	end
--------------------------------
	if matches[1]:lower() == 'اختصر' then
		local longlink = http.request('http://api.beyond-dev.ir/shortLink?url='..matches[2])
		local shlink = json:decode(longlink)
		if shlink.status then
    if not lang then
			return 'اختصار الرابط 🚹 :\nGoogle: '..(shlink.results.google or '')..'\nOpizo: '..(shlink.results.opizo or '')..'\nBitly: '..(shlink.results.bitly or '')..'\nYon: '..(shlink.results.yon or '')..'\nLlink: '..(shlink.results.llink or '')..'\nU2S: '..(shlink.results.u2s or '')..'\nShorte: '..(shlink.results.shorte or '')

        end
		else
    if not lang then
			return '_الرابط غير صحيح 🚫_'

        end
		end
	end
--------------------------------
	if matches[1]:lower() == 'ملسق' then
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'text.webp')
sendDocument(msg.to.id, file, msg.id, "@kenamch")
	end
--------------------------------
	if matches[1]:lower() == 'صوره' then
		local eq = URL.escape(matches[2])
		local w = "500"
		local h = "500"
		local txtsize = "100"
		local txtclr = "ff2e4357"
		if matches[3] then 
			txtclr = matches[3]
		end
		if matches[4] then 
			txtsize = matches[4]
		end
		if matches[5] and matches[6] then 
			w = matches[5]
			h = matches[6]
		end
		local url = "https://assets.imgix.net/examples/clouds.jpg?blur=150&w="..w.."&h="..h.."&fit=crop&txt="..eq.."&txtsize="..txtsize.."&txtclr="..txtclr.."&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc"
		local receiver = msg.to.id
		local  file = download_to_file(url,'text.jpg')
sendPhoto(msg.to.id, file, "@kenamch", msg.id)
	end
if matches[1] == 'خيره' then
local url , res = http.request('http://api.beyond-dev.ir/fal')
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
     if not lang then
       fal = "*حظك لهذا اليوم 😆*:\n"..jdat.poem.."\n\n*الترجمه 😹 :*\n"..jdat.mean..'\n\n@kenamch'

        end
      return fal
  end
if matches[1] == 'تطبيق' or matches[1] == 'fibazaar' then
if matches[1] == 'تطبيق' then
xurl  = 'http://api.beyond-dev.ir/bazaar/?q='..URL.escape(matches[2])
elseif matches[1] == 'fibazaar' then
xurl = 'http://api.beyond-dev.ir/bazaar/?price=yes&q='..URL.escape(matches[2])
end
local url , res = http.request(xurl)
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
    if not lang then
       bazaar = "نتائج البحث 🗯 :\n"..jdat.information

   end
      return check_markdown(bazaar)
end
--------------------------------
if matches[1] == "م6" then
if not lang then
helpfun = [[
_ﭑهہۣۧلہۣۧﭑ بہۣۧكہۣۧمہۣۧ فہۣۧيہۣۧ ﭑلہۣۧﭑۇﭑمہۣۧڔٌ ﭑلہۣۧتہۣۧڔٌفہۣۧيہۣۧهہۣۧيہۣۧهہۣۧ😃_

〰〰〰〰〰⛓
⌚️ *الوقت*
_لجلب الوقت بشكل ملسق_

🍃 *اختصر* `[رابط]`
_لاختصار الروابط_

🍃 *صوت* `[كتابه]`
_لتحويل الكتابه الى صوت_

👁‍🗨 *ترجم* `[اللغه] [الكلمه]`
_لترجمة النصوص_
_مثال:_
❄️ *ترجم hi ar*

🚹 *ملسق* `[كتابه]`
_تحويل النص الى ملسق_

🚹 *صوره* `[كتابه]`
_تحويل النص الى صوره_

📲 *ناتج* `[عدد + عدد]`
_آله حاسبه_

🍁 *صلاة* `[المدينه]`
_اوقات الصلاة_

⚡️ *تحويل ملسق* `[بالرد]`
_تحويل صوره الى ملسق_

⚡️ *تحويل صوره* `[بالرد]`
_تحويل ملسق الى صوره_

🌤 *طقس* `[المدينه]`
_حالة الطقس_

📲 *تطبيق* `[مع اسم التطبيق]`
_للحصول على رابط تطبيق مباشر_

🔮 *خيره*
_حظك لهذا اليوم 😹_
➖➖➖➖➖➖➖➖➖➖➖
]]
end
return helpfun.."\n@kenamch"
end

end
--------------------------------
return {               
	patterns = {
"^(م6)$",
"^(طقس) (.*)$",
"^(ناتج) (.*)$",
"^(الوقت)$",
"^(تحويل صوره)$",
"^(تحويل ملسق)$",
"^(صوت) +(.*)$",
"^(صلاة) (.*)$",
"^(صلاة)$",
"^(ترجم) ([^%s]+) (.*)$",
"^(اختصر) (.*)$",
"^(صوره) (.+)$",
"^(ملسق) (.+)$",
'^(خيره)$',
'^(تطبيق) (.*)$',
		}, 
	run = run,
	}

--#by @kenamch :)
