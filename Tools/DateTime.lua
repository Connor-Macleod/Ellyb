---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.DateTime then
	return
end

-- Lua imports
local date = date;
local time = time;
local assert = assert;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;

local TODAY;

---@class DateTime
local DateTime, _private = Ellyb.Class("DateTime");

function DateTime:initialize(ideallyATimeStamp)
	_private[self] = date(ideallyATimeStamp);
end

function DateTime:SetTimestamp(timestamp)
	_private[self].timestamp = timestamp;
end

function DateTime:GetTimestamp()
	return _private[self].timestamp;
end

function DateTime:UpdateTimestamp()
	self:SetTimestamp(time(self:GetTimeTable()));
end

function DateTime:SetYear(year)
	_private[self].year = year;
	self:UpdateTimestamp();
end

function DateTime:GetYear()
	return _private[self].year;
end

function DateTime:SetMonth(month)
	_private[self].month = month;
	self:UpdateTimestamp();
end

function DateTime:GetMonth()
	return _private[self].month;
end

function DateTime:SetDay(day)
	_private[self].day = day;
	self:UpdateTimestamp();
end

function DateTime:GetDay()
	return _private[self].day;
end

function DateTime:SetHour(hour)
	_private[self].hour = hour;
	self:UpdateTimestamp();
end

function DateTime:GetHour()
	return _private[self].hour;
end

function DateTime:SetMinutes(minutes)
	_private[self].minutes = minutes;
	self:UpdateTimestamp();
end

function DateTime:GetMinutes()
	return _private[self].minutes;
end

function DateTime:SetSeconds(seconds)
	_private[self].seconds = seconds;
	self:UpdateTimestamp();
end

function DateTime:GetSeconds()
	return _private[self].seconds;
end

function DateTime:SetDaylightSavingTime(isDaylightSavingTime)
	_private[self].isDaylightSavingTime = isDaylightSavingTime == true;
	self:UpdateTimestamp();
end

function DateTime:IsDaylightSavingTime()
	return _private[self].isDaylightSavingTime == true;
end

function DateTime:GetTimeTable()
	return {
		year = self:GetYear(),
		month = self:GetMonth(),
		day = self:GetDay(),
		hour = self:GetHour(),
		min = self:GetMinutes(),
		sec = self:GetSeconds(),
		isdst = self:IsDaylightSavingTime(),
	}
end

function DateTime:SetFromTimeTable(timeTable)
	self:SetYear(timeTable.year);
	self:SetMonth(timeTable.month);
	self:SetDay(timeTable.day);
	self:SetHour(timeTable.hour);
	self:SetMinutes(timeTable.min);
	self:SetSeconds(timeTable.sec);
	self:SetDaylightSavingTime(timeTable.isdst);
	self:UpdateTimestamp();
end

---@param date DateTime
function DateTime:__eq(date)
	return self:GetTimestamp() == date:GetTimestamp();
end

---@param date DateTime
function DateTime:__lt(date)
	return self:GetTimestamp() < date:GetTimestamp();
end

---@param date DateTime
function DateTime:__le(date)
	-- not really necessary, just improves "<=" and ">" performance
	return self:GetTimestamp() <= date:GetTimestamp();
end

function DateTime:Format(dateFormat)
	assert(isType(dateFormat, "string", dateFormat));

	return Ellyb.DateManager.formatDate(self, dateFormat);
end

function DateTime:__tostring()
	return self:Format(Ellyb.DateManager.getDefaultFormat());
end

TODAY = DateTime(time());

Ellyb.DateTime = DateTime;