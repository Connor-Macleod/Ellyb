---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.DateManager then
	return
end

-- Lua imports
local assert = assert;

-- Ellyb imports
local isInstanceOf = Ellyb.Assertions.isInstanceOf;

local DateManager = {};

DateManager.DATE_FORMATS = {
	DD_MM_YYYY = "%m/%d/%Y %H:%M:%S",
	MM_DD_YYYY = "%d/%m/%Y %I:%M:%S %p",
	YYYY_MM_DD = "%Y/%m/%d %H:%M:%S",
}

-- Default date format is DD/MM/YYYY except for the American weirdos
local DEFAULT_DATE_FORMAT = GetLocale() == "enUS" and DateManager.DATE_FORMATS.MM_DD_YYYY or DateManager.DATE_FORMATS.DD_MM_YYYY;

---@param date DateTime
---@param optional format string
function DateManager.formatDate(date, format)
	assert(isInstanceOf(date, "DateTime", "date"));

	if not format then
		format = DEFAULT_DATE_FORMAT;
	end

	return date(format, date:GetTimestamp());
end

function DateManager.getDefaultFormat()
	return DEFAULT_DATE_FORMAT;
end


Ellyb.DateManager = DateManager;