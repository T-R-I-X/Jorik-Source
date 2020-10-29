local module = {}


function module.NumberToTimeLength(date, val)
	local function plural(num)
		if num and num == 1 then
			return ''
		else
			return 's'
		end
	end
	local seconds = date
	local SecondsToTime = {
		year = 3.154e+7, month = 2.628e+6, week = 604800, day = 86400,
		hour = 3600, min = 60
	}
	local Time = {year = 0, month = 0, week = 0, day = 0, hour = 0, min = 0}
	local SortBy = {"year", "month", "week", "day", "hour", "min"}
	local secondsleft = seconds
	for _, t in pairs (SortBy) do
		local v = Time[t]
		if SecondsToTime[t] and typeof(seconds) ~= "string" then
			local x = secondsleft / SecondsToTime[t]
			if x >= 1 then
				local c = secondsleft - (math.floor(x) * SecondsToTime[t])
				secondsleft = c
			end
			Time[t] = math.floor(x)
		end
	end
	Time.sec = secondsleft
	
	if val then
		return Time
	else
		local Display = {year = "Years", month = "Months", week = "Weeks", day = "Days", hour = "Hours", min = "Minutes", sec = "Seconds"}
		local line = ""
		table.insert(SortBy, "Seconds")
		for i, v in pairs (Display) do
			local t = Time[i]
			
			if typeof(t) ~= "string" then	
				if t and t > 0 then		
					line = line .. " " .. t .. " " .. string.sub(v, 1, #v-1) .. plural(t)		
				end	
			end
		end
		
		return string.sub(line, 2)
	end
end
function module.GetDateFromTimestamp(timestamp)
	local date = string.split(string.split(timestamp, "T")[1], "-")
	local t = string.split(string.split(string.split(timestamp, "T")[2], "Z")[1], ":")
	local Date = {year = tostring(date[1]), month = tostring(date[2]), day = tostring(date[3]),
		hour = tostring(t[1]), min = tostring(t[2]), sec = tostring(t[3])
	}
	return Date
end
function GetDays(v, year)
	local leapyear = year%4==0 
	local month = {
		['30'] = {9, 4, 6, 11}	, ['31'] = {1, 3, 5, 7, 8, 10, 12}, ['28'] = {2}
	}
	if leapyear then
		month['28'] = nil
		month['29'] = {2}
	end
	for val, m in pairs (month) do
		for _, x in pairs (m) do
			if v == x then
				return val
			end
		end
	end
	return
end
function ToTime(date)
	local seconds = 0
	local SecondsToTime = {
		year = 365.25*24*60*60, month = 2.628e+6, day = 86400
	}
	local x = {"year", "month", "day"}
	local seconds = 0
	for _, d in pairs (x) do
		local t = SecondsToTime[d]
		local num = tonumber(date[d])
		if t and num then
			if d == "year" then
				num = num - 1950
			elseif d == "month" then
				d = "day"
				local days = 0
				for i = 1, num do
					if i ~= num then
						days = days + tonumber(GetDays(i, date.year))
					end
				end
				num = days
			end
			seconds = seconds + (num * SecondsToTime[d])
		end
	end
	return seconds
end
function module.CompareTime(t1, t2)
	local SecondsToTime = {
		hour = 3600, min = 60, sec = 1
	}
	local seconds_t1 = 0
	local seconds_t2 = 0
	local seconds = 0
	local sort = {"hour", "min", "sec"}
	for _, t in pairs (sort) do
		local num = tonumber(t1[t])
		if num and SecondsToTime[t] then
			seconds_t1 = seconds_t1 + (num * SecondsToTime[t])
		end
	end
	for _, t in pairs (sort) do
		local num = tonumber(t2[t])
		if num and SecondsToTime[t] then
			seconds_t2 = seconds_t2 + (num * SecondsToTime[t])
		end
	end
	if seconds_t1 > seconds_t2 then
		seconds = seconds_t1 - seconds_t2
	elseif seconds_t1 < seconds_t2 then
		seconds = seconds_t2 - seconds_t1
	end
	return seconds
end

function module.GetLastUpdated(d)
	local date = module.GetDateFromTimestamp(d)
	local currentdate = os.date("*t", os.time())
	local updated = ToTime(date)
	local now = ToTime(currentdate)
	
	if now == updated then
		return module.CompareTime(date, currentdate)
	elseif now < updated then
		return "From the Future"
	else
		return now - updated
	end
end

return module